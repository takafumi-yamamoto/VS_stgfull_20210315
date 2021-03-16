@isTest
public class KrYsFreUnSetlDlImpT {

    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
    }
    
    public class FreApiDealsGetEx_IClient_Stub implements FreApiDealsGetEx.IClient{
        public List<FreApiDealsGetEx.Deal> sendRequest(FreApiDealsGetEx.Request pReq){return new List<FreApiDealsGetEx.Deal>();}
        public List<FreApiDealsGetEx.Deal> get_unsettled_all(){
            List<FreApiDealsGetEx.Deal> the_deals = new List<FreApiDealsGetEx.Deal>{
                new FreApiDealsGetEx.Deal()
            };
            return the_deals;
        }
    }
    public class KrYsFreUnSetlDlImpCln_ICleanUpJob_Stub implements KrYsFreUnSetlDlImpCln.ICleanUpJob{
        public KrYsFreUnSetlDlImpCln.ICleanUpJob set_KrYsFreUnsetlDlId_toKeep(String pVallue){ return this; }
        public void startAsync(){return;}
    }

    public class KrYsZanSyncBat_IRunner_Stub implements KrYsZanSyncBat.IRunner{
        public void run(List<Account> pRecords){return;}
    }
    @isTest public static void Importer_ImportUnSettledDeal(){
        beginSetUp();
        KrYsFreUnSetlDlImpJob__c aJob = new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created');
        INSERT aJob;
        endSetUp();
        
        Test.startTest();
        new KrYsFreUnSetlDlImp.Importer(
            new FreApiDealsGetEx_IClient_Stub(),
            new KrYsFreUnSetlDlImpCln_ICleanUpJob_Stub()
        )
        .ImportUnSettledDeal(aJob.Id);
        Test.stopTest();

    }

    public class KrYsFreUnSetlDlImp_IImporter_Stub implements KrYsFreUnSetlDlImp.IImporter{
        public void ImportUnSettledDeal(String p_KrYsFreUnsetlDlId){ return; }
    }
    @isTest public static void ImportJob_startAsync(){
        beginSetUp();
        KrYsFreUnSetlDlImpJob__c aJob = new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created');
        INSERT aJob;
        KrYsZanSyncBat.IRunner_instance = new KrYsZanSyncBat_IRunner_Stub();
        endSetUp();

        Test.startTest();
        new KrYsFreUnSetlDlImp.ImportJob(
            new KrYsFreUnSetlDlImp_IImporter_Stub()
        )
        .set_KrYsFreUnsetlDlId(aJob.Id)
        .startAsync();
        Test.stopTest();
    }

    @isTest public static void get_IImportJob_instance(){
        Test.startTest();
        KrYsFreUnSetlDlImp.get_IImportJob_instance();
        Test.stopTest();
    }

    @isTest public static void get_IImporter_instance(){
        Test.startTest();
        KrYsFreUnSetlDlImp.get_IImporter_instance();
        Test.stopTest();
    }
}