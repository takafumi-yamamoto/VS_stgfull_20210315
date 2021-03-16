public class SogSok_BodaijiUmu {
    private static Map<String,String> Entries = sche_Pickls.getEntriesMap('SogSok_SokyakuSho__c', 'TaishoSha_BodaijiUmu__c');

    private static Map<String,String> BindingToCustomerAccountBodaijiUmu = new Map<String,String>{
        '無' => '無',
        '有' => '有',
        null => null
    };
    public String tryGetCustomerAccountBodaijiUmu(String pValue){
        if( !BindingToCustomerAccountBodaijiUmu.containsKey(pValue) ) return null;
        return BindingToCustomerAccountBodaijiUmu.get(pValue);
    }

    private static Map<String,String> BindingFromCustomerAccountBodaijiUmu = new Map<String,String>{
        '無' => '無',
        '有' => '有',
        '有-葬儀に来ない' => '有',
        '有-葬儀に来る' => '有',
        '要確認' => '無',
        null => null
    };
    public String tryGetKeyFromCustomerAccountBodaijiUmu(String pValue){
        if( !BindingFromCustomerAccountBodaijiUmu.containsKey(pValue) ) return null;
        return BindingFromCustomerAccountBodaijiUmu.get(pValue);
    }
}