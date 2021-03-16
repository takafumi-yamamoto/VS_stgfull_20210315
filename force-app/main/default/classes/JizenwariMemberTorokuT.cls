@isTest
public class JizenwariMemberTorokuT {
	
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

	@isTest static void test_method_one() {
		
		beginSetUp();
		endSetUp();
		
		Account a = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '_', LastName = '_',
                			MemberTourokuZumi__c = true
            			);

		insert a;
	}
	
	@isTest static void test_method_two() {
		
		beginSetUp();
		
		Account a = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '_', LastName = '_',
                			MemberTourokuZumi__c = true
            			);

		insert a;

		endSetUp();

		a.MemberTourokuZumi__c = true;
		update a;
	}
	
}