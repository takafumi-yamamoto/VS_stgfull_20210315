public class SogSok_Gender {

    private static Map<String,String> Entries = sche_Pickls.getEntriesMap('SogSok_SokyakuSho__c', 'TaishoSha_Gender__c');

    private static Map<String,String> BindingToCustomerAccountGender = new Map<String,String>{
        '男性' => '男性',
        '女性' => '女性',
        null => null
    };
    public String tryGetCustomerAccountGender(String pValue){
        if( !BindingToCustomerAccountGender.containsKey(pValue) ) return null;
        return BindingToCustomerAccountGender.get(pValue);
    }

    private static Map<String,String> BindingFromCustomerAccountGender = new Map<String,String>{
        '男性' => '男性',
        '女性' => '女性',
        null => null
    };
    public String tryGetKeyFromCustomerAccountGender(String pValue){
        if( !BindingFromCustomerAccountGender.containsKey(pValue) ) return null;
        return BindingFromCustomerAccountGender.get(pValue);
    }
}