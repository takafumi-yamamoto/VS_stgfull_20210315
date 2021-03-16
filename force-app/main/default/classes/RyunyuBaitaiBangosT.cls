@isTest
public class RyunyuBaitaiBangosT {

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
    @isTest public static void RyunyuBaitaiBango_Is_Mandatory_on_opp_before_update() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客-1').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();

        Opportunity a_old_one = new Opportunity(
            Id = theOpps.get('葬儀商談-1').Id,
            Iriguchi__c = null,
            RyunyuBaitaiBango__c = null
        );

        Opportunity a_new_one = new Opportunity(
            Id = theOpps.get('葬儀商談-1').Id,
            Iriguchi__c = '折込チラシ',
            RyunyuBaitaiBango__c = 'test-bango'
        );
        endSetUp();
    
        Test.startTest();
        new RyunyuBaitaiBangos.RyunyuBaitaiBango_Is_Mandatory().on_opp_before_update(
            new List<Opportunity>{ a_new_one },
            new Map<Id, Opportunity>{
                a_old_one.Id => a_old_one
            }
        );
        Test.stopTest();
    }
}