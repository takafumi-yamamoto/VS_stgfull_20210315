@RestResource(urlMapping='/api/v1/soukyaku/detail/*')
global class Api_V1_SogSok_Soukyaku_Detail{

    public class ReqBody{
        public String soukyaku_bango = '';
    }

    public class ResBody{
        public Api_V1_SogSok_Soukyaku_Data.Soukyaku soukyaku;
        public Api_V1_SogSok_Soukyakusho_Data.SoukyakuSho soukyakusho;
        public Api_V1_SogSok_MitsumoriSho_Data.MitsumoriSho mitsumorisho;
        public Api_V1_SogSok_SeikyuSho_Data.SeikyuSho seikyusho;
        public Api_V1_SogSok_SrthIraiSho_Data.SrthIraiSho srthiraisho;
        public String toJson(){ return JSON.serialize( this ); }
    }

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');

        String theSoukyakuBango = theReq.params.get('soukyaku_bango');
        if( String.isBlank(theSoukyakuBango) ){
            theRes.statusCode = 400;
            return;
        }
        ReqBody theReqBody = new ReqBody();
        theReqBody.soukyaku_bango = theSoukyakuBango;

        ResBody theResBody = new Processor().run(theReqBody);

        theRes.responseBody = Blob.valueOf( theResBody.toJson() );
        
    }

    private class Processor{

        public ResBody run(ReqBody pReqBody){
            ResBody theResBody = new ResBody();
            theResBody.soukyaku = new Api_V1_SogSok_Soukyaku_Data().selectSoukyakuBySoukyakuBango( pReqBody.soukyaku_bango );
            theResBody.soukyakusho = new Api_V1_SogSok_Soukyakusho_Data().selectSoukyakuShoBySoukyakuBango( pReqBody.soukyaku_bango );
            theResBody.mitsumorisho = new Api_V1_SogSok_MitsumoriSho_Data().selectMitsumoriShoBySoukyakuBango( pReqBody.soukyaku_bango );
            theResBody.seikyusho = new Api_V1_SogSok_SeikyuSho_Data().selectSeikyuShoBySoukyakuBango( pReqBody.soukyaku_bango );
            theResBody.srthiraisho = new Api_V1_SogSok_SrthIraiSho_Data().selectSrthIraiShoBySoukyakuBango(pReqBody.soukyaku_bango);
            return theResBody;
        }
    }
}