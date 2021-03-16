global class MakeSMSHaishin implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

	// スケジューラー起動
	global void execute(SchedulableContext sc) {
		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, SMSBatchSize__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];
		Integer theBatchSize = (Integer)MarkeSMSdelivery.SMSBatchSize__c;
		Database.executeBatch(new MakeSMSHaishin(), theBatchSize);
	}

	global List<MarkeSMSDeliveryMember__c> start(Database.BatchableContext BC) {

		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, MarkeSMSTESTFlg__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];

		List<MarkeSMSDeliveryMember__c> ListMarkeSMS = new List<MarkeSMSDeliveryMember__c>();
		Date DateNow = Date.today();
		String StrSmsSendStatus = '未送信';
		String StrCheckEmail = '%@yoriso.com';

		String query_str  = '';
		query_str  = 'SELECT';
		query_str  = query_str  + ' Id,';
		query_str  = query_str  + ' SmsSendStatus__c,';
		query_str  = query_str  + ' SmsSendResultMessage__c,';
		query_str  = query_str  + ' SmsSendCellphoneNumber__c,';
		query_str  = query_str  + ' SmsSendDatetime__c,';
		query_str  = query_str  + ' SmsSendSchedule__c,';
		query_str  = query_str  + ' Opportunity__c,';
		query_str  = query_str  + ' Opportunity__r.StageName,';
		query_str  = query_str  + ' Account__c,';
		query_str  = query_str  + ' AccountID__c,';
		query_str  = query_str  + ' Account__r.PermissionFlag__pc,';
		query_str  = query_str  + ' Account__r.KoukokuSmsNg__c,';
		query_str  = query_str  + ' Account__r.JizenJizenSheetTeishutsuzumi__c,';
		query_str  = query_str  + ' Opportunity__r.SimpleYasugoRef__r.PreliminaryConsultationDate__c,';
		query_str  = query_str  + ' Opportunity__r.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c,';
		query_str  = query_str  + ' Account__r.YusenMailAddressFormula__c';
		query_str  = query_str  + ' FROM MarkeSMSDeliveryMember__c';
		query_str  = query_str  + ' WHERE SmsSendSchedule__c = :DateNow';
		query_str  = query_str  + ' AND SmsSendStatus__c = :StrSmsSendStatus ';

		if(MarkeSMSdelivery.MarkeSMSTESTFlg__c){
			//「MarkeSMSTESTFlg__c」は、本番環境でTESTを行うためのフラグ
			//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
			query_str  = query_str  + ' AND Account__r.YusenMailAddressFormula__c like :StrCheckEmail';
		}

		ListMarkeSMS = Database.query(query_str);

		return ListMarkeSMS;
	}

	global void execute(Database.BatchableContext BC, List<MarkeSMSDeliveryMember__c> ListMarkeSMS) {

		MarkeSMSdelivery__mdt MarkeSMSdelivery = [SELECT Id, MarkeSMSFlg__c, MessageBody__c FROM MarkeSMSdelivery__mdt WHERE DeveloperName = 'JizenJunbiSheet' limit 1];

		AccreteSmsApi smsApi = new AccreteSmsApi();

		String StrStageName = '問合せ受付,フォロー';
		List<String> ChkStageName = StrStageName.split(',');
		String ChkPermissionFlag = '受け取る';
		String ChkJizenJunbiSheetGoannaiJokyo = '受領';

		Datetime sendDate = Datetime.now();

		Map<String,MarkeSMSDeliveryMember__c> MapMemberKoshin = new Map<String,MarkeSMSDeliveryMember__c>();

		if(MarkeSMSdelivery.MarkeSMSFlg__c){
			if(ListMarkeSMS.size() > 0){
				for(MarkeSMSDeliveryMember__c MarkeSMS :ListMarkeSMS){
					if(ChkStageName.indexOf(MarkeSMS.Opportunity__r.StageName) == -1){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前にステータスが変更された'
							)
						);
					}else if(MarkeSMS.Account__r.PermissionFlag__pc != ChkPermissionFlag){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前に商品・サービス案内(Eメール・SMS)が受け取らないに更新された'
							)
						);
					}else if(MarkeSMS.Account__r.KoukokuSmsNg__c){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前にSms NGが更新された'
							)
						);
					}else if(MarkeSMS.Account__r.JizenJizenSheetTeishutsuzumi__c){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前に事前準備シート提出済が更新された'
							)
						);
					}else if(MarkeSMS.Opportunity__r.SimpleYasugoRef__r.PreliminaryConsultationDate__c != null){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前にシンプル安豪の事前準備シート受領日が更新された'
							)
						);
					}else if(MarkeSMS.Opportunity__r.SimpleYasugoRef__r.JizenJunbiSheetGoannaiJokyo__c == ChkJizenJunbiSheetGoannaiJokyo){
						MapMemberKoshin.put(
							MarkeSMS.AccountID__c,
							new MarkeSMSDeliveryMember__c(
								Id = MarkeSMS.Id,
								AccountID__c = MarkeSMS.AccountID__c,
								SmsSendStatus__c = '対象外',
								SmsSendResultMessage__c = 'SMS送信処理前にシンプル安豪の事前準備シートご案内状況が「受領」に更新された'
							)
						);
					}else {
						try {
							smsApi.smsReg(MarkeSMSdelivery.MessageBody__c,
										MarkeSMS.SmsSendCellphoneNumber__c,
										MarkeSMS.Opportunity__c);
							MapMemberKoshin.put(
								MarkeSMS.AccountID__c,
								new MarkeSMSDeliveryMember__c(
									Id = MarkeSMS.Id,
									AccountID__c = MarkeSMS.AccountID__c,
									SmsSendStatus__c = '送信OK',
									SmsSendResultMessage__c = '送信成功',
									SmsSendDatetime__c = sendDate
								)
							);
						} catch (Exception e) {
							String strException  = '';
							strException = 'Exception : ' + e.getMessage() + '\r\n';
							strException = strException  + 'LineNumber : ' + e.getLineNumber() + '\r\n';
							strException = strException  + 'getStackTraceString : ' +  e.getStackTraceString() + '\r\n';
							MapMemberKoshin.put(
								MarkeSMS.AccountID__c,
								new MarkeSMSDeliveryMember__c(
									Id = MarkeSMS.Id,
									AccountID__c = MarkeSMS.AccountID__c,
									SmsSendStatus__c = '送信NG',
									SmsSendResultMessage__c = strException,
									SmsSendDatetime__c = null
								)
							);
						}
					}
				}
			}
			if(MapMemberKoshin.size() > 0){
				UPSERT MapMemberKoshin.values() AccountID__c;
			}
		}
	}

	global void finish(Database.BatchableContext BC) {
	}

}