@isTest
public class Tes_Api_V1_PartnerContract_Simple {
	static testMethod void testCase1() {
String json = '{'+
        '\"sogisha\":{'+
        '\"sogisha_moshikomibi\":\"2018-04-01\",'+
        '\"sogisha_kaishamei_kana\":\"テストソウギシャ\",'+
        '\"sogisha_kaishamei\":\"テスト葬儀社\"'+
        '},'+
        '\"saijo\":[{'+
        '\"saijo_saijokubun\":\"自社斎場\",'+
        '\"heya\":[{'+
                   '\"saijo_heyamei\":\"テスト部屋1\"'+
        '}]'+
        '}],'+
        '\"interview\":{'+
        '\"interview_hekinsekokensunen\":\"10件\"'+
        '}'+
        '}';

	    Test.startTest();
	        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/api/v1/partnercontract_simplenaososhiki';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof(json);

        RestContext.request = req;
        RestContext.response= res;
        
        Api_V1_PartnerContract_Simple.doPost();
	    
	        
        Test.stopTest();        
    }
}