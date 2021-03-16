@isTest
private class Tes_PaymentHelper {
//     static testMethod void testMethod1() {
//     	PaymentHelper.SeikyusyoSakuseiBean bean = new PaymentHelper.SeikyusyoSakuseiBean();
//     	bean.recordId = '0060k0000069kTpAAI';

//         bean.torihikiShodanId = '12345';

//         bean.totalAmount = 49999;
//         bean.oppLineItemIds = new List<String>() ;
//         bean.seikyuHouhou = 'gmo_credit';

//         bean.seikyusyoBango = '123';
//         bean.torihikisakiBango= '123';
//         bean.seikyusaki = ''; // 請求先
//         bean.seikyusakiMail = '';    // 請求先メールアドレス
//         bean.isBetsuNoSeikyuSaki = true;    // 請求先メールアドレス

//     	PaymentHelper.CoreSeikiyusyouBuilder builder = new  PaymentHelper.CoreSeikiyusyouBuilder(bean);
//     	System.debug(builder.getKessaiInfo());


//    /* 	String seikyuBango = 'OKSM-00059209';
//         SeikyuData.OkyakusamaSeikyuMeisaiTree tree = new SeikyuData.OkyakusamaSeikyuMeisaiTree(seikyuBango);
// 		//System.debug(tree);
// 		System.debug(tree.getKessaiInfoJsonStr());
//      */   
//     }


//     static testMethod void test_OpportunityTree() {
//         PaymentHelper.OpportunityTree tree = new PaymentHelper.OpportunityTree(null);

//         id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
//         Account acc1=new Account();
//         acc1.lastname='新規';
//         acc1.LastNameFurigana__pc ='defualt';
//         acc1.FirstNameFurigana__pc ='defualt';
//         acc1.Phone='080-0000-0001';
//         acc1.MobilePhone__c='080-0000-0001';
//         acc1.recordtypeid=redtpId;
//         insert acc1;

//         Account Acc=new Account();
//         Acc.name='テスト';
//         insert Acc;
        
//         Case c=new Case();
//         c.accountid=Acc.id;
//         c.description='テスト';
//         insert c;
    
//         // 商談
//         String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
//         Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today()); 
//         insert opp; 

//         //==============SimpleYasugo__c===============
//         SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
//         insert simpleYasugo;            
//         String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
//         Opportunity oppSimpleYasugo = new Opportunity(
//             Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
//             TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
//             );  
//         insert oppSimpleYasugo; 


//         OkyakusamaSeikyuMeisai__c okyakusamaseikyumeisai = new OkyakusamaSeikyuMeisai__c();
//         okyakusamaseikyumeisai.SeikyuBango__c = 'seikyubango-99999';
//         okyakusamaseikyumeisai.OpportunityRef__c = opp.Id;
//         okyakusamaseikyumeisai.SeikyuStatus__c = '決済済';
//         okyakusamaseikyumeisai.SeikyuKingaku__c = 45000;
//         okyakusamaseikyumeisai.SeikyuHouhou__c = 'gmo_credit';
//         insert okyakusamaseikyumeisai;


//         PaymentHelper.OpportunityTree tree2 = new PaymentHelper.OpportunityTree(oppSimpleYasugo.Id);
//         List<String> oppLineItemIds = new List<String>();
//         List<OpportunityLineItem> items = tree2.getSelOpportunityLineItem(oppLineItemIds);

//     }


//     @isTest(SeeAllData=true)
//     static void test_CoreSeikyusRequest() {
//         PaymentHelper.SeikyusyoSakuseiBean bean = new PaymentHelper.SeikyusyoSakuseiBean();
//         bean.recordId = '0060k0000069kTpAAI';

//         bean.torihikiShodanId = '12345';

//         bean.totalAmount = 49999;
//         bean.oppLineItemIds = new List<String>() ;
//         bean.seikyuHouhou = 'gmo_credit';

//         bean.seikyusyoBango = '123';
//         bean.torihikisakiBango= '123';
//         bean.seikyusaki = ''; // 請求先
//         bean.seikyusakiMail = '';    // 請求先メールアドレス
//         bean.isBetsuNoSeikyuSaki = true;    // 請求先メールアドレス

//         PaymentHelper.CoreSeikiyusyouBuilder builder = new  PaymentHelper.CoreSeikiyusyouBuilder(bean);
//         System.debug(builder.getKessaiInfo());


//         Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );
//         Test.startTest();

//         PaymentHelper.CoreSeikyusRequest req = new PaymentHelper.CoreSeikyusRequest();
//         String response = req.createSeikyu(bean, builder);
//         System.debug(response);

//         Test.stopTest();

//     }


//     @isTest(SeeAllData=true)
//     static void test_CoreSeikyusRequest_error_pattern() {
//         PaymentHelper.SeikyusyoSakuseiBean bean = new PaymentHelper.SeikyusyoSakuseiBean();
//         bean.recordId = '0060k0000069kTpAAI';

//         bean.torihikiShodanId = '12345';

//         bean.totalAmount = 49999;
//         bean.oppLineItemIds = new List<String>() ;
//         bean.seikyuHouhou = 'gmo_credit';

//         bean.seikyusyoBango = '123';
//         bean.torihikisakiBango= '123';
//         bean.seikyusaki = ''; // 請求先
//         bean.seikyusakiMail = '';    // 請求先メールアドレス
//         bean.isBetsuNoSeikyuSaki = true;    // 請求先メールアドレス

//         PaymentHelper.CoreSeikiyusyouBuilder builder = new  PaymentHelper.CoreSeikiyusyouBuilder(bean);
//         System.debug(builder.getKessaiInfo());


//         Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
//         Test.startTest();

//         PaymentHelper.CoreSeikyusRequest req = new PaymentHelper.CoreSeikyusRequest();
//         try {
//             String response = req.createSeikyu(bean, builder);
//             System.debug(response);
//         }
//         catch (Exception e) {
//             System.debug(e);
//         }

//         Test.stopTest();

//     }

//     @isTest(SeeAllData=true)
//     static void test_CoreSeikyusRequest_ok_pattern() {
//         PaymentHelper.OpportunityTree tree = new PaymentHelper.OpportunityTree(null);

//         id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
//         Account acc1=new Account();
//         acc1.lastname='新規';
//         acc1.LastNameFurigana__pc ='defualt';
//         acc1.FirstNameFurigana__pc ='defualt';
//         acc1.Phone='080-0000-0001';
//         acc1.MobilePhone__c='080-0000-0001';
//         acc1.recordtypeid=redtpId;
//         insert acc1;

//         Account Acc=new Account();
//         Acc.name='テスト';
//         insert Acc;
        
//         Case c=new Case();
//         c.accountid=Acc.id;
//         c.description='テスト';
//         insert c;
    
//         // 商談
//         String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
//         Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today()); 
//         insert opp; 

//         //==============SimpleYasugo__c===============
//         SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
//         insert simpleYasugo;            
//         String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
//         Opportunity oppSimpleYasugo = new Opportunity(
//             Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
//             TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
//             );  
//         insert oppSimpleYasugo; 


//         OkyakusamaSeikyuMeisai__c okyakusamaseikyumeisai = new OkyakusamaSeikyuMeisai__c();
//         okyakusamaseikyumeisai.SeikyuBango__c = 'seikyubango-99999';
//         okyakusamaseikyumeisai.OpportunityRef__c = opp.Id;
//         okyakusamaseikyumeisai.SeikyuStatus__c = '決済済';
//         okyakusamaseikyumeisai.SeikyuKingaku__c = 45000;
//         okyakusamaseikyumeisai.SeikyuHouhou__c = 'gmo_credit';
//         insert okyakusamaseikyumeisai;


//         PaymentHelper.SeikyusyoSakuseiBean bean = new PaymentHelper.SeikyusyoSakuseiBean();
//         bean.recordId = oppSimpleYasugo.Id;

//         bean.torihikiShodanId = opp.Id;

//         bean.totalAmount = 49999;
//         bean.oppLineItemIds = new List<String>() ;
//         bean.seikyuHouhou = 'gmo_credit';

//         bean.seikyusyoBango = '123';
//         bean.torihikisakiBango= '123';
//         bean.seikyusaki = '請求先'; // 請求先
//         bean.seikyusakiMail = 'sss@minrevi.jp.test12345';    // 請求先メールアドレス
//         bean.isBetsuNoSeikyuSaki = true;    // 請求先メールアドレス

//         PaymentHelper.CoreSeikiyusyouBuilder builder = new  PaymentHelper.CoreSeikiyusyouBuilder(bean);
//         System.debug(builder.getKessaiInfo());


//         Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
//         Test.startTest();

//         PaymentHelper.CoreSeikyusRequest req = new PaymentHelper.CoreSeikyusRequest();

//         try {
//             String response = req.createSeikyu(bean, builder);
//             System.debug(response);
//         }
//         catch (Exception e) {
//             System.debug(e);
//         }
//         Test.stopTest();

//     }



//     static testMethod void test_validator() {
//         PaymentHelper.Validator validator = new PaymentHelper.Validator();
//         System.debug(validator.isDulicateGmoSeikyu('torihikiShodanId'));

//     }

}