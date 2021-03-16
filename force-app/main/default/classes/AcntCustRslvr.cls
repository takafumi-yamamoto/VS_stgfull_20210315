public class AcntCustRslvr {

    public static IAccountRelver get_IAccountRelver_instance(){
        return new AccountRelver();
    }

    public class Req{
        public String first_name;
        public Req set_first_name(String pValue){ this.first_name = pValue; return this; }
        public String last_name;
        public Req set_last_name(String pValue){ this.last_name = pValue; return this; }
        public String first_name_kana;
        public Req set_first_name_kana(String pValue){ this.first_name_kana = pValue; return this; }
        public String last_name_kana;
        public Req set_last_name_kana(String pValue){ this.last_name_kana = pValue; return this; }
        public String email;
        public Req set_email(String pValue){ this.email = pValue; return this; }
        public String mobile;
        public Req set_mobile(String pValue){ this.mobile = pValue; return this; }
        public String phone;
        public Req set_phone(String pValue){ this.phone = pValue; return this; }
        public String postal_code;
        public Req set_postal_code(String pValue){ this.postal_code = pValue; return this; }
        public String state;
        public Req set_state(String pValue){ this.state = pValue; return this; }
        public String city;
        public Req set_city(String pValue){ this.city = pValue; return this; }
        public String street;
        public Req set_street(String pValue){ this.street = pValue; return this; }
    }

    public class Result{
        public ResultTypes result_type = ResultTypes.UnKnown;
        public String account_id = null;
    }
    public enum ResultTypes { UnKnown, Inserted, AlreadyExists }

    public interface IAccountRelver {
        Result try_insert(Req p_req);
    }

    @TestVisible
    private class AccountRelver implements IAccountRelver{
        public Result try_insert(Req p_req){
            try{
                return this.run_try_insert(p_req);
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Warn, '20200918-1730', 'AcntCustRslvr.AccountRelver.try_insert')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                    .putAttr('JSON.serialize(p_req)', p_req == null ? '' : JSON.serialize(p_req) )
                );
                throw ex;
            }
        }

        private Result run_try_insert(Req p_req){
            Result the_result = new Result();

            Account the_account_to_be_inserted = new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = p_req.first_name, 
                FirstNameFurigana__pc = p_req.first_name_kana,
                LastName = p_req.last_name,
                LastNameFurigana__pc = p_req.last_name_kana,
                BillingPostalCode = p_req.postal_code,
                BillingState = p_req.state,
                BillingCity = p_req.city,
                BillingStreet = p_req.street,
                MailAddress__c = p_req.email,
                MobilePhone__c = p_req.mobile,
                Phone = p_req.phone
            );

            Database.SaveResult the_save_result_of_insert = Database.insert(the_account_to_be_inserted, false);

            if( the_save_result_of_insert.isSuccess() ){
                the_result.result_type = ResultTypes.Inserted;
                the_result.account_id = the_save_result_of_insert.getId();
            }else{
                the_result.result_type = ResultTypes.AlreadyExists;
                the_result.account_id = this.inspect_save_result_for_match_account(the_save_result_of_insert);
            }

            return the_result;
        }

        private String inspect_save_result_for_match_account(Database.SaveResult p_save_result){
            String the_account_id_resolved = null;
    
            for(Database.Error a_error : p_save_result.getErrors()){
    
                if( !(a_error instanceof Database.DuplicateError) ) throw new Exceptions.AnException( a_error.getMessage() );
    
                Datacloud.DuplicateResult a_duplicate_result = ((Database.DuplicateError)a_error).getDuplicateResult();
    
                for(Datacloud.MatchResult a_match_result : a_duplicate_result.getMatchResults()) {
    
                    for(Datacloud.MatchRecord a_match_record : a_match_result.getMatchRecords()) {
                        the_account_id_resolved = a_match_record.getRecord().Id;
                    }
                }
            }
    
            return the_account_id_resolved;
        }
    }


}