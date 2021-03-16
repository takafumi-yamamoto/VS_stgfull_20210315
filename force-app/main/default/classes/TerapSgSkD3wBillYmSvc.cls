public without sharing class TerapSgSkD3wBillYmSvc {

    @TestVisible
    private static TerapSgSkD3wConf.IProvider m_conf_provider = TerapSgSkD3wConf.get_IProvider_instance();

    @TestVisible
    private static ITaskCreator m_ITaskCreator_instance = new TaskCreator(
        m_conf_provider.getConfig().d3w_work_name,
        TerapSgSeikD3wData.get_ICsvProvider_instance(),
        D3wTaskCreator.get_ITaskCreator_instance()
    );

    public class create_d3w_task_req{
        @AuraEnabled public String bill_ym {get; set;}
        @AuraEnabled public Boolean is_preview_mode {get; set;} 
    }
    public class create_d3w_task_res{
        @AuraEnabled public Boolean is_success {get; set;} 
        public create_d3w_task_res set_is_success(Boolean p_value){ this.is_success = p_value; return this; }
        @AuraEnabled public String d3w_task_id {get; set;}
        public create_d3w_task_res set_d3w_task_id(String p_value){ this.d3w_task_id = p_value; return this; }
        @AuraEnabled public String err_msg {get; set;}
        public create_d3w_task_res set_err_msg(String p_value){ this.err_msg = p_value; return this; }
    }

    @AuraEnabled
    public static create_d3w_task_res create_d3w_task(create_d3w_task_req p_req){

        try{
            return m_ITaskCreator_instance.create_d3w_task(p_req);
        }catch(Exception ex){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20210224-1656', 'TerapSgSkD3wBillYmSvc.create_d3w_task')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString', ex.getStackTraceString())
	        );
            return new create_d3w_task_res()
            .set_is_success(false)
            ;
        }
        
    }
    public interface ITaskCreator {
        create_d3w_task_res create_d3w_task(create_d3w_task_req p_req);
    }
    public class TaskCreator implements ITaskCreator{
        private String m_d3w_work_name;
        private TerapSgSeikD3wData.ICsvProvider m_ICsvProvider;
        private D3wTaskCreator.ITaskCreator m_D3wTaskCreator_ITaskCreator;
        public TaskCreator(
            String p_d3w_work_name,
            TerapSgSeikD3wData.ICsvProvider p_ICsvProvider,
            D3wTaskCreator.ITaskCreator p_D3wTaskCreator_ITaskCreator
        ){
            this.m_d3w_work_name = p_d3w_work_name;
            this.m_ICsvProvider = p_ICsvProvider;
            this.m_D3wTaskCreator_ITaskCreator = p_D3wTaskCreator_ITaskCreator;
        }

        public create_d3w_task_res create_d3w_task(create_d3w_task_req p_req){

            Date a_bill_ym = null;
            try{
                a_bill_ym = Date.valueOf( p_req.bill_ym + '-01' ) ;
            }catch(Exception ex){
                return new create_d3w_task_res()
                    .set_is_success(false)
                    .set_err_msg('年月不正;')
                ;
            }
    
            Date a_date_from = a_bill_ym.toStartOfMonth();
            Date a_date_to =a_bill_ym.addMonths(1).toStartOfMonth().addDays(-1);
            List<String> the_TerapSgSeik_ids = new List<String>();
            for(TerapSgSeik__c a_TerapSgSeik : [
                SELECT Id
                FROM TerapSgSeik__c
                WHERE BillingTargetYearMonth__c >= :a_date_from 
                AND BillingTargetYearMonth__c <= :a_date_to
                AND DocStatus__c = 'Closed'
            ]){
                the_TerapSgSeik_ids.add(a_TerapSgSeik.Id);
            }

            if( the_TerapSgSeik_ids.size() == 0 ){
                return new create_d3w_task_res()
                    .set_is_success(false)
                    .set_err_msg('対象データなし;')
                    ;
            }
 
            Boolean a_dont_send_any = p_req.is_preview_mode;
            String a_task_id = 
                this.m_D3wTaskCreator_ITaskCreator.insert_task(
                    this.m_d3w_work_name, 
                    this.m_ICsvProvider.get_csv_data_by_TerapSgSeik_ids(the_TerapSgSeik_ids, a_dont_send_any)
                );

            return new create_d3w_task_res()
                .set_is_success(true)
                .set_d3w_task_id(a_task_id)
            ;
        }
    }

}