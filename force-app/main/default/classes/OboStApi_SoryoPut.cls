public class OboStApi_SoryoPut {

    public static final String ServiceFeatureTags_KaimyoOnly = '戒名のみ';
    public static final String ServiceFeatureTags_AmazonYahoo = 'AmazonYahoo';
    public static final String ServiceFeatureTags_TeigakuTehaiDaiko = '定額僧侶手配代行';

	public class ReqBody {
		//public String keiyaku_bango;
		public String partner_id; //torihikisaki_bango;
		public String partner_name; //torihikisaki_name;
        public Place place = new Place();
		public String shushi;
		public String shuha;
        public String temple;
		public String rank;
		public Boolean is_active;
		public List<String> unavailable_services = new List<String>();
		public List<Sekosha> contractors = new List<Sekosha>();
        public String toJson(){ return JSON.serialize( this ); }
	}

	public class Place {
		public String postal_code;
		public String address;
		public Decimal latitude;
		public Decimal longitude;
	}

	public class Sekosha {
		public String contract_id; //keiyaku_bango;
		public String partner_id; //torihikisaki_bango;
		public String partner_name; // torihikisaki_name;
	}

    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public Result sendRequest(String pKeiyakuBango, ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/contracts/' + pKeiyakuBango;
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
                    Loggings.Level.Error, '20190304-1433-01', 'OboStApi_SoryoPut.sendRequest')
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