public class KrYsFreUnSetlDlImp {

    public static IImportJob get_IImportJob_instance(){
        return new ImportJob(
            get_IImporter_instance()
        );
    }
    public static IImporter get_IImporter_instance(){
        return new Importer(
            FreApiDealsGetEx.get_IClient_instance(),
            KrYsFreUnSetlDlImpCln.get_ICleanUpJob_instance()
        );
    }

    public interface IImporter{
        void ImportUnSettledDeal(String p_KrYsFreUnsetlDlId);
    }
    public class Importer implements IImporter{
        private FreApiDealsGetEx.IClient m_ApiClient;
        private KrYsFreUnSetlDlImpCln.ICleanUpJob m_ICleanUpJob;

        public Importer(FreApiDealsGetEx.IClient p_ApiClient, KrYsFreUnSetlDlImpCln.ICleanUpJob p_ICleanUpJob){
            this.m_ApiClient = p_ApiClient;
            this.m_ICleanUpJob = p_ICleanUpJob;
        }

        public void ImportUnSettledDeal(String p_KrYsFreUnsetlDlId){
            try{
                this.importAndSvaUnSettledDeals(p_KrYsFreUnsetlDlId);
                this.m_ICleanUpJob.set_KrYsFreUnsetlDlId_toKeep(p_KrYsFreUnsetlDlId).startAsync();
                UPDATE new KrYsFreUnSetlDlImpJob__c(Id = p_KrYsFreUnsetlDlId, ShoriStatus__c = 'Completed', CompletedDt__c = Datetime.now() );
            }catch(Exception ex){
                UPDATE new KrYsFreUnSetlDlImpJob__c(Id = p_KrYsFreUnsetlDlId, ShoriStatus__c = 'Failed');
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201127-1533', 'KrYsFreUnSetlDlImp.Importer.importAndSvaUnSettledDeals')
                        .setSubjectRecordId(p_KrYsFreUnsetlDlId)
                        .putAttr('ex.getTypeName', ex.getTypeName())
                        .putAttr('ex.getMessage', ex.getMessage())
                        .putAttr('ex.getLineNumber', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString', ex.getStackTraceString())
                );
            }
        }
        private void importAndSvaUnSettledDeals(String p_KrYsFreUnsetlDlId){
            List<FreApiDealsGetEx.Deal> the_deals_unsettled = m_ApiClient.get_unsettled_all();

            List<KrYsFreUnsetlDl__c> the_KrYsFreUnsetlDls = new List<KrYsFreUnsetlDl__c>(); 
            for(FreApiDealsGetEx.Deal a_deal : the_deals_unsettled){
                the_KrYsFreUnsetlDls.add(
                    new KrYsFreUnsetlDl__c(
                        KrYsFreUnSetlDlImpJobRef__c = p_KrYsFreUnsetlDlId,
                        id__c = String.valueOf(a_deal.id),
                        type__c = a_deal.type,
                        status__c = a_deal.status,
                        company_id__c = String.valueOf(a_deal.company_id),
                        ref_number__c = a_deal.ref_number,
                        partner_code__c = a_deal.partner_code,
                        issue_date__c = a_deal.issue_date,
                        amount__c = a_deal.amount,
                        due_date__c = a_deal.due_date,
                        due_amount__c = a_deal.due_amount
                    )
                );
            }
            INSERT the_KrYsFreUnsetlDls;
        }
    }

    public interface IImportJob {
        IImportJob set_KrYsFreUnsetlDlId(String pValue);
        void startAsync();
    }
    public class ImportJob implements IImportJob, Queueable, Database.AllowsCallouts{

        private IImporter m_IImporter;
        private String m_KrYsFreUnsetlDlId;
        public ImportJob(IImporter p_IImporter){
            this.m_IImporter = p_IImporter;
        }

        public IImportJob set_KrYsFreUnsetlDlId(String pValue){
            this.m_KrYsFreUnsetlDlId = pValue; return this;
        }
        public void startAsync(){
            System.enqueueJob(this);
        }
        public void execute(QueueableContext context) {
            this.m_IImporter.ImportUnSettledDeal(this.m_KrYsFreUnsetlDlId);
            KrYsZanSyncBat.start();
        }
    }
}