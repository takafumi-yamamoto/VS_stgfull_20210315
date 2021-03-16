@isTest
private class Api_V1_PtWeb_PartnerSeikyushoListT {
	
	@testSetup
    static void initializeTestData() {

		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		//acc.LastNameFurigana__pc ='defualt';
		//acc.FirstNameFurigana__pc ='defualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
		insert dacc;

		//カスタム設定のTriggerIsActive__cのデータを作成
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;

		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        PartnerSeikyuSogisha__c pss = new PartnerSeikyuSogisha__c();
        pss.KokyakuId__c = '0002';
        pss.TorihikisakiBango__c = '1234';
        pss.SeikyuStatus__c = '請求済';
        pss.SeikyuKingaku__c = 10000;
        pss.Seikyubi__c = date.today();
        pss.ShiharaiKijitsu__c = date.today();
        pss.NyukinShimekiribi__c = date.today();
        insert pss;

        PartnerSeikyuMeisaiSogisha__c psms = new PartnerSeikyuMeisaiSogisha__c();
        psms.PartnerSeikyuSogishaRef__c = pss.Id;

        insert psms;
    }

	@isTest
	static void test_method_one() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/partnerseikyusho/list';
        req.httpMethod = 'GET';
        req.params.put('torihikisaki_bango', '1234');

        RestContext.request = req;
        RestContext.response= res;
    
		Api_V1_PtWeb_PartnerSeikyushoList.doGet();

        Test.stopTest();
	}
}