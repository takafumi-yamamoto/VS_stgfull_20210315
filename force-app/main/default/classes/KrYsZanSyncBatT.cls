@isTest
public class KrYsZanSyncBatT {
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
    
    @isTest public static void start(){
        beginSetUp();
        Map<String, KrYsYosin__c> theKrYsYosins = new Map<String, KrYsYosin__c>{
            '与信状況-1' => new KrYsYosin__c()
        };
        INSERT theKrYsYosins.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_',
                KrYsYosinRef__c = theKrYsYosins.get('与信状況-1').Id,
                KeiriTorihikiSakiName__c = 'Partner-Code-For-Test'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, KrYsFreUnSetlDlImpJob__c> theKrYsFreUnSetlDlImpJobs = new Map<String, KrYsFreUnSetlDlImpJob__c>{
            '残明細取得ジョブ-1' => new KrYsFreUnSetlDlImpJob__c( 
                ShoriStatus__c = 'Completed', 
                CompletedDt__c = Datetime.newInstance(2020,1,1,0,0,0)
            )
        };
        INSERT theKrYsFreUnSetlDlImpJobs.values();

        Map<String, KrYsFreUnsetlDl__c> theKrYsFreUnsetlDls = new Map<String, KrYsFreUnsetlDl__c>{
            '残明細-1' => new KrYsFreUnsetlDl__c(
                KrYsFreUnSetlDlImpJobRef__c = theKrYsFreUnSetlDlImpJobs.get('残明細取得ジョブ-1').Id,
                partner_code__c = theAccounts.get('葬儀社-1').KeiriTorihikiSakiName__c,
                due_amount__c = 10000
            )
        };
        INSERT theKrYsFreUnsetlDls.values();
        endSetUp();

        Test.startTest();
        KrYsZanSyncBat.start();
        Test.stopTest();
    }
}