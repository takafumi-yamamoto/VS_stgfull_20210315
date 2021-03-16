public class SzsdCardExcld {
    
    public static IJudgeToExclude get_IJudgeToExclude_instance(){
        return new JudgeToExclude(
            Szsd_OppValids.get_IOppBasicVallidator_instance(),
            SzsdDontContactMe.get_IDontContactMe_Judger_instance(),
            Szsd_Shiiragiku.get_IOppList_For_Shiragiku_instance(),
            TesterOpp.get_ITestDataJudger_instance(),
            SzsdAssigneesCard.get_ICardFinder_instance(),
            new Environments.Env()
        );
    }

    public enum Exclude_Reasons{
        Opp_Basic_Validation,
        Cross_Selling,
        Dont_Contact_Me,
        Shirgiku_Selling,
        Test_Data,
        Card_Exists
    }

    public interface IJudgeToExclude{
        Boolean to_exclude( String p_opp_id, Boolean p_is_hakkou_shijji_directly);
    }
    public class JudgeToExclude implements IJudgeToExclude{
        private Szsd_OppValids.IOppBasicVallidator m_IOppBasicVallidator;
        private SzsdDontContactMe.IDontContactMe_Judger m_IDontContactMe_Judger;
        private Szsd_Shiiragiku.IOppList_For_Shiragiku m_IOppList_For_Shiragiku;
        private TesterOpp.ITestDataJudger m_ITestDataJudger;
        private SzsdAssigneesCard.ICardFinder m_ICardFinder;
        private Environments.IEnv m_IEnv;
        public JudgeToExclude(
            Szsd_OppValids.IOppBasicVallidator p_IOppBasicVallidator,
            SzsdDontContactMe.IDontContactMe_Judger p_IDontContactMe_Judger,
            Szsd_Shiiragiku.IOppList_For_Shiragiku p_IOppList_For_Shiragiku,
            TesterOpp.ITestDataJudger p_ITestDataJudger,
            SzsdAssigneesCard.ICardFinder p_ICardFinder,
            Environments.IEnv p_IEnv
        ){
            this.m_IOppBasicVallidator = p_IOppBasicVallidator;
            this.m_IDontContactMe_Judger = p_IDontContactMe_Judger;
            this.m_IOppList_For_Shiragiku = p_IOppList_For_Shiragiku;
            this.m_ITestDataJudger = p_ITestDataJudger;
            this.m_ICardFinder = p_ICardFinder;
            this.m_IEnv = p_IEnv;
        }

        public Set<Exclude_Reasons> get_exclude_reason( String p_opp_id, Boolean p_is_hakkou_shijji_directly){

            Set<Exclude_Reasons> a_reasons = new Set<Exclude_Reasons>();

            Opportunity a_opp = 
                [
                    SELECT Id, AccountId
                    FROM Opportunity
                    WHERE Id = :p_opp_id
                ]
                .get(0);

            if( a_reasons.size() == 0 ){
                if( !this.m_IOppBasicVallidator.is_valid(a_opp.Id) ){ a_reasons.add( Exclude_Reasons.Opp_Basic_Validation ); }
            }

            if( a_reasons.size() == 0 ){
                if( this.m_IDontContactMe_Judger.is_dont_contact_me(a_opp.AccountId) ){ a_reasons.add( Exclude_Reasons.Dont_Contact_Me ); }
            }

            if( a_reasons.size() == 0 ){
                if( this.m_ICardFinder.is_card_published_for_any_asignee(a_opp.Id) ){ a_reasons.add( Exclude_Reasons.Card_Exists ); }
            }

            if( a_reasons.size() == 0 ){
                if( !p_is_hakkou_shijji_directly ){
                    if( this.m_IOppList_For_Shiragiku.isMatch(a_opp.Id) ){ a_reasons.add( Exclude_Reasons.Shirgiku_Selling ); }
                }
            }
            
            if( a_reasons.size() == 0 ){
                if( !m_IEnv.isSandbox() ){
                    if( this.m_ITestDataJudger.isTestData(a_opp.Id) ){ a_reasons.add( Exclude_Reasons.Test_Data ); }
                }
            }

            return a_reasons;
        }
        public Boolean to_exclude( String p_opp_id, Boolean p_is_hakkou_shijji_directly){
            return this.get_exclude_reason(p_opp_id, p_is_hakkou_shijji_directly).size() > 0;
        }
    }
}