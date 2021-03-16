public class OboStApi_OfferCancel {
	public class ReqBody {
		public Integer id;
		public String toJson(){ return JSON.serialize( this ); }
	}

    /////////////////////////////////////////////////////////
    //HttpRequest戻り値
    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    /////////////////////////////////////////////////////////
    // HttpRequest
    public Result sendRequest(ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/offers/' + pReqBody.id + '/cancel';
            theResult.reqBodyRaw = pReqBody.toJson();

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            new OboStApi_Auth().setAuthHeader(request);

            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 200;

        } catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
        }

        Loggings.writeLog(
            Loggings.createLogEntry(
                theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20190614-1700-01', 'OboStApi_OfferCancel.sendRequest')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
        return theResult;
    }
}