@isTest
global class MockAccreteSmsApi implements HttpCalloutMock {
    private Integer statusCodeSmsReg;

    public void setStatusCodeSmsReg(Integer sCd) {
        this.statusCodeSmsReg = sCd;
    }

    global HTTPResponse respond(HTTPRequest req) {
        Integer stCd;
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        Map<String, String> resBody = new Map<String, String>();

        if (req.getEndpoint().contains(Env.survey.AccreteSmsApiUrl__c + 'sms_reg/wM673852/')) {
            stCd = this.statusCodeSmsReg;
            System.debug(stCd);
            if (stCd == 200) {
                resBody.put('action', 'sms_reg');
                resBody.put('telNo', '09000000001');
                resBody.put('delivery_id ', '9999999999');
                resBody.put('result_code', '0000');
                resBody.put('message', 'succeeded');
                resBody.put('register_time', datetime.now().format('yyyy/MM/dd hh:mm:ss'));
            } else {
                resBody.put('action', 'sms_reg');
                resBody.put('telNo', '05000000000');
                resBody.put('delivery_id ', '9999999998');
                resBody.put('message', 'systemerror');
                resBody.put('result_code', '9999');
            }
        }

        res.setBody(JSON.serialize(resBody));
        res.setStatusCode(stCd);
        return res;
    }
}