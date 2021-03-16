public class KeiyakuSikkoFactors {

    public static ISikkoFactorReader get_ISikkoFactorReader_instance(){
        return new SikkoFactorReader();
    }

    public enum Factors{
        keiri_sokyaku_teishi, //債権回収滞留
        yosin_over,
        has_sokyaku_teishi_riyu
    }

    public interface ISikkoFactorReader {
        List<Keiyaku__c> select_keiyakus(List<String> p_keiyaku_ids);
        Set<Factors> get_sikko_factors(Keiyaku__c p_keiyaku);
        Boolean is_any_other_sikko_factor(Keiyaku__c p_keiyaku, Factors p_factor_exclude);
    }
    public class SikkoFactorReader implements ISikkoFactorReader{
        public List<Keiyaku__c> select_keiyakus(List<String> p_keiyaku_ids){
            return [
                SELECT Id,
                KeiyakuJokyo__c, 
                KeiriSokyakuTeishiFlag__c, 
                IsYosinOverStop__c,
                KeiyakuSikkouKasibi__c, KeiyakuSikkouKaijoBi__c, KeiyakuSikkoRiyu__c
                FROM Keiyaku__c
                WHERE Id IN :p_keiyaku_ids
            ];
        }
        public Set<Factors> get_sikko_factors(Keiyaku__c p_keiyaku){
            
            Set<Factors> the_factos = new Set<Factors>();
            if( p_keiyaku.KeiyakuJokyo__c != '失効中') { return the_factos; }

            { //keiri_sokyaku_teishi
                if( p_keiyaku.KeiriSokyakuTeishiFlag__c ){ the_factos.add(Factors.keiri_sokyaku_teishi); }
            }
            { //factors_yosin_over
                if( p_keiyaku.IsYosinOverStop__c ){ the_factos.add(Factors.yosin_over); }
            } //has_sokyaku_teishi_riyu
            {
                if( this.has_sokyaku_teishi_riyu(p_keiyaku) ){ the_factos.add(Factors.has_sokyaku_teishi_riyu); }
            }
            return the_factos;
        }

        public Boolean is_any_other_sikko_factor(Keiyaku__c p_keiyaku, Factors p_factor_exclude){
            Boolean is_any_other_factor = false;
            for(Factors a_factor : this.get_sikko_factors(p_keiyaku) ){
                if( a_factor != p_factor_exclude){
                    is_any_other_factor = true;
                }
            }
            return is_any_other_factor;
        }
        private Boolean has_sokyaku_teishi_riyu(Keiyaku__c p_keiyaku){
            if( p_keiyaku.KeiyakuSikkouKasibi__c == null ){ return false; }
            if( p_keiyaku.KeiyakuSikkoRiyu__c == '経理・法務グループ により送客停止' ){ return false; } //keiri_sokyaku_teishiに該当するので除外
            if( p_keiyaku.KeiyakuSikkouKaijoBi__c == null){ return true; }
            if( p_keiyaku.KeiyakuSikkouKasibi__c > p_keiyaku.KeiyakuSikkouKaijoBi__c ){ return true; }
            return false;
        }

    }
}