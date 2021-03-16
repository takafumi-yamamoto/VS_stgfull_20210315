public class CoreManageApi {

    public CoreManageApi() {
    }

    @future (callout=true)
    private static void fetch(String endPoint
                        ,String method
                        ,String body) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endPoint);
        if (method == 'PATCH') {
            req.setMethod('POST');
            req.setHeader('X-HTTP-Method-Override','PATCH');
        } else {
            req.setMethod(method);
        }
        req.setBody(body);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setTimeout(5000);
        RsCoreApi_AuthClients.getInstance().setAuthHeader(req);

        HttpResponse res = http.send(req);
        System.debug(body);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        if (res.getStatusCode() != 200) {
            throw new CalloutException('statusCode:' + res.getStatusCode() + ';' + Cnst.LF
                                            + String.valueOf(JSON.serialize(res.getBody())));
        }
    }

    public void surveyPost(Map<String, Object> reqBody) {

        String endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/sogiSurvey/';

        try {
            for (String key : reqBody.keySet()) {
                System.debug(key);
                System.debug(reqBody.get(key));
            }
            fetch(endPoint, 'POST', JSON.serialize(reqBody));
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error
                                        ,Datetime.now().format('yyyyMMdd-hhmm')
                                        ,'CoreManageApi')
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
    }

    public void surveyPatch(Map<String, Object> reqBody) {
        String endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/sogiSurvey/';

        try {
            fetch(endPoint, 'PATCH', JSON.serialize(reqBody));
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error
                                        ,Datetime.now().format('yyyyMMdd-hhmm')
                                        ,'CoreManageApi')
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
    }

    public void surveyDelete(String id) {
        String endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/sogiSurvey/' + id;

        try {
            fetch(endpoint, 'DELETE', '');
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error
                                        ,Datetime.now().format('yyyyMMdd-hhmm')
                                        ,'CoreManageApi')
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
    }
}