public class TerapSgSeikD3wDataNotf {
    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator();
    }

    public interface IRecordGenerator {
        TerapSgSeikD3wDataRec.Record generate_record(Boolean p_dont_send_any);
    }
    public class RecordGenerator implements IRecordGenerator{
        public TerapSgSeikD3wDataRec.Record generate_record(Boolean p_dont_send_any){
            TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
            a_record.env_key = GuidUtil.NewGuid();
            a_record.env_error = 'no';
            a_record.svc_notify = 'yes';

            a_record.svc_notify_msg = '';
            a_record.svc_notify_msg  += '処理を実行しました。';
            if(p_dont_send_any){
                a_record.svc_notify_msg += '\n';
                a_record.svc_notify_msg += '※previewモードで実行したため、送信はされません。';
            }

            a_record.svc_mail = 'no';
            a_record.svc_gdrive = 'no';
            return a_record;
        }
    }
}