@isTest
public class RsCoreApi_UtilT {

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		INSERT new List<KaiinkibanSetting__c>{
			new KaiinkibanSetting__c(
				name='dev',
				client_id__c='',
				client_secret__c='',
				grant_type__c='',
				timeOutPeriod__c=60000,
				Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com',
				KeiyakuCoreFlag__c=true,
				isActive__c=true
			),
			new KaiinkibanSetting__c(
				name='prod',
				client_id__c='',
				client_secret__c='',
				grant_type__c='',
				timeOutPeriod__c=60000,
				Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com',
				KeiyakuCoreFlag__c=true,
				isActive__c=true
            )
        };
		Utility_Common.isMimicExecAsDataIkouProfile = false;
    }
    
    private class HttpRequest_Stub implements RsCoreApi_Util.IHttpRequest{
        public String getJsonQueryString(){return null;}
        public String getEndPoint(){ return 'http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com';  }
        public Boolean isSuccess(HttpResponse res){ return true; }
        public void doOnSuccess(HttpResponse res){ return; }
        public void doOnError(HttpResponse res){ return; }
        public void doOnException(Exception e){ return; }
    }
    private class IRequester_Stub implements RsCoreApi_Util.IRequester{
        public void doAction(RsCoreApi_Util.IHttpRequest action, String method, Boolean isUsePatch){ return;}
    }
    private class IAuthClient_Stub implements RsCoreApi_AuthClients.IAuthClient{
        public String getAccessToken(){ return ''; }
        public Void setAuthHeader(HttpRequest pRequest){ return; }
    }

    @isTest public static void Requester_doAction(){
        beginSetUp();
        Test.setMock( HttpCalloutMock.class, 
            new Testing_HttpResMock()
                .addResponder(
                    new Testing_HttpResponders.CatchAll()
                        .setStatusCode(200)
                )
        );
        endSetUp();

        Test.startTest();
        new RsCoreApi_Util.Requester(
            new IAuthClient_Stub()
        )
        .doAction(
            new HttpRequest_Stub(),    
            'GET',
            false
        );
        Test.stopTest();
    }
    @isTest public static void doGet(){
        RsCoreApi_Util.m_IRequester_instance = new IRequester_Stub();
        Test.startTest();
        RsCoreApi_Util.doGet(
            new HttpRequest_Stub()
        );
        Test.stopTest();
    }

    @isTest public static void doPost(){
        RsCoreApi_Util.m_IRequester_instance = new IRequester_Stub();
        Test.startTest();
        RsCoreApi_Util.doPost(
            new HttpRequest_Stub()
        );
        Test.stopTest();
    }
    @isTest public static void doPut(){
        RsCoreApi_Util.m_IRequester_instance = new IRequester_Stub();
        Test.startTest();
        RsCoreApi_Util.doPut(
            new HttpRequest_Stub()
        );
        Test.stopTest();
    }

    @isTest public static void doPatch(){
        RsCoreApi_Util.m_IRequester_instance = new IRequester_Stub();
        Test.startTest();
        RsCoreApi_Util.doPatch(
            new HttpRequest_Stub()
        );
        Test.stopTest();
    }

    @isTest public static void doDelete(){
        RsCoreApi_Util.m_IRequester_instance = new IRequester_Stub();
        Test.startTest();
        RsCoreApi_Util.doDelete(
            new HttpRequest_Stub()
        );
        Test.stopTest();
    }
}