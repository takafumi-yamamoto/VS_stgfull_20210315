public class RsCoreApi_TestDataClient implements RsCoreApi_Util.IHttpRequest {
    public static final String TYPE_OBOSANBIN_SOURYOUTEHAI_WEB = 'お坊さん便法事法要僧侶手配申込Web受付';
    public static final String TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB = 'お坊さん便資料請求Web受付';
    public static final String TYPE_SIMPLE_SIRYOUSEIKYU_WEB = '[WebToCase]シンプル安豪資料請求Web受付';
    public static final String TYPE_OBOSANBIN_YOUYAKU_WEB = 'お坊さん便予約';
    public static final String TYPE_SIMPLE_TOIAWASE_WEB = 'シンプル安豪問合せWeb受付';
    public static final String TYPE_SIMPLE_ENDORINGU_WEB = 'シンプル安豪エンディングノート請求Web受付';

    private static final String FRONT_CORE_TESTDATA_URL = '/formTestCase/';

    // 成功コード
    private static final Integer SUCCESS_CODE = 200; // 会員基盤成功コード

    private WebFormDataCheck checker;
    private String dataType;

    public RsCoreApi_TestDataClient(WebFormDataCheck checker, String dataType){
        this.dataType = dataType;
        //this.checker = new WebFormDataCheck();
        this.checker = checker;
    }
    
    public String getJsonQueryString(){
        return null;
    }

    public String getEndPoint(){
        //RsCoreApi_Configs.getConfig().Endpoint__c
        String url = RsCoreApi_Configs.getConfig().Endpoint__c + FRONT_CORE_TESTDATA_URL + EncodingUtil.urlEncode(this.dataType, 'UTF-8');

        this.checker.addLog('>>> front data url : ' + url);
        System.debug('>>>getEndPoint');
        System.debug(url);
        return url;
    }

    public Boolean isSuccess(HttpResponse res){
        Boolean getDataResult = res.getStatusCode() == SUCCESS_CODE;
        this.checker.addLog('>>>Front側データ取得結果 : ' + getDataResult);

        return getDataResult;
    }

    public void doOnSuccess(HttpResponse res){
        System.debug('>>>>doOnSuccess');
        System.debug(res);
        System.debug(res.getBody());
        this.checker.addLog('>>>Front側データ取得結果 : ' + res);
        String testDataStr = res.getBody();
        this.checker.startToCheckData(testDataStr, this.dataType);
    }

    public void doOnError(HttpResponse res){
        System.debug('>>>>doOnError');
        System.debug(res);
        this.checker.addErrorLog('>>>doOnError : ' + res);
        //this.checker.sendMail();
    }

    public void doOnException(Exception e){
        System.debug('>>>>Exception');
        System.debug(e);
        this.checker.addErrorLog('>>>doOnException : ' + e.getMessage());
        //this.checker.sendMail();
    }
}