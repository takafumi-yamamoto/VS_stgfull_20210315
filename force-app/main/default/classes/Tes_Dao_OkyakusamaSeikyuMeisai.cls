@isTest
private class Tes_Dao_OkyakusamaSeikyuMeisai {
 	/**
     * This is a test method for getOkyakusamaSeikyuMeisaiByOppids
     */
    static testMethod void test_getOkyakusamaSeikyuMeisaiByOppids() {

        // PageReference pageRef = Page.Dao_OkyakusamaSeikyuMeisai;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		list<id> OpportunityIds = new list<id>();
		List<OkyakusamaSeikyuMeisai__c> resultGetOkyakusamaSeikyuMeisaiByOppids = Dao_OkyakusamaSeikyuMeisai.getOkyakusamaSeikyuMeisaiByOppids(OpportunityIds);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for getOkyakusamaSeikyuMeisaiByOppid
     */
    static testMethod void test_getOkyakusamaSeikyuMeisaiByOppid() {

        // PageReference pageRef = Page.Dao_OkyakusamaSeikyuMeisai;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		Id OpportunityId = null;
		List<OkyakusamaSeikyuMeisai__c> resultGetOkyakusamaSeikyuMeisaiByOppid = Dao_OkyakusamaSeikyuMeisai.getOkyakusamaSeikyuMeisaiByOppid(OpportunityId);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }

}