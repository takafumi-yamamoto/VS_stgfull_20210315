@isTest
private class Api_V1_OboDashinResT {

    @testSetup
    static void setup() {
        DashinTestData.dashin_test_data_init();
        DashinTestData.init_DashIraiHist();
    }

    @isTest
    static void Api_V1_OboDashinRes_accepted_test() {
        DashIrai__c dashiIrai = [SELECT Id, offer_id__c FROM DashIrai__c Limit 1].get(0);
        Opportunity opp = [SELECT Id, ShodanBango__c From Opportunity WHERE DashIraiRef__c = :dashiIrai.Id LIMIT 1].get(0);
        Keiyaku__c keiyaku = [ SELECT Id, KeiyakuBango__c FROM Keiyaku__c LIMIT 1 ].get(0);

        String json = '{' +
                        '  \"offer_id\": ' + dashiIrai.offer_id__c +  ',' +
                        '  \"shodan_bango\": \"' + opp.ShodanBango__c + '\",' +
                        '  \"result\": \"ok\",' +
                        '  \"sokyakusaki\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '  \"sekotanto\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '  \"accepted_datetime\": \"\",' +
                        '  \"replies\": [' +
                        '    {' +
                        '      \"keiyaku_bango\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '      \"answer\": \"accept\"' +
                        '    }' +
                        '  ]' +
                        '}';
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/api/v1/obo-dashin-res';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

        Api_V1_OboDashinRes.doPost();
        Test.stopTest();

    }

    @isTest
    static void Api_V1_OboDashinRes_reject_test() {
        DashIrai__c dashiIrai = [SELECT Id, offer_id__c FROM DashIrai__c Limit 1].get(0);
        Opportunity opp = [SELECT Id, ShodanBango__c From Opportunity WHERE DashIraiRef__c = :dashiIrai.Id LIMIT 1].get(0);
        Keiyaku__c keiyaku = [ SELECT Id, KeiyakuBango__c FROM Keiyaku__c LIMIT 1 ].get(0);

        String json = '{' +
                        '  \"offer_id\": ' + dashiIrai.offer_id__c +  ',' +
                        '  \"shodan_bango\": \"' + opp.ShodanBango__c + '\",' +
                        '  \"result\": \"ok\",' +
                        '  \"sokyakusaki\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '  \"sekotanto\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '  \"accepted_datetime\": \"\",' +
                        '  \"replies\": [' +
                        '    {' +
                        '      \"keiyaku_bango\": \"' + keiyaku.KeiyakuBango__c +'\",' +
                        '      \"answer\": \"reject\"' +
                        '    }' +
                        '  ]' +
                        '}';
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/api/v1/obo-dashin-res';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

        Api_V1_OboDashinRes.doPost();
        Test.stopTest();

    }

    @isTest
    static void Api_V1_OboDashinRes_Exception() {

        String json = '{' +
                        '  \"offer_id\": 123456789,' +
                        '  \"shodan_bango\": \"xxxx\",' +
                        '  \"result\": \"ok\",' +
                        '  \"sokyakusaki\": \"xxxx\",' +
                        '  \"sekotanto\": \"xxxx\",' +
                        '  \"accepted_datetime\": \"\",' +
                        '  \"replies\": [' +
                        '    {' +
                        '      \"keiyaku_bango\": \"sdf\",' +
                        '      \"answer\": \"accept\"' +
                        '    }' +
                        '  ]' +
                        '}';
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/api/v1/obo-dashin-res';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

        Api_V1_OboDashinRes.doPost();
        Test.stopTest();

    }

    @isTest
    static void Api_V1_OboDashinRes_null_test() {
        // Implement test code

        String json = '';
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/api/v1/obo-dashin-res';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

        Api_V1_OboDashinRes.doPost();
        Test.stopTest();

    }

    @isTest
    static void Api_V1_OboDashinRes_blank_test() {
        // Implement test code

        String json = '{' +
                        '  \"offer_id\": null,' +
                        '  \"shodan_bango\": \"\",' +
                        '  \"result\": \"\",' +
                        '  \"sokyakusaki\": \"\",' +
                        '  \"sekotanto\": \"\",' +
                        '  \"accepted_datetime\": \"\",' +
                        '  \"replies\": [' +
                        '    {' +
                        '      \"keiyaku_bango\": \"\",' +
                        '      \"answer\": \"\"' +
                        '    }' +
                        '  ]' +
                        '}';
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/api/v1/obo-dashin-res';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;

        Api_V1_OboDashinRes.doPost();
        Test.stopTest();

    }
}