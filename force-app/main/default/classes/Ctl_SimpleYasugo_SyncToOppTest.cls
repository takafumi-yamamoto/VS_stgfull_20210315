@isTest
public class Ctl_SimpleYasugo_SyncToOppTest {
    @isTest(SeeAllData=true)
    public static void doTest(){

        List<Account> theAccounts = 
        new List<Account>{
            new Account( Name = '相談者'),
            new Account( Name = '対象者'),
            new Account( Name = '喪主'),
            new Account( Name = 'パートナー', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId())
        };
        insert theAccounts;

        List<Keiyaku__c> theKeiyakus = 
        new List<Keiyaku__c>{
            new Keiyaku__c( Teikeisaki__c = theAccounts.get(3).Id,
                            RecordTypeId =  Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() )
        };
        insert theKeiyakus;

        SimpleYasugo__c theService = new SimpleYasugo__c();
        insert theService;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccounts.get(0).Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_'
        );

        insert theOpp;
        theOpp.SimpleYasugoRef__c = theService.Id;
        update theOpp;

        theService.TaishoshaRef__c = theAccounts.get(1).Id;
        theService.MoshuRef__c = theAccounts.get(2).Id;
        theService.SimpleYasugoKeiyakuRef__c = theKeiyakus.get(0).Id;
        theService.TaiouKanouRiyu__c = '対応可能（斎場優先）';
        update theService;

        //Opportunity theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0);
        Opportunity theActual = 
            [select Id, SimpleYasugoRef__c, TaishosyaRef__c, MosyuRef__c, KeiyakuSyaRef__c, KetteiSakiRef__c, KetteiPlanName__c from Opportunity where Id = :theOpp.Id].get(0);
        System.Debug('theActual;' + theActual);
    }
}