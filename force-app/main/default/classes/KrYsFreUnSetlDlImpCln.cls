public class KrYsFreUnSetlDlImpCln {

    @TestVisible
    private static Boolean i_will_raise_error_for_test_coverage = false;

    public static ICleanUpJob get_ICleanUpJob_instance(){
        return new CleanUpJob();
    }
    public interface ICleanUpJob{
        ICleanUpJob set_KrYsFreUnsetlDlId_toKeep(String pVallue);
        void startAsync();
    }
    public class CleanUpJob implements ICleanUpJob, Queueable{
        private String m_KrYsFreUnsetlDlId_toKeep;

        public ICleanUpJob set_KrYsFreUnsetlDlId_toKeep(String pVallue){ 
            this.m_KrYsFreUnsetlDlId_toKeep = pVallue; return this; 
        }
        public void cleanUp(String p_KrYsFreUnsetlDlId_toKeep){
            Set<String> job_ids_to_delete = new Set<String>();

            for(KrYsFreUnSetlDlImpJob__c aJob : 
                [
                    SELECT Id FROM KrYsFreUnSetlDlImpJob__c
                    WHERE Id != :p_KrYsFreUnsetlDlId_toKeep
                    AND CompletedDt__c = NULL
                    LIMIT 10
                ]
            ){
                job_ids_to_delete.add(aJob.Id);
            }

            Integer a_counter = 0;
            for(KrYsFreUnSetlDlImpJob__c aJob : 
                [
                    SELECT Id FROM KrYsFreUnSetlDlImpJob__c
                    WHERE Id != :p_KrYsFreUnsetlDlId_toKeep
                    AND CompletedDt__c != NULL
                    ORDER BY CompletedDt__c ASC
                    LIMIT 10
                ]
            ){
                a_counter++;
                if( a_counter > 2 ){
                    job_ids_to_delete.add(aJob.Id);
                }
            }

            DELETE [SELECT Id FROM KrYsFreUnsetlDl__c WHERE KrYsFreUnSetlDlImpJobRef__c IN : job_ids_to_delete];
            DELETE [SELECT Id FROM KrYsFreUnSetlDlImpJob__c WHERE Id IN : job_ids_to_delete];
        }

        public void startAsync(){
            System.enqueueJob(this);
        }
        public void execute(QueueableContext context) {
            try{
                this.cleanUp(this.m_KrYsFreUnsetlDlId_toKeep);
                if(i_will_raise_error_for_test_coverage) throw new Exceptions.AnException();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201127-1730', 'KrYsFreUnSetlDlImp.CleanUpJob.execute')
                        .setSubjectRecordId(null)
                        .putAttr('ex.getTypeName', ex.getTypeName())
                        .putAttr('ex.getMessage', ex.getMessage())
                        .putAttr('ex.getLineNumber', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                        .putAttr('this.m_KrYsFreUnsetlDlId_toKeep', this.m_KrYsFreUnsetlDlId_toKeep)
                );
            }
        }
    }
}