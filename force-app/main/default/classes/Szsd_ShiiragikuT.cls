@isTest
public class Szsd_ShiiragikuT {

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
    @isTest public static void IOppList_For_Shiragiku_isMatch() {
        beginSetUp();
        Map<String, k_ShohinSyubetsu__c> thek_ShohinSyubetsus = new Map<String, k_ShohinSyubetsu__c>{
            '本体（委託）' => new k_ShohinSyubetsu__c(
               ID__c = '1', Name = '本体（委託）'
            )
        };
        INSERT thek_ShohinSyubetsus.values();
        Map<String, Product2> theProds = new Map<String, Product2>{
            '葬儀プラン-1' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-1',
                k_ShohinSyubetsuRef__c = thek_ShohinSyubetsus.get('本体（委託）').Id
            )
         };
        INSERT theProds.values();
        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
             '葬儀プラン-1' => new PricebookEntry(
                 Pricebook2Id = Test.getStandardPricebookId(),
                 Product2Id = theProds.get('葬儀プラン-1').Id,
                 UnitPrice = 1000,
                 IsActive = true
            )
         };
        INSERT theProdEntries.values();

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
                CloseDate = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            )
        };
        INSERT the_opps.values();

        Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '葬儀プラン-1' => new OpportunityLineItem(
                OpportunityId = the_opps.get('葬儀商談-1').Id,
                Product2Id = theProds.get('葬儀プラン-1').Id,
                TotalPrice = 1000
            )
        };
        INSERT theOppItems.values();
        endSetUp();

        Test.startTest();
        new Szsd_Shiiragiku.OppList_For_Shiragiku().isMatch( the_opps.get('葬儀商談-1').Id );
        Test.stopTest();
    }

    @isTest public static void get_IOppList_For_Shiragiku_instance(){
        Szsd_Shiiragiku.get_IOppList_For_Shiragiku_instance();
    }
}