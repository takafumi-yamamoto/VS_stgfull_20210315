@isTest
public class SpfyOppNewT {
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
    public class AccountResolverMock implements SpfyOppNewAcntRslv.IAccountResolver{
        public SpfyOppNewAcntRslv.Res resolveAccount(SpfyOppNewAcntRslv.Req pReq){
            Map<String, Account> theAccounts = new Map<String, Account>{
                '客' => new Account(
                    RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                    FirstName = '_', LastName = '_'
                )
            };
            INSERT theAccounts.values();
            SpfyOppNewAcntRslv.Res theRes = new SpfyOppNewAcntRslv.Res();
            theRes.AccountId = theAccounts.get('客').Id;
            return theRes;
        }
    }

    public class CyumonJohoTexterMock implements SpfyCyumonJohoTxt.ICyumonJohoTexter{
        public String getText(SpfyApi_OrdersGetEx.Order pOrder){
            return '';
        }
    }

    @isTest public static void OppCreator_createNew() {
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
        endSetUp();
        Test.startTest();
        new SpfyOppNew.OppCreator(
            new SpfyOrdersGetMock(),
            new SpfyOppShohinBango.ShohinBangoForOppLineItems('test-code'),
            new AccountResolverMock(),
            new SpfyNoteShipDates.SpfyNoteShipDate(),
            new SpfyOppStages.StageRsolver( new SpfyPreKessaiPolicy.PreKessaiPolicy() ),
            new CyumonJohoTexterMock()
        )
        .createNew(1.0);
        Test.stopTest();

    }
}