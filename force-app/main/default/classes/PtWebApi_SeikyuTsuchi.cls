public class PtWebApi_SeikyuTsuchi {

	public class ReqBody{
        String torihikisaki_bango = '';
        String seikyu_bango = '';
        String kokyaku_id = '';
    }

    public class ReqArgs{
        public String torihikisaki_bango = '';
        public String seikyu_bango = '';
        public String kokyaku_id = '';
    }

    public class Result{
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){

	        Result theResult = new Result();
	        
	        try {
                theResult.endPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/seikyu';
                theResult.reqBodyRaw = this.createReqBodyJson(pReqArgs);
                System.debug('theResult.reqBodyRaw:' + theResult.reqBodyRaw);

                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                request.setBody( theResult.reqBodyRaw );
                PtWebApi_Auth.setAuthHeader(request);

                HttpResponse response = new http().send(request);

                theResult.statusCode = response.getStatusCode();
                theResult.resBodyRaw = response.getBody();
                theResult.isSuccess = theResult.statusCode == 200;
            }catch(Exception e){
                theResult.isSuccess = false;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }

	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20190523-1853-01', 'PtWebApi_SeikyuTsuchi.Post')
	                .putAttr('theResult.endPoint', theResult.endPoint)
	                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
	                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
	                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
	                .putAttr('theResult.descr',theResult.descr)
	        );

            return theResult;
	    }

	    public String createReqBodyJson(ReqArgs pArgs){
	        ReqBody theReqBody = new ReqBody();
	        theReqBody.torihikisaki_bango = pArgs.torihikisaki_bango;
	        theReqBody.seikyu_bango = pArgs.seikyu_bango;
	        theReqBody.kokyaku_id = pArgs.kokyaku_id;
	        return JSON.serialize( theReqBody );
	    }
	}
}