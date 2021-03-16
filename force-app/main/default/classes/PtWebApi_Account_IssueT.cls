@isTest
public class PtWebApi_Account_IssueT {
    public class PtWebApiAuthRes{
        public string access_token = '_';
    }

    @isTest
    public static void sendRequest(){

        TesterMails.f_instance = 
            new TesterMails(new TesterMailEnts.TesterMailEntriesStub(), new Environments.EnvStub().setIsSandBoxFalse());

        PtWebApiAuthRes PtWebApiAuthRes = new PtWebApiAuthRes();
        Test.setMock( HttpCalloutMock.class, 
        	new Testing_HttpResMock()
        		.addResponder(
        			new Testing_HttpResponders.UrlContains()
        				.setStrUrlContains( PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/oauth/token' )
        				.setStatusCode(200)
        				.setBody( JSON.serialize(PtWebApiAuthRes) )
    			)
        		.addResponder(
        			new Testing_HttpResponders.CatchAll()
        				.setStatusCode(200)
    			)
    	);

        PtWebApi_Account_Issue.ReqArgs theReqArg = new PtWebApi_Account_Issue.ReqArgs(); 
        theReqArg.email = '_';

        Test.startTest();
        new PtWebApi_Account_Issue.Agent().sendRequest(theReqArg);
        Test.stopTest();
        
        
        // theReqArg.torihikisaki_bango = '_';
        // theReqArg.torihikisaki_name = '_';
        // theReqArg.role = '_';

    }
}