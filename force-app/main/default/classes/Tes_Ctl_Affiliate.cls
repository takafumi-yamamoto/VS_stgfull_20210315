@isTest
private class Tes_Ctl_Affiliate {
	
    /**
     * This is a test method for onCaseAfterInsert
     */
    static testMethod void test_onCaseAfterInsert() {

        // PageReference pageRef = Page.Ctl_Affiliate;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Case childCase = new Case();
        childCase.parent_mailshori_id__c = 'uniq_id__c123456';

        Case pCase = new Case();
        pCase.uniq_id__c = 'uniq_id__c123456';

        insert childCase;
        insert pCase;
        
        Test.startTest();

		List<Case> caseList = new List<Case>{pCase};

		Ctl_Affiliate ctl_Affiliate = new Ctl_Affiliate();
		ctl_Affiliate.onCaseAfterInsert(caseList);


        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }
	
}