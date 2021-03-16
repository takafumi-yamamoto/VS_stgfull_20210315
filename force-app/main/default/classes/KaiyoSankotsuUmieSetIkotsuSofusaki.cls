/**
 * 決定葬儀社が設定されたら遺骨送付先を設定する
 * ・海洋散骨Umieのトリガーから呼ばれる
 *
 */
public with sharing class KaiyoSankotsuUmieSetIkotsuSofusaki {

    public static final String[] ACC_TAISHO_NOS = new List<String>{'FR-00138','ACUMIE-3'};

    //Before Update時
    public void setIkotsuSofusakiForUpdate(List<KaiyoSankotsuUmie__c> newlist,Map<ID, KaiyoSankotsuUmie__c> oldMap){

        Map<Id, Keiyaku__c> keiyakuIdMap = new Map<Id, Keiyaku__c>();
        Map<String, Keiyaku__c> keiyakuBangoMap = new Map<String, Keiyaku__c>();
        for(Keiyaku__c k : getTargetPartnerList()){
            keiyakuIdMap.put(k.Id, k);
            keiyakuBangoMap.put(k.Teikeisaki__r.TorihikisakiBango__c, k);
        }

        for(KaiyoSankotsuUmie__c kaiyosankotsu:newList){
            KaiyoSankotsuUmie__c oldkaiyosankotsu = oldMap.get(kaiyosankotsu.Id);
            if(kaiyosankotsu.KetteiPlan__c != null && oldkaiyosankotsu.KetteiPlan__c != kaiyosankotsu.KetteiPlan__c && kaiyosankotsu.KetteiPlan__c == '貸切乗船散骨'){
                if(!keiyakuBangoMap.containsKey('FR-00138')){
                    kaiyosankotsu.addError('葬儀社マスタがありません。');
                    return;
                }
                else{
                    kaiyosankotsu.KetteiSogisha__c = keiyakuBangoMap.get('FR-00138').Id;
                    kaiyosankotsu.IkotsuSoufusakiRef__c = keiyakuBangoMap.get('FR-00138').Id;
                }
            }
            else if(kaiyosankotsu.KetteiKaiiki__c != null && oldkaiyosankotsu.KetteiKaiiki__c != kaiyosankotsu.KetteiKaiiki__c && 
                (kaiyosankotsu.KetteiKaiiki__c == '湘南海岸（神奈川）' || 
                    kaiyosankotsu.KetteiKaiiki__c == '駿河湾（静岡）' || 
                    kaiyosankotsu.KetteiKaiiki__c == '伊勢志摩（三重）' || 
                    kaiyosankotsu.KetteiKaiiki__c == '南紀白浜（和歌山）' || 
                    kaiyosankotsu.KetteiKaiiki__c == '博多湾（福岡）' || 
                    kaiyosankotsu.KetteiKaiiki__c == '沖縄本島')){
                if(!keiyakuBangoMap.containsKey('ACUMIE-3')){
                    kaiyosankotsu.addError('葬儀社マスタがありません。');
                    return;
                }
                else{
                    kaiyosankotsu.KetteiSogisha__c = keiyakuBangoMap.get('ACUMIE-3').Id;
                    kaiyosankotsu.IkotsuSoufusakiRef__c = keiyakuBangoMap.get('ACUMIE-3').Id;
                }
            }
            else if(kaiyosankotsu.KetteiSogisha__c != null && oldkaiyosankotsu.KetteiSogisha__c != kaiyosankotsu.KetteiSogisha__c){
                if(keiyakuIdMap.containsKey(kaiyosankotsu.KetteiSogisha__c)){
                    kaiyosankotsu.IkotsuSoufusakiRef__c = kaiyosankotsu.KetteiSogisha__c;
                }
            }
        }
    }

    private List<Keiyaku__c> getTargetPartnerList(){

        return [
            SELECT 
                Id
                ,Teikeisaki__c
                ,Teikeisaki__r.TorihikisakiBango__c
            FROM Keiyaku__c
            WHERE Teikeisaki__r.TorihikisakiBango__c in :ACC_TAISHO_NOS 
                AND RecordTypeId = :Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Umie').getRecordTypeId()
        ];
    }

}