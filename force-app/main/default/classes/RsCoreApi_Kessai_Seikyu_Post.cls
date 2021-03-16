public class RsCoreApi_Kessai_Seikyu_Post {

    public class ReqBody{
        public String service = '';
        public String title = '';
        public String seikyuBango = '';
        public String paymentMethod = 'カード（GMOPG）';
        public Boolean sokujiUriage = false;
        public Decimal totalAmount = 0;
        public List<ReqBodyService> services = new List<ReqBodyService>();
        public String torihikisakiBango = '';
        public ReqBodySeikyusaki seikyusaki = new ReqBodySeikyusaki();
    }
    public Class ReqBodyService{
        public Decimal totalAmount = 0;
        public String serviceName = '';
        public List<ReqBodyServiceItem> items = new List<ReqBodyServiceItem>();
    }
    public Class ReqBodyServiceItem{
        public String type = '';
        public Decimal price = 0;
        public String name = '';
    }
    public Class ReqBodySeikyusaki{
        public String name = '';
        public String mailAddress = '';
        public String sms = '';
    }

    public class Result{
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public static Result sendRequest(ReqBody pReqBody){
        Result theResult = new Result();

        try {
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setMethod('PUT');

            TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pReqBody.seikyusaki.mailAddress);
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pReqBody.seikyusaki.sms);

            theResult.endPoint = RsCoreApi_Configs.getConfig().Endpoint__c + '/payments/seikyuBango/' + pReqBody.seikyuBango;
            request.setEndpoint(theResult.endPoint);
            theResult.reqBodyRaw = JSON.serialize( pReqBody );
            request.setBody( theResult.reqBodyRaw );

            RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
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
                theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20181115-1326', 'CoreKessai.CoreSeikyusRequest')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );

        return theResult;
    }
}