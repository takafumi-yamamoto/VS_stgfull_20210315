@isTest
global class HttpResponseMock implements HttpCalloutMock{
    public String body {private get; private set; }
    public Integer statusCode {private get; private set; }

    public HttpResponseMock setBody(String body){
        this.body = body;
        return this;
    }
    public HttpResponseMock setStatusCode(Integer statusCode){
        this.statusCode = statusCode;
        return this;
    }
    global HttpResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody(this.body);
        response.setStatusCode(this.statusCode);
        return response;
    }
}