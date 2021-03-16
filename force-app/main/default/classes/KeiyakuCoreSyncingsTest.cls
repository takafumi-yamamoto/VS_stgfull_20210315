@isTest
public class KeiyakuCoreSyncingsTest {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );

        Insert new List<KaiinkibanSetting__c>{
            new KaiinkibanSetting__c(
                name='dev', 
                client_id__c='5', 
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            ),
            new KaiinkibanSetting__c(
                name='prod',
                client_id__c='5',
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true
            )
        };

        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void subscriveOnTesuryoTekiyoAfterUpdatedTest(){

        setUp();

        Map<String, k_Service__c> theServices = new Map<String, k_Service__c>{
            '1' => new k_Service__c( name='_', ID__c = '1' )
        };
        Insert theServices.values();

        Map<String, TesuryoPlan__c> theTesuryoPlans = new Map<String, TesuryoPlan__c>{
            '1' => new TesuryoPlan__c( 
                Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = theServices.get('1').Id,
                KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false )
        };
        Insert theTesuryoPlans.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account( Name = '_', RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya')  )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            '1' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo')
            )
        };
        Insert theKeiyakus.values();

        Map<String, TesuryoTekiyo__c> theTesuryoTekiyos = new Map<String,TesuryoTekiyo__c>{
            '1' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = 'ドラフト',
                    TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
                    TesuryoPlanRef__c = theTesuryoPlans.get('1').Id,
                    ServiceRef__c = theServices.get('1').Id
                )
        };
        Insert theTesuryoTekiyos.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );

        Test.startTest();
        theTesuryoTekiyos.get('1').ShoninStatus__c = '承認済';
        Update theTesuryoTekiyos.get('1');
        Test.stopTest();
    }
}