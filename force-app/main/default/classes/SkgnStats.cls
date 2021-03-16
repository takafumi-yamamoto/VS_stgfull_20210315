public class SkgnStats {

    public static ISkgnStatsUpdater get_ISkgnStatsUpdater_instance(){
        return new SkgnStatsUpdater(
            SkgnSogiKeiyaku.get_ITaioKanoKeiyakuCounter_instance()
        );
    }

    public interface ISkgnStatsUpdater {
        void update_shikugun_stats( List<String> p_shikugun_ids);
    }
    public class SkgnStatsUpdater implements ISkgnStatsUpdater{
        private SkgnSogiKeiyaku.ITaioKanoKeiyakuCounter m_SkgnSogiKeiyaku_ITaioKanoKeiyakuCounter;
        public SkgnStatsUpdater(
            SkgnSogiKeiyaku.ITaioKanoKeiyakuCounter p_SkgnSogiKeiyaku_ITaioKanoKeiyakuCounter
        ){
            this.m_SkgnSogiKeiyaku_ITaioKanoKeiyakuCounter = p_SkgnSogiKeiyaku_ITaioKanoKeiyakuCounter;
        }

        public void update_shikugun_stats( List<String> p_shikugun_ids){

            Map<String, Integer> the_ShikugunId_to_ActiveKeiyakuCount = 
                this.m_SkgnSogiKeiyaku_ITaioKanoKeiyakuCounter.get_taiokano_keiyaku_count_by_shikugun_ids(p_shikugun_ids);
            
            List<Shikugun__c> the_updates = new List<Shikugun__c>();
            for( String a_shikugun_id : p_shikugun_ids ){
                the_updates.add(
                    new Shikugun__c(
                        Id = a_shikugun_id,
                        Sogi_TaioKanoKeiyaku_Cnt__c = the_ShikugunId_to_ActiveKeiyakuCount.get(a_shikugun_id)
                    )
                );
            }
            UPDATE the_updates;
        }
    }
}