@isTest
public class WrTkSbgMapsT {
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

	public class ShohinBangoMapStub implements WrTkSbgMaps.IShohinBangoMap{
		public Map<String, Set<String>> getShohinBangoMap(){
			return new Map<String, Set<String>>{
				'SBG-TEST001' => new Set<String>{ 'SBG-TEST002' }
			};
		}	
	}

	@isTest
	public static void doTest() {
		beginSetUp();
        Map<String, Product2> theProds = new Map<String, Product2>{
            '通常商品' => new Product2(
            Name = '通常商品', ShohinBango__c = 'SBG-TEST001', IsActive = true
            ),
            '割引商品' => new Product2(
               Name = '割引商品', ShohinBango__c = 'SBG-TEST002', IsActive = true
            )
        };
        INSERT theProds.Values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '通常商品' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('通常商品').Id, UnitPrice = 100000
            ),
            '割引商品' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
                Product2Id = theProds.get('割引商品').Id, UnitPrice = -10000
            )
        };
        INSERT theProdEntries.values();
		endSetUp();
        
		Test.startTest();
		new WrTkSbgMaps().getMapping( new ShohinBangoMapStub() );
		Test.stopTest();
	}
}