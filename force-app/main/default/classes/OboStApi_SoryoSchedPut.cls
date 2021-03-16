public class OboStApi_SoryoSchedPut {

    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }
	public class ReqBody {
		public List<Event> schedules = new List<Event>();
        public String toJson(){ return JSON.serialize( this ); }
	}
	public class Event {
		public String start_datetime;
		public String end_datetime;
	}

    public Result sendRequest(String pTorihikiSakiBango, ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/partners/' + pTorihikiSakiBango + '/schedules';
            theResult.reqBodyRaw = pReqBody.toJson();

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody( theResult.reqBodyRaw );
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

        if (!theResult.isSuccess) {
        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190304-1442-01', 'OboStApi_SoryoSchedPut.sendRequest')
                    .putAttr('theResult.endPoint', theResult.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                    .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                    .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                    .putAttr('theResult.descr',theResult.descr)
            );
        }

        return theResult;
    }
}