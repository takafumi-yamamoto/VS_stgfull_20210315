@RestResource(urlMapping='/api/v1/soukyaku/partner/*')
global class Api_V1_SogSok_Soukyaku_Partner {

    public class ReqBody{
        public String torihikisaki_bango = '';
    }

    public class ResBody{
        public List<Api_V1_SogSok_Soukyaku_Data.Soukyaku> soukyakus = new List<Api_V1_SogSok_Soukyaku_Data.Soukyaku>();
        public String toJson(){ return JSON.serialize( this.soukyakus ); }
    }

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');

        String thePartnerTorihikisakiBango = theReq.params.get('torihikisaki_bango');
        if( String.isBlank(thePartnerTorihikisakiBango) ){
            theRes.statusCode = 400;
            return;
        }
        ReqBody theReqBody = new ReqBody();
        theReqBody.torihikisaki_bango = thePartnerTorihikisakiBango;

        ResBody theResBody = new Processor().run(theReqBody);

        theRes.responseBody = Blob.valueOf( theResBody.toJson() );
        
    }

    private class Processor{

        public ResBody run(ReqBody pReqBody){
            ResBody theResBody = new ResBody();
            theResBody.soukyakus.addall( 
                new Api_V1_SogSok_Soukyaku_Data().selectSoukyakuByPartnerTorihikiSakiBango( pReqBody.torihikisaki_bango ) 
            );
            return theResBody;
        }
    }
}