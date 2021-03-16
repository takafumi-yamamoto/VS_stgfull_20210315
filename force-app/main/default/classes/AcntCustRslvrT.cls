@isTest
public class AcntCustRslvrT {
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
    
    @isTest public static void AccountRelver_try_insert_new_account(){
        Test.startTest();

        AcntCustRslvr.Req theReq = 
            new AcntCustRslvr.Req()
            .set_last_name('_')
            .set_first_name( '_' )
            .set_last_name_kana( '_' )
            .set_first_name_kana( '_' )
            .set_phone( '_' )
            .set_mobile( '_' )
            .set_postal_code( '_' )
            .set_state( '_' )
            .set_city( '_')
            .set_street( '_' );

        AcntCustRslvr.Result the_Result = new AcntCustRslvr.AccountRelver().try_insert(theReq);
        Test.stopTest();
    }

    @isTest public static void AccountRelver_try_insert_existsting_account(){
        beginSetUp();

        endSetUp();

        Test.startTest();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'テスト', LastName = 'テスト', 
                FirstNameFurigana__pc = 'テスト', LastNameFurigana__pc = 'テスト',
                MobilePhone__c = '08099999999'
            )
        };
        INSERT theAccounts.values();
        
        AcntCustRslvr.Req theReq = 
            new AcntCustRslvr.Req()
            .set_last_name('テスト')
            .set_first_name( 'テスト' )
            .set_last_name_kana( 'テスト' )
            .set_first_name_kana( 'テスト' )
            .set_phone( '_' )
            .set_mobile( '08099999999' )
            .set_postal_code( '_' )
            .set_state( '_' )
            .set_city( '_')
            .set_street( '_' );

        AcntCustRslvr.Result the_Result = new AcntCustRslvr.AccountRelver().try_insert(theReq);
        Test.stopTest();
    }
}