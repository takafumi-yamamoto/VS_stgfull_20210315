@isTest
private class Tes_Bat_ObosanJizenSmsSender {
	
	@isTest static void test_method_one() {
		Test.startTest();

        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc1=new Account();
        acc1.lastname='新規';
        acc1.LastNameFurigana__pc ='defualt';
        acc1.FirstNameFurigana__pc ='defualt';
        acc1.Phone='080-0000-0001';
        acc1.MobilePhone__c='080-0000-0001';
        acc1.recordtypeid=redtpId;
        insert acc1;

        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert sodansha;

        Account moshu = new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert moshu;

        Account taishosha = new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert taishosha;
        Account obosan = new Account(Name = 'お坊田中対象者',RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'));
        insert obosan;

        Keiyaku__c keiyaku = new Keiyaku__c();
        keiyaku.Teikeisaki__c = obosan.Id;
        insert keiyaku;
        
        

        Obosanbin__c service = new Obosanbin__c(Taishosha1Ref__c = taishosha.Id, 
        										MemorialServicePlan__c = '初七日法要',
                                                ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
        										KokubetsuDateTime_Inp__c = datetime.now().addDays(1),
        										MoshuRef__c = moshu.Id);
        insert service;

        System.debug('>>>>>>>>>service : ' + service);

		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = sodansha.Id,
											StageName = '施行待ち',
											SubPhase__c = '事前確認連絡1日前（SMS）',
											KakuteibiSyodan__c = date.Today(),
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											ObosanbinRef__c = service.Id
										);
	    insert opp;
        opp = [
                Select 
                    id, 
                    SubPhase__c,
                    ShodanBangoF__c,
                    ObosanbinRef__c
                FROM Opportunity
                WHERE id = : opp.id
            ];
        Obosanbin__c obo = new Obosanbin__c(Id = opp.ObosanbinRef__c,
                                        Taishosha1Ref__c = taishosha.Id, 
                                                MemorialServicePlan__c = '初七日法要',
                                                ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
                                                KokubetsuDateTime_Inp__c = datetime.now().addDays(1),
                                                MoshuRef__c = moshu.Id
                );
        update obo;

        Test.setMock(HttpCalloutMock.class, new Tes_AosSMSMockHttpResponseGenerator());

		Test.stopTest();

		List<String> syoriObosanPlan = HouyoPlans.getHoyoPlans();
		List<Opportunity> oppList = [
				Select 
					id, 
					SubPhase__c,
					ShodanBangoF__c,
					ObosanbinRef__c,
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c, //窓口僧侶
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c  //窓口僧侶連絡先
				FROM Opportunity
				WHERE StageName = '施行待ち'
				AND KakuteibiSyodan__c != null
				AND ObosanbinRef__r.MemorialServicePlan__c in :syoriObosanPlan  //お坊さん便-プラン
                AND SubPhase__c = '事前確認連絡1日前（SMS）'
                AND ObosanbinRef__r.JizenSmsBf1Status__c = null
                AND ObosanbinRef__r.KokubetsuDateTime_Inp__c = NEXT_N_DAYS:1
			];
		new Bat_ObosanJizenSmsCreator1DaysBf().execute(null, oppList);
		new Bat_ObosanJizenSmsSender().execute(null);
	}
	
	@isTest static void test_method_two() {
        Test.startTest();

        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc1=new Account();
        acc1.lastname='新規';
        acc1.LastNameFurigana__pc ='defualt';
        acc1.FirstNameFurigana__pc ='defualt';
        acc1.Phone='080-0000-0001';
        acc1.MobilePhone__c='080-0000-0001';
        acc1.recordtypeid=redtpId;
        insert acc1;

        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert sodansha;

        Account moshu = new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert moshu;

        Account taishosha = new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert taishosha;
        Account obosan = new Account(Name = 'お坊田中対象者',RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'));
        insert obosan;

        Keiyaku__c keiyaku = new Keiyaku__c();
        keiyaku.Teikeisaki__c = obosan.Id;
        insert keiyaku;
        
        

        Obosanbin__c service = new Obosanbin__c(Taishosha1Ref__c = taishosha.Id, 
                                                MemorialServicePlan__c = '初七日法要',
                                                ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
                                                KokubetsuDateTime_Inp__c = datetime.now().addDays(1),
                                                MoshuRef__c = moshu.Id);
        insert service;

        System.debug('>>>>>>>>>service : ' + service);

        // サービス商談作成
        Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
        Opportunity opp = new Opportunity(
                                            Name = 'テスト商談',
                                            AccountId = sodansha.Id,
                                            StageName = '施行待ち',
                                            SubPhase__c = '事前確認連絡7日前（SMS）',
                                            KakuteibiSyodan__c = date.Today(),
                                            CloseDate = date.Today(),
                                            RecordTypeId = oppRecordTypeId,
                                            ObosanbinRef__c = service.Id
                                        );
        insert opp;
        opp = [
                Select 
                    id, 
                    SubPhase__c,
                    ShodanBangoF__c,
                    ObosanbinRef__c
                FROM Opportunity
                WHERE id = : opp.id
            ];
        Obosanbin__c obo = new Obosanbin__c(Id = opp.ObosanbinRef__c,
                                        Taishosha1Ref__c = taishosha.Id, 
                                                MemorialServicePlan__c = '初七日法要',
                                                ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
                                                KokubetsuDateTime_Inp__c = datetime.now().addDays(1),
                                                MoshuRef__c = moshu.Id
                );
        update obo;

        Test.setMock(HttpCalloutMock.class, new Tes_AosSMSMockHttpResponseGenerator());

        Test.stopTest();
        
		List<String> syoriObosanPlan = HouyoPlans.getHoyoPlans();
		List<Opportunity> oppList = [
				Select 
                    id, 
                    SubPhase__c,
                    ShodanBangoF__c,
                    ObosanbinRef__c,
                    ObosanbinRef__r.KokubetsuDateTime_Inp__c,
                    Account.lastname,
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c, //窓口僧侶
                    ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c  //窓口僧侶連絡先
				FROM Opportunity
				WHERE StageName = '施行待ち'
				AND KakuteibiSyodan__c != null
				AND ObosanbinRef__r.MemorialServicePlan__c in :syoriObosanPlan  //お坊さん便-プラン
                AND SubPhase__c = '事前確認連絡7日前（SMS）'
                AND ObosanbinRef__r.JizenSmsBf1Status__c = null
                AND ObosanbinRef__r.KokubetsuDateTime_Inp__c = NEXT_N_DAYS:1
			];
		new Bat_ObosanJizenSmsCreator7DaysBf().execute(null, oppList);
		new Bat_ObosanJizenSmsSender().execute(null);
	}
	
}