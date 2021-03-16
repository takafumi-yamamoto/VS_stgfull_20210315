public Class UmeDev{

    public class IToExclude_Judger_Stub implements SgThkExcld.IToExclude_Judger{
        public Set<SgThkExcld.Reasons_To_Exclude> get_any_reason_to_exclude(String p_opp_id){
            return new Set<SgThkExcld.Reasons_To_Exclude>();
        }
    }
    public class IServiceToBeExcluded_Judger_Stub implements SgThkSvcExcld.IServiceToBeExcluded_Judger{
        public Set<SgThkSvcExcld.ServiceKubuns> get_services_tobe_excluded(String p_opp_id){
            return new Set<SgThkSvcExcld.ServiceKubuns>();
        }
    }
    public static void do_anonymous(){
        
        String thank_you_call_id = 
            new SgThkCre.SogiSekogoThankYouCallCreator(
                new IToExclude_Judger_Stub(),
                new IServiceToBeExcluded_Judger_Stub(),
                new Todays.Today()
            )
            .create( '0062v00001EcOHaAAN' );
        System.Debug(
            thank_you_call_id
        );
    }

}