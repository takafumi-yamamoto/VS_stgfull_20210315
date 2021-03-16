@isTest
private class Tes_OpportunityLineItemDao {
   /**
     * This is a test method for ListToMapById
     */
    static testMethod void test_ListToMapById() {

        // PageReference pageRef = Page.OpportunityLineItemDao;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		List<OpportunityLineItem> entries = new List<OpportunityLineItem>();
		OpportunityLineItemDao opportunityLineItemDao = new OpportunityLineItemDao();
		Map<Id,OpportunityLineItem> resultListToMapById = opportunityLineItemDao.ListToMapById(entries);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for SelectByTehaiShodanId
     */
    static testMethod void test_SelectByTehaiShodanId() {

        // PageReference pageRef = Page.OpportunityLineItemDao;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		Set<Id> tehaiShodanIds = null;
		OpportunityLineItemDao opportunityLineItemDao = new OpportunityLineItemDao();
		List<OpportunityLineItem> resultSelectByTehaiShodanId = opportunityLineItemDao.SelectByTehaiShodanId(tehaiShodanIds);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


    /**
     * This is a test method for SelectById
     */
    static testMethod void test_SelectById() {

        // PageReference pageRef = Page.OpportunityLineItemDao;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

		List<Id> ids = null;
		OpportunityLineItemDao opportunityLineItemDao = new OpportunityLineItemDao();
		List<OpportunityLineItem> resultSelectById = opportunityLineItemDao.SelectById(ids);

		Id opportunityLineItemId = null;
		OpportunityLineItem resultSelectById2 = opportunityLineItemDao.SelectById(opportunityLineItemId);

        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


}