public class TelNos{
    public static String toNumber(String pTelNo){
        return pTelNo.replace('-','').replace('ー','');
    }

    public static Boolean isTelNo(String pTelNo){
        if(pTelNo == null) return false;
        return toNumber(pTelNo).isNumeric();
    }

    public static Boolean isValidMobilePhoneNumber(String str){
        if(str.length() == 11 && str.isNumeric() && (str.startsWith('070') || str.startsWith('080') || str.startsWith('090'))){
            return true;
        }
        return false;
    }
}