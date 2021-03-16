public class Aos_SMSTransUtility {

    //SMS送信リクエスト用パラメタ
    private static final String accessToken = Label.AccessToken;
    private static final String clienId     = Label.ClientId;
    private static final String smsCode     = Label.SmsCode;

    //ClientTag　FormatType識別子文字列
    private static final String FormatTypeOfObouSekouKakuninStr    = 'ObouSekouKakunin';
    private static final String FormatTypeOfObouCampaignStr        = 'Campaign';

    private static String endpointStr = 'https://qpd-api.aossms.com/p1/api/mt.json?';//AosSMS送信先エンドポイントURL
    private static String contentTypeStr = 'application/json';//SMS送信時コンテントタイプ


    public class AosSmsMessage {
        public String ClientTag;
        public String PhoneNumber;
        public String Message;
    }


    /*
        SMSメッセージ送信
        @Param
        Integer formatTypeId　       ：ClientTag フォーマット->2:キャンペーン　3:お坊さん便施行確認
        String mobilePhoneFormula   ：ハイフン無し携帯電話番号（SMS送信先）
        String naibuShodanId        ：内部商談ID
        String accountNewId         ：取引先　新顧客ID
        String sendText　            ：送信メッセージ本文

    */
    public static void sendAosSmsMessages(List<AosSmsMessage> aossmss){

        System.debug('sendAosSmsMessages：'+aossmss.size());

        for (AosSmsMessage aossms : aossmss) {

            System.debug('----sendAosSmsMessages----');
            System.debug(aossms);
            sendHttpRequest(aossms.ClientTag,aossms.PhoneNumber,aossms.Message);

            //Long startTime = DateTime.now().getTime();
            //Long finishTime = DateTime.now().getTime();
            //while ((finishTime - startTime) < timeSleepValue ) {
            //    //sleep for 1s
            //    finishTime = DateTime.now().getTime();
            //}            

       }

    }

    /*
        HTTPリクエスト送信
    */
    public enum SendResult{
        Fault,
        Success
    }
    public static SendResult sendHttpRequest(String clientTag, String phoneNumber, String sendTextParam){

        Boolean isResricted = false;
        try{
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(phoneNumber);
        }catch(Testers.NotTesterException ex){
            isResricted = true;
        }
        if(isResricted) return SendResult.Fault;

		Map<String, String> queryStringMap = new Map<String, String>();

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        queryStringMap = new Map<String, String>();
        queryStringMap.put('token', accessToken);
        queryStringMap.put('clientId', clienId);
        queryStringMap.put('smsCode', smsCode);
        queryStringMap.put('message', EncodingUtil.urlEncode(sendTextParam,'UTF-8'));
        queryStringMap.put('phoneNumber', EncodingUtil.urlEncode(phoneNumber,'UTF-8'));
        queryStringMap.put('clientTag', EncodingUtil.urlEncode(clientTag,'UTF-8'));
 
        String queryString = '';
        for(String s : queryStringMap.keyset()){
            queryString = queryString + s + '=' + queryStringMap.get(s) + '&';
        }
        queryString = queryString.removeEnd('&');

        system.debug('queryString:' + queryString);
        req.setEndpoint(endpointStr + queryString);
        req.setMethod('POST');
        req.setHeader('Content-Type', contentTypeStr);
        system.debug('req-EndPoint---' + req);

        HttpResponse res = http.send(req);
        String resBody = res.getBody();
        System.debug(res.getBody());
        RestResponseParam resparam = (RestResponseParam)JSON.deserialize(resBody, RestResponseParam.class);        
        Integer status = resparam.responseCode;

        if(status == 0) return SendResult.Success;
        else return SendResult.Fault;
    }

    public class RestResponseParam{
        public Integer responseCode {get;set;}
    }
}