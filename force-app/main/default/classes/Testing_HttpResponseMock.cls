@isTest
global class Testing_HttpResponseMock implements HttpCalloutMock {
    public String body {private get; private set; }
    public Integer statusCode {private get; private set; }

    public Testing_HttpResponseMock setBody(String pValue){
        this.body = pValue; return this;
    }
    public Testing_HttpResponseMock setStatusCode(Integer pValue){
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
        String theRsCoreApi_Auth_Endpoint = RsCoreApi_Configs.getConfig().Endpoint__c + '/oauth/token';
        if( pRequest.getEndpoint().contains(theRsCoreApi_Auth_Endpoint) ){
            HttpResponse theResponse = new HttpResponse();
            theResponse.setStatusCode(200);
            theResponse.setBody( JSON.serialize(new RsCoreApi_AuthClients.JSONTokenResponse()) );
            return theResponse;
        }
        return null;
    }
}