public class SgThkSvcExcld{

    public enum ServiceKubuns {
        koden_gaeshi,
        hoyo_49nichi,
        eitai_kuyo,
        kaiyo_sankotsu
    }

    public static IServiceToBeExcluded_Judger get_IServiceToBeExcluded_Judger_instance(){
        return new ServiceToBeExcluded_Judger(
            new ToExclude_Judger_KodenGaeshi(
                ShiragikuTaios.get_ICanShiragikuTaio_Judger_instance()
            ),
            new ToExclude_Judger_49Nichi(),
            new ToExclude_Judger_EitaiKuyo(
                EitaiKuyoTaioAreas.get_ITaioKanoAreaHantei_instance()
            ),
            new ToExclude_Judger_kaiyoSankotsu()
        );
    }

    public interface IServiceToBeExcluded_Judger {
        Set<ServiceKubuns> get_services_tobe_excluded(String p_opp_id);
    }
    public class ServiceToBeExcluded_Judger implements IServiceToBeExcluded_Judger{
        private IToExclude_Judger_KodenGaeshi m_IToExclude_Judger_KodenGaeshi;
        private IToExclude_Judger_49Nichi m_IToExclude_Judger_49Nichi;
        private IToExclude_Judger_EitaiKuyo m_IToExclude_Judger_EitaiKuyo;
        private IToExclude_Judger_kaiyoSankotsu m_IToExclude_Judger_kaiyoSankotsu;
        public ServiceToBeExcluded_Judger(
            IToExclude_Judger_KodenGaeshi p_IToExclude_Judger_KodenGaeshi,
            IToExclude_Judger_49Nichi p_IToExclude_Judger_49Nichi,
            IToExclude_Judger_EitaiKuyo p_IToExclude_Judger_EitaiKuyo,
            IToExclude_Judger_kaiyoSankotsu p_IToExclude_Judger_kaiyoSankotsu
        ){
            this.m_IToExclude_Judger_KodenGaeshi = p_IToExclude_Judger_KodenGaeshi;
            this.m_IToExclude_Judger_49Nichi = p_IToExclude_Judger_49Nichi;
            this.m_IToExclude_Judger_EitaiKuyo = p_IToExclude_Judger_EitaiKuyo;
            this.m_IToExclude_Judger_kaiyoSankotsu = p_IToExclude_Judger_kaiyoSankotsu;
        }

        public Set<ServiceKubuns> get_services_tobe_excluded(String p_opp_id){
            Set<ServiceKubuns> the_services_tobe_excluded = new Set<ServiceKubuns>();

            Opportunity a_opp = this.select_opps( new List<String>{p_opp_id} ).get(0);

            if( this.m_IToExclude_Judger_KodenGaeshi.to_exclude(a_opp) ){ the_services_tobe_excluded.add(ServiceKubuns.koden_gaeshi); }
            if( this.m_IToExclude_Judger_49Nichi.to_exclude(a_opp) ){ the_services_tobe_excluded.add(ServiceKubuns.hoyo_49nichi); }
            if( this.m_IToExclude_Judger_EitaiKuyo.to_exclude(a_opp) ){ the_services_tobe_excluded.add(ServiceKubuns.eitai_kuyo);  }
            if( this.m_IToExclude_Judger_kaiyoSankotsu.to_exclude(a_opp) ){ the_services_tobe_excluded.add(ServiceKubuns.kaiyo_sankotsu); }

            return the_services_tobe_excluded;
        }
        public List<Opportunity> select_opps( List<String> p_opp_ids ){
            return [
                SELECT Id,
                Account.KoukokuDmNg__c,
                SimpleYasugoRef__r.TaishoshaRef__c,
                SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c,
                SimpleYasugoRef__r.KiboAreaRef__r.TodoufuKenRef__r.Name
                FROM Opportunity
                WHERE Id IN :p_opp_ids
            ];
        }
    }

    public interface IToExclude_Judger_KodenGaeshi{
        Boolean to_exclude(Opportunity p_opp);
    }
    public class ToExclude_Judger_KodenGaeshi implements IToExclude_Judger_KodenGaeshi{
        private ShiragikuTaios.ICanShiragikuTaio_Judger m_ICanShiragikuTaio_Judger;
        public ToExclude_Judger_KodenGaeshi(
            ShiragikuTaios.ICanShiragikuTaio_Judger p_ICanShiragikuTaio_Judger
        ){
            this.m_ICanShiragikuTaio_Judger = p_ICanShiragikuTaio_Judger;
        }
        public Boolean to_exclude(Opportunity p_opp){
            if( p_opp.Account.KoukokuDmNg__c ){ //香典返しのカタログを送付しない条件に該当
                return true;
            }
            return !this.m_ICanShiragikuTaio_Judger.can_taio(p_opp.Id);
        }
    }

    public interface IToExclude_Judger_49Nichi {
        Boolean to_exclude(Opportunity p_opp);
    }
    public class ToExclude_Judger_49Nichi implements IToExclude_Judger_49Nichi{
        public Boolean to_exclude(Opportunity p_opp){

            Boolean is_bodaiji_ari = new List<String>{'有','有-葬儀に来ない','有-葬儀に来る'}.contains(p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c);
            if( is_bodaiji_ari ){ return true; }
            
            Boolean is_already =
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName != '除外'
                    AND ObosanbinRef__r.Taishosha1Ref__c != NULL
                    AND ObosanbinRef__r.Taishosha1Ref__c = :p_opp.SimpleYasugoRef__r.TaishoshaRef__c
                    AND ObosanbinRef__r.MemorialServicePlan__c = '四十九日法要'
                    LIMIT 1
                ]
                .size() > 0;
            if( is_already ){ return true; }

            return false;
        }
    }

    public interface IToExclude_Judger_EitaiKuyo {
        Boolean to_exclude(Opportunity p_opp);
    }
    public class ToExclude_Judger_EitaiKuyo implements IToExclude_Judger_EitaiKuyo{

        private EitaiKuyoTaioAreas.ITaioKanoAreaHantei m_ITaioKanoAreaHantei;
        public ToExclude_Judger_EitaiKuyo(
            EitaiKuyoTaioAreas.ITaioKanoAreaHantei p_ITaioKanoAreaHantei
        ){
            this.m_ITaioKanoAreaHantei = p_ITaioKanoAreaHantei;
        }

        public Boolean to_exclude(Opportunity p_opp){

            Boolean is_bodaiji_ari = new List<String>{'有','有-葬儀に来ない','有-葬儀に来る'}.contains(p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c);
            if( is_bodaiji_ari ){ return true; }

            Boolean is_area_unavailable = false;
            {
                String a_state_of_sogi_kibo_area = p_opp.SimpleYasugoRef__r.KiboAreaRef__r.TodoufuKenRef__r.Name;
                if( !String.isBlank(a_state_of_sogi_kibo_area) && !this.m_ITaioKanoAreaHantei.is_available_state(a_state_of_sogi_kibo_area) ){
                    is_area_unavailable = true;
                }
            }
            if( is_area_unavailable ){ return true; }

            
            Boolean is_eitai_kuyo_already = 
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName != '除外'
                    AND EitaiKuyoRef__r.TaishoshaRef__c != NULL
                    AND EitaiKuyoRef__r.TaishoshaRef__c = :p_opp.SimpleYasugoRef__r.TaishoshaRef__c
                    LIMIT 1
                ]
                .size() > 0;
            if( is_eitai_kuyo_already ){ return true; }

            Boolean is_kaiyo_sankotsu_already = 
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName != '除外'
                    AND KaiyoSankotsuUmieRef__r.TaishoshaRef__c != NULL
                    AND KaiyoSankotsuUmieRef__r.TaishoshaRef__c = :p_opp.SimpleYasugoRef__r.TaishoshaRef__c
                    LIMIT 1
                ]
                .size() > 0;
            if( is_kaiyo_sankotsu_already ){ return true; }

            return false;
        }
    }

    public interface IToExclude_Judger_kaiyoSankotsu {
        Boolean to_exclude(Opportunity p_opp);
    }
    public class ToExclude_Judger_kaiyoSankotsu implements IToExclude_Judger_kaiyoSankotsu{

        public Boolean to_exclude(Opportunity p_opp){

            Boolean is_bodaiji_ari = new List<String>{'有','有-葬儀に来ない','有-葬儀に来る'}.contains(p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BodaijinoUmu__c);
            if( is_bodaiji_ari ){ return true; }

            Boolean is_eitai_kuyo_already = 
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName != '除外'
                    AND EitaiKuyoRef__r.TaishoshaRef__c != NULL
                    AND EitaiKuyoRef__r.TaishoshaRef__c = :p_opp.SimpleYasugoRef__r.TaishoshaRef__c
                    LIMIT 1
                ]
                .size() > 0;
            if( is_eitai_kuyo_already ){ return true; }

            Boolean is_kaiyo_sankotsu_already = 
                [
                    SELECT Id
                    FROM Opportunity
                    WHERE StageName != '除外'
                    AND KaiyoSankotsuUmieRef__r.TaishoshaRef__c != NULL
                    AND KaiyoSankotsuUmieRef__r.TaishoshaRef__c = :p_opp.SimpleYasugoRef__r.TaishoshaRef__c
                    LIMIT 1
                ]
                .size() > 0;
            if( is_kaiyo_sankotsu_already ){ return true; }

            return false;
        }
    }
}