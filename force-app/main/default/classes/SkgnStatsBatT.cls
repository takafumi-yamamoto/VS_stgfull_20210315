@isTest
public class SkgnStatsBatT {

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
        Test.startTest();
        SkgnStatsBat.start();
        Test.stopTest();
    }

    @isTest public static void SkgnStatsBat_execute_error(){
        beginSetUp();
        Map<String, Shikugun__c> the_Shikuguns = new Map<String, Shikugun__c>{
            '市区郡-1' => new Shikugun__c( Name = '_' )
        };
        INSERT the_Shikuguns.values();

        SkgnStatsBat.i_will_raise_error_for_test_coverage = true;
        endSetUp();

        Test.startTest();
        try{
            SkgnStatsBat.get_SkgnStatsBat_instance().execute(
                null, 
                new List<Shikugun__c>{ the_Shikuguns.get('市区郡-1') }
            );
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}