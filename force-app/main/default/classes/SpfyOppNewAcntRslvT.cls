@isTest
public class SpfyOppNewAcntRslvT {

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
    @isTest public static void AccountResolver_resolveAccount_newAccount() {
    
        Test.startTest();
        new SpfyOppNewAcntRslv.AccountResolver().resolveAccount(
            new SpfyOppNewAcntRslv.Req()
            .set_customer_id(1)
            .set_last_name('test')
            .set_first_name('test')
            .set_email('this-is-test@this-is-test.com')
            .set_phone('08000000000')
            .set_address_zip('1410031')
            .set_address_province('test')
            .set_address_city('test')
            .set_address_address1('test')
            .set_address_address2('test')
        );
        Test.stopTest();
    }

    @isTest public static void AccountResolver_resolveAccount_ExistingAccount() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'test', LastName = 'test', NayoseMailAddress__c = 'this-is-test@this-is-test.com'
            )
        };
        INSERT theAccounts.values();
        endSetUp();
        Test.startTest();
        new SpfyOppNewAcntRslv.AccountResolver().resolveAccount(
            new SpfyOppNewAcntRslv.Req()
            .set_customer_id(1)
            .set_last_name('test')
            .set_first_name('test')
            .set_email('this-is-test@this-is-test.com')
            .set_phone('08000000000')
            .set_address_zip('1410031')
            .set_address_province('test')
            .set_address_city('test')
            .set_address_address1('test')
            .set_address_address2('test')
        );
        Test.stopTest();
    }
}