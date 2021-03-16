/**
* ログインアカウントアクティベート
*/
@RestResource(urlMapping='/WebAccountService/*')
global with sharing class Api_V1_WebAccountService {
    // メッセージ
    public static final String SUCCESS = 'success';
    public static final String ERROR = 'error';
    public static final String VALIDATE_NULL_ERROR = '入力データエラー。';
    public static final String SUCCESS_LOG = 'ログインアカウントアクティベート成功。';
    public static final String ERROR_MSG_NOT_FOUND_WEBACCOUNTTOUROKUIRAI = 'Webアカウント登録依頼がみつかりません。';
    public static final String ERROR_MSG_NOT_FOUND_WEBACCOUNT = 'Webアカウントがみつかりません。';
    public static final String ERROR_MSG_SHORISTATUS_ERROR = 'Webアカウント登録依頼は既に処理済み。';

    // 処理ステータス , ShoriStatus__c , picklist
    public static final String CONST_SHORISTATUS_NEW = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_NEW;
    public static final String CONST_SHORISTATUS_CHECK = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_CHECK;
    public static final String CONST_SHORISTATUS_IRAIZUMI = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_IRAIZUMI;
    public static final String CONST_SHORISTATUS_SYORIZUMI = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_SYORIZUMI;
    public static final String CONST_SHORISTATUS_OK = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_OK;
    public static final String CONST_SHORISTATUS_ERROR = Ctl_WebAccountTourokuIrai.CONST_SHORISTATUS_ERROR;

    // 処理区分 , ShoriKubun__c , picklist
    public static final String CONST_SHORIKUBUN_NEW = Ctl_WebAccountTourokuIrai.CONST_SHORIKUBUN_NEW;
    public static final String CONST_SHORIKUBUN_UPDATE = Ctl_WebAccountTourokuIrai.CONST_SHORIKUBUN_UPDATE;
    public static final String CONST_SHORIKUBUN_DEL = Ctl_WebAccountTourokuIrai.CONST_SHORIKUBUN_DEL;
    public static final String CONST_SHORIKUBUN_ACTIVATE = Ctl_WebAccountTourokuIrai.CONST_SHORIKUBUN_ACTIVATE;

    // excepiton define
    public class ValidateException extends Exception {}
      // excepiton define
    public class BussinessException extends Exception {}

    @HttpPost
    global static void doPost() {

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.addHeader('Content-Type', 'application/json');

        ResultBean result = new ResultBean();

        String requestBody      = RestContext.request.requestBody.toString();
        RequestBean req             = null;
        System.Savepoint sp     = Database.setSavepoint();

        try {
          System.debug('requestBody>>>>>>>>');
          System.debug(requestBody);
          req = (RequestBean) System.JSON.deserialize(requestBody, RequestBean.class);
          System.debug(req);

          // check data
          checkData(req);

          // ログインアカウントアクティベート
          //MemberAccountService.GetInstance().ActivateMemberAccount(req.Iraibango);
          new WebAccountTouroku().toroku(req, result);

        } catch(BussinessException e) {
          result.status = ERROR;
          result.log = e.getMessage();
          res.statusCode = 500;

          Loggings.writeLog(
              Loggings.createLogEntry(Loggings.Level.Error
                                      ,'2020082801234501'
                                      ,'Api_V1_WebAccountService')
                  .putAttr('reqBody', requestBody)
                  .putAttr('errMsg', e.getMessage())
                  .putAttr('stackTrace', e.getStackTraceString())
          );
        } catch(Exception e) {

          Database.rollback(sp);
          System.debug('The following exception has occurred: ' + e.getMessage());
          result.status = ERROR;
          result.log = e.getMessage();
          res.statusCode = 500;

          Loggings.writeLog(
              Loggings.createLogEntry(Loggings.Level.Error
                                      ,'2020082801234502'
                                      ,'Api_V1_WebAccountService')
                  .putAttr('reqBody', requestBody)
                  .putAttr('errMsg', e.getMessage())
                  .putAttr('stackTrace', e.getStackTraceString())
          );
        }
        
        System.debug(result);
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    private static void checkData(RequestBean req) {
        if(String.isBlank(req.Iraibango)){
            throw new ValidateException(VALIDATE_NULL_ERROR);
        }
    }

    public class ResultBean {
        public String status;
        public String log;
    }

    public class RequestBean {
      // Webアカウント登録依頼 Id
      public String Iraibango; 

    }

    /**
    * Web Account 登録処理
    */
    public class WebAccountTouroku {

        public void toroku(RequestBean req, ResultBean result){
            //Webアカウント登録依頼を取得
            WebAccountTourokuIrai__c irai = Dao_WebAccountTourokuIrai.GetInstance().getWebAccountTourokuIraiListByIraibango(req.Iraibango);
            if(irai != null){
              if(irai.ShoriStatus__c == CONST_SHORISTATUS_IRAIZUMI){
                //取得したものを処理します
                doWebAccount(irai, result);
              } else{
                throw new BussinessException(ERROR_MSG_SHORISTATUS_ERROR + req.Iraibango);
              }

            } else {
              throw new BussinessException(ERROR_MSG_NOT_FOUND_WEBACCOUNTTOUROKUIRAI + req.Iraibango);
            }
        }

        /**
        * Web Account登録処理
        */
        private void doWebAccount(WebAccountTourokuIrai__c irai, ResultBean result){
            result.status = SUCCESS;

            //依頼書更新
            irai.ShoriStatus__c = CONST_SHORISTATUS_SYORIZUMI;
            if( !Test.isRunningTest() ){
                update irai;
            }

        }


    }
}