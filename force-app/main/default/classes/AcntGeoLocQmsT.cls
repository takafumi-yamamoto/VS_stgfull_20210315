@isTest
public class AcntGeoLocQmsT {
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
    
    public class GeoLocsStub implements IGeoLocs{
        public GeoLocs.Result getGeoLocation(String postcode, String address, Boolean isRetry){
            GeoLocs.GeoLocation theLocation = new GeoLocs.GeoLocation();
            theLocation.lat = 35.6235679;
            theLocation.lng = 139.7192223;

            GeoLocs.Result theResult = new GeoLocs.Result();
            theResult.isSuccess = true;
            theResult.geoLocation = theLocation;

            return theResult;
        }
        public GeoLocs.Result getGeoLocation(String postcode, String address){
            return this.getGeoLocation(postcode, address, true);
        }
    }
    @isTest public static void handleQms_Exception(){
        beginSetUp();
        Qms__c theQms = new Qms__c();
        INSERT theQms;
        endSetUp();
        Test.startTest();
        new AcntGeoLocQms().handleQms(theQms);
        Test.stopTest();
    }
    @isTest public static void Runner_getUpdate(){
        beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_',
                BillingPostalCode = '1410031',
                BillingState = '東京都',
                BillingCity = '品川区',
                BillingStreet = '西五反田'
            )
        };
        INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        new AcntGeoLocQms.Runner( new GeoLocsStub() ).run( theAccounts.get('Customer').Id );
        Test.stopTest();
        
    }

    @isTest public static void QueuingOnAccountAfterInsert_getQueues(){
        Test.startTest();
        new AcntGeoLocQms.QueuingOnAccountAfterInsert().enqueAccountLocationUpdates(
            new List<Account>{
                new Account(
                    RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                    FirstName = '_', LastName = '_',
                    BillingPostalCode = '1410031',
                    BillingState = '東京都',
                    BillingCity = '品川区',
                    BillingStreet = '西五反田'
                )
            }
        );
        Test.stopTest();
    }
}