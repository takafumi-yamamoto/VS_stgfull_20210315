@isTest
private class Tes_WepPayKekkaUketsukeTask {

	//決済結果受付タスク test
    static testMethod void testMethod1() {
        
        WepPayKekkaUketsukeTask__c weppaykekkauketsuketask = new WepPayKekkaUketsukeTask__c();
        weppaykekkauketsuketask.ErrorMessage__c = 'error message';    //ErrorMessage
        weppaykekkauketsuketask.Status__c = 'error';    //Status
        weppaykekkauketsuketask.SeikyuBango__c = 'seikyu_bango';    //請求番号

        weppaykekkauketsuketask.ShoriStatus__c = '未処理';    //処理ステータス
        insert weppaykekkauketsuketask;

    }

    static testMethod void test_WepPayKekkaUketsukeTaskProcessor(){
    	id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc1=new Account();
        acc1.lastname='新規';
        acc1.LastNameFurigana__pc ='defualt';
        acc1.FirstNameFurigana__pc ='defualt';
        acc1.Phone='080-0000-0001';
        acc1.MobilePhone__c='080-0000-0001';
        acc1.recordtypeid=redtpId;
        insert acc1;

		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;
	
	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
		insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);	
		insert oppSimpleYasugo;	


		OkyakusamaSeikyuMeisai__c okyakusamaseikyumeisai = new OkyakusamaSeikyuMeisai__c();
		okyakusamaseikyumeisai.SeikyuBango__c = 'seikyubango-99999';
		okyakusamaseikyumeisai.OpportunityRef__c = opp.Id;
		okyakusamaseikyumeisai.SeikyuStatus__c = '決済待ち';
		okyakusamaseikyumeisai.SeikyuKingaku__c = 45000;
		okyakusamaseikyumeisai.SeikyuHouhou__c = 'gmo_credit';
		insert okyakusamaseikyumeisai;

        WepPayKekkaUketsukeTask__c weppaykekkauketsuketask = new WepPayKekkaUketsukeTask__c();
        weppaykekkauketsuketask.ErrorMessage__c = 'error message';    //ErrorMessage
        weppaykekkauketsuketask.Status__c = 'error';    //Status
        weppaykekkauketsuketask.SeikyuBango__c = okyakusamaseikyumeisai.SeikyuBango__c;    //請求番号
        weppaykekkauketsuketask.ShoriStatus__c = '未処理';    //処理ステータス
        insert weppaykekkauketsuketask;

        //WepPayKekkaUketsukeTaskProcessor taskProcessor = new WepPayKekkaUketsukeTaskProcessor(weppaykekkauketsuketask);
        //taskProcessor.execute(null);

    }
}