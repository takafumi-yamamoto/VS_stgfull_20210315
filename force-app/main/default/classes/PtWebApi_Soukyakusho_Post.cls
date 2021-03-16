public class PtWebApi_Soukyakusho_Post {

    public class ReqBody{
        public Api_V1_SogSok_Soukyakusho_Data.SoukyakuSho soukyakusho;
        public String toJson(){ return JSON.serialize( this.soukyakusho ); }
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
            request.setMethod('POST');

            theResult.endPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/soukyaku';
            request.setEndpoint(theResult.endPoint);

            theResult.reqBodyRaw = pReqBody.toJson();
            request.setBody( theResult.reqBodyRaw );

            PtWebApi_Auth.setAuthHeader(request);
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
                theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20180820-1100-01', 'Soukyakusho.Post')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );

        return theResult;
    }

    public ReqBody createReqBody(Id pSoukyakuShoId){
        ReqBody theReqBody = new ReqBody();
        theReqBody.soukyakusho = new Api_V1_SogSok_Soukyakusho_Data().selectSoukyakuShoBySoukyakuShoId(pSoukyakuShoId);
        return theReqBody;
    }


    public List<String> getValidMessages(Api_V1_SogSok_Soukyakusho_Data.SoukyakuSho soukyakusho){
        List<String> msgList = new List<String>();
        if(soukyakusho == null){
            msgList.add('送客書が見つかりません');
            return msgList;
        }

        if(String.isBlank(soukyakusho.soukyaku_bango)){
            msgList.add('送客番号を入力してください');
        }
        if(String.isBlank(soukyakusho.shodan_bango)){
            msgList.add('商談番号を入力してください');
        }
        
        if(String.isBlank(soukyakusho.soukyakusaki.torihikisaki_bango)){
            msgList.add('送客先葬儀社取引先番号を入力してください');
        }
        if(String.isBlank(soukyakusho.soukyakusaki.torihikisaki_name)){
            msgList.add('送客先葬儀社名を入力してください');
        }

        if(String.isBlank(soukyakusho.sodansha.torihikisaki_bango)){
            msgList.add('相談者取引先番号を入力してください');
        }
        if(String.isBlank(soukyakusho.sodansha.sei)){
            msgList.add('相談者姓を入力してください');
        }
        if(String.isBlank(soukyakusho.sodansha.mei)){
            msgList.add('相談者名を入力してください');
        }
        if(String.isBlank(soukyakusho.sodansha.sei_kana)){
            msgList.add('相談者姓カナを入力してください');
        }
        if(String.isBlank(soukyakusho.sodansha.mei_kana)){
            msgList.add('相談者名カナを入力してください');
        }
        if(String.isBlank(soukyakusho.taishosha.torihikisaki_bango)){
            msgList.add('対象者取引先番号を入力してください');
        }
        if(String.isBlank(soukyakusho.taishosha.sei)){
            msgList.add('対象者姓を入力してください');
        }
        if(String.isBlank(soukyakusho.taishosha.mei)){
            msgList.add('対象者名を入力してください');
        }
        if(String.isBlank(soukyakusho.taishosha.sei_kana)){
            msgList.add('対象者姓カナを入力してください');
        }
        if(String.isBlank(soukyakusho.taishosha.mei_kana)){
            msgList.add('対象者名カナを入力してください');
        }
        if(String.isBlank(soukyakusho.omukaesaki.name)){
            msgList.add('お迎え先名称を入力してください');
        }
        if(String.isBlank(soukyakusho.omukaesaki.address)){
            msgList.add('お迎え先住所を入力してください');
        }
        if(String.isBlank(soukyakusho.omukaesaki.anchisaki)){
            msgList.add('お迎え先安置先を入力してください');
        }
        if(String.isBlank(soukyakusho.soryo_tehai.tehai_umu)){
            msgList.add('僧侶手配有無を入力してください');
        }
        if(String.isBlank(soukyakusho.sogi_plan.shohin_bango)){
            msgList.add('希望お葬式プラン_商品番号を入力してください');
        }
        if(String.isBlank(soukyakusho.sogi_plan.name)){
            msgList.add('希望お葬式プラン_プラン名を入力してください');
        }
        if(soukyakusho.sogi_plan.kingaku == null){
            msgList.add('希望お葬式プラン_金額を入力してください');
        }
        if(String.isBlank(soukyakusho.shiharai.kibo_shiharai_hoho)){
            msgList.add('希望支払方法を入力してください');
        }
        if(soukyakusho.shiharai.maeuke_kingaku == null){
            msgList.add('前受金額を入力してください');
        }

        for( Api_V1_SogSok_Soukyakusho_Data.SoukyakuSho_TekiyoWaribiki waribki : soukyakusho.tekiyo_waribikis ){
            if(String.isBlank(waribki.shohin_bango)){
                msgList.add('適用割引商品番号を入力してください');
            }
            if(String.isBlank(waribki.name)){
                msgList.add('適用割引品名を入力してください');
            }
            if(waribki.unit_price == null){
                msgList.add('適用割引単価を入力してください');
            }
            if(waribki.quantity == null){
                msgList.add('適用割引数量を入力してください');
            }
            if(waribki.amount == null){
                msgList.add('適用割引金額を入力してください');
            }
        }

        return msgList;
    }

}