public without sharing class SogitokuyakutenSetter {

    public static ITokuyakutenKeiyakuSetter get_ITokuyakutenKeiyakuSetter(){
        return new TokuyakutenKeiyakuSetter();
    }

    public interface ITokuyakutenKeiyakuSetter {
        void set_tokuyakuten_keiyaku(List<SimpleYasugo__c> pNewOnes , Map<Id, SimpleYasugo__c> oldOnes);
    }
    public class TokuyakutenKeiyakuSetter implements ITokuyakutenKeiyakuSetter{
        public void set_tokuyakuten_keiyaku(List<SimpleYasugo__c> pNewOnes , Map<Id, SimpleYasugo__c> oldOnes){

            List<SimpleYasugo__c> entries_tobe_processed = new List<SimpleYasugo__c>();
            for(SimpleYasugo__c a_new_one :pNewOnes){
                SimpleYasugo__c a_old_one =  oldOnes.get(a_new_one.Id);
                if(a_new_one.SimpleYasugoKeiyakuRef__c != a_old_one.SimpleYasugoKeiyakuRef__c){
                    entries_tobe_processed.add( a_new_one );
                }
            }
    
            Set<String> the_simple_yasugo_keiyaku_ids = new Set<String>();
            for(SimpleYasugo__c a_entry : entries_tobe_processed ){
                if(a_entry.SimpleYasugoKeiyakuRef__c != null){ the_simple_yasugo_keiyaku_ids.add(a_entry.SimpleYasugoKeiyakuRef__c); }
            }
    
            Map<String, String> the_simpleyasugo_to_tokuyakuten_keiyakuid_map = new Map<String, String>();
            for( Keiyaku__c a_tokuyakuten_keiyaku : [
                SELECT Id, SyuKeiyakuRef__c, KeiyakuJokyo__c
                FROM Keiyaku__c
                WHERE SyuKeiyakuRef__c IN :the_simple_yasugo_keiyaku_ids
                AND RecordTypeId = :Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('TokuyakuTen').getRecordTypeId()
                AND KeiyakuJokyo__c = '契約中'
            ]){
                the_simpleyasugo_to_tokuyakuten_keiyakuid_map.put( a_tokuyakuten_keiyaku.SyuKeiyakuRef__c,  a_tokuyakuten_keiyaku.Id );
            }
    
            for(SimpleYasugo__c a_entry : entries_tobe_processed ){
                a_entry.TokuyakutenKeiyakuRef__c =
                    a_entry.SimpleYasugoKeiyakuRef__c == null
                    ? null
                    : the_simpleyasugo_to_tokuyakuten_keiyakuid_map.get( a_entry.SimpleYasugoKeiyakuRef__c )
                    ;
            }
        }
    }

}