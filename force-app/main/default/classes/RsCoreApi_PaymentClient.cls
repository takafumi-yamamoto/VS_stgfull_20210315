/**
* 決済情報受付
* 
* 実行方法:  RsCoreApi_Util.doPut(new RsCoreApi_PaymentClient('OKSM-00059209'));
* 実行
*/
public class RsCoreApi_PaymentClient implements RsCoreApi_Util.IHttpRequest {

    // 成功コード
    private static final Integer SUCCESS_CODE = 200;

    private String url;
    private String requestParams;

    private Boolean f_isSuccess;

    public String result {
        get {
            return result;
        }
        set {
            result = value;
        }
    }

    public Integer code {
        get {
            return code;
        }
        set {
            code = value;
        }
    }


    public Boolean getIsSuccess() {
        return f_isSuccess;
    }

    //////////////////////////////////////////////////////////

    public RsCoreApi_PaymentClient(String url, String requestParams){
        this.url = url;
        this.requestParams = requestParams;
    }

    public String getJsonQueryString() {
        return this.requestParams;
    }
    
    public String getEndPoint() {
        return this.url;
    }
    
    public Boolean isSuccess(HttpResponse res) {
        return res.getStatusCode() == SUCCESS_CODE;
    }
    
    public void doOnSuccess(HttpResponse res){
        System.debug('>>>>doOnSuccess');
        this.result = res.getBody();
        this.code = res.getStatusCode();
        this.f_isSuccess = true;
    }
    
    public void doOnError(HttpResponse res){
        System.debug('>>>>doOnError');
        this.result = res.getBody();
        this.code = res.getStatusCode();
        this.f_isSuccess = false;
    }
    
    public void doOnException(Exception e){
        System.debug('>>>>Exception');
        System.debug('>>>HttpTemplate doPost Exception');
        System.debug(e);
        this.result = e.getMessage();
        this.code = -1;
        this.f_isSuccess = false;
    }

    //////////////////
    public class Error {
        public Integer code;
        public String message;
    }

    public class CoreErrorMsg {
        public Error error;
    }

    public String getCoreErrorMsg(){
        String errorMsg = '';
        if(!this.f_isSuccess && String.isNotBlank(this.result)){
            try {
                CoreErrorMsg coreErrorMsg = (CoreErrorMsg) JSON.deserialize(this.result, CoreErrorMsg.class);
                errorMsg = coreErrorMsg.error.message;
            }
            catch (Exception e) {
                
            }
        }

        return errorMsg;
    }

}