/**
* @Author Exia.huang
*/
public class RsCoreApi_Util {

    @TestVisible
    private static RsCoreApi_Util.IRequester m_IRequester_instance = new Requester(
        RsCoreApi_AuthClients.getInstance()
    );

    public interface IHttpRequest { 
        String getJsonQueryString();
        String getEndPoint();
        Boolean isSuccess(HttpResponse res);
        void doOnSuccess(HttpResponse res);
        void doOnError(HttpResponse res);
        void doOnException(Exception e);
    } 

    public static void doPost(IHttpRequest action) {
    	m_IRequester_instance.doAction(action, 'POST', false);
    }

    public static void doPut(IHttpRequest action) {
        m_IRequester_instance.doAction(action, 'PUT', false);
    }

    public static void doPatch(IHttpRequest action){
        m_IRequester_instance.doAction(action, 'POST', true);
    }

    public static void doGet(IHttpRequest action) {
        m_IRequester_instance.doAction(action, 'GET', false);
    }

    public static void doDelete(IHttpRequest action) {
        m_IRequester_instance.doAction(action, 'DELETE', false);
    }

    public interface IRequester {
        void doAction(IHttpRequest action, String method, Boolean isUsePatch);
    }
    public class Requester implements IRequester{

        private RsCoreApi_AuthClients.IAuthClient m_IAuthClient;
        public Requester(RsCoreApi_AuthClients.IAuthClient p_IAuthClient){
            this.m_IAuthClient = p_IAuthClient;
        }

        public void doAction(IHttpRequest action, String method, Boolean isUsePatch) { 
            // 有効フラグ
            if(!RsCoreApi_Configs.getConfig().isActive__c) return;
            
            try {
                  Http http = new Http();
                  HttpRequest req = new HttpRequest();
                  
                  String queryString = action.getJsonQueryString() ;
                  System.debug('>>>queryString');
                  System.debug(queryString);
        
                  req.setEndpoint(action.getEndPoint());
                  req.setMethod(method);
                  req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                  req.setHeader('accept', 'application/json');
                  if(isUsePatch){
                    req.setHeader('X-HTTP-Method-Override','PATCH');
                  }
                  this.m_IAuthClient.setAuthHeader(req);
    
                  if(String.isNotBlank(queryString))
                    req.setBody(queryString);
                  system.debug('req-EndPoint---' + req);
                  
                  HttpResponse res = http.send(req);
                  
                  if(action.isSuccess(res)) action.doOnSuccess(res);
                  else action.doOnError(res);
              
            } catch (Exception e) {
                  action.doOnException(e);
            }
        }
    }
}