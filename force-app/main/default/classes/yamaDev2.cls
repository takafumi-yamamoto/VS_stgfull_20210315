@isTest
global class yamaDev2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://rest.faximo.jp/snd/v1/record.json', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        System.debug('req.getEndpoint():' + req.getEndpoint());
        System.debug('req.getMethod():' + req.getMethod());
        System.debug('req.getMethod(X-Auth):' + req.getHeader('X-Auth'));
        System.debug('req.getBody():' + req.getBody());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}