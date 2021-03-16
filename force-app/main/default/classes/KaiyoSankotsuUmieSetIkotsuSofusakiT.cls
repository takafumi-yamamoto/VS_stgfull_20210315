@isTest
private class KaiyoSankotsuUmieSetIkotsuSofusakiT {
    
    @testSetup
    static void initializeTestData() {

        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );


        List<Account> insAccountList = new List<Account>();
        Account Acc=new Account();
		Acc.name='テスト';
        insAccountList.add(Acc);

        Account Acc2=new Account();
		Acc2.name='テスト2';
        Acc2.RecordtypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'Sogisya');
        insAccountList.add(Acc2);

        insert insAccountList;
		
        //パートナー契約（海洋散骨_umie）
        Keiyaku__c kaiyo_keiyaku = new Keiyaku__c( 
                Teikeisaki__c = Acc2.Id
                ,Name = 'ACC2_海洋散骨'
                ,RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Umie')
            );

        Insert kaiyo_keiyaku;
	
	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	
		
	    String oppKaiyoSankotsuRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KaiyoUmie');
		Opportunity oppKaiyoSankotsu = new Opportunity(
			Name = '商談_海洋散骨umie', AccountId = acc.Id, RecordTypeId = oppKaiyoSankotsuRdId, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);
		insert oppKaiyoSankotsu;

    }
    /**
     * 海洋散骨umieのUpdate()
     */
    static testMethod void testCaseUpdate(){
        //海洋散骨umieを取得する
        Opportunity targetOpportunity = [
            SELECT 
                Id
                ,KaiyoSankotsuUmieRef__c
                ,KaiyoSankotsuUmieRef__r.KetteiSogisha__c
                ,KaiyoSankotsuUmieRef__r.IkotsuSoufusakiRef__c
            FROM Opportunity
            WHERE Name = '商談_海洋散骨umie'
        ];

        //パートナー契約を取得する
        Keiyaku__c partner_kaiyo = [SELECT ID FROM Keiyaku__c WHERE Name = 'ACC2_海洋散骨'];
        Test.startTest();
        KaiyoSankotsuUmie__c updateKaiyosankotsu = new KaiyoSankotsuUmie__c();
        updateKaiyosankotsu.Id = targetOpportunity.KaiyoSankotsuUmieRef__c;
        updateKaiyosankotsu.KetteiSogisha__c = partner_kaiyo.Id;
        update updateKaiyosankotsu;
        Test.stopTest();
    }
}