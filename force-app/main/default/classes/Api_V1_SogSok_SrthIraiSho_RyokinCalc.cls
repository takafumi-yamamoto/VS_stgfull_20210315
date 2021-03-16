@RestResource(urlMapping='/api/v1/sogsok/srthiraisho/ryokincalc/*')
global class Api_V1_SogSok_SrthIraiSho_RyokinCalc {

    @HttpPost
    global static void doPost(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;

        Result theResult = new Result();
        theResult.reqBodyRaw = theReq.requestBody.toString();

        try{
            ReqBody theReqBody = (ReqBody)JSON.deserialize(theReq.requestBody.toString(), ReqBody.class);
            ResBody theResBody = new ResBody();
            
            theResBody.amount = 
                new SogSok_SrthRyokin().getPrice(theReqBody.plan_code, theReqBody.kaimyo_code, theReqBody.makurakyo_code);

            theResult.resBodyRaw = JSON.serialize(theResBody);
            theRes.responseBody = Blob.valueOf(theResult.resBodyRaw);
            
            theResult.isSuccess = true;
        }catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.Debug( e.getMessage() );
        }

        theRes.statusCode = theResult.isSuccess ? 200 : 500;
    }

    public class Result{
        public Boolean isSuccess = false;
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public String descr = '';
    }
    private class ReqBody{
        String plan_code = '';
        String makurakyo_code = '';
        String kaimyo_code = '';
    }
    private class ResBody{
        Decimal amount = 0;
    }
}