/**
* @Author Exia.huang
*/
public class PtWebApi_Util {
    
    ///////////////////////////////////IHttpRequest
    public interface IHttpRequest { 
        String getJsonQueryString();
        String getEndPoint();
        Boolean isSuccess(HttpResponse res);
        void doOnSuccess(HttpResponse res);
        void doOnError(HttpResponse res);
        void doOnException(Exception e);
    } 
    
    /////////////////////////////////HttpTemplate
    private static final String JSON_CONTENT_TYPE = 'application/json;charset=UTF-8'; //コンテントタイプ
    private static final String ACCEPT = 'application/json'; //コンテントタイプ

    //doPost
    private HttpResponse doAction(IHttpRequest action, String method, Boolean isUsePatch) { 
    	HttpResponse res = null;
        try {
              Http http = new Http();
              HttpRequest req = new HttpRequest();
              
              String queryString = action.getJsonQueryString() ;
              System.debug('>>>queryString');
              System.debug(queryString);
    
              req.setEndpoint(action.getEndPoint());
              req.setMethod(method);
              req.setHeader('Content-Type', JSON_CONTENT_TYPE);
              req.setHeader('accept', ACCEPT);
              if(isUsePatch){
                req.setHeader('X-HTTP-Method-Override','PATCH');
              }
              PtWebApi_Auth.setAuthHeader(req);

              if(String.isNotBlank(queryString))
                req.setBody(queryString);
              system.debug('req-EndPoint---' + req);
              
              res = http.send(req);
              
              if(action.isSuccess(res)) action.doOnSuccess(res);
              else action.doOnError(res);

              return res;
          
        } catch (Exception e) {
            action.doOnException(e);
            return res;
        }
    }

    public static HttpResponse doPost(IHttpRequest action) {
    	return new PtWebApi_Util().doAction(action, 'POST', false);
    }

    public static HttpResponse doPut(IHttpRequest action) {
      	return new PtWebApi_Util().doAction(action, 'PUT', false);
    }

    public static HttpResponse doPatch(IHttpRequest action){
      	return new PtWebApi_Util().doAction(action, 'POST', true);
    }

    public static HttpResponse doGet(IHttpRequest action) {
      	return new PtWebApi_Util().doAction(action, 'GET', false);
    }

    public static HttpResponse doDelete(IHttpRequest action) {
      	return new PtWebApi_Util().doAction(action, 'DELETE', false);
    }
}