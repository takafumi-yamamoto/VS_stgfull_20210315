@isTest
global class Mock_WepPayKekkaUketsukeResponse implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();

        String response = '{' +
'    "seikyu_bango":"SKBG-0000000155",' +
'    "status":"error",' +
'    "errors":[' +
'        {' +
'            "error_code":"42G020000",' +
'            "error_descr":"カード会社オーソリエラー"' +
'        },' +
'        {' +
'            "error_code":"42G020000",' +
'            "error_descr":"カード会社オーソリエラー"' +
'        }' +
'    ]' +
'}';
        res.setBody(response);

        res.setStatusCode(200);

        return res;

    }
}