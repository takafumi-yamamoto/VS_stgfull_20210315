@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {    
    global HTTPResponse respond(HTTPRequest req) {        
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"token_type":"1","expires_in":"111","access_token":"111"}');
        res.setStatusCode(200);
        return res;
    }
}