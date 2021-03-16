public class KenSearchController {

    @AuraEnabled
    public static Zyusho search(String postcode) {
        if(String.isBlank(postcode)) return null;
        String postcode_for_search = postcodeFilter(postcode);
        List<Ken_all__c> kens = [SELECT id, post_code__c,todofuken__c,shikugun__c,tyoumei__c FROM Ken_all__c WHERE post_code__c = :postcode_for_search LIMIT 1];
        if(kens.size() == 0) return null;
        Zyusho zyusho = new Zyusho();
        zyusho.postcode = postcode;
        zyusho.todofuken = kens[0].todofuken__c;
        zyusho.shikugun = kens[0].shikugun__c;
        zyusho.tyoumei = kens[0].tyoumei__c;
        return zyusho;
    }

    private static String postcodeFilter(String postcode){
        String temp_postcode = Com_Utility.HankakuReplace(postcode);
        temp_postcode = temp_postcode.replace('-', '').replace('ー', '').replace('―', '');
        Pattern myPattern = pattern.compile('^(0*)([^0].*)');
        Matcher myMatcher = myPattern.matcher(temp_postcode);
        Boolean isMatch = myMatcher.matches();
        if(isMatch){
            temp_postcode = myMatcher.group(2);
        }
        return temp_postcode;
    }

    public class Zyusho {
        @AuraEnabled public String postcode;
        @AuraEnabled public String todofuken;
        @AuraEnabled public String shikugun;
        @AuraEnabled public String tyoumei;
        @AuraEnabled public String banchi;
    }

    @AuraEnabled
    public static Location getLocation(String postcode, String todofuken, String shikugun, String tyoumei, String banchi) {
        List<String> addressList = new List<String>();
        if(String.isNotBlank(todofuken)) addressList.add(todofuken);
        if(String.isNotBlank(shikugun)) addressList.add(shikugun);
        if(String.isNotBlank(tyoumei)) addressList.add(tyoumei);
        if(String.isNotBlank(banchi)) addressList.add(banchi);
        String address = String.join(addressList, '');
        GeoLocs.Result res = new GeoLocs().getGeoLocation(postcode, address, true);
        Location loc = new Location();
        loc.is_success = res.isSuccess;
        if(loc.is_success){
            loc.lat = res.geoLocation.lat;
            loc.lng = res.geoLocation.lng;
        }
        return loc;
    }

    public class Location {
        @AuraEnabled public Decimal lat;
        @AuraEnabled public Decimal lng;
        @AuraEnabled public Boolean is_success;
    }
}