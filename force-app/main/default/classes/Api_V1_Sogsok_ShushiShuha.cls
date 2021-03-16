@RestResource(urlMapping='/api/v1/sogsok/shushishuha/*')
global class Api_V1_Sogsok_ShushiShuha {

   public class Shuha{
        public String code = '';
        public String label = '';    
        public Shuha(String pCode, String pLabel){ this.code = pCode; this.label = pLabel; }   
    }
    public class Shushi{
        public String code = '';
        public String label = '';
        public List<Shuha> shuhas = new List<Shuha>();
        public Shushi(String pCode, String pLabel){ this.code = pCode; this.label = pLabel; }   
        public Shushi addShuha(Shuha pShuha){ this.shuhas.add(pShuha);return this; }
    }

    private static List<Shushi>  getEntries(){
        List<Shushi> theEntries = new List<Shushi>();
        Map<String, Set<String>> theShushiShuhas = Sogsok_ShushiShuha.shushiShuhas;
        for( String aShushiCode : theShushiShuhas.keySet() ){
            Set<String> theShuhaCodes = theShushiShuhas.get(aShushiCode);
            Shushi aShushiEntry = new Shushi( aShushiCode, Sogsok_ShushiShuha.tryGetShushiLabel( aShushiCode,'') );
            for( String aShuhaCode : theShuhaCodes ){
                aShushiEntry.addShuha(
                    new Shuha( aShuhaCode, Sogsok_ShushiShuha.tryGetShuhaLabel(aShuhaCode,'') )
                );
            }
            theEntries.add(aShushiEntry);
        }
        return theEntries;
    }

    @HttpGet
    global static void doGet(){

        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');

        List<Shushi> theEntries = getEntries();
        theRes.responseBody = Blob.valueOf(JSON.serialize(theEntries));
    }
}