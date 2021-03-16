public class PostalCodes{
    public static String toNumber(String pPostalCode){
        return pPostalCode.replace('-','').replace('ー','');
    }
}