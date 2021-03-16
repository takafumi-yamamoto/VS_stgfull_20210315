@isTest
public class Ctl_EitaiKuyo_SyncToOppTest {
    @isTest(SeeAllData=true)
    public static void doTest(){

        List<Account> theAccounts = 
        new List<Account>{
            new Account( Name = '相談者'),
            new Account( Name = '対象者'),
            new Account( Name = '喪主'),
            new Account( Name = 'パートナー', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Jiin').getRecordTypeId())
        };
        insert theAccounts;

        List<Keiyaku__c> theKeiyakus = 
        new List<Keiyaku__c>{
            new Keiyaku__c( Teikeisaki__c = theAccounts.get(3).Id,
                            RecordTypeId =  Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('EitaiKuyo').getRecordTypeId())
        };
        insert theKeiyakus;

        EitaiKuyo__c theService = new EitaiKuyo__c();
        insert theService;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccounts.get(0).Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_'
        );

        insert theOpp;
        theOpp.EitaiKuyoRef__c = theService.Id;
        update theOpp;

        theService.TaishoshaRef__c = theAccounts.get(1).Id;
        theService.KetteiJiin__c = theKeiyakus.get(0).Id;
        theService.KakuteiPlan__c = '永代供養プラン';
        update theService;

        Opportunity theActual = 
            [select Id, EitaiKuyoRef__c, TaishosyaRef__c, MosyuRef__c, KeiyakuSyaRef__c, KetteiSakiRef__c, KetteiPlanName__c from Opportunity where Id = :theOpp.Id].get(0);
        System.Debug('theActual;' + theActual);
    }
}