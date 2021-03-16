public class SogiTokuyakutenTesuryoLatest {

    public static ILatestUpdater get_ILatestUpdater_instance(){
        return new LatestUpdater();
    }
    public interface ILatestUpdater {
        void on_SogiShaTokuyakutenTesuryo_after_Insert( List<SogiShaTokuyakutenTesuryo__c> p_new_ones );
        void on_SogiShaTokuyakutenTesuryo_after_update(
            List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones
        );
        void on_SogiShaTokuyakutenTesuryo_after_delete( Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones );
    }
    public class LatestUpdater implements ILatestUpdater{
        public void on_SogiShaTokuyakutenTesuryo_after_Insert(
            List<SogiShaTokuyakutenTesuryo__c> p_new_ones
        ){
            Set<String> the_keiyaku_ids = new Set<String>();
            for(SogiShaTokuyakutenTesuryo__c a_new_one : p_new_ones){
                if( a_new_one.KeiyakuRef__c != null ){
                    the_keiyaku_ids.add(a_new_one.KeiyakuRef__c);
                }
            }
            this.update_latest_tesuryo( new List<String>(the_keiyaku_ids) );
        }

        public void on_SogiShaTokuyakutenTesuryo_after_update(
            List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones
        ){
            Set<String> the_keiyaku_ids = new Set<String>();
            for(SogiShaTokuyakutenTesuryo__c a_new_one : p_new_ones){
                if( a_new_one.KeiyakuRef__c != null ){
                    the_keiyaku_ids.add(a_new_one.KeiyakuRef__c);
                }
            }
            this.update_latest_tesuryo( new List<String>(the_keiyaku_ids) );
        }

        public void on_SogiShaTokuyakutenTesuryo_after_delete(
            Map<Id, SogiShaTokuyakutenTesuryo__c> p_old_ones
        ){
            Set<String> the_keiyaku_ids = new Set<String>();
            for(SogiShaTokuyakutenTesuryo__c a_old_one : p_old_ones.values()){
                if( a_old_one.KeiyakuRef__c != null ){
                    the_keiyaku_ids.add(a_old_one.KeiyakuRef__c);
                }
            }
            this.update_latest_tesuryo( new List<String>(the_keiyaku_ids) );
        }

        public void update_latest_tesuryo(List<String> p_keiyaku_ids){

            List<Keiyaku__c> the_keiyakus = 
                [
                    SELECT Id, TokuyakutenTesuryoRef__c,
                    (
                        SELECT Id, Tekiyokaishi__c,
                        Chokuso__c, Kasoshiki__c, 
                        Ichinichiso__c, Kazokuso__c, Ippanso__c
                        FROM SogiShaTokuyakutenTesuryos__r
                        ORDER BY Tekiyokaishi__c DESC
                        LIMIT 1
                    )
                    FROM Keiyaku__c
                    WHERE Id IN :p_keiyaku_ids
                ];

            Map<String, TokuyakutenTesuryo__c> the_keiyaku_id_to_TokuyakutenTesuryo_map = new Map<String, TokuyakutenTesuryo__c>();
            Map<String, TokuyakutenTesuryo__c> the_keiyaku_id_to_TokuyakutenTesuryo_insert_map = new Map<String, TokuyakutenTesuryo__c>();
            for(Keiyaku__c a_keiyaku : the_keiyakus){
                TokuyakutenTesuryo__c a_TokuyakutenTesuryo = null;
                if( a_keiyaku.TokuyakutenTesuryoRef__c != null){
                    a_TokuyakutenTesuryo = new TokuyakutenTesuryo__c(Id = a_keiyaku.TokuyakutenTesuryoRef__c);
                }
                else{
                    a_TokuyakutenTesuryo = new TokuyakutenTesuryo__c();
                    the_keiyaku_id_to_TokuyakutenTesuryo_insert_map.put(a_keiyaku.Id, a_TokuyakutenTesuryo);
                }
                the_keiyaku_id_to_TokuyakutenTesuryo_map.put(a_keiyaku.Id, a_TokuyakutenTesuryo);
            }
            INSERT the_keiyaku_id_to_TokuyakutenTesuryo_insert_map.values();

            List<Keiyaku__c> the_keiyaku_updates_for_TokuyakutenTesuryo_relation = new List<Keiyaku__c>();
            for( String a_keiyaku_id : the_keiyaku_id_to_TokuyakutenTesuryo_insert_map.keySet() ){
                the_keiyaku_updates_for_TokuyakutenTesuryo_relation.add(
                    new Keiyaku__c(
                        Id = a_keiyaku_id, 
                        TokuyakutenTesuryoRef__c = the_keiyaku_id_to_TokuyakutenTesuryo_insert_map.get(a_keiyaku_id).Id
                    )
                );
            }
            UPDATE the_keiyaku_updates_for_TokuyakutenTesuryo_relation;

            List<TokuyakutenTesuryo__c> the_TokuyakutenTesuryo_udate = new List<TokuyakutenTesuryo__c>();
            for(Keiyaku__c a_keiyaku : the_keiyakus){
                SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo_latest = 
                    a_keiyaku.SogiShaTokuyakutenTesuryos__r.size() > 0 
                    ? a_keiyaku.SogiShaTokuyakutenTesuryos__r.get(0)
                    : null;
                
                TokuyakutenTesuryo__c a_TokuyakutenTesuryo_update = 
                    new TokuyakutenTesuryo__c(
                        Id = the_keiyaku_id_to_TokuyakutenTesuryo_map.get(a_keiyaku.Id).Id,
                        Chokuso__c = 
                            a_SogiShaTokuyakutenTesuryo_latest == null 
                            ? 0 
                            : a_SogiShaTokuyakutenTesuryo_latest.Chokuso__c,
                        Kasoshiki__c = 
                            a_SogiShaTokuyakutenTesuryo_latest == null 
                            ? 0 
                            : a_SogiShaTokuyakutenTesuryo_latest.Kasoshiki__c,
                        Ichinichiso__c = 
                            a_SogiShaTokuyakutenTesuryo_latest == null 
                            ? 0 
                            : a_SogiShaTokuyakutenTesuryo_latest.Ichinichiso__c,
                        Kazokuso__c = 
                            a_SogiShaTokuyakutenTesuryo_latest == null 
                            ? 0 
                            : a_SogiShaTokuyakutenTesuryo_latest.Kazokuso__c,
                        Ippanso__c =
                            a_SogiShaTokuyakutenTesuryo_latest == null 
                            ? 0 
                            : a_SogiShaTokuyakutenTesuryo_latest.Ippanso__c
                    );
                    the_TokuyakutenTesuryo_udate.add(a_TokuyakutenTesuryo_update);
            }
            UPDATE the_TokuyakutenTesuryo_udate;
        }
    }
}