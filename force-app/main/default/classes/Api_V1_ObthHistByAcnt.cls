@RestResource(urlMapping='/api/v1/obotehai-history-by-account/*')
global class Api_V1_ObthHistByAcnt {
	public static Runner mRunner = 
		new Runner(
			new Api_V1_ObthHistByAcntDt.DataProvider(
				new Api_V1_ObthHistByAcntRes.OboTehaiValidator()
			)
		);


	@HttpGet
	global static void httpGet(){

		Api_V1_ObthHistByAcntReq.Req theReq = null;
		try{
			theReq = new ReqParser().parseReq(RestContext.request);
		}catch(Exception ex){
			Api_V1_ObthHistByAcntRes.Res theRes =
				createRes_Error(
					Api_V1_ObthHistByAcntRes.ErrorCodes.invalid_request,
					'invalid_request'
				);
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize( theRes ));
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.statusCode = 400;
			return;
		}
		
		try{
			Api_V1_ObthHistByAcntRes.Res theRes = mRunner.run(theReq);
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize( theRes ));
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.statusCode = 200;
			return;
		}catch(Api_V1_ObthHistByAcntDt.AccountNotFoundException AcNotFoundEx){
			Api_V1_ObthHistByAcntRes.Res theRes =
				createRes_Error(
					Api_V1_ObthHistByAcntRes.ErrorCodes.account_not_found,
					'account_not_found'
				);
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize( theRes ));
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.statusCode = 404;
			return;
		}catch(Exception ex){
			Api_V1_ObthHistByAcntRes.Res theRes =
				createRes_Error(
					Api_V1_ObthHistByAcntRes.ErrorCodes.unhandled_exception,
					'unhandled_exception'
				);
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize( theRes ));
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.statusCode = 500;
			return;
		}
	}

	private class ReqParser{
		public Api_V1_ObthHistByAcntReq.Req parseReq(RestRequest pRestRequest){
			Api_V1_ObthHistByAcntReq.Req theReq = new Api_V1_ObthHistByAcntReq.Req();
			theReq.torihikisaki_bango = 
				pRestRequest.requestURI.substring( pRestRequest.requestURI.lastIndexOf('/')+1 );
			if( String.isBlank(theReq.torihikisaki_bango)  ) throw new InvalidReqException();
			return theReq;
		}
	}

	public class Runner{
		private Api_V1_ObthHistByAcntDt.IDataProvider mDataProvider;
		public Runner(Api_V1_ObthHistByAcntDt.IDataProvider pDataProvider){
			this.mDataProvider = pDataProvider;
		}

		public Api_V1_ObthHistByAcntRes.Res run(Api_V1_ObthHistByAcntReq.Req pReq){
			return createRes_Success( 
				this.mDataProvider.getResponse(pReq)
			 );
		}
	}

	public static Api_V1_ObthHistByAcntRes.Res createRes_Success(Api_V1_ObthHistByAcntRes.Response pResponse){
		Api_V1_ObthHistByAcntRes.Meta theMeta = new Api_V1_ObthHistByAcntRes.Meta();
		{  
			theMeta.response_status = 
				String.valueOf(Api_V1_ObthHistByAcntRes.ResponseStatuses.success);
		}

		Api_V1_ObthHistByAcntRes.Res theRes = new Api_V1_ObthHistByAcntRes.Res();
		{ theRes.meta = theMeta; theRes.response = pResponse; }

		return theRes;
	}
	public static Api_V1_ObthHistByAcntRes.Res createRes_Error(Api_V1_ObthHistByAcntRes.ErrorCodes pErrCode, String pMsg){
		Api_V1_ObthHistByAcntRes.Error theError = new Api_V1_ObthHistByAcntRes.Error();
		{
			theError.code = String.valueOf(pErrCode);
			theError.message = pMsg;
		}
		Api_V1_ObthHistByAcntRes.Meta theMeta = new Api_V1_ObthHistByAcntRes.Meta();
		{
			theMeta.response_status = 
				String.valueOf(Api_V1_ObthHistByAcntRes.ResponseStatuses.error);
			theMeta.Error = theError;
		}
		Api_V1_ObthHistByAcntRes.Res theRes = new Api_V1_ObthHistByAcntRes.Res();
		{ theRes.meta = theMeta; theRes.response = null; }

		return theRes;
	}

	public class InvalidReqException extends Exception{}
}