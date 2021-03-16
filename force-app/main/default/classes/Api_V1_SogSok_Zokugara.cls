@RestResource(urlMapping='/api/v1/sogsok/zokugara/*')
global class Api_V1_SogSok_Zokugara {

    @HttpGet
    global static void doGet(){

        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');

        List<Entry> theEntries = new List<Entry>();
        Map<String, String> theMap = SogSok_Zokugara.getEntries();
        for( String aKey : theMap.keySet() ){
            theEntries.add(
                new Entry( aKey, theMap.get(aKey) )
            );
        }
        theRes.responseBody = Blob.valueOf(JSON.serialize(theEntries));
    }

    private class Entry{
        public Entry(String pCode, String pLabel){ this.code = pCode; this.label = pLabel; }
        String code;
        String label;
    }
}