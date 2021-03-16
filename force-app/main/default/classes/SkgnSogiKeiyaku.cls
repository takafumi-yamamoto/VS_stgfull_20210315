public class SkgnSogiKeiyaku {

    public static ITaioKanoKeiyakuCounter get_ITaioKanoKeiyakuCounter_instance(){
        return new TaioKanoKeiyakuCounter();
    }
    public interface ITaioKanoKeiyakuCounter {
        Map<String, Integer> get_taiokano_keiyaku_count_by_shikugun_ids(List<String> p_shikugun_ids);
    }
    public class TaioKanoKeiyakuCounter implements ITaioKanoKeiyakuCounter{
        public Map<String, Integer> get_taiokano_keiyaku_count_by_shikugun_ids(List<String> p_shikugun_ids){

            List<SekouKanouArea__c> the_SekouKanouAreas = [
                SELECT Id, ShikugunRef__c, SimpleYasugoKeiyakuRef__c
                FROM SekouKanouArea__c
                WHERE ShikugunRef__c IN :p_shikugun_ids
                AND ShikugunRef__c != NULL
                AND SokyakuTeishi__c = FALSE
                AND SimpleYasugoKeiyakuRef__r.KeiyakuJokyo__c = '契約中'
                AND SimpleYasugoKeiyakuRef__r.RecordType.DeveloperName = 'SimpleYasugo'
            ];

            Map< String, Set<String> > the_ShikugunId_to_KeiyakuIds = new Map< String, Set<String> >();
            for(String a_shikugun_id : p_shikugun_ids){
                the_ShikugunId_to_KeiyakuIds.put( a_shikugun_id, new Set<String>() );
            }

            for(SekouKanouArea__c a_SekouKanouArea : the_SekouKanouAreas){
                the_ShikugunId_to_KeiyakuIds.get( a_SekouKanouArea.ShikugunRef__c ).add( a_SekouKanouArea.SimpleYasugoKeiyakuRef__c );
            }

            Map<String, Integer> the_ShikugunId_to_Count = new Map<String, Integer>();
            for( String a_shikugun_id : the_ShikugunId_to_KeiyakuIds.keySet() ){
                the_ShikugunId_to_Count.put( a_shikugun_id, the_ShikugunId_to_KeiyakuIds.get(a_shikugun_id).size() );
            }

            return the_ShikugunId_to_Count;
        }

    }
}