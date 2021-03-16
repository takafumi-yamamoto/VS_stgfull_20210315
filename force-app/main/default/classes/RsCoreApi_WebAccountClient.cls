/**
* 会員基盤への連携、Webアカウントの新規、変更、削除
* 
*/
public class RsCoreApi_WebAccountClient implements RsCoreApi_Util.IHttpRequest {

    // 処理ステータス , ShoriStatus__c , picklist
    public static final String CONST_SHORISTATUS_NEW = 'Processing_Created';
    public static final String CONST_SHORISTATUS_CHECK = 'Processing_Validated';
    public static final String CONST_SHORISTATUS_IRAIZUMI = 'Processing_WebAccountRequested';
    public static final String CONST_SHORISTATUS_FRONT_SYORIZUMI = 'Processing_WebAccountProcessed';
    public static final String CONST_SHORISTATUS_OK = 'Closed_Success';
    public static final String CONST_SHORISTATUS_ERROR = 'Closed_Error';

    // 処理区分 , ShoriKubun__c , picklist
    public static final String CONST_SHORIKUBUN_NEW = 'New';
    public static final String CONST_SHORIKUBUN_UPDATE = 'Modify';
    public static final String CONST_SHORIKUBUN_DEL = 'Remove';
    public static final String CONST_SHORIKUBUN_ACTIVATE = 'Activate';

    private static final String FRONT_CORE_USER = '/user';

    // 会員基盤成功コード
    private static final Integer SUCCESS_CODE = 200; // 会員基盤成功コード

    // Endpoint と timeSleepValue　をカスタム設定で設定してください。
    private static final Integer timeSleepValue = Integer.valueOf(RsCoreApi_Configs.getConfig().timeOutPeriod__c);

    private WebAccountTourokuIrai__c irai;
    private Ctl_WebAccountTourokuIrai.Util util;
    
    public class WebAccountTourokuIraiResponseParam {
        public String userId; //依頼書Id
    }

    public class RequestBean {
        // public Map<String, String> identifiers; 
        public List<Object> identifiers; 
        public Map<String, Object> salesForceIdentifier; 

        public RequestBean(WebAccountTourokuIrai__c irai){

            this.identifiers = new List<Object>();
            Map<String, String> tmpIdentifier = new Map<String, String>();
            tmpIdentifier.put('identifier', irai.TourokuChi__c);
            tmpIdentifier.put('idKind', getAuthenticationType(irai)); // 1:email, 2:tel
            this.identifiers.add(tmpIdentifier);

            this.salesForceIdentifier = new Map<String, Object>();
            // this.salesForceIdentifier.put('torihikisakiBango', irai.TorihikisakiBango__c);
            this.salesForceIdentifier.put('iraiBango', irai.Name);
            this.salesForceIdentifier.put('contextType', getContextType(irai));
        }

        // 1:シンプル資料請求,2:シンプルエンディングノート, 3:事前割, 99:その他
        private Integer getContextType(WebAccountTourokuIrai__c irai){
            Integer contextType = 99;
            if(irai.Context__c == 'simple_yasugo_siryoseikyu'){
                contextType = 1;
            } else if(irai.Context__c == 'simple_yasugo_endingnote'){
                contextType = 2;
            } else if(irai.Context__c == 'jizenwari_moushikomi'){
                contextType = 3;
            } else if(irai.Context__c == 'ososhiki_yoyaku_siryoseikyu'){
                contextType = 4;
            } else if(irai.Context__c == 'ohanaippainoososhiki_shiryoseikyu'){
                contextType = 5;
            } else if(irai.Context__c == null 
            && irai.NinshoHouhou__c == 'メールアドレス' 
            && irai.RecordTypeId == Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Modify').getRecordTypeId()  ){
                contextType = 90;
            }else {
                contextType = 99;
            }
            return contextType;
        }

        // 1:メールアドレス,2:電話番号
        private String getAuthenticationType(WebAccountTourokuIrai__c irai){
            String contextType = '';
            if(irai.NinshoHouhou__c == 'メールアドレス'){
                contextType = '1';
            } else if(irai.NinshoHouhou__c == '電話番号'){
                contextType = '2';
            }
            return contextType;
        }
    }

    public class RequestDelBean {
        public Integer status; 
        public Map<String, Object> salesForceIdentifier; 

        public RequestDelBean(WebAccountTourokuIrai__c irai){
            this.status = 0;
            this.salesForceIdentifier = new Map<String, Object>();
            this.salesForceIdentifier.put('contextType', getContextType(irai));
            this.salesForceIdentifier.put('iraiBango', irai.Name);
        }

        // 1:シンプル資料請求,2:シンプルエンディングノート, 3:事前割, 99:その他
        private Integer getContextType(WebAccountTourokuIrai__c irai){
            Integer contextType = 99;
            if(irai.Context__c == 'simple_yasugo_siryoseikyu'){
                contextType = 0;
            } else if(irai.Context__c == 'simple_yasugo_endingnote'){
                contextType = 1;
            } else if(irai.Context__c == 'jizenwari_moushikomi'){
                contextType = 2;
            } else {
                contextType = 99;
            }
            return contextType;
        }
    }

    public RsCoreApi_WebAccountClient(WebAccountTourokuIrai__c irai){
        this.irai = irai;
        this.util = new Ctl_WebAccountTourokuIrai.Util();
    }

    public String getJsonQueryString() {
        Object requestBean = null;
        if(this.util.isNewIrai(irai) || this.util.isUpdateIrai(irai)) {
            System.debug('this.util.isUpdateIrai(irai)');
            requestBean = new RequestBean(irai);
        }
        else if(this.util.isDelIrai(irai)) {
            System.debug('this.util.isDelIrai(irai)');
            requestBean = new RequestDelBean(irai);
        }
        JSONGenerator gen = JSON.createGenerator(false);   
        gen.writeObject(requestBean);
        return gen.getAsString();
    }
    
    public String getEndPoint() {
        String url = '';
        if(this.util.isNewIrai(irai)) {
            url = RsCoreApi_Configs.getConfig().Endpoint__c + FRONT_CORE_USER + '/' + irai.TorihikisakiBango__c;
        }
        else if(this.util.isUpdateIrai(irai)) {
            url = RsCoreApi_Configs.getConfig().Endpoint__c + FRONT_CORE_USER + '/' + irai.TorihikisakiBango__c;
        }
        else if(this.util.isDelIrai(irai)) {
            url = RsCoreApi_Configs.getConfig().Endpoint__c + FRONT_CORE_USER + '/' + irai.TorihikisakiBango__c + '/status';
        }
        System.debug('>>>getEndPoint');
        System.debug(url);
        return url;
    }
    
    public Boolean isSuccess(HttpResponse res) {
        return res.getStatusCode() == SUCCESS_CODE;
    }
    
    public void doOnSuccess(HttpResponse res){
        System.debug('>>>>doOnSuccess');

        setTryCount(this.irai);
        setBiko(this.irai, res.getStatusCode(), res.getBody());
        if(this.util.isDelIrai(irai)){
            this.irai.ShoriStatus__c = CONST_SHORISTATUS_FRONT_SYORIZUMI;
        } else {
            this.irai.ShoriStatus__c = CONST_SHORISTATUS_IRAIZUMI;
        }

        if(!Test.isRunningTest()){
            update this.irai;    
        }
        
    }
    
    public void doOnError(HttpResponse res){
        System.debug('>>>>doOnError');

        doOnError(this.irai, res.getStatusCode(), res.getBody());
    }
    
    public void doOnException(Exception e){
        System.debug('>>>>Exception');
        System.debug('>>>HttpTemplate doPost Exception');
        System.debug(e);
        doOnError(this.irai, 0, 'SF System Error: ' + e.getMessage());
    }

    private void doOnError(WebAccountTourokuIrai__c irai , Integer resCode, String resBody) {
        setTryCount(irai);
        Boolean isRetry = isRetry(irai);
        if(!isRetry){
            // 依頼予定日時を再スケジュールする
            irai.ShoriStatus__c = CONST_SHORISTATUS_ERROR;
        }
        setBiko(irai, resCode, resBody);

        if(!Test.isRunningTest()){
            update irai;
        }

        if(isRetry && !Test.isRunningTest()) {
            retryWebAccountTourokuIrai(irai);
        }
    }

    private void setBiko(WebAccountTourokuIrai__c irai, Integer resCode, String resBody){
        irai.ShoriStatusBiko__c = String.isBlank(irai.ShoriStatusBiko__c) ? '' : irai.ShoriStatusBiko__c;
        irai.ShoriStatusBiko__c += '>>>>>>>>>>>\n';
        irai.ShoriStatusBiko__c = getJsonQueryString() + '\n';
        irai.ShoriStatusBiko__c += resCode + '\n' + resBody + '\n';
        irai.ShoriStatusBiko__c = irai.ShoriStatusBiko__c.left(131072);
    }

    /**
    * リトライ
    */
    private void retryWebAccountTourokuIrai(WebAccountTourokuIrai__c irai){
        // add to queue to run 
        if(irai != null && irai.ShoriStatus__c == CONST_SHORISTATUS_CHECK){
            Utility_Common.sleep(timeSleepValue);

            ID jobID = System.enqueueJob(new Ctl_WebAccountTourokuIrai.WebAccountTourokuIraiJob(irai));
            System.debug('jobID : ' + jobID);
        }
    }

    private void setTryCount(WebAccountTourokuIrai__c irai) {
        Decimal retryCount = irai.WebAccountRequestTryCount__c == null ? 0 : irai.WebAccountRequestTryCount__c;
        irai.WebAccountRequestTryCount__c = retryCount + 1;
    }

    private Boolean isRetry(WebAccountTourokuIrai__c irai) {
        return (irai.WebAccountRequestTryCount__c < irai.WebAccountRequestTryLimit__c);
    }


}