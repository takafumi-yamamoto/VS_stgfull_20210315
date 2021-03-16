@isTest
global class CoreManageApiMock implements HttpCalloutMock {
    private Integer statusCodeSmsReg;

    public void setStatusCode(Integer sCd) {
        this.statusCodeSmsReg = sCd;
    }

    global HTTPResponse respond(HTTPRequest req) {
        Integer stCd;
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        Map<String, String> resBody = new Map<String, String>();

        if (req.getEndpoint().contains('https://api.core.yoriso.com-dummmmy/')) {
            stCd = this.statusCodeSmsReg;
            System.debug(stCd);
            if (stCd == 200) {
                resBody.put('message', 'success');
            } else {
                resBody.put('message', 'error');
            }
        }

        res.setBody(JSON.serialize(resBody));
        res.setStatusCode(stCd);
        return res;
    }
}