global class MakeSMSHaishinMemberToroku implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

	// スケジューラー起動
	global void execute(SchedulableContext sc) {
		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, MemberTorokuBatchSize__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];
		Integer theBatchSize = (Integer)MarkeSMSdelivery.MemberTorokuBatchSize__c;
		Database.executeBatch(new MakeSMSHaishinMemberToroku(), theBatchSize);
	}

	global List<Opportunity> start(Database.BatchableContext BC) {

		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, MarkeSMSTESTFlg__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];

		List<Opportunity> ListOpp = new List<Opportunity>();
		
		List<MarkeSMSDeliveryMember__c> MemberList = new List<MarkeSMSDeliveryMember__c>();

		List<Opportunity> returnListOpp = new List<Opportunity>();

		List<String> ListAccId = new List<String>();
		List<String> ListMemberAccId = new List<String>();

		ID OpportunityTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		List<ID> CaseRecordTypeId = new List<ID>();
		CaseRecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId());
		CaseRecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId());
		CaseRecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OsoshikiYoyaku_SiryoSeikyu_Web').getRecordTypeId());

		String StrStageName = '問合せ受付,フォロー';
		List<String> ChkStageName = StrStageName.split(',');
		//issues3806--Start--
		//String StrTaishoushaJokyo = '通院中,入院・通院中,入院中,健在,検査,自宅療養中,生前,老人ホーム,事前相談,入院余命1ヶ月,入院余命2週間,入院余命3ヶ月,入院余命6ヶ月,余命宣告,余命宣告(1ヶ月以上),余命宣告(1ヶ月以内),余命宣告(2週間以内)';
		String StrTaishoushaJokyo = '危篤,余命宣告,高齢終末期,闘病中（重度）,闘病中（軽度）,闘病中（度合不明）,健在,未聴取により不明';
		//issues3806--End--
		List<String> ChkTaishoushaJokyo = StrTaishoushaJokyo.split(',');

		String ChkPermissionFlag = '受け取る';
		String ChkJizenJunbiSheetGoannaiJokyo = '受領';

		Date DateNow = Date.today();
		Date ChkDate = DateNow.addDays(-5);
		Time FromTime = Time.newInstance(0, 0, 0, 0);
		DateTime ChkFromdt = DateTime.newInstance(ChkDate, FromTime);
		Time ToTime = Time.newInstance(23, 59, 59, 999);
		DateTime ChkTodt = DateTime.newInstance(ChkDate, ToTime);

		String StrCheckEmail = '%@yoriso.com';

		String query_str  = '';
		query_str  = 'SELECT';
		query_str  = query_str  + ' Id,';
		query_str  = query_str  + ' AccountId,';
		query_str  = query_str  + ' Account.MobilePhone__c';
		query_str  = query_str  + ' FROM Opportunity';
		query_str  = query_str  + ' WHERE RecordTypeId = :OpportunityTypeId ';
		query_str  = query_str  + ' AND Req_Day__c >= :ChkFromdt ';
		query_str  = query_str  + ' AND Req_Day__c <= :ChkTodt ';
		query_str  = query_str  + ' AND StageName in :ChkStageName ';
		query_str  = query_str  + ' AND TaishoushaJokyo__c in :ChkTaishoushaJokyo ';
		query_str  = query_str  + ' AND CaseRef__r.RecordTypeId in :CaseRecordTypeId ';
		query_str  = query_str  + ' AND Account.PermissionFlag__pc = :ChkPermissionFlag ';
		query_str  = query_str  + ' AND Account.KoukokuSmsNg__c = False ';
		query_str  = query_str  + ' AND Account.MobilePhone__c != null ';
		query_str  = query_str  + ' AND Account.JizenJizenSheetTeishutsuzumi__c = False ';
		query_str  = query_str  + ' AND SimpleYasugoRef__r.PreliminaryConsultationDate__c = null ';
		query_str  = query_str  + ' AND SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c != :ChkJizenJunbiSheetGoannaiJokyo ';

		if(MarkeSMSdelivery.MarkeSMSTESTFlg__c){
			//「MarkeSMSTESTFlg__c」は、本番環境でTESTを行うためのフラグ
			//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
			query_str  = query_str  + ' AND Account.YusenMailAddressFormula__c like :StrCheckEmail';
		}

		ListOpp = Database.query(query_str);

		//すでにMarkeSMSDeliveryMember__cに登録されていた場合、
		//MarkeSMSDeliveryMember__cへの登録を場外する処理
		if(ListOpp.size() > 0){

			for(Opportunity Opp :ListOpp){
				ListAccId.add(Opp.AccountId);
			}

			MemberList = [SELECT Id, AccountID__c FROM MarkeSMSDeliveryMember__c WHERE AccountID__c in :ListAccId];
			
			if(MemberList.size() > 0){
				for(MarkeSMSDeliveryMember__c Member :MemberList){
					ListMemberAccId.add(Member.AccountID__c);
				}
				for(Opportunity sOpp :ListOpp){
					if(ListMemberAccId.indexOf(sOpp.AccountId) == -1){
						returnListOpp.add(sOpp);
					}
				}
			}else{
				returnListOpp = ListOpp;
			}

		}

		return returnListOpp;
	}

	global void execute(Database.BatchableContext BC, List<Opportunity> ListOpp) {

		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, MarkeSMSFlg__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];

		String StrMobilePhone = '090,080,070';
		List<String> ChkMobilePhone = StrMobilePhone.split(',');

		Date DateNow = Date.today();

		Map<String,MarkeSMSDeliveryMember__c> MapMemberToroku = new Map<String,MarkeSMSDeliveryMember__c>();

		if(MarkeSMSdelivery.MarkeSMSFlg__c){
			if(ListOpp.size() > 0){
				for(Opportunity opp :ListOpp){
					String MobilePhone = genTelNoKey(Opp.Account.MobilePhone__c);
					if(String.isNotBlank(MobilePhone)){
						if(ChkMobilePhone.indexOf(MobilePhone.left(3)) > -1 &&
							MobilePhone.length() == 11){
							MapMemberToroku.put(
								Opp.AccountId,
								new MarkeSMSDeliveryMember__c(
									Account__c = Opp.AccountId,
									AccountID__c = Opp.AccountId,
									Opportunity__c = Opp.Id,
									SmsSendCellphoneNumber__c = MobilePhone,
									SmsSendSchedule__c = DateNow,
									SmsSendStatus__c = '未送信'
								)
							);
						}
					}
				}
			}
			if(MapMemberToroku.size() > 0){
				UPSERT MapMemberToroku.values() AccountID__c;
			}
		}
	}

	global void finish(Database.BatchableContext BC) {
	}

	public String genTelNoKey(String pTelNo){
		if(String.isBlank(pTelNo)) return null;
		String regEx = '[^0-9]';   
		Pattern p = Pattern.compile(regEx);   
		Matcher m = p.matcher(pTelNo);
		String theReplaced = m.replaceAll('').trim();
		return String.isBlank(theReplaced) ? null : theReplaced;
	}

}