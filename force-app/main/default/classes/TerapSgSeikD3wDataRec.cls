public class TerapSgSeikD3wDataRec {

    public static ICsvConverter get_ICsvConverter_instance(){
        return new CsvConverter();
    }
    public interface ICsvConverter{
        String get_csv(List<Record> p_records,Boolean p_to_add_column_header);
    }
    public class CsvConverter implements ICsvConverter{

        public String get_csv(List<Record> p_records,Boolean p_to_add_column_header){
            List<CsvDatas.Row> the_csv_data_rows = new List<CsvDatas.Row>();
            if(p_to_add_column_header){
                the_csv_data_rows.add( 
                    new CsvDatas.Row( new Record().getColumns() ) 
                );
            }
            for(Record a_record : p_records){
                the_csv_data_rows.add( 
                    new CsvDatas.Row( a_record.getValues() ) 
                );
            }
            return new CsvDatas.DataSet(the_csv_data_rows).get_csv_encoded();
        }
    }

    public class Record{
        public String env_key = '';
        public String env_doc_name = '';
        public String env_error = '';
        public String env_error_msg = '';
        public String svc_notify = '';
        public String svc_notify_msg = '';
        public String svc_mail = '';
        public String svc_mail_to_address = '';
        public String svc_gdrive = '';
        public String svc_gdrive_folder = '';
        public String var_seikyusho_no = '';
        public String var_seikyu_nengetsu = '';
        public String var_atena = '';
        public String opro_template = '';
        public String terapseik_hd_issue_date = '';
        public String terapseik_hd_seikyu_no = '';
        public String terapseik_hd_to_name = '';
        public String terapseik_hd_to_addr_zip = '';
        public String terapseik_hd_to_addr_state_city = '';
        public String terapseik_hd_to_addr_street = '';
        public String terapseik_hd_seikyugaku_zeinuki = '';
        public String terapseik_hd_seikyugaku_tax = '';
        public String terapseik_hd_seikyugaku_total = '';
        public String terapseik_hd_furikomi_due_date = '';
        public String terapseik_hd_furikomisaki_bank = '';
        public String terapseik_hd_furikomisaki_branch = '';
        public String terapseik_hd_furikomisaki_koza = '';
        public String terapseik_hd_furikomisaki_meigi = '';
        public String terapseik_hd_biko = '';
        public String terapseik_ln_hinmei = '';
        public String terapseik_ln_quantity = '';
        public String terapseik_ln_unit_price = '';
        public String terapseik_ln_total_price = '';
        public String terapseko_hd_seko_count = '';
        public String terapseko_ln_seko_date = '';
        public String terapseko_ln_hoyo_type = '';
        public String terapseko_ln_seshu = '';
        public String teraptoi_hd_issue_date = '';
        public String teraptoi_hd_to_name = '';
        public String teraptoi_hd_to_addr_zip = '';
        public String teraptoi_hd_to_addr_state_city = '';
        public String teraptoi_hd_to_addr_street = '';
        public String teraptoi_hd_tesuryo_rate_last = '';
        public String teraptoi_hd_tesuryo_rate_next = '';
        public String teraptoi_hd_biko = '';
        public String teraptoi_ln_toiawase_date = '';
        public String teraptoi_ln_hoyo_type = '';
        public String teraptoi_ln_seshu = '';   

        public List<String> getColumns(){
            return new List<String>{
                'env_key',
                'env_doc_name',
                'env_error',
                'env_error_msg',
                'svc_notify',
                'svc_notify_msg',
                'svc_mail',
                'svc_mail_to_address',
                'svc_gdrive',
                'svc_gdrive_folder',
                'var_seikyusho_no',
                'var_seikyu_nengetsu',
                'var_atena',
                'opro_template',
                'terapseik_hd_issue_date',
                'terapseik_hd_seikyu_no',
                'terapseik_hd_to_name',
                'terapseik_hd_to_addr_zip',
                'terapseik_hd_to_addr_state_city',
                'terapseik_hd_to_addr_street',
                'terapseik_hd_seikyugaku_zeinuki',
                'terapseik_hd_seikyugaku_tax',
                'terapseik_hd_seikyugaku_total',
                'terapseik_hd_furikomi_due_date',
                'terapseik_hd_furikomisaki_bank',
                'terapseik_hd_furikomisaki_branch',
                'terapseik_hd_furikomisaki_koza',
                'terapseik_hd_furikomisaki_meigi',
                'terapseik_hd_biko',
                'terapseik_ln_hinmei',
                'terapseik_ln_quantity',
                'terapseik_ln_unit_price',
                'terapseik_ln_total_price',
                'terapseko_hd_seko_count',
                'terapseko_ln_seko_date',
                'terapseko_ln_hoyo_type',
                'terapseko_ln_seshu',
                'teraptoi_hd_issue_date',
                'teraptoi_hd_to_name',
                'teraptoi_hd_to_addr_zip',
                'teraptoi_hd_to_addr_state_city',
                'teraptoi_hd_to_addr_street',
                'teraptoi_hd_tesuryo_rate_last',
                'teraptoi_hd_tesuryo_rate_next',
                'teraptoi_hd_biko',
                'teraptoi_ln_toiawase_date',
                'teraptoi_ln_hoyo_type',
                'teraptoi_ln_seshu'                     
            };
        }
    
        public List<String> getValues(){
            return new List<String>{
                this.env_key,
                this.env_doc_name,
                this.env_error,
                this.env_error_msg,
                this.svc_notify,
                this.svc_notify_msg,
                this.svc_mail,
                this.svc_mail_to_address,
                this.svc_gdrive,
                this.svc_gdrive_folder,
                this.var_seikyusho_no,
                this.var_seikyu_nengetsu,
                this.var_atena,
                this.opro_template,
                this.terapseik_hd_issue_date,
                this.terapseik_hd_seikyu_no,
                this.terapseik_hd_to_name,
                this.terapseik_hd_to_addr_zip,
                this.terapseik_hd_to_addr_state_city,
                this.terapseik_hd_to_addr_street,
                this.terapseik_hd_seikyugaku_zeinuki,
                this.terapseik_hd_seikyugaku_tax,
                this.terapseik_hd_seikyugaku_total,
                this.terapseik_hd_furikomi_due_date,
                this.terapseik_hd_furikomisaki_bank,
                this.terapseik_hd_furikomisaki_branch,
                this.terapseik_hd_furikomisaki_koza,
                this.terapseik_hd_furikomisaki_meigi,
                this.terapseik_hd_biko,
                this.terapseik_ln_hinmei,
                this.terapseik_ln_quantity,
                this.terapseik_ln_unit_price,
                this.terapseik_ln_total_price,
                this.terapseko_hd_seko_count,
                this.terapseko_ln_seko_date,
                this.terapseko_ln_hoyo_type,
                this.terapseko_ln_seshu,
                this.teraptoi_hd_issue_date,
                this.teraptoi_hd_to_name,
                this.teraptoi_hd_to_addr_zip,
                this.teraptoi_hd_to_addr_state_city,
                this.teraptoi_hd_to_addr_street,
                this.teraptoi_hd_tesuryo_rate_last,
                this.teraptoi_hd_tesuryo_rate_next,
                this.teraptoi_hd_biko,
                this.teraptoi_ln_toiawase_date,
                this.teraptoi_ln_hoyo_type,
                this.teraptoi_ln_seshu
            };
        }
    }

}