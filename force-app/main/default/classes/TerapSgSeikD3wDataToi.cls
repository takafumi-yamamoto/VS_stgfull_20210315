public class TerapSgSeikD3wDataToi {

    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator( new Todays.Today() );
    }

    public interface IRecordGenerator {
        List<TerapSgSeikD3wDataRec.Record> generate_records(TerapSgSeik__c p_TerapSgSeik);
    }
    public class RecordGenerator implements IRecordGenerator{
        private Todays.IToday m_IToday;
        public RecordGenerator(Todays.IToday p_IToday){
            this.m_IToday = p_IToday;
        }

        public List<TerapSgSeikD3wDataRec.Record> generate_records(TerapSgSeik__c p_TerapSgSeik){
            String a_template_name = 'live_teraptoi';
            Integer a_line_count = 0;
            List<TerapSgSeikD3wDataRec.Record> the_records = new List<TerapSgSeikD3wDataRec.Record>();
            for(TerapSgSeikCallLine__c a_line : p_TerapSgSeik.TerapSgSeikCallLines__r){
                a_line_count ++;
                TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
                a_record.opro_template = a_template_name;
                
                if( a_line_count == 1 ){
                    a_record.teraptoi_hd_issue_date = m_IToday.Date().format();
                    a_record.teraptoi_hd_to_name = p_TerapSgSeik.ToName__c;
                    a_record.teraptoi_hd_to_addr_zip = p_TerapSgSeik.ToAddrZipCode__c;
                    a_record.teraptoi_hd_to_addr_state_city =        
                        this.null_to_blank(p_TerapSgSeik.ToAddrState__c)
                        +
                        this.null_to_blank(p_TerapSgSeik.City__c)
                        ;
                    a_record.teraptoi_hd_to_addr_street = p_TerapSgSeik.Street__c;
                    a_record.teraptoi_hd_tesuryo_rate_last = 
                        String.format('{0}月の手数料率：{1}%', new List<String>{
                            String.valueOf( p_TerapSgSeik.BillingTargetYearMonth__c.month() ),
                            String.valueOf(p_TerapSgSeik.TesuryoRate__c)
                        })
                        ;
                    a_record.teraptoi_hd_tesuryo_rate_next = 
                        String.format('{0}月の手数料率：{1}%', new List<String>{
                            String.valueOf( p_TerapSgSeik.BillingTargetYearMonth__c.addMonths(1).month() ),
                            p_TerapSgSeik.TesuryoRateNextMonth__c == null ? '-' : String.valueOf(p_TerapSgSeik.TesuryoRateNextMonth__c)
                        })
                        ;
                } 

                a_record.teraptoi_ln_toiawase_date = a_line.ToiawaseDate__c.format();
                a_record.teraptoi_ln_hoyo_type = a_line.HoyoShubetsu__c;
                a_record.teraptoi_ln_seshu = a_line.Seshu__c;

                the_records.add(a_record);
            }
            return the_records;
        }

        private String null_to_blank(String p_value){
            return p_value == null ? '' : p_value;
        }
    }
}