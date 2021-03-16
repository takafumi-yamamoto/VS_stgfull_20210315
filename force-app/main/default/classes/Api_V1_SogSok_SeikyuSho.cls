@RestResource(urlMapping='/api/v1/sogsok/seikyusho/*')
global class Api_V1_SogSok_SeikyuSho {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String resBodyRaw = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    public class ReqBody{
        Api_V1_SogSok_SeikyuSho_Data.SeikyuSho seikyusho;
        public ReqBody readJson(String pJson){
            this.seikyusho =
                (Api_V1_SogSok_SeikyuSho_Data.SeikyuSho)
                JSON.deserializeStrict(pJson, Api_V1_SogSok_SeikyuSho_Data.SeikyuSho.class);
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
    public static String errCode_mitsumori_notyet = 'mitsumori_notyet';
    public static String errCode_illegal_product_settings = 'illegal_product_settings';

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
                    theResult.resBodyOnErr.errors.addAll(theProcResult.resBodyOnErr.errors);
                }
            }catch(Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
                theResult.resBodyOnErr.addEntry(errCode_unhandled, theResult.descr);
            }
        }

        if(theResult.statusCode != 200){
            theResult.resBodyRaw = JSON.serializePretty(theResult.resBodyOnErr);
        }
        theRes.statusCode = theResult.statusCode;
        theRes.responseBody = Blob.valueOf(theResult.resBodyRaw);

        Loggings.writeLog(
            Loggings.createLogEntry(
                theResult.statusCode == 500 ? Loggings.Level.Error : Loggings.Level.Info, '20180813-1147-01', 'SogSok.SeikyuSho.Receive')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

    private class ProcResult{
        Boolean isSuccess = true;
        String errCode = '';
        String descr = '';
        ResBodyOnErr resBodyOnErr = new ResBodyOnErr();
    }

    private class Processor{
        public ProcResult process(ReqBody pReqBody){
            ProcResult theProcResult = new ProcResult();

            List<SogSok_Sokyaku__c> theSoukyakus = [
                select Id, SoukyakuStatus__c, 
                MitsumoriShoRef__c, MitsumoriShoRef__r.DocStatus__c,
                SeikyuShoRef__c ,SeikyuShoRef__r.DocStatus__c
                from SogSok_Sokyaku__c 
                where Name = :pReqBody.seikyusho.soukyaku_bango 
                limit 1
            ];
            if(theSoukyakus.size() <= 0){
                theProcResult.isSuccess = false; 
                theProcResult.errCode = errCode_soukyaku_closed_already;
                theProcResult.descr = 'soukyaku not found';
                theProcResult.resBodyOnErr.addEntry(theProcResult.errCode, theProcResult.descr);
                return theProcResult;
            }
            SogSok_Sokyaku__c theSoukyaku = theSoukyakus.get(0);

            if( !(theSoukyaku.SoukyakuStatus__c == 'wait_for_mitsumorisho' || theSoukyaku.SoukyakuStatus__c == 'wait_for_seikyusho') ){
                theProcResult.isSuccess = false;
                theProcResult.errCode = errCode_soukyaku_closed_already;
                theProcResult.resBodyOnErr.addEntry(theProcResult.errCode, theProcResult.descr);
                return theProcResult;
            }
            if( !(theSoukyaku.SeikyuShoRef__r.DocStatus__c != 'activated') ){
                theProcResult.isSuccess = false;
                theProcResult.errCode = errCode_doc_activated_already;
                theProcResult.resBodyOnErr.addEntry(theProcResult.errCode, theProcResult.descr);
                return theProcResult;
            }
            if( !(theSoukyaku.MitsumoriShoRef__r.DocStatus__c == 'activated') ){
                theProcResult.isSuccess = false;
                theProcResult.errCode = errCode_mitsumori_notyet;
                theProcResult.resBodyOnErr.addEntry(theProcResult.errCode, theProcResult.descr);
                return theProcResult;
            }

            String planShohinBango = pReqBody.seikyusho.sogi_plan.shohin_bango;
            for(Api_V1_SogSok_SeikyuSho_Data.SeikyuSho_Tsuika_hinmokus tsuikaHinLine : pReqBody.seikyusho.tsuika_hinmokus){

                String tsuikaShohinBango = tsuikaHinLine.shohin_bango;
                if(planShohinBango == 'SBG-0005006' || planShohinBango == 'SBG-0005008'){ //【20.11】よりそう家族葬 一日プラン
                    if(tsuikaShohinBango == 'SBG-0005404'){ //【20.11】祭壇アップグレード L (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '一日プランに祭壇アップグレード L (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005405'){ //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '一日プランに祭壇アップグレード LL (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005406'){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '一日プランに祭壇アップグレード LL (家族葬 華やかプラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005416'){ //【20.11】よりそうオプション 遺影写真 (大小2枚)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '一日プランに遺影写真は設定できません');
                    }
                }
                if(planShohinBango == 'SBG-0005002'){ //【20.11】よりそう家族葬 二日プラン
                    if(tsuikaShohinBango == 'SBG-0005401'){ //【20.11】祭壇アップグレード M (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '二日プランに祭壇アップグレード M (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005402'){ //【20.11】祭壇アップグレード L (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '二日プランに祭壇アップグレード L (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005403'){ //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '二日プランに祭壇アップグレード LL (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005406'){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '二日プランに祭壇アップグレード LL (家族葬 華やかプラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005416'){ //【20.11】よりそうオプション 遺影写真 (大小2枚)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '二日プランに遺影写真は設定できません');
                    }
                }
                if(planShohinBango == 'SBG-0005003'){ //【20.11】よりそう家族葬 華やかプラン
                    if(tsuikaShohinBango == 'SBG-0005401'){ //【20.11】祭壇アップグレード M (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに祭壇アップグレード M (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005402'){ //【20.11】祭壇アップグレード L (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに祭壇アップグレード L (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005403'){ //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに祭壇アップグレード LL (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005404'){ //【20.11】祭壇アップグレード L (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに祭壇アップグレード L (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005405'){ //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに祭壇アップグレード LL (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005416'){ //【20.11】よりそうオプション 遺影写真 (大小2枚)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '華やかプランに遺影写真は設定できません');
                    }
                }
                if(planShohinBango == 'SBG-0005004' || planShohinBango == 'SBG-0005007' || planShohinBango == 'SBG-0005009'){ //【20.11】よりそう火葬式 直葬プラン,  旧【20.11】よりそう火葬式 直葬プラン、【21.03】よりそう火葬式 シンプルプラン
                    if(tsuikaShohinBango == 'SBG-0005401'){ //【20.11】祭壇アップグレード M (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード M (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005402'){ //【20.11】祭壇アップグレード L (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード L (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005403'){ //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード LL (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005404'){ //【20.11】祭壇アップグレード L (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード L (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005405'){ //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード LL (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005406'){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに祭壇アップグレード LL (家族葬 華やかプラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005417'){ //【20.11】よりそうオプション 付添安置 (1泊)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直葬プランに付添安置は設定できません');
                    }
                }
                if(planShohinBango == 'SBG-0005005'){ //【20.11】よりそう火葬式 標準プラン
                    if(tsuikaShohinBango == 'SBG-0005401'){ //【20.11】祭壇アップグレード M (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード M (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005402'){ //【20.11】祭壇アップグレード L (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード L (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005403'){ //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード LL (家族葬 一日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005404'){ //【20.11】祭壇アップグレード L (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード L (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005405'){ //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード LL (家族葬 二日プラン)は設定できません');
                    }
                    if(tsuikaShohinBango == 'SBG-0005406'){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
                        theProcResult.isSuccess = false;
                        theProcResult.errCode = errCode_illegal_product_settings;
                        theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに祭壇アップグレード LL (家族葬 華やかプラン)は設定できません');
                    }
                }
            }

            if(planShohinBango == 'SBG-0005004' || planShohinBango == 'SBG-0005007' || planShohinBango == 'SBG-0005009'){ //【20.11】よりそう火葬式 直葬プラン, 旧【20.11】よりそう火葬式 直葬プラン, 【21.03】よりそう火葬式 シンプルプラン
                if(pReqBody.seikyusho.sogi_plan.butsugu_kibo == '仏具なし'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直送プランに仏具なし割引は設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.last_message == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直送プランにラストメッセージは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.ohanaire == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直送プランにお花入れは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.memorial_corner == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直送プランにメモリアルコーナーは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.iei_hanakazari == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '直送プランに遺影写真は設定できません');
                }
            }

            if(planShohinBango == 'SBG-0005005'){ //【20.11】よりそう火葬式 標準プラン
                if(pReqBody.seikyusho.sogi_plan.last_message == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランにラストメッセージは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.ohanaire == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランにお花入れは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.memorial_corner == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランにメモリアルコーナーは設定できません');
                }
                if(pReqBody.seikyusho.sogi_plan.iei_hanakazari == '希望する'){
                    theProcResult.isSuccess = false;
                    theProcResult.errCode = errCode_illegal_product_settings;
                    theProcResult.resBodyOnErr.addEntry(errCode_illegal_product_settings, '標準プランに遺影写真は設定できません');
                }
            }

            if(!theProcResult.isSuccess){
                return theProcResult;
            }

            SogSok_SeikyuSho__c theSogSokSeikyuSho = 
                new Api_V1_SogSok_SeikyuSho_Data().createSogSokSeikyuSho(pReqBody.seikyusho);
            Insert theSogSokSeikyuSho;

            List<SogSok_Seikyusho_TsuikaHinLine__c> theSogSokSeikyushoTsuikaHinLines =
                new Api_V1_SogSok_SeikyuSho_Data()
                    .createSogSokSeikyuShoTsuikaHinLines(pReqBody.seikyusho, theSogSokSeikyuSho.Id);
            
            Insert theSogSokSeikyushoTsuikaHinLines;

            List<SogSok_Seikyusho_WaribikiLine__c> theSogSokSeikyushoWaribikiLines =
                new Api_V1_SogSok_SeikyuSho_Data()
                    .createSogSokSeikyuShoWaribikiLines(pReqBody.seikyusho, theSogSokSeikyuSho.Id);

            Insert theSogSokSeikyushoWaribikiLines;
            Delete [select Id from SogSok_SeikyuSho__c where Id = :theSoukyaku.SeikyuShoRef__c];

            theSoukyaku.SeikyuShoRef__c = theSogSokSeikyuSho.id;

            if(theSogSokSeikyuSho.DocStatus__c == 'Activated'){
                theSoukyaku.SoukyakuStatus__c = 'seikyusho_received';
            }
            
            Update theSoukyaku;

            theProcResult.isSuccess = true;
            return theProcResult;
        }
    }
}