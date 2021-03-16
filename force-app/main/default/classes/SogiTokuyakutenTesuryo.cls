public class SogiTokuyakutenTesuryo {/** this delete class */
//sogitokuyakutensetterに切る

    // public void updateTokuyakutenTesuryoData(List<SimpleYasugo__c> pNewOnes , Map<Id, SimpleYasugo__c> oldOnes){
    //     Map<Id,SimpleYasugo__c> entrys_tobe_processed = new Map<Id,SimpleYasugo__c>();
    //     for(SimpleYasugo__c newOne :pNewOnes){
    //         SimpleYasugo__c oldOne =  oldOnes.get(newOne.Id);
    //         if(newOne.SimpleYasugoKeiyakuRef__c != oldOne.SimpleYasugoKeiyakuRef__c){
    //             // 決定葬儀社名が変わった物だけを対象
    //             entrys_tobe_processed.put(newOne.Id,newOne);
    //         }
    //     }
    //     // key:決定葬儀社 value:特約店Id（パートナー契約）
    //     Map<String,String> SimpleYasugoKeiyakuToSogishaId = new Map<String,String>();
    //     Map<String, String> KeiyakuIdTotokuyakutenKeiyakuId = new Map<String, String>();
    //     Map<String, String> SogiTokuyakutenId = new Map<String, String>();
    //     for(SimpleYasugo__c entry : entrys_tobe_processed.values()){
    //         if(entry.SimpleYasugoKeiyakuRef__c != null){
    //             // この時は特約店の情報は取得できない為null
    //             SimpleYasugoKeiyakuToSogishaId.put(entry.SimpleYasugoKeiyakuRef__c, null);
    //         }
    //     }
    //     // パートナー契約の主契約に対して決定葬儀社のIdを条件に取得（取得できれば特約店のパートナー契約）
    //     for(Keiyaku__c keiyaku : [
    //         SELECT 
    //             Id,
    //             Teikeisaki__c,
    //             SyuKeiyakuRef__c,
    //             KeiyakuJokyo__c
    //         FROM 
    //             Keiyaku__c 
    //         WHERE 
    //             SyuKeiyakuRef__c IN :SimpleYasugoKeiyakuToSogishaId.keySet()
    //             AND
    //             RecordTypeId = :Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('TokuyakuTen').getRecordTypeId()
    //             AND
    //             KeiyakuJokyo__c = '契約中' 
    //     ]){
    //             // key:主契約のパートナー契約Id　value:特約店のパートナー契約Id
    //             SimpleYasugoKeiyakuToSogishaId.put(keiyaku.SyuKeiyakuRef__c,keiyaku.Id); 
    //     }
    //     for(String keiyakuId : SimpleYasugoKeiyakuToSogishaId.keySet()){
    //         // 設定されていない決定葬儀社は更新の対象外になるため判定する
    //         if(SimpleYasugoKeiyakuToSogishaId.get(keiyakuId) != null){
    //             KeiyakuIdTotokuyakutenKeiyakuId.put(keiyakuId, SimpleYasugoKeiyakuToSogishaId.get(keiyakuId));
    //         }
    //     }
    //     // 葬儀社特約店手数料オブジェクトにSELECTをする
    //     for(SogiShaTokuyakutenTesuryo__c SogiShaTokuyakutenTesuryo : [
    //         SELECT Id , KeiyakuRef__c FROM SogiShaTokuyakutenTesuryo__c WHERE KeiyakuRef__c IN : KeiyakuIdTotokuyakutenKeiyakuId.values()
    //     ] ){
    //         // key:特約店パートナー契約Id value: 葬儀社特約店手数料オブジェクトId
    //         SogiTokuyakutenId.put(SogiShaTokuyakutenTesuryo.KeiyakuRef__c, SogiShaTokuyakutenTesuryo.Id);
    //     }
    //     // for (SimpleYasugo__c newOne : pNewOnes) {
    //     //     if(entrys_tobe_processed.get(newOne.Id) != null){
    //     //         newOne.SogiShaTokuyakutenTesuryoRef__c = SogiTokuyakutenId.get(SimpleYasugoKeiyakuToSogishaId.get(entrys_tobe_processed.get(newOne.Id).SimpleYasugoKeiyakuRef__c));
    //     //     }
    //     // }

    //     // for(Keiyaku__c tokuyakuten : [
    //     //     SELECT Id,Teikeisaki__c,KeiyakuJokyo__c FROM Keiyaku__c WHERE Teikeisaki__c IN : SimpleYasugoKeiyakuToSogishaId.values()
    //     // ]){
    //     //     if(tokuyakuten.KeiyakuJokyo__c == '契約中'){
    //     //         SogishaTotokuyakutenKeiyakuId.put(tokuyakuten.Id,tokuyakuten.Teikeisaki__c);
    //     //     }
            
    //     // }
    //     // 特約店のidをシンプル安豪の項目を追加する。
    // }

    // public static SogiShaTokuyakutenTesuryo__c getSogiShaTokuyakutenTesuryo(Id kaiyakuId , DateTime kakuteibi){
    //     SogiShaTokuyakutenTesuryo__c ret = new SogiShaTokuyakutenTesuryo__c();
    //     ret.Ichinichiso__c = 0;
    //     ret.Ippanso__c = 0;
    //     ret.Kazokuso__c = 0;
    //     ret.Kasoshiki__c = 0;
    //     ret.Chokuso__c = 0;
    //     List<SogiShaTokuyakutenTesuryo__c> retList = [
    //             SELECT Id , name , Ichinichiso__c,Ippanso__c,Kazokuso__c,Kasoshiki__c,Chokuso__c, Tekiyokaishi__c from SogiShaTokuyakutenTesuryo__c where Tekiyokaishi__c <= :kakuteibi.date() AND KeiyakuRef__c = :kaiyakuId LIMIT 1
    //         ];
    //     if(retList.size() > 0){
    //         return retList.get(0);
    //     }else{
    //         return ret;
    //     }
    // }
    
}