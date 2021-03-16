@isTest
public class Tes_Api_V1_Member_YorisoJizenwariCerts {
	static testMethod void testCase1() {

        account acc=new account();
        acc.lastname='test';
        insert acc;
        acc=[select id,TorihikisakiBangoF__c from account limit 1];

	    Test.startTest();
		   restRequest req = new RestRequest(); 
		    RestResponse res = new RestResponse();
		    req.requestURI = '/services/apexrest/api/v1/member/yoriso_member_certs';  
		    req.addParameter('cust_cd', acc.Id);
		    req.httpMethod = 'GET';
		    RestContext.request = req;
		    RestContext.response = res;		
		    Api_V1_Member_YorisoJizenwariCerts.doGet();
        Test.stopTest();
	}

	static testMethod void testCase2() {

        account acc=new account();
        acc.lastname='test';
        insert acc;
        acc=[select id,TorihikisakiBangoF__c from account limit 1];

	    Test.startTest();
		   restRequest req = new RestRequest(); 
		    RestResponse res = new RestResponse();
		    req.requestURI = '/services/apexrest/api/v1/member/yoriso_member_certs';  
		    req.addParameter('cust_cd', acc.TorihikisakiBangoF__c);
		    req.httpMethod = 'GET';
		    RestContext.request = req;
		    RestContext.response = res;		
		    Api_V1_Member_YorisoJizenwariCerts.doGet();
        Test.stopTest();
	}

}