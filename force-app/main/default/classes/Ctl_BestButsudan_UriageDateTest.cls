@isTest
public class Ctl_BestButsudan_UriageDateTest {
    @isTest(seeAllData=true)
    public static void doTest(){

        Account theAccount = new Account(
            Name = '_'
        );
        Insert theAccount;
        BestButsudan__c theService = new BestButsudan__c();
        Insert theService;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_',
            BestButsudanRef__c = theService.Id
        );
        Insert theOpp;

        theService.Hassoubi__c = Date.valueOf('2000-01-01');
        update theService; 

        Date theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0).Utiagebi__c;

        System.Debug('theActual'+ theActual);
    }
}