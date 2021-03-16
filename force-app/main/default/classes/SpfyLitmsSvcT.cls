@isTest
public class SpfyLitmsSvcT {
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
    @isTest public static void getSpfyLineItemsByOppId() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String,SpfyOrder__c> theSpfyOrders = new Map<String,SpfyOrder__c>{
            '1' => new SpfyOrder__c( spfyOrder_Id__c = 1.0 )
        };
        INSERT theSpfyOrders.values();

        Map<String,RefHub4Opp__c> theRefHub4Opps = new Map<String,RefHub4Opp__c>{
            '1' => new RefHub4Opp__c(
                SpfyOrderRef__c = theSpfyOrders.get('1').Id
            )
        };
        INSERT theRefHub4Opps.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                RefHub4OppRef__c = theRefHub4Opps.get('1').Id
            )
        };
        INSERT theOpps.values();

        INSERT new SpfyLineItem__c( SpfyOrderRef__c = theSpfyOrders.get('1').Id );

        endSetUp();

        Test.startTest();
        SpfyLitmsSvc.getSpfyLineItemsByOppId( theOpps.get('ベスト').Id );
        Test.stopTest();

    }
}