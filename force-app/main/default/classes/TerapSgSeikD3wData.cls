public class TerapSgSeikD3wData {

    public static ICsvProvider get_ICsvProvider_instance(){
        return new CsvProvider(
            TerapSgSeikD3wDataSelect.get_ISelector_instance(),
            get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataRec.get_ICsvConverter_instance()
        );
    }
    public static IRecordGenerator get_IRecordGenerator_instance(){
        return new RecordGenerator(
            TerapSgSeikD3wDataEnv.get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataSeik.get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataSeko.get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataToi.get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataNotf.get_IRecordGenerator_instance(),
            TerapSgSeikD3wDataErr.get_IValidator_instance()
        );
    }

    public interface ICsvProvider{
        String get_csv_data_by_TerapSgSeik_ids(List<String> p_TerapSgSeik_ids, Boolean p_dont_send_any);
    }
    public class CsvProvider implements ICsvProvider{
        private TerapSgSeikD3wDataSelect.ISelector m_ISelector;
        private IRecordGenerator m_IRecordGenerator;
        private TerapSgSeikD3wDataRec.ICsvConverter m_ICsvConverter;
        public CsvProvider(
            TerapSgSeikD3wDataSelect.ISelector p_ISelector,
            IRecordGenerator p_IRecordGenerator,
            TerapSgSeikD3wDataRec.ICsvConverter p_ICsvConverter
        ){
            this.m_ISelector = p_ISelector;
            this.m_IRecordGenerator = p_IRecordGenerator;
            this.m_ICsvConverter = p_ICsvConverter;
        }

        public String get_csv_data_by_TerapSgSeik_ids(List<String> p_TerapSgSeik_ids, Boolean p_dont_send_any){
            Boolean to_add_column_header = true;

            return this.m_ICsvConverter.get_csv(
                this.m_IRecordGenerator.generate_records(
                    this.m_ISelector.select_by_TerapSgSeik_ids( p_TerapSgSeik_ids ), 
                    p_dont_send_any
                ), 
                to_add_column_header
            );
        }
    }

    public interface IRecordGenerator {
        List<TerapSgSeikD3wDataRec.Record> generate_records(List<TerapSgSeik__c> p_TerapSgSeiks, Boolean p_dont_send_any);
    }
    public class RecordGenerator implements IRecordGenerator{

        private TerapSgSeikD3wDataEnv.IRecordGenerator m_envelope_IRecordGenerator;
        private TerapSgSeikD3wDataSeik.IRecordGenerator m_seikyu_IRecordGenerator;
        private TerapSgSeikD3wDataSeko.IRecordGenerator m_seko_IRecordGenerator;
        private TerapSgSeikD3wDataToi.IRecordGenerator m_toiawase_IRecordGenerator;
        private TerapSgSeikD3wDataNotf.IRecordGenerator m_notify_IRecordGenerator;
        private TerapSgSeikD3wDataErr.IValidator m_IValidator;
        public RecordGenerator(
            TerapSgSeikD3wDataEnv.IRecordGenerator p_envelope_IRecordGenerator,
            TerapSgSeikD3wDataSeik.IRecordGenerator p_seikyu_IRecordGenerator,
            TerapSgSeikD3wDataSeko.IRecordGenerator p_seko_IRecordGenerator,
            TerapSgSeikD3wDataToi.IRecordGenerator p_toiawase_IRecordGenerator,
            TerapSgSeikD3wDataNotf.IRecordGenerator p_notify_IRecordGenerator,
            TerapSgSeikD3wDataErr.IValidator p_IValidator
        ){
            this.m_envelope_IRecordGenerator = p_envelope_IRecordGenerator;
            this.m_seikyu_IRecordGenerator = p_seikyu_IRecordGenerator;
            this.m_seko_IRecordGenerator = p_seko_IRecordGenerator;
            this.m_toiawase_IRecordGenerator = p_toiawase_IRecordGenerator;
            this.m_notify_IRecordGenerator = p_notify_IRecordGenerator;
            this.m_IValidator = p_IValidator;
        }

        public List<TerapSgSeikD3wDataRec.Record> generate_records(List<TerapSgSeik__c> p_TerapSgSeiks, Boolean p_dont_send_any){
            List<TerapSgSeikD3wDataRec.Record> the_records = new List<TerapSgSeikD3wDataRec.Record>();
            for(TerapSgSeik__c a_TerapSgSeik : p_TerapSgSeiks){
                try{
                    the_records.addAll( this.generate_records(a_TerapSgSeik, p_dont_send_any) );
                }catch(Exception ex){
                    Loggings.writeLog(
                        Loggings.createLogEntry(
                            Loggings.Level.Error, '20210225-1818', 'TerapSgSeikD3wData.RecordGenerator.generate_records')
                            .setSubjectRecordId(a_TerapSgSeik.Id)
                            .putAttr('ex.getTypeName()', ex.getTypeName() )
                            .putAttr('ex.getMessage()', ex.getMessage())
                            .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                            .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                    );
                    throw ex;
                }
                
            }

            if(the_records.size() > 0){
                the_records.add(
                    this.m_notify_IRecordGenerator.generate_record(p_dont_send_any)
                );
            }

            return the_records;
        }

        private List<TerapSgSeikD3wDataRec.Record> generate_records(TerapSgSeik__c p_TerapSgSeik, Boolean p_dont_send_any){
            List<TerapSgSeikD3wDataRec.Record> the_records = new List<TerapSgSeikD3wDataRec.Record>();

            TerapSgSeikD3wDataRec.Record a_error_record = 
                this.m_IValidator.generate_record_if_any_error(p_TerapSgSeik);

            if(a_error_record != null){
                the_records.add(a_error_record);
                return the_records;
            }

            List<TerapSgSeikD3wDataRec.Record> records_for_template = new List<TerapSgSeikD3wDataRec.Record>();
            if( p_TerapSgSeik.ZeikomiKingaku__c > 0 ){
                records_for_template.addAll( this.m_seikyu_IRecordGenerator.generate_records(p_TerapSgSeik) );
                records_for_template.addAll( this.m_seko_IRecordGenerator.generate_records(p_TerapSgSeik) );
            }
            records_for_template.addAll( this.m_toiawase_IRecordGenerator.generate_records(p_TerapSgSeik) );

            if( records_for_template.size() == 0 ){ return the_records; }

            TerapSgSeikD3wDataRec.Record a_heaer_recoed = 
                this.m_envelope_IRecordGenerator.generate_record(p_TerapSgSeik, p_dont_send_any);
            this.m_envelope_IRecordGenerator.copy_envelope_field_values(a_heaer_recoed, records_for_template);

            the_records.add(a_heaer_recoed);
            the_records.addAll(records_for_template);

            return the_records;
        }

    }

}