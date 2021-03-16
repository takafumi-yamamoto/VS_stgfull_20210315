public class TerapSgSeikD3wDataSeko {
    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator();
    }

    public interface IRecordGenerator {
        List<TerapSgSeikD3wDataRec.Record> generate_records(TerapSgSeik__c p_TerapSgSeik);
    }

    public class RecordGenerator implements IRecordGenerator{
        public List<TerapSgSeikD3wDataRec.Record> generate_records(TerapSgSeik__c p_TerapSgSeik){
            String a_template_name = 'live_terapseko';
            Integer a_line_count = 0;
            List<TerapSgSeikD3wDataRec.Record> the_records = new List<TerapSgSeikD3wDataRec.Record>();
            for(TerapSgSeikSekoLine__c a_line : p_TerapSgSeik.TerapSgSeikSekoLine__r){
                a_line_count ++;
                TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
                a_record.opro_template = a_template_name;
                
                if( a_line_count == 1 ){
                    a_record.terapseko_hd_seko_count = 
                        '施行明細件数：' + String.valueOf(p_TerapSgSeik.TerapSgSeikLines__r.size()) + '件';
                } 

                a_record.terapseko_ln_seko_date = a_line.SekoDate__c.format();
                a_record.terapseko_ln_hoyo_type = a_line.HoyoShubetsu__c;
                a_record.terapseko_ln_seshu = a_line.Seshu__c;

                the_records.add(a_record);
            }
            return the_records;
        }
    }
}