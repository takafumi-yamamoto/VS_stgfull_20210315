@isTest
public class SzsdExcldByThkCallT {
    
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

    @isTest public static void ToExclude_Hantei_By_ThankYouCall_get_reason_to_exclude_by_oppId(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT the_opps.values();

        Map<String, SgThkCall__c> the_SgThkCalls = new Map<String,SgThkCall__c>{
            'ThankYouCall-1' => new SgThkCall__c(
                SodanshaRef__c = the_accounts.get('客-1').Id,
                Sogi_OppRef__c = the_opps.get('葬儀商談-1').Id
            )
        };
        INSERT the_SgThkCalls.values();

        Map<String ,SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new Map<String, SgThkCallSvcAnnai__c>{
            'サービス案内-相続相談' => new SgThkCallSvcAnnai__c(
                SgThkCallRef__c = the_SgThkCalls.get('ThankYouCall-1').Id,
                ServiceKbn__c = '相続相談', 
                CallKekka__c = '未案内'
            ),
            'サービス案内-相続相談' => new SgThkCallSvcAnnai__c(
                SgThkCallRef__c = the_SgThkCalls.get('ThankYouCall-1').Id,
                ServiceKbn__c = '相続相談', 
                CallKekka__c = '香典返し'
            )
        };
        INSERT the_SgThkCallSvcAnnais.values();
        endSetUp();

        Test.startTest();

        new SzsdExcldByThkCall.ToExclude_Hantei_By_ThankYouCall(
            new SzsdExcldByThkCall.No_SozokuAnnnai_But_Shirgiku()
        )
        .get_reason_to_exclude_by_oppId(
            the_opps.get('葬儀商談-1').Id,
            false
        );

        Test.stopTest();
    }
}