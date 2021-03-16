global class SogiButsudanCrossSellingMail implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

	global AddOpportunityContactRoleBat__mdt f_CachedConfig;

	global SogiButsudanCrossSellingMail(){
		// バッチ実行のための各種フラグ取得
		f_CachedConfig = new AddOpportunityContactRoleBat__mdt();
		f_CachedConfig = [SELECT BatchSize__c, 
								TESTMarketoFlg__c, 
								MarketoFlg__c
						FROM AddOpportunityContactRoleBat__mdt
						WHERE DeveloperName = 'SogiButsudanCrossSellingMail'
						Limit 1];
	}

	// スケジューラー起動
	global void execute(SchedulableContext sc) {

		// バッチサイズ取得
		Integer theBatchSize = Integer.valueOf(f_CachedConfig.BatchSize__c);

		// バッチ実行
		Database.executeBatch(new SogiButsudanCrossSellingMail(), theBatchSize);
	}

	// バッチのスタート
	global List<Opportunity> start(Database.BatchableContext BC) {

		// 商談データ取得用の配列
		List<Opportunity> ListOpp = new List<Opportunity>();

		// 商談データ戻り値用の配列
		List<Opportunity> returnListOpp = new List<Opportunity>();

		// SOQLの条件_お客様のレコードタイプの取得
		ID AccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

		// SOQLの条件_商談のシンプル安豪レコードタイプの取得
		ID OpportunityTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();


		// SOQLの条件_商品・サービス案内項目の条件文字列
		String ChkPermissionFlag = '受け取る';

		// SOQLの条件_フェーズ項目の対象外条件文字列
		String ChkStageName = '除外';

		// SOQLの条件_商談の問合せ日項目の日付条件（バッチ実行の12日前）
		Date DateNow = Date.today();
		Date ChkDate = DateNow.addDays(-12);
		Time FromTime = Time.newInstance(0, 0, 0, 0);
		DateTime ChkFromdt = DateTime.newInstance(ChkDate, FromTime);
		Time ToTime = Time.newInstance(23, 59, 59, 999);
		DateTime ChkTodt = DateTime.newInstance(ChkDate, ToTime);

		// 本番環境でTESTを行う際、取引先の優先メールアドレス項目の条件文字列
		String StrCheckEmail = '%@yoriso.com';

		// 実行フラグの確認
		if(f_CachedConfig.MarketoFlg__c){

			// データ取得用のSOQL
			String query_str  = '';
			query_str  = 'SELECT';
			query_str  = query_str  + ' Id,';
			query_str  = query_str  + ' AccountId,';
			query_str  = query_str  + ' Account.PersonContactId,';
			query_str  = query_str  + ' Account.PersonContact.mkto71_SendToMarketoFlag__c,';
			query_str  = query_str  + ' Account.YusenMailAddressFormula__c';
			query_str  = query_str  + ' FROM Opportunity';
			query_str  = query_str  + ' WHERE RecordTypeId = :OpportunityTypeId ';
			query_str  = query_str  + ' AND StageName != :ChkStageName ';
			query_str  = query_str  + ' AND Req_Day__c >= :ChkFromdt ';
			query_str  = query_str  + ' AND Req_Day__c <= :ChkTodt ';
			query_str  = query_str  + ' AND Account.RecordTypeId = :AccountTypeId ';
			query_str  = query_str  + ' AND Account.PermissionFlag__pc = :ChkPermissionFlag ';
			query_str  = query_str  + ' AND Account.E_NG__pc = False ';
			query_str  = query_str  + ' AND Account.YusenMailAddressFormula__c != null ';
			query_str  = query_str  + ' AND Account.PersonDeathDate__pc = null ';

			if(f_CachedConfig.TESTMarketoFlg__c){
				//「MarkeSMSTESTFlg__c」は、本番環境でTESTを行うためのフラグ
				//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
				query_str  = query_str  + ' AND Account.YusenMailAddressFormula__c like :StrCheckEmail';
			}

			// データ取得
			ListOpp = Database.query(query_str);

			// 戻り値設定処理
			if(ListOpp.size() > 0){
				returnListOpp = ListOpp;
			}
		}

		return returnListOpp;
	}

	// バッチ実施
	global void execute(Database.BatchableContext BC, List<Opportunity> ListOpp) {

		if(ListOpp.size() > 0){

			// 実行フラグの確認
			if(f_CachedConfig.MarketoFlg__c){

				try {
					// キャンペーンメンバーを設定する際に利用するキャンペーンIDの取得処理
					MarketoManagement__c SelctMarketo = new MarketoManagement__c();
					SelctMarketo = [SELECT Id, 
										Name, 
										MarketoName__c, 
										Campaign__c 
									FROM MarketoManagement__c 
									WHERE MarketoName__c = 'SogiButsudanCrossSellingMail' 
									limit 1];

					List<CampaignMember> CampaignMemberList = new List<CampaignMember>();

					String CampaignID = '';
					Set<ID> ContactSetID = new Set<ID>();
					Set<ID> CampaignMemberSetID = new Set<ID>();
					Set<ID> addMemberSetID = new Set<ID>();

					Set<ID> updateSendToMarketoFlagID = new Set<ID>();

					List<Opportunity> l_Opportunity = new List<Opportunity>();

					if(SelctMarketo != null){
						if(String.isNotBlank(SelctMarketo.Campaign__c)){

							CampaignID = SelctMarketo.Campaign__c;

							for(Opportunity aOpp :ListOpp){
								// キャンペーンメンバーに追加する対象の取引先責任者ID取得処理
								ContactSetID.add(aOpp.Account.PersonContactId);
								// Marketoキャンペーンと商談の紐付きテーブルに、対象の商談を追加するための配列格納
								l_Opportunity.add(aOpp);

								if(aOpp.Account.PersonContact.mkto71_SendToMarketoFlag__c == false){
									// 取引先責任者のMarketo送信フラグ項目をTrueにするための取引先責任者ID取得処理
									updateSendToMarketoFlagID.add(aOpp.Account.PersonContactId);
								}
							}

							// すでにキャンペーンメンバーに追加された取引先責任者IDを確認する処理
							CampaignMemberList = [SELECT Id, 
														CampaignId, 
														ContactId 
												FROM CampaignMember 
												WHERE ContactId in :ContactSetID 
												AND CampaignId = :CampaignID];

							if(CampaignMemberList.size() > 0){
								for(CampaignMember aMember :CampaignMemberList){
									CampaignMemberSetID.add(aMember.ContactId);
								}
							}

							if(CampaignMemberSetID.size() > 0){
								for(ID aConID :ContactSetID){
									if(CampaignMemberSetID.contains(aConID) == false){
										addMemberSetID.add(aConID);
									}
								}
							}else{
								addMemberSetID = ContactSetID;
							}

							// 取引先責任者のMarketo送信フラグ項目をTrueにするため処理
							if(updateSendToMarketoFlagID.size() > 0){
								List<Contact> l_Contact = new List<Contact>([SELECT Id, 
																				mkto71_SendToMarketoFlag__c,
																				Email
																			FROM Contact
																			WHERE Id in :updateSendToMarketoFlagID]);

								if(l_Contact.size() > 0){
									for(Contact aCon :l_Contact){
										aCon.mkto71_SendToMarketoFlag__c = TRUE;
									}
									update l_Contact;
								}
								
							}

							// キャンペーンメンバーに新規追加する処理
							if(addMemberSetID.size() > 0){
								List<CampaignMember> l_InCampaignMember = new List<CampaignMember>();
								for(ID aMember :addMemberSetID){
									CampaignMember sCampaignMember = new CampaignMember(
												CampaignId = CampaignID,
												ContactId = aMember,
												Status = '送信');
											l_InCampaignMember.add(sCampaignMember);
								}
								if(l_InCampaignMember.size() > 0){
									insert l_InCampaignMember;
								}
							}

							// Marketoキャンペーンと商談の紐付きテーブルに追加する処理
							if(l_Opportunity.size() > 0){
								MarketoCampaignAndOpportunity sMarketoCampaignAndOpportunity = new MarketoCampaignAndOpportunity();
								sMarketoCampaignAndOpportunity.addLinkMarketoCampaignAndOpportunity(l_Opportunity,CampaignID);
							}
						}
					}
				}catch (Exception e) {
					Loggings.writeLog(
						Loggings.createLogEntry(
							Loggings.Level.Error, '20201120-2005-01', 'SogiButsudanCrossSellingMail','葬儀_仏壇のクロスセルメールバッチエラー')
							.putAttr('e.getMessage()',e.getMessage())
							.putAttr('e.getLineNumber()',String.valueOf(e.getLineNumber()))
							.putAttr('e.getStackTraceString()',String.valueOf(e.getStackTraceString()))
							.putAttr('e.getTypeNmae()',String.valueOf(e.getTypeName()))
					);
				
				}
			}
		}
	}

	// バッチ終了処理
	global void finish(Database.BatchableContext BC) {
		// 特になし
	}

}