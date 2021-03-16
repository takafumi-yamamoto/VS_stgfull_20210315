public class KenAlls {
    
    public static String formatPostalCdToPostalCdKey(String pZipCode){
        String temp_postcode = Com_Utility.HankakuReplace(pZipCode);
        temp_postcode = temp_postcode.replace('-', '').replace('ー', '').replace('―', '');
        Pattern myPattern = pattern.compile('^(0*)([^0].*)');
        Matcher myMatcher = myPattern.matcher(temp_postcode);
        Boolean isMatch = myMatcher.matches();
        if(isMatch){
            temp_postcode = myMatcher.group(2);
        }
        return temp_postcode;
    }
}