public class SogSok_Zokugara {
    private static Map<String,String> Entries = sche_Pickls.getEntriesMap('SogSok_SokyakuSho__c', 'TaishoSha_ZokugaraFromSoudanSha__c');
    public static Map<String,String> getEntries(){ return Entries; }

    private static Map<String,String> BindingToSimpleYasugoTaishoshaZokugara = new Map<String,String>{
        'otto' => '夫',
        'tsuma' => '妻',
        'chichi' => '父',
        'haha' => '母',
        'sofu' => '祖父',
        'sobo' => '祖母',
        'ani' => '兄',
        'ototo' => '弟',
        'ane' => '姉',
        'imoto' => '妹',
        'gohonnin' => 'ご本人',
        'chijin' => '知人',
        'shinseki' => '親戚',
        'gifu' => '義父',
        'gibo' => '義母',
        'gikei' => '義兄',
        'gitei' => '義弟',
        'gishi' => '義姉',
        'gimai' => '義妹',
        'musuko' => '息子',
        'musume' => '娘',
        'oji' => '叔父',
        'oba' => '叔母',
        'itoko' => 'いとこ',
        'mago' => '孫',
        'oi' => '甥',
        'mei' => '姪',
        'kaigokankeisha' => '介護関係者',
        'sonota' => 'その他',
        null => null
    };
    public String tryGetSimpleYasugoTaishoshaZokugara(String pValue){
        if( !BindingToSimpleYasugoTaishoshaZokugara.containsKey(pValue) ) return null;
        return BindingToSimpleYasugoTaishoshaZokugara.get(pValue);
    }

    private static Map<String,String> BindingFromSimpleYasugoTaishoshaZokugara = Maps.swap(BindingToSimpleYasugoTaishoshaZokugara, false);
        

    public String tryGetKeyFromSimpleYasugoTaishoshaZokugara(String pValue){
        if( !BindingFromSimpleYasugoTaishoshaZokugara.containsKey(pValue) ) return null;
        return BindingFromSimpleYasugoTaishoshaZokugara.get(pValue);
    }
}