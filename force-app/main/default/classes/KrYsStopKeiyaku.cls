public class KrYsStopKeiyaku {

    public static IStopOrUnStopper get_IStopOrUnStopper_instance(){
        return new StopOrUnStopper(
            get_IStopOfKeiyaku_instance(),
            get_IUnStopOfKeiyaku_instance()
        );
    }
    public static IStopOfKeiyaku get_IStopOfKeiyaku_instance(){
        return new StopOfKeiyaku();
    }
    public static IUnStopOfKeiyaku get_IUnStopOfKeiyaku_instance(){
        return new UnStopOfKeiyaku(
            KeiyakuSikkoFactors.get_ISikkoFactorReader_instance()
        );
    }

    public interface IStopOrUnStopper {
        void stop_or_unstop_by_yosin(String p_torihikisaki_bango);
    }
    public class StopOrUnStopper implements IStopOrUnStopper{
        private IStopOfKeiyaku m_IStopOfKeiyaku;
        private IUnStopOfKeiyaku m_IUnStopOfKeiyaku;
        public StopOrUnStopper(IStopOfKeiyaku p_IStopOfKeiyaku, IUnStopOfKeiyaku p_IUnStopOfKeiyaku){
            this.m_IStopOfKeiyaku = p_IStopOfKeiyaku;
            this.m_IUnStopOfKeiyaku = p_IUnStopOfKeiyaku;
        }

        public void stop_or_unstop_by_yosin(String p_torihikisaki_bango){
            Account a_account = (Account)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, TorihikiSakiBango__c,
                    KrYsYosinRef__r.YosinHantei__c
                    FROM Account
                    WHERE TorihikiSakiBango__c = :p_torihikisaki_bango
                    LIMIT 1
                ]
            );

            if( String.isBlank(a_account.KrYsYosinRef__r.YosinHantei__c) ){ throw new Exceptions.AnException('与信判定結果なし;'); }
            
            if(a_account.KrYsYosinRef__r.YosinHantei__c == 'NG-与信限度額Over'){
                this.m_IStopOfKeiyaku.stop(p_torihikisaki_bango);
            }else{
                this.m_IUnStopOfKeiyaku.unstop(p_torihikisaki_bango);
            }
        }
    }

    public interface IStopOfKeiyaku {
        void stop(String p_torihikisaki_bango);
    }
    public class StopOfKeiyaku implements IStopOfKeiyaku{

        public void stop(String p_torihikisaki_bango){

            List<Keiyaku__c> the_updates = new List<Keiyaku__c>();
            List<Keiyaku__c> the_keiyakus =
                [
                    SELECT Id, KeiyakuJokyo__c
                    FROM Keiyaku__c 
                    WHERE RecordType.DeveloperName = 'SimpleYasugo'
                    AND Teikeisaki__r.TorihikiSakiBango__c = :p_torihikisaki_bango
                    AND KeiyakuJokyo__c IN ('契約中','失効中')
                ];
            
            for(Keiyaku__c a_keiyaku : the_keiyakus){
                Keiyaku__c a_update_keiyaku = 
                    new Keiyaku__c( Id = a_keiyaku.Id, IsYosinOverStop__c = true);

                if(a_keiyaku.KeiyakuJokyo__c == '契約中'){
                    a_update_keiyaku.KeiyakuJokyo__c = '失効中';
                }
                the_updates.add(a_update_keiyaku);
            }
            UPDATE the_updates;
        }
    }

    public interface IUnStopOfKeiyaku{
        void unstop(String p_torihikisaki_bango);
    }
    public class UnStopOfKeiyaku implements IUnStopOfKeiyaku{
        private KeiyakuSikkoFactors.ISikkoFactorReader m_ISikkoFactorReader;
        public UnStopOfKeiyaku(KeiyakuSikkoFactors.ISikkoFactorReader p_ISikkoFactorReader){
            this.m_ISikkoFactorReader = p_ISikkoFactorReader;
        }
        
        public void unstop(String p_torihikisaki_bango){

            List<Keiyaku__c> the_updates = new List<Keiyaku__c>();
            List<Keiyaku__c> the_keiyakus =
                [
                    SELECT Id, KeiyakuJokyo__c,
                    KeiyakuSikkouKasibi__c, KeiyakuSikkouKaijoBi__c
                    FROM Keiyaku__c 
                    WHERE Teikeisaki__r.TorihikiSakiBango__c = :p_torihikisaki_bango
                    AND IsYosinOverStop__c = true
                ];
            
            for(Keiyaku__c a_keiyaku : the_keiyakus){
                Keiyaku__c a_update_keiyaku = 
                    new Keiyaku__c( Id = a_keiyaku.Id, IsYosinOverStop__c = false);

                if(a_keiyaku.KeiyakuJokyo__c == '失効中'){
                    Boolean is_any_other_sikko_factor = 
                        this.m_ISikkoFactorReader.is_any_other_sikko_factor(
                            this.m_ISikkoFactorReader.select_keiyakus(new List<string>{a_keiyaku.Id}).get(0),
                            KeiyakuSikkoFactors.Factors.yosin_over
                        );
                    if( !is_any_other_sikko_factor ){ a_update_keiyaku.KeiyakuJokyo__c = '契約中'; }
                }

                the_updates.add(a_update_keiyaku);
            }
            UPDATE the_updates;
        }
    }

}