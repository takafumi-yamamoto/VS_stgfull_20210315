public class TerapSgSeikD3wDataErr {
    public static IValidator get_IValidator_instance(){
        return new Validator(
            get_IRecordGenerator_instance()
        );
    }
    
    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator();
    }

    public interface IValidator {
        TerapSgSeikD3wDataRec.Record generate_record_if_any_error(TerapSgSeik__c p_TerapSgSeik);
    }
    public class Validator implements IValidator{
        private IRecordGenerator m_IRecordGenerator;
        public Validator(IRecordGenerator p_IRecordGenerator){
            this.m_IRecordGenerator = p_IRecordGenerator;
        }

        public TerapSgSeikD3wDataRec.Record generate_record_if_any_error(TerapSgSeik__c p_TerapSgSeik){
            List<String> the_err_messages = this.validate(p_TerapSgSeik);
            if(the_err_messages.size() > 0){
                return this.m_IRecordGenerator.generate_record(p_TerapSgSeik, the_err_messages.get(0) );
            }
            return null;
        }

        private List<String> validate(TerapSgSeik__c p_TerapSgSeik){
            List<String> the_err_messages = new List<String>();
            if( String.isBlank(p_TerapSgSeik.EmailExp__c) ){
                the_err_messages.add('宛先メールアドレス不正');
            }
            return the_err_messages;
        }
    }

    public interface IRecordGenerator {
        TerapSgSeikD3wDataRec.Record generate_record(TerapSgSeik__c p_TerapSgSeik, String p_err_message);
    }
    public class RecordGenerator implements IRecordGenerator{
        public TerapSgSeikD3wDataRec.Record generate_record(TerapSgSeik__c p_TerapSgSeik, String p_err_message){
            TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
            a_record.env_key = GuidUtil.NewGuid();
            a_record.env_error = 'yes';
            a_record.env_error_msg = p_err_message;
            a_record.svc_notify = 'no';
            a_record.svc_mail = 'no';
            a_record.svc_gdrive = 'no';

            a_record.var_seikyusho_no = p_TerapSgSeik.Name;

            return a_record;
        }
    }
}