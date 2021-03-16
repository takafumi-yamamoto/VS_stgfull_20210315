public class AccreteSmsApi {
    public Map<String, Object> mapRes {get;set;}
    public Integer statusCode {get;set;}

    public AccreteSmsApi() {
    }

    private void fetch(String endPoint
                                ,String method) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endPoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setTimeout(30000);

        HttpResponse res = http.send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        this.statusCode = res.getStatusCode();
        mapRes = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
    }

    public void smsReg(String msg, String telNo, String oppId) {
		Map<String, String> queryStringMap = new Map<String, String>();
        queryStringMap.put('id', 'YVx6KSEuybXjU');
        queryStringMap.put('pass', 'dvEzAWUJ');
        queryStringMap.put('shorten_url', 'yes');
        if (Env.survey.TestTelNo__c != null) {
            queryStringMap.put('telno', Env.survey.TestTelNo__c);
        } else {
            queryStringMap.put('telno', telNo);
        }
        queryStringMap.put('user_ref', oppId + '_' + datetime.now().format('yyyyMMddhhmm'));
        queryStringMap.put('text.long', EncodingUtil.urlEncode(msg, 'UTF-8'));
        String queryString = '';
        for(String s : queryStringMap.keyset()){
            queryString = queryString + s + '=' + queryStringMap.get(s) + '&';
        }
        queryString = queryString.removeEnd('&');
        System.debug('queryString:' + queryString);
        String endPoint = Env.survey.AccreteSmsApiUrl__c + 'sms_reg/wM673852/?' + queryString;

        try {
            fetch(endPoint, 'POST');
            if (this.statusCode != 200) {
                throw new CalloutException('statusCode:' + statusCode + ';' + Cnst.LF
                                            + String.valueOf(JSON.serialize(mapRes)));
            }
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error
                                        ,'2019122912334411'
                                        ,'AccreteSmsApi')
                    .putAttr('OpportunityId', oppId)
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
            );

            throw e;
        }
    }

    public Boolean isValidTelNo(String telNo) {
        if (String.isEmpty(telNo)) {
            return false;
        }

        Pattern p = pattern.compile('^0[7-9]0[0-9]{8}$');
        Matcher m = p.matcher(telNo);
        if (m.matches()) {
            return true;
        }

        return false;
    }
}