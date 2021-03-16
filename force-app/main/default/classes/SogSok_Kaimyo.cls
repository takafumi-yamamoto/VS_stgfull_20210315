public class SogSok_Kaimyo {

    private static Map<String,String> Entries = sche_Pickls.getEntriesMap('SogSok_SrthIraiSho__c', 'SoryoTehai_Kaimyo__c');
    public static Map<String,String> getEntries(){ return Entries; }

    private static Map<String,String> BindingToSimpleYasugoKaimyo = new Map<String,String>{
        '信士' => '信士',
        '信女' => '信女',
        '釋' => '釋',
        '釋尼' => '釋尼',
        '居士' => '居士',
        '大姉' => '大姉',
        '院釋' => '院釋',
        '院釋尼' => '院釋尼',
        '院信士' => '院信士',
        '院信女' => '院信女',
        '院日信士' => '院日信士',
        '院日信女' => '院日信女',
        '院居士' => '院居士',
        '院大姉' => '院大姉',
        'none' => '無',
        null => null
    };

    private static Map<String,String> BindingFromSimpleYasugoKaimyo = Maps.swap(BindingToSimpleYasugoKaimyo, false);
    
    public String tryGetKeyFromSimpleYasugoKaimyo(String pValue){
        if ( !BindingFromSimpleYasugoKaimyo.containsKey(pValue) ) return null;
        return BindingFromSimpleYasugoKaimyo.get(pValue);
    }


    private static Map<String,String> BindingToSimpleYasugoKaimyoJuyo = new Map<String,String>{
        '信士' => '戒名の授与を希望する',
        '信女' => '戒名の授与を希望する',
        '釋' => '戒名の授与を希望する',
        '釋尼' => '戒名の授与を希望する',
        '居士' => '戒名の授与を希望する',
        '大姉' => '戒名の授与を希望する',
        '院釋' => '戒名の授与を希望する',
        '院釋尼' => '戒名の授与を希望する',
        '院信士' => '戒名の授与を希望する',
        '院信女' => '戒名の授与を希望する',
        '院日信士' => '戒名の授与を希望する',
        '院日信女' => '戒名の授与を希望する',
        '院居士' => '戒名の授与を希望する',
        '院大姉' => '戒名の授与を希望する',
        'none' => '戒名の授与を希望しない',
        null => null
    };

    public String tryGetSimpleYasugoKaimyo(String pValue){
        if ( !BindingToSimpleYasugoKaimyo.containsKey(pValue) ) return null;
        return BindingToSimpleYasugoKaimyo.get(pValue);
    }
    public String tryGetSimpleYasugoKaimyoJuyo(String pValue){
        if ( !BindingToSimpleYasugoKaimyoJuyo.containsKey(pValue) ) return null;
        return BindingToSimpleYasugoKaimyoJuyo.get(pValue);
    }
}