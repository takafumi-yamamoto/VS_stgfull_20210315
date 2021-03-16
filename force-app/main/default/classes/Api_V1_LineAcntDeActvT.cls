@isTest
private class Api_V1_LineAcntDeActvT {
    
    @isTest static void test_method_one() {
        String json = '{'
                    + ' \"torihikisaki_bango\" : \"\" '
                    + '}';
            
        // Implement test code
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/api/v1/line-account/deactivatation/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        //正常
        Api_V1_LineAcntDeActv.doPost();

        Test.stopTest();
    }
    
    @isTest static void test_method_2() {
        Account acc = new SampleData().getAccountSoryoAccount();
        insert acc;
        Account acc1 = [select 
                Id, TorihikisakiBango__c from Account 
                where id = :acc.Id
                limit 1];
        String json = '{'
                    + ' \"torihikisaki_bango\" : \"' + acc1.TorihikisakiBango__c + '\" '
                    + '}';
            
        // Implement test code
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/api/v1/line-account/deactivatation/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        //正常
        Api_V1_LineAcntDeActv.doPost();

        Test.stopTest();
    }
}