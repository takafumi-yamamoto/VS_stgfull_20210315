public class OboStApi_InactivateSoryoCmdPost {


    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public Result sendRequest(String pKeiyakuBango) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/contracts/' + pKeiyakuBango + '/activate';

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('DELETE');
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
                    Loggings.Level.Error, '20190319-1400-01', 'OboStApi_InactivateSoryoCmdPost.sendRequest')
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