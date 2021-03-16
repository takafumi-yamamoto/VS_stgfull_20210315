@isTest
public class SpfyOppUpdT {
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

    public class SpfyOrdersGetMock implements SpfyOrdersGet.IClient{
        public SpfyApi_OrdersGetEx.Order getOrder(Decimal pOrderId){
            SpfyApi_OrdersGetEx.Order theOrder = new SpfyApi_OrdersGetEx.Order();
            theOrder.id = 1.0;
            theOrder.created_at = Datetime.newInstance(2020, 7, 13,12,0,0);
            theOrder.financial_status = 'paid';
            theOrder.customer = new SpfyApi_OrdersGetEx.Customer();
            theOrder.billing_address = new SpfyApi_OrdersGetEx.BillingAddress();
            theOrder.billing_address.last_name = '_';
            theOrder.billing_address.first_name = '_';
            theOrder.shipping_address = new SpfyApi_OrdersGetEx.ShippingAddress();
            theOrder.line_items = new List<SpfyApi_OrdersGetEx.LineItem>();
            return theOrder;
        }
    }

    public class CyumonJohoTexterMock implements SpfyCyumonJohoTxt.ICyumonJohoTexter{
        public String getText(SpfyApi_OrdersGetEx.Order pOrder){
            return '';
        }
    }
    @isTest public static void OppUpdater_updateOpp() {
        beginSetUp();
        Map<String, Product2> theProds = new Map<String, Product2>{
            'test-code' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = 'test-code'
            )
        };
        INSERT theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = 'test-code'),
                UnitPrice = 1000,
                IsActive = true
           )
        };
        INSERT theProdEntries.values();

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

		Map<String, BestButsudan__c> theBest = new Map<String, BestButsudan__c>{
			'ベスト' => new BestButsudan__c()
		};
        INSERT theBest.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベスト' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId(),
                BestButsudanRef__c = theBest.get('ベスト').Id,
                RefHub4OppRef__c = theRefHub4Opps.get('1').Id
            )
        };
        INSERT theOpps.values();
        endSetUp();

        Test.startTest();
        new SpfyOppUpd.OppUpdater(
            new SpfyOrdersGetMock(),
            new SpfyOppShohinBango.ShohinBangoForOppLineItems('test-code'),
            new SpfyNoteShipDates.SpfyNoteShipDate(),
            new SpfyOppStages.StageRsolver( new SpfyPreKessaiPolicy.PreKessaiPolicy() ),
            new CyumonJohoTexterMock()
        )
        .updateOpp(1.0);
        Test.stopTest();
    }
}