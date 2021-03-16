public class TerapSgSeikD3wDataEnv {
    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator();
    }

    public interface IRecordGenerator {
        TerapSgSeikD3wDataRec.Record generate_record(TerapSgSeik__c p_TerapSgSeik, Boolean p_dont_send_any);
        void copy_envelope_field_values(
            TerapSgSeikD3wDataRec.Record p_header_record, 
            List<TerapSgSeikD3wDataRec.Record> p_line_records
        );
    }
    public class RecordGenerator implements IRecordGenerator{
        public TerapSgSeikD3wDataRec.Record generate_record(TerapSgSeik__c p_TerapSgSeik, Boolean p_dont_send_any){
            TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
            a_record.env_key = GuidUtil.NewGuid();
            a_record.env_doc_name = 
                String.format('{0}_{1}', new List<String>{ p_TerapSgSeik.ToName__c, p_TerapSgSeik.ToTorihikiSakiBango__c })
                .replace('.','_')
                ;
            a_record.env_error = 'no';
            a_record.svc_notify = 'no';
            a_record.svc_mail = p_dont_send_any ? 'no' : 'yes';
            a_record.svc_mail_to_address = p_TerapSgSeik.EmailExp__c;
            a_record.svc_gdrive = 'yes';
            a_record.svc_gdrive_folder = 
                Datetime.newInstance(
                    p_TerapSgSeik.BillingTargetYearMonth__c.year(), 
                    p_TerapSgSeik.BillingTargetYearMonth__c.month(), 
                    p_TerapSgSeik.BillingTargetYearMonth__c.day() 
                )
                .format('yyyyMMdd')
                ;
            a_record.var_seikyusho_no = p_TerapSgSeik.Name;
            a_record.var_seikyu_nengetsu = 
                Datetime.newInstance(
                    p_TerapSgSeik.BillingTargetYearMonth__c.year(), 
                    p_TerapSgSeik.BillingTargetYearMonth__c.month(), 
                    p_TerapSgSeik.BillingTargetYearMonth__c.day() 
                )
                .format('yyyy年M月')
                ;
            a_record.var_atena = p_TerapSgSeik.ToName__c;
            return a_record;
        }

        public void copy_envelope_field_values(
            TerapSgSeikD3wDataRec.Record p_header_record, 
            List<TerapSgSeikD3wDataRec.Record> p_line_records
        ){
            for( TerapSgSeikD3wDataRec.Record a_line_record : p_line_records){
                a_line_record.env_key = p_header_record.env_key;
                a_line_record.env_doc_name = p_header_record.env_doc_name;
                a_line_record.env_error = p_header_record.env_error;
                a_line_record.svc_notify = p_header_record.svc_notify;
                a_line_record.svc_mail = p_header_record.svc_mail;
                a_line_record.svc_gdrive = p_header_record.svc_gdrive;
            }
        }
    }
}