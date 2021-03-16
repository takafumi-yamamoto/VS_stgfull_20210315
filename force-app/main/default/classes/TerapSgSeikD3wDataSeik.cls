public class TerapSgSeikD3wDataSeik {
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
            String a_template_name = 'live_terapseik';
            Integer a_line_count = 0;
            List<TerapSgSeikD3wDataRec.Record> the_records = new List<TerapSgSeikD3wDataRec.Record>();
            for(TerapSgSeikLine__c a_line : p_TerapSgSeik.TerapSgSeikLines__r){
                a_line_count ++;
                TerapSgSeikD3wDataRec.Record a_record = new TerapSgSeikD3wDataRec.Record();
                a_record.opro_template = a_template_name;
                
                if( a_line_count == 1 ){
                    a_record.terapseik_hd_issue_date = m_IToday.Date().format();
                    a_record.terapseik_hd_seikyu_no = p_TerapSgSeik.Name;
                    a_record.terapseik_hd_to_name = p_TerapSgSeik.ToName__c;
                    a_record.terapseik_hd_to_addr_zip = p_TerapSgSeik.ToAddrZipCode__c;
                    a_record.terapseik_hd_to_addr_state_city = 
                        this.null_to_blank(p_TerapSgSeik.ToAddrState__c)
                        +
                        this.null_to_blank(p_TerapSgSeik.City__c);
                        
                    a_record.terapseik_hd_to_addr_street = p_TerapSgSeik.Street__c;
                    a_record.terapseik_hd_seikyugaku_zeinuki = '\\'+ p_TerapSgSeik.ZeinukiKingaku__c.format();
                    a_record.terapseik_hd_seikyugaku_tax = '\\'+ p_TerapSgSeik.Tax__c.format();
                    a_record.terapseik_hd_seikyugaku_total = '\\'+ p_TerapSgSeik.ZeikomiKingaku__c.format();
                    a_record.terapseik_hd_furikomi_due_date = p_TerapSgSeik.ShiharaiKijitsu__c.format();
                    a_record.terapseik_hd_furikomisaki_bank = 
                        this.null_to_blank(p_TerapSgSeik.FriKzGinkoName__c)
                        + '('
                        + this.null_to_blank(p_TerapSgSeik.FriKzGinkoCode__c)
                        + ')'
                        ;
                    a_record.terapseik_hd_furikomisaki_branch = 
                        this.null_to_blank(p_TerapSgSeik.FriKzShitenName__c)
                        + '('
                        + this.null_to_blank(p_TerapSgSeik.FriKzShitenCode__c)
                        + ')'
                        ;
                    a_record.terapseik_hd_furikomisaki_koza = 
                        this.null_to_blank(p_TerapSgSeik.FriKzKouzaType__c)
                        + ' '
                        + this.null_to_blank(p_TerapSgSeik.FriKzKouzaBango__c)
                        ;
                    a_record.terapseik_hd_furikomisaki_meigi = p_TerapSgSeik.FriKzMeigiName__c;
                    a_record.terapseik_hd_biko = p_TerapSgSeik.Biko__c;
                }

                a_record.terapseik_ln_hinmei = a_line.Descr__c;
                a_record.terapseik_ln_quantity = a_line.Quantity__c.format();
                a_record.terapseik_ln_unit_price = '\\'+ a_line.UnitPrice__c.format();
                a_record.terapseik_ln_total_price = '\\'+ a_line.Price__c.format();

                the_records.add(a_record);
            }
            return the_records;
        }

        private String null_to_blank(String p_value){
            return p_value == null ? '' : p_value;
        }
        
    }
}