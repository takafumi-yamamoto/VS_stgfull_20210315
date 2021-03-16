@isTest
public class PriceBookDaoT {

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
	public static void doTest(){

        beginSetUp();
		Map<String, Product2> theProds = new Map<String, Product2>{
			'SBG-0000001' => new Product2(
			Name = '_', ShohinBango__c = 'SBG-0000001', IsActive = true
			)
		};
		INSERT theProds.Values();

		Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
			'SBG-0000001' => new PricebookEntry(
				Pricebook2Id = Test.getStandardPricebookId(), IsActive = true,
				Product2Id = theProds.get('SBG-0000001').Id, UnitPrice = 100000
			)
		};
		INSERT theProdEntries.values();
		endSetUp();

		Test.startTest();
		PriceBookDao.instance().getEntry( Test.getStandardPricebookId(), 'SBG-0000001' );
		Test.stopTest();
	}
}