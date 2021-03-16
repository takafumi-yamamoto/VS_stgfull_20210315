@isTest
public class SpfyOppNameT {

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

    @isTest
    public static void OnOppBeforeUpdate_appendShopifyOrderNo_To_OppName(){
        
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = 'A',
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                AccountId = theAccounts.get('客').Id,
                SpfyOrderName__c = '#0001'
            )
        };
        INSERT theOpps.values();
        
        Opportunity theOldOne = theOpps.get('ベスト');
        Opportunity theNewOne = theOldOne.clone(true);
        theNewOne.Name = 'B';
        endSetUp();

        Test.startTest();
        new SpfyOppName.OnOppBeforeUpdate().appendShopifyOrderNo_To_OppName(
            new List<Opportunity>{ theNewOne }, 
            new Map<Id, Opportunity> { theOldOne.Id => theOldOne }
            );
        Test.stopTest();
    }
}