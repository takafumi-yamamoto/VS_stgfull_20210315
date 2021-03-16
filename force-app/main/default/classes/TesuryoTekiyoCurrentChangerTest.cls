@isTest
public class TesuryoTekiyoCurrentChangerTest {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void whenCurrentTesuryoTekiyoIsKyuTesuryoTaio_thenKeiyakuAlsoShouldBeTesuryoTaio(){

        setUp();

        Map<String, k_Service__c> theServices = new Map<String, k_Service__c>{
            '1' => new k_Service__c( name='_', ID__c = '1' )
        };
        Insert theServices.values();

        Map<String, TesuryoPlan__c> theTesuryoPlans = new Map<String, TesuryoPlan__c>{
            'NotKyuTesuryo' => new TesuryoPlan__c( Name = '_',  isKyuTesuryoTaio__c = false ),
            'KyuTesuryo' => new TesuryoPlan__c( Name = '_',  isKyuTesuryoTaio__c = true )
        };
        Insert theTesuryoPlans.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account( Name = '_', RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount')  )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            '1' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KyuTesuryoTaioFlag__c = false
            )
        };
        Insert theKeiyakus.values();

        Map<String, TesuryoTekiyo__c> theTesuryoTekiyos = new Map<String,TesuryoTekiyo__c>{
            'plan_Previous_NotKyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = '承認済',
                    TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
                    TesuryoPlanRef__c = theTesuryoPlans.get('NotKyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                ),
            'plan_Current_KyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = '承認済',
                    TekiyoKaishiBi__c = Date.today(),
                    TesuryoPlanRef__c = theTesuryoPlans.get('KyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                ),
            'plan_Future_NotKyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = '承認済',
                    TekiyoKaishiBi__c = Date.valueOf('2900-01-01'),
                    TesuryoPlanRef__c = theTesuryoPlans.get('NotKyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                )
        };
        Insert theTesuryoTekiyos.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );

        System.assertEquals(false, theKeiyakus.get('1').KyuTesuryoTaioFlag__c );
        
        Test.startTest();
        new TesuryoTekiyoCurrentChanger().processBatch( 
                new List<TesuryoTekiyo__c> { theTesuryoTekiyos.get('plan_Current_KyuTesuryo') } 
            );
        Test.stopTest();

        List<Keiyaku__c> theActuals = new List<Keiyaku__c>(
            [
                select Id, KyuTesuryoTaioFlag__c
                from Keiyaku__c 
                where Id = :theKeiyakus.get('1').Id
            ]
        );

        System.assertEquals(true, theActuals.get(0).KyuTesuryoTaioFlag__c );
    }

    @isTest
    public static void subscribeOnTesuryoTekiyoAfterUpdatedTest(){

        setUp();

        Map<String, k_Service__c> theServices = new Map<String, k_Service__c>{
            '1' => new k_Service__c( name='_', ID__c = '1' )
        };
        Insert theServices.values();

        Map<String, TesuryoPlan__c> theTesuryoPlans = new Map<String, TesuryoPlan__c>{
            'NotKyuTesuryo' => new TesuryoPlan__c( Name = '_',  isKyuTesuryoTaio__c = false ),
            'KyuTesuryo' => new TesuryoPlan__c( Name = '_',  isKyuTesuryoTaio__c = true )
        };
        Insert theTesuryoPlans.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account( Name = '_', RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount')  )
        };
        Insert theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
            '1' => new Keiyaku__c( 
                Teikeisaki__c = theAccounts.get('1').Id,
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
                KyuTesuryoTaioFlag__c = false
            )
        };
        Insert theKeiyakus.values();

        Map<String, TesuryoTekiyo__c> theTesuryoTekiyos = new Map<String,TesuryoTekiyo__c>{
            'plan_Previous_NotKyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = '承認済',
                    TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
                    TesuryoPlanRef__c = theTesuryoPlans.get('NotKyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                ),
            'plan_Current_KyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = 'ドラフト',
                    TekiyoKaishiBi__c = Date.today(),
                    TesuryoPlanRef__c = theTesuryoPlans.get('KyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                ),
            'plan_Future_NotKyuTesuryo' => new TesuryoTekiyo__c( 
                    KeiyakuRef__c = theKeiyakus.get('1').Id,  
                    ShoninStatus__c = '承認済',
                    TekiyoKaishiBi__c = Date.valueOf('2900-01-01'),
                    TesuryoPlanRef__c = theTesuryoPlans.get('NotKyuTesuryo').Id,
                    ServiceRef__c = theServices.get('1').Id
                )
        };
        Insert theTesuryoTekiyos.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );

        System.assertEquals(false, theKeiyakus.get('1').KyuTesuryoTaioFlag__c );
        
        Test.startTest();
        theTesuryoTekiyos.get('plan_Current_KyuTesuryo').ShoninStatus__c = '承認済';
        Update theTesuryoTekiyos.get('plan_Current_KyuTesuryo');
        Test.stopTest();

        List<Keiyaku__c> theActuals = new List<Keiyaku__c>(
            [
                select Id, KyuTesuryoTaioFlag__c
                from Keiyaku__c 
                where Id = :theKeiyakus.get('1').Id
            ]
        );

        System.assertEquals(true, theActuals.get(0).KyuTesuryoTaioFlag__c );
    }
}