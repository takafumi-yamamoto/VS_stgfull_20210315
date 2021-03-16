@isTest
global class Testing_HttpResponseOproMock implements HttpCalloutMock {
    public String body {private get; private set; }
    public Integer statusCode {private get; private set; }

    public Testing_HttpResponseOproMock setBody(String pValue){
        this.body = pValue; return this;
    }
    public Testing_HttpResponseOproMock setStatusCode(Integer pValue){
        this.statusCode = pValue; return this;
    }
    global HttpResponse respond(HTTPRequest pRequest) {

        HttpResponse theResponse = this.tryGetResponseByReservedResponder(pRequest);
        if(theResponse != null) return theResponse;

        //respond by default
        theResponse = new HttpResponse();
        if(this.body != null) theResponse.setBody(this.body);
        if(this.statusCode != null) theResponse.setStatusCode(this.statusCode);
        return theResponse;
    }
    private HttpResponse tryGetResponseByReservedResponder(HTTPRequest pRequest){
        String theOproApi_Endpoint = OpfcConfs.getConfig().base_url + '/AsyncFacade';
        if( pRequest.getEndpoint().contains(theOproApi_Endpoint) ){
            HttpResponse theResponse = new HttpResponse();
            theResponse.setStatusCode(200);
            theResponse.setBody( JSON.serialize(new SougiShiryoSakusei.JSONTokenOproResponse()) );
            return theResponse;
        }
        return null;
    }
}