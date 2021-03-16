@RestResource(urlMapping='/api/v1/sogsok/sogiwaribikilist/*')
global class Api_V1_Sogsok_SogiWaribikiList {

	public class Data{
        public String opp_code = '';
        public String plan_code = '';
        public String butsugu_kibo = '';
    }

	@HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;
        if (res == null) { res = new RestResponse(); RestContext.response = res; }

        try {
            String jsonData = RestContext.request.requestBody.toString();
            System.debug('jsonData:' + jsonData);
            Data theData = (Data)JSON.deserialize(jsonData, Data.class);

            String reBody = '';
            if(String.isBlank(theData.opp_code) || String.isBlank(theData.plan_code)){
        		reBody = 'opp_codeまたはplan_codeがnullです';
            }
            else{
                reBody = new WaribikiShohinAdd_201912().addWaribikiShouhin(theData.opp_code, theData.plan_code, theData.butsugu_kibo);
            }

            res.statusCode = 200; res.responseBody = Blob.valueOf(reBody);
        } catch(Exception e) {
        	res.statusCode = 500;
            res.responseBody = Blob.valueOf(e.getMessage());

            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190410-1600-01', 'Api_V1_Sogsok_SogiWaribikiList')
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
        }

    }
}