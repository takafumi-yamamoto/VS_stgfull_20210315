@isTest
public class OkyakusamaSeikyuMeisaiKessaibiT {
    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
    }

    @isTest static void okyakusamaMeisaiBi(){
        setUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };        
        Insert theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('1').Id,
                StageName = '_',
                CloseDate = system.today()
            )
        };
        Insert theOpps.values();

        Map<String, OkyakusamaSeikyuMeisai__c> theOkyakusamaSeikyuMeisaisTobeUpdated = new Map <String, OkyakusamaSeikyuMeisai__c>{
        '1' => new OkyakusamaSeikyuMeisai__c(
                SeikyuHouhou__c = 'Partner',
                OpportunityRef__c = theOpps.get('1').Id
            ),
        '2' => new OkyakusamaSeikyuMeisai__c(
                SeikyuHouhou__c = 'Amazon',
                OpportunityRef__c = theOpps.get('1').Id
            )
        };
        Insert theOkyakusamaSeikyuMeisaisTobeUpdated.values();
       
        Test.StartTest();
        //プラン火葬の場合は、火葬日時を入れると商談の売上日が登録されるはず。
        List<Opportunity> theOppsSaved = [
            select Id, ObosanbinRef__c
            from Opportunity
            where Id = :theOpps.get('1').Id
        ];

        Update new Obosanbin__c(
            Id = theOppsSaved.get(0).ObosanbinRef__c,
            MemorialServicePlan__c = '火葬式',
            KasoDateTime_Inp__c = Datetime.now()
        );
        Test.StopTest();
    }

}