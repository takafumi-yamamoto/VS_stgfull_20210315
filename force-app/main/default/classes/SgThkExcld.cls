public class SgThkExcld {

    public static IToExclude_Judger get_IToExclude_Judger_instance(){
        Todays.IToday a_IToday = new Todays.Today();
        return new ToExclude_Judger(
            new CreatedAlready_Checker(),
            new TooLate_Checker(a_IToday),
            new ShikigoShiryoMisofu_Checker(),
            new DontContactMe_Checker(a_IToday),
            new AnyOther_Checker()
        );
    }

    public enum Reasons_To_Exclude{
        shikigo_shiryo_misofu,
        too_late,
        created_already,
        dont_contact_me,
        any_other
    }

    public interface IToExclude_Judger{
        Set<Reasons_To_Exclude> get_any_reason_to_exclude(String p_opp_id);
    }
    public class ToExclude_Judger implements IToExclude_Judger{

        private ICreatedAlready_Checker m_ICreatedAlready_Checker;
        private ITooLate_Checker m_ITooLate_Checker;
        private IShikigoShiryoMisofu_Checker m_IShikigoShiryoMisofu_Checker;
        private IDontContactMe_Checker m_IDontContactMe_Checker;
        private IAnyOther_Checker m_IAnyOther_Checker;

        public ToExclude_Judger(
            ICreatedAlready_Checker p_ICreatedAlready_Checker,
            ITooLate_Checker p_ITooLate_Checker,
            IShikigoShiryoMisofu_Checker p_IShikigoShiryoMisofu_Checker,
            IDontContactMe_Checker p_IDontContactMe_Checker,
            IAnyOther_Checker p_IAnyOther_Checker
        ){
            this.m_ICreatedAlready_Checker = p_ICreatedAlready_Checker;
            this.m_ITooLate_Checker = p_ITooLate_Checker;
            this.m_IShikigoShiryoMisofu_Checker = p_IShikigoShiryoMisofu_Checker;
            this.m_IDontContactMe_Checker = p_IDontContactMe_Checker;
            this.m_IAnyOther_Checker = p_IAnyOther_Checker;
        }

        private List<Opportunity> getOpps(List<String> p_opp_ids){
            return [
                SELECT Id, RecordType.DeveloperName,
                StageName, Utiagebi__c, 
                AccountId, Account.Phone, Account.MobilePhone__c,
                SimpleYasugoRef__r.SogiAfterSodanshaMailDatetime__c
                FROM Opportunity
                WHERE Id IN :p_opp_ids
            ];
        }

        public Set<Reasons_To_Exclude> get_any_reason_to_exclude(String p_opp_id){
            Set<Reasons_To_Exclude> the_reasons = new Set<Reasons_To_Exclude>();

            Opportunity a_opp = this.getOpps( new List<String>{p_opp_id} ).get(0);

            if( this.m_IAnyOther_Checker.is_match(a_opp) ){
                the_reasons.add(Reasons_To_Exclude.any_other);
            }
            if(the_reasons.size() > 0) { return the_reasons; }

            if( this.m_IShikigoShiryoMisofu_Checker.is_match(a_opp) ){
                the_reasons.add(Reasons_To_Exclude.shikigo_shiryo_misofu);
            }
            if(the_reasons.size() > 0) { return the_reasons; }

            if( this.m_ITooLate_Checker.is_matvh( a_opp.Utiagebi__c ) ){
                the_reasons.add(Reasons_To_Exclude.too_late);
            }
            if(the_reasons.size() > 0) { return the_reasons; }

            if( this.m_ICreatedAlready_Checker.is_match(p_opp_id) ){
                the_reasons.add(Reasons_To_Exclude.created_already);
            }
            if(the_reasons.size() > 0) { return the_reasons; }

            if( this.m_IDontContactMe_Checker.is_dont_contact_me(a_opp.AccountId) ){
                the_reasons.add(Reasons_To_Exclude.dont_contact_me);
            }
            if(the_reasons.size() > 0) { return the_reasons; }

            return the_reasons;
        }
    }

    public interface ICreatedAlready_Checker {
        Boolean is_match(String p_opp_id);
    }
    public class CreatedAlready_Checker implements ICreatedAlready_Checker{
        public Boolean is_match(String p_opp_id){
            return [SELECT Id FROM SgThkCall__c WHERE Sogi_OppRef__c = :p_opp_id LIMIT 1].size() > 0;
        }
    }

    public interface ITooLate_Checker {
        Boolean is_matvh(Date p_Seko_Date);
    }
    public class TooLate_Checker implements ITooLate_Checker{
        private Todays.IToday m_IToday;
        public TooLate_Checker(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }

        public Boolean is_matvh(Date p_Seko_Date){
            if( p_Seko_Date == null ){ return false; }
            Date the_end_date_of_thank_call_kikan = p_Seko_Date.addDays(2);
            return this.m_IToday.Date() > the_end_date_of_thank_call_kikan;
        }
    }

    public interface IShikigoShiryoMisofu_Checker {
        Boolean is_match(Opportunity p_opp);
    }
    public class ShikigoShiryoMisofu_Checker implements IShikigoShiryoMisofu_Checker{
        public Boolean is_match(Opportunity p_opp){
            return p_opp.SimpleYasugoRef__r.SogiAfterSodanshaMailDatetime__c == null;
        }
    }

    public interface IDontContactMe_Checker{
        Boolean is_dont_contact_me(String p_account_id);
    }
	public class DontContactMe_Checker implements IDontContactMe_Checker{

        private Todays.IToday m_IToday;
        public DontContactMe_Checker(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }

		public Boolean is_dont_contact_me(String p_account_id){
            Date a_from_date = m_IToday.Date().addYears(-1);
			DateTime a_from_datetime = Datetime.newInstance( a_from_date.year(), a_from_date.month(), a_from_date.day(), 0, 0, 0 );
			Account a_account =
				[
					SELECT Id, TorihikisakiBango__c, TelemarketingNG__pc,
					(
						SELECT Id FROM Tasks 
                        WHERE Claim__c = True
                        AND Kijitsu__c >= :a_from_datetime
						LIMIT 1
					),
					(
                        SELECT Id 
                        FROM OkyakusamaAccounts__r
						WHERE ( Hasseibi__c >= :a_from_date OR CreatedDate >= :a_from_datetime ) 
						LIMIT 1
					)
					FROM Account
					WHERE Id = :p_account_id
				]
				.get(0);
			
			Contact a_contact = (Contact)SobjectsExtension.firstOrNull(
				[
					SELECT Id, 
					(
						SELECT Id FROM Tasks 
                        WHERE Claim__c = True
                        AND Kijitsu__c >= :a_from_datetime
						LIMIT 1
					)
					FROM Contact
					WHERE AccountId = :a_account.Id
					LIMIT 1
				]
			);

			if( a_account.TelemarketingNG__pc ) return true;
			Boolean any_account_claims = a_account.Tasks.size() > 0 || a_account.OkyakusamaAccounts__r.size() > 0;
			if( any_account_claims ) return true;
			Boolean any_contact_claims = a_contact.Tasks.size() > 0;
			if( any_contact_claims ) return true;
			return false;
        }
        
    }

    public interface IAnyOther_Checker {
        Boolean is_match(Opportunity p_opp);
    }
    public class AnyOther_Checker implements IAnyOther_Checker{
        public Boolean is_match(Opportunity p_opp){

            if( !new List<String>{'決定','施行完了', '施行待ち','商談クローズ'}.contains(p_opp.StageName) ) { return true; }

            if( p_opp.RecordType.DeveloperName != 'SimpleYasugo' ){ return true; }

            if( String.isBlank( p_opp.Account.Phone ) && String.isBlank( p_opp.Account.MobilePhone__c ) ) { return true; }

            if( p_opp.Utiagebi__c == null ) { return true; }

            return false;
        }
    }
}