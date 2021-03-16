@isTest
public class KrYsFreUnSetlDlImpClnT {

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
    @isTest public static void CleanUpJob_startAsync() {
        beginSetUp();
        List<KrYsFreUnSetlDlImpJob__c> the_jobs = new List<KrYsFreUnSetlDlImpJob__c>{
            new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created', CompletedDt__c = Datetime.newInstance(2020,1,1,12,0,0) ),
            new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created', CompletedDt__c = Datetime.newInstance(2020,1,1,12,0,0) ),
            new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created', CompletedDt__c = Datetime.newInstance(2020,1,1,12,0,0) ),
            new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Created', CompletedDt__c = Datetime.newInstance(2020,1,1,12,0,0) ),
            new KrYsFreUnSetlDlImpJob__c(ShoriStatus__c = 'Failed')
        };
        INSERT the_jobs;
        endSetUp();
        Test.startTest();
        new KrYsFreUnSetlDlImpCln.CleanUpJob().set_KrYsFreUnsetlDlId_toKeep(the_jobs.get(0).Id).startAsync();
        Test.stopTest();
    }

    @isTest public static void CleanUpJob_startAsync_error() {
        beginSetUp();
        KrYsFreUnSetlDlImpCln.i_will_raise_error_for_test_coverage = true;
        endSetUp();
        Test.startTest();
        try{
            new KrYsFreUnSetlDlImpCln.CleanUpJob().set_KrYsFreUnsetlDlId_toKeep(null).startAsync();
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
    
}