@RestResource(urlMapping='/api/v1/sogsok/srthiraisho/*')
global class Api_V1_SogSok_SrthIraiSho {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    public class ReqBody{
        Api_V1_SogSok_SrthIraiSho_Data.SrthIraiSho srthIraisho;
        public ReqBody readJson(String pJson){
            this.srthIraisho =
                (Api_V1_SogSok_SrthIraiSho_Data.SrthIraiSho)
                JSON.deserializeStrict(pJson, Api_V1_SogSok_SrthIraiSho_Data.SrthIraiSho.class);
            return this;
        }
    }

    public class ResBodyOnErr{
        public List<ResBodyOnErrEntry> errors = new List<ResBodyOnErrEntry>();
        public ResBodyOnErr addEntry(String pCode, String pMessage){
            this.errors.add(new ResBodyOnErrEntry(pCode, pMessage));
            return this;
        }
    }
    public class ResBodyOnErrEntry{
        public ResBodyOnErrEntry(String pCode, String pMessage){ this.code = pCode; this.message = pMessage; }
        public string code = '';
        public string message = ''; 
    }
    public static String errCode_unhandled = 'unhandled';
    public static String errCode_invalid_json_format = 'invalid_json_format';
    public static String errCode_soukyaku_closed_already = 'soukyaku_closed_already';
    public static String errCode_doc_activated_already = 'doc_activated_already';

    @HttpPost
    global static void doPost() {

        Result theResult = new Result(); theResult.statusCode = 200;
        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;

        ReqBody theReqBody = null;
        if(theResult.statusCode == 200){
            try{
                theResult.reqBodyRaw = theReq.requestBody.toString();
                theReqBody = new ReqBody().readJson(theResult.reqBodyRaw);
            }catch(Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_invalid_json_format, theResult.descr);
            }
        }

        if(theResult.statusCode == 200){
            try{
                ProcResult theProcResult = new Processor().process(theReqBody);
                if(!theProcResult.isSuccess){
                    theResult.statusCode = 400;
                    theResult.descr = theProcResult.descr;
                    theResult.resBodyOnErr.addEntry(theProcResult.errCode, theResult.descr);
                }
            }catch(Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_unhandled, theResult.descr);
                System.Debug( e.getMessage() );
            }
        }

        if(theResult.statusCode != 200){
            theResult.resBodyRaw = JSON.serialize(theResult.resBodyOnErr);
        }
        theRes.statusCode = theResult.statusCode;
        theRes.responseBody = Blob.valueOf(theResult.resBodyRaw);

        Loggings.writeLog(
            Loggings.createLogEntry(
                theResult.statusCode == 200 ? Loggings.Level.Info : Loggings.Level.Error, '20180814-1158-01', 'SogSok.SrthIraiSho.Receive')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

    private class ProcResult{
        Boolean isSuccess = false;
        String errCode = '';
        String descr = '';
    }

    private class Processor{
        public ProcResult process(ReqBody pReqBody){
            ProcResult theProcResult = new ProcResult();

            List<SogSok_Sokyaku__c> theSoukyakus = [
                select Id, SoukyakuStatus__c, 
                SrthIraiShoRef__c, SrthIraiShoRef__r.DocStatus__c 
                from SogSok_Sokyaku__c 
                where Name = :pReqBody.srthIraisho.soukyaku_bango 
                limit 1
            ];
            if(theSoukyakus.size() <= 0){
                theProcResult.isSuccess = false; 
                theProcResult.errCode = errCode_soukyaku_closed_already;
                theProcResult.descr = 'soukyaku not found';
                return theProcResult;
            }
            SogSok_Sokyaku__c theSoukyaku = theSoukyakus.get(0);
            if( !(theSoukyaku.SoukyakuStatus__c == 'wait_for_mitsumorisho' || theSoukyaku.SoukyakuStatus__c == 'wait_for_seikyusho' || theSoukyaku.SoukyakuStatus__c == 'seikyusho_received') ){
                theProcResult.isSuccess = false;
                theProcResult.errCode = errCode_soukyaku_closed_already;
                return theProcResult;
            }

            if( !(theSoukyaku.SrthIraiShoRef__r.DocStatus__c != 'activated') ){
                theProcResult.isSuccess = false;
                theProcResult.errCode = errCode_doc_activated_already;
                return theProcResult;
            }

            SogSok_SrthIraiSho__c theSogSokSrthIraiSho = 
                new Api_V1_SogSok_SrthIraiSho_Data().createSogSokSrthIraiSho(pReqBody.srthIraisho);
            Insert theSogSokSrthIraiSho;

            Delete [select Id from SogSok_SrthIraiSho__c where Id = :theSoukyaku.SrthIraiShoRef__c];

            theSoukyaku.SrthIraiShoRef__c = theSogSokSrthIraiSho.id;
            Update theSoukyaku;

            theProcResult.isSuccess = true;
            return theProcResult;
        }
    }
}