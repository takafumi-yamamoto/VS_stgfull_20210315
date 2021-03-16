public class Gannens {
    public static String toGannen(String pValue){
        if( String.isBlank(pValue) ) return pValue;

        String theAnswer = null;
        Boolean to_replace = Pattern.matches('.*[^1-9]1年.*', pValue);
        if(to_replace){
            theAnswer = pValue.replace('01年','元年').replace('1年','元年');
        }else{
            theAnswer = pValue;
        }
        return theAnswer;
    }
}