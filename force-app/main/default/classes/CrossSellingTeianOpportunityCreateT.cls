@isTest
private class CrossSellingTeianOpportunityCreateT {

    @testSetup
    static void initializeTestData() {
        //Insert new TriggerIsActive__c( name='default', isActive__c=true );
        List<Account> insAccountList = new List<Account>();
        Account Acc=new Account();
		Acc.name='テスト';
        insAccountList.add(Acc);

        Account Acc2=new Account();
		Acc2.name='テスト2';
        insAccountList.add(Acc2);

        insert insAccountList;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;
	
	    // 商談
		String oppTorihikiShodanRdId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId();
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        // SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id,TaishoshaRef__c = Acc2.Id,ZokugaraSodanshaNitottenoTaishosha__c='夫');
		// insert simpleYasugo;			
	    String oppSimpleYasugoRdId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = '商談‗シンプル安豪', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);
		insert oppSimpleYasugo;

        //シンプル安豪のアップデート
        Opportunity yasugoOppResult = [
            SELECT 
                Id
                ,SimpleYasugoRef__c
            FROM Opportunity
            WHERE Id = :oppSimpleYasugo.Id
        ];
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        simpleYasugo.ID = yasugoOppResult.SimpleYasugoRef__c;
        simpleYasugo.TaishoshaRef__c = Acc2.Id;
        simpleYasugo.ZokugaraSodanshaNitottenoTaishosha__c = '夫';
        update simpleYasugo;
    }

    /**
     * クロスセル提案のInsert(永代供養)
     */
    static testMethod void testCaseEitaiInsert(){

        Opportunity oppSimpleYasugo = [SELECT Id, Name, StageName, CloseDate, Utiagebi__c FROM Opportunity WHERE Name = '商談‗シンプル安豪'];
        Account Acc = [SELECT Id FROM Account WHERE name='テスト'];
        Test.startTest();
        //クロスセル提案をInsertする
        CrossSellingTeian__c csteian = new CrossSellingTeian__c();
        csteian.OpportunityRef__c = oppSimpleYasugo.Id;
        csteian.TeianShohin__c = '永代供養';
        csteian.TeianKekka__c = 'クロスセル希望あり';
        insert csteian;
        Test.stopTest();

        assertResult('永代供養', oppSimpleYasugo, acc, 'クロスセル希望あり');
        
    }
    /**
     * クロスセル提案のUpdate(永代供養)
     *  興味なし→検討中
     */
    static testMethod void testCaseEitaiUpdate(){
        Opportunity oppSimpleYasugo = [SELECT Id, Name, StageName, CloseDate, Utiagebi__c FROM Opportunity WHERE Name = '商談‗シンプル安豪'];
        Account Acc = [SELECT Id FROM Account WHERE name='テスト'];
        Test.startTest();
        //クロスセル提案をInsertする
        CrossSellingTeian__c csteian = new CrossSellingTeian__c();
        csteian.OpportunityRef__c = oppSimpleYasugo.Id;
        csteian.TeianShohin__c = '永代供養';
        csteian.TeianKekka__c = '興味なし';
        insert csteian;
        //この時点ではできていないことを確認する
        List<Opportunity> resultOppList1 = [SELECT Id FROM Opportunity WHERE Name = 'テスト_永代供養'];
        System.assertEquals(0, resultOppList1.size());

        Trg_CrossSellingTeian.isActive = true;
        csteian.TeianKekka__c = 'クロスセル検討中';
        update csteian;
        
        Test.stopTest();

        assertResult('永代供養', oppSimpleYasugo, acc, 'クロスセル検討中');

    }
    /**
     * クロスセル提案のInsert(位牌)
     */
    static testMethod void testCaseIhaiInsert(){

        Opportunity oppSimpleYasugo = [SELECT Id, Name, StageName, CloseDate, Utiagebi__c FROM Opportunity WHERE Name = '商談‗シンプル安豪'];
        Account Acc = [SELECT Id FROM Account WHERE name='テスト'];
        Test.startTest();
        //クロスセル提案をInsertする
        CrossSellingTeian__c csteian = new CrossSellingTeian__c();
        csteian.OpportunityRef__c = oppSimpleYasugo.Id;
        csteian.TeianShohin__c = '位牌';
        csteian.TeianKekka__c = 'クロスセル希望あり';
        insert csteian;
        Test.stopTest();

        assertResult('ベスト仏壇', oppSimpleYasugo, acc,'クロスセル希望あり');
        
    }
    /**
     * クロスセル提案のUpdate(位牌)
     *  興味なし→検討中
     */
    static testMethod void testCaseIhaiUpdate(){
        Opportunity oppSimpleYasugo = [SELECT Id, Name, StageName, CloseDate, Utiagebi__c FROM Opportunity WHERE Name = '商談‗シンプル安豪'];
        Account Acc = [SELECT Id FROM Account WHERE name='テスト'];
        Test.startTest();
        //クロスセル提案をInsertする
        CrossSellingTeian__c csteian = new CrossSellingTeian__c();
        csteian.OpportunityRef__c = oppSimpleYasugo.Id;
        csteian.TeianShohin__c = '位牌';
        csteian.TeianKekka__c = '興味なし';
        insert csteian;
        //この時点ではできていないことを確認する
        List<Opportunity> resultOppList1 = [SELECT Id FROM Opportunity WHERE Name = 'テスト_永代供養'];
        System.assertEquals(0, resultOppList1.size());

        Trg_CrossSellingTeian.isActive = true;
        csteian.TeianKekka__c = 'クロスセル検討中';
        update csteian;
        
        Test.stopTest();

        assertResult('ベスト仏壇', oppSimpleYasugo, acc, 'クロスセル検討中');

    }

    /**
     * 海洋散骨UmieのInsert(位牌)
     */
    static testMethod void testCaseKaiyoInsert(){

        Opportunity oppSimpleYasugo = [SELECT Id, Name, StageName, CloseDate, Utiagebi__c FROM Opportunity WHERE Name = '商談‗シンプル安豪'];
        Account Acc = [SELECT Id FROM Account WHERE name='テスト'];
        Test.startTest();
        //クロスセル提案をInsertする
        CrossSellingTeian__c csteian = new CrossSellingTeian__c();
        csteian.OpportunityRef__c = oppSimpleYasugo.Id;
        csteian.TeianShohin__c = '海洋散骨Umie';
        csteian.TeianKekka__c = 'クロスセル希望あり';
        insert csteian;
        Test.stopTest();

        assertResult('海洋散骨', oppSimpleYasugo, acc,'クロスセル希望あり');
        
    }
    private static void assertResult(String rectypeName,Opportunity oppSimpleYasugo,Account acc,String subPhase){
        //商談ができていることを確認する
        String oppname = 'テスト_' + rectypeName;
        List<Opportunity> resultOppList = [
                                            SELECT
                                                Id
                                                ,RecordType.Name
                                                ,CloseDate
                                                ,StageName
                                                ,SubPhase__c
                                                ,AccountId
                                                ,RyunyumotoService__c
                                                ,Pricebook2Id
                                                ,YorisonoOsoshikiSekobi__c
                                                ,EitaiKuyoRef__c
                                                ,KaiyoSankotsuUmieRef__c
                                            FROM Opportunity
                                            WHERE Name = :oppname
                                        ];
        System.assertEquals(1, resultOppList.size());
        Opportunity resultOpp = resultOppList.get(0);
        System.assertEquals(rectypeName, resultOpp.RecordType.Name);
        System.assertEquals(date.today(), resultOpp.CloseDate);
        System.assertEquals(subPhase, resultOpp.SubPhase__c);
        System.assertEquals(Acc.Id, resultOpp.AccountId);
        System.assertEquals('シンプル安豪', resultOpp.RyunyumotoService__c);
        System.assertEquals('01s7F0000064fmI', resultOpp.Pricebook2Id);
        System.assertEquals(oppSimpleYasugo.Utiagebi__c, resultOpp.YorisonoOsoshikiSekobi__c);        

        //クロスセル提案に提案先の商談のIDが入っている
        List<CrossSellingTeian__c> resultCrossTeianList = [SELECT ID,CrossSellingSakiOpportunityRef__c FROM CrossSellingTeian__c];
        CrossSellingTeian__c resultCrossTeian = resultCrossTeianList.get(0);
        System.assertEquals(resultOpp.Id,resultCrossTeian.CrossSellingSakiOpportunityRef__c);

        //永代供養の場合、元から情報がコピーされている
        if(resultOpp.EitaiKuyoRef__c!=null){
            Account Acc2 = [SELECT Id FROM Account WHERE name='テスト2'];
            EitaiKuyo__c eitaikuyo = [SELECT ID,TaishoshaRef__c,ZokugaraSodanshaNitottenoTaishosha__c FROM EitaiKuyo__c WHERE ID = :resultOpp.EitaiKuyoRef__c];
            System.assertEquals(Acc2.Id, eitaikuyo.TaishoshaRef__c);
            System.assertEquals('夫', eitaikuyo.ZokugaraSodanshaNitottenoTaishosha__c);
        }
        //海洋散骨の場合、元から情報がコピーされている
        if(resultOpp.KaiyoSankotsuUmieRef__c!=null){
            Account Acc2 = [SELECT Id FROM Account WHERE name='テスト2'];
            KaiyoSankotsuUmie__c kaiyo = [SELECT ID,TaishoshaRef__c,ZokugaraSodanshaNitottenoTaishosha__c FROM KaiyoSankotsuUmie__c WHERE ID = :resultOpp.KaiyoSankotsuUmieRef__c];
            System.assertEquals(Acc2.Id, kaiyo.TaishoshaRef__c);
            System.assertEquals('夫', kaiyo.ZokugaraSodanshaNitottenoTaishosha__c);
        }
        //コンタクトが作成されている
        List<Task> taskList = [
            SELECT
                Id
                ,ShiborikomiJoken__c
                ,YokenSyubetsu__c
            FROM Task
            WHERE WhatId = :resultOpp.Id
            AND ShiborikomiJoken__c Like '%フォロー：クロスセル%'
        ];
        Task resultTask = taskList.get(0);
        System.assertEquals('フォロー：'+subPhase, resultTask.ShiborikomiJoken__c);
        System.assertEquals('受電（お客様）', resultTask.YokenSyubetsu__c);
    }
}