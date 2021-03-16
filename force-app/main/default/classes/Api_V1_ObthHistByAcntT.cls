@isTest
public class Api_V1_ObthHistByAcntT {
	
	public class DataProviderStub_Success implements Api_V1_ObthHistByAcntDt.IDataProvider{
		public Api_V1_ObthHistByAcntRes.Response getResponse(Api_V1_ObthHistByAcntReq.Req pReq){
			return new Api_V1_ObthHistByAcntRes.Response();
		}
	}
	public class DataProviderStub_NotFound implements Api_V1_ObthHistByAcntDt.IDataProvider{
		public Api_V1_ObthHistByAcntRes.Response getResponse(Api_V1_ObthHistByAcntReq.Req pReq){
			throw new Api_V1_ObthHistByAcntDt.AccountNotFoundException();
		}
	}

	@isTest
	public static void httpGet(){
		RestRequest theRestRequest = new RestRequest();
		theRestRequest.requestUri ='/services/apexrest/api/v1/obotehai-history-by-account/test001';
		theRestRequest.httpMethod = 'GET';
		RestContext.request = theRestRequest;
		RestContext.response = new RestResponse();
		
		Test.startTest();
		Api_V1_ObthHistByAcnt.mRunner = 
			new Api_V1_ObthHistByAcnt.Runner(
				new DataProviderStub_Success()
			);

		Api_V1_ObthHistByAcnt.httpGet();
		Test.stopTest();
	}

	@isTest
	public static void httpGet_AccountNoFound(){
		RestRequest theRestRequest = new RestRequest();
		theRestRequest.requestUri ='/services/apexrest/api/v1/obotehai-history-by-account/test001';
		theRestRequest.httpMethod = 'GET';
		RestContext.request = theRestRequest;
		RestContext.response = new RestResponse();
		
		Test.startTest();
		Api_V1_ObthHistByAcnt.mRunner = 
			new Api_V1_ObthHistByAcnt.Runner(
				new DataProviderStub_NotFound()
			);

		Api_V1_ObthHistByAcnt.httpGet();
		Test.stopTest();
	}

	@isTest
	public static void httpGet_InvalidRequest(){
		RestRequest theRestRequest = new RestRequest();
		theRestRequest.requestUri ='/services/apexrest/api/v1/obotehai-history-by-account/';
		theRestRequest.httpMethod = 'GET';
		RestContext.request = theRestRequest;
		RestContext.response = new RestResponse();
		
		Test.startTest();
		// Api_V1_ObthHistByAcnt.mRunner = 
		// 	new Api_V1_ObthHistByAcnt.Runner(
		// 		new DataProviderStub_NotFound()
		// 	);

		Api_V1_ObthHistByAcnt.httpGet();
		Test.stopTest();
	}
}