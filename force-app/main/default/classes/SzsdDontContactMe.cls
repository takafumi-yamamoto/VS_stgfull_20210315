public class SzsdDontContactMe {

    public static IDontContactMe_Judger get_IDontContactMe_Judger_instance(){
        return new DontContactMe_Judger(
            new Todays.Today()
        );
    }
    public interface IDontContactMe_Judger{
        Boolean is_dont_contact_me(String p_account_id);
    }
	public class DontContactMe_Judger implements IDontContactMe_Judger{

        private Todays.IToday m_IToday;
        public DontContactMe_Judger(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }

		public Boolean is_dont_contact_me(String p_account_id){
            Date a_from_date = m_IToday.Date().addYears(-1);
			DateTime a_from_datetime = Datetime.newInstance( a_from_date.year(), a_from_date.month(), a_from_date.day(), 0, 0, 0 );
			Account a_account =
				[
					SELECT Id, TorihikisakiBango__c, 
					KoukokuSmsNg__c, KoukokuDmNg__c, KaihoshiNG__c, TelemarketingNG__pc,
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
    
}