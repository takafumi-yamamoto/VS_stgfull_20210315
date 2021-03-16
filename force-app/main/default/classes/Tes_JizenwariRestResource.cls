@isTest(seeAllData=true)
public class Tes_JizenwariRestResource {

    // 新規申し込み
    static testMethod void testCase1(){

        //カスタム設定のTriggerIsActive__cのデータを作成
        /*TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;*/


        String json1 = '{'+
        '\"gaclient_id\":\"11111\",'+
        '\"last_name\":\"高輪\",'+
        '\"first_name\":\"五郎\",'+
        '\"last_name_kana\":\"カスタム\",'+
        '\"first_name_kana\":\"テスト\",'+
        '\"address_post\":\"132-0000\",'+
        '\"address_state\":\"東京都\",'+
        '\"address_city\":\"千代田区\",'+
        '\"address_street\":\"神田岩本町２２２\",'+
        '\"email\":\"test@minrevi.jp\",'+
        '\"uniq_id\":\"1111\",'+
        '\"payment_status\":\"事前割-申込完了\",'+
        '\"request_number\":\"121212\",'+
        '\"phone\":\"080-1111-1111\",'+
        '\"NyukinBankMeigi\":\"テスト タロウ\",'+
        '\"Sogi_planHope\":\"一般葬\",'+
        '\"AreaState\":\"東京都\",'+
        '\"AreaCity\":\"渋谷区\",'+
        '\"Plan\":\"事前割3年（500円）\",'+
        '\"NyukinDay\":\"2017/07/07\",'+
        '\"payment_type\":\"クレジットカード決済\",'+
        '\"status\":\"入院中\",'+
        '\"correspondingStopDate\":\"2017/07/07\",'+
        '\"settleCompleteDate\":\"2017/07/07\",'+
        '\"cancelReceiptDate\":\"2017/07/07\",' +
        '\"SimpleJizenwariOwns_material\":\"持っていない\",'+
        '\"sId\":\"12345\"'+
        '}';


        Test.startTest();

        RestRequest  req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        
        req1.requestURI = '/services/apexrest/Jizenwari/';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(json1);

        RestContext.request = req1;
        RestContext.response= res1;

        // システム用Account作成
        /*String accountDefaultRecordType = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null');

        Account systemAccount = new Account(LastName = 'システム',FirstName = 'アカウント', RecordTypeId = accountDefaultRecordType);
        insert systemAccount;


        JizenWariPlan__c jizenWariPlan = new JizenWariPlan__c(Name = 'test',Code__c = 'Yoriso');
        insert jizenWariPlan;

        Product2 plan = new Product2(Name = '葬儀プラン',ProductCode = '12345',SougiPlan__c = true, ShohinBango__c = 'SBG-0000075');
        insert plan;

        /*Id pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry pde1 = new PricebookEntry(Product2Id = plan.Id, KakakuEntryBango__c = '00001', Pricebook2Id = pricebook2Id, UnitPrice = 15000,IsActive = true);
        insert pde1;*/


        Ctl_JizenwariRestResource.create();

        String json2 = '{'+
        '\"payment_status\":\"事前割-申込完了\",'+
        '\"sId\":\"12345\",'+
        '\"payment_type\":\"credit\",'+
        '\"correspondingStopDate\":\"2017/07/07\",'+
        '\"settleCompleteDate\":\"2017/07/07\",'+
        '\"cancelReceiptDate\":\"2017/07/07\"' +
        '}';

        RestRequest  req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        
        req2.requestURI = '/services/apexrest/Jizenwari/';
        req2.httpMethod = 'PUT';
        req2.requestBody = Blob.valueof(json2);

        RestContext.request = req2;
        RestContext.response= res2;

        //Ctl_JizenwariRestResource.edit();

        Test.stopTest();
    }
    // 新規申し込み
    static testMethod void testCase2(){

        //カスタム設定のTriggerIsActive__cのデータを作成
        /*TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;*/


        Test.startTest();

        String json2 = '{'+
        '\"payment_status\":\"事前割-申込完了\",'+
        '\"sId\":\"12345\",'+
        '\"payment_type\":\"credit\",'+
        '\"correspondingStopDate\":\"2017/07/07\",'+
        '\"settleCompleteDate\":\"2017/07/07\",'+
        '\"cancelReceiptDate\":\"2017/07/07\"' +
        '}';

        RestRequest  req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        
        req2.requestURI = '/services/apexrest/Jizenwari/';
        req2.httpMethod = 'PUT';
        req2.requestBody = Blob.valueof(json2);

        RestContext.request = req2;
        RestContext.response= res2;
        
		Account acc=new Account();
		acc.name = 'testdsdf';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		acc.Phone='080-0000-0001';
		acc.MobilePhone__c='080-0000-0001';
		insert acc;

        
        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId,MailAddress__c = 'test@minrevi.jp');
        insert sodansha;
        Jizenwari__c service = new Jizenwari__c(KeiyakuSha__c = sodansha.Id,MoushikomiKanryoBi__c = date.Today());
        insert service;     
        		
        opportunity opp=new opportunity();
        opp.accountid=acc.id;
        opp.Name='test';
        opp.StageName='商談開始';
        opp.CloseDate=system.today();
        opp.accountid=acc.id;
        opp.TaishoushaJokyo__c = '_';
        opp.JizenwariRef__c = service.Id;
        insert opp;                  
        
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai=new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.SeikyuBango__c='12345';
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c='paydesign_credit';
		oOkyakusamaSeikyuMeisai.OpportunityRef__c=opp.id;		
		insert oOkyakusamaSeikyuMeisai;
        Ctl_JizenwariRestResource.edit();

        Test.stopTest();
    }    

}