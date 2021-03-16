@RestResource(urlMapping='/api/v1/sogsok/tsuikahin_bunrui/*')
global class Api_V1_SogSok_TsuikaHinBunrui {

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        String theShodanBango = theReq.params.get('opp_code');
        theRes.addHeader('Content-Type', 'application/json');
        System.debug('theShodanBango:' + theShodanBango);
        
        theRes.responseBody = Blob.valueOf(Sogsok_TsuikaHinBunrui_201101.getEntries());
    }
}