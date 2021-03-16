@isTest
public class Ctl_SougiRev_UriageDateTest {
    @isTest(seeAllData=true)
    public static void doTest(){

        Account theAccount = new Account(
            Name = '_'
        );
        Insert theAccount;
        SougiRev__c theRevi = new SougiRev__c();
        Insert theRevi;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_',
            SogiReviRef__c = theRevi.Id
        );
        Insert theOpp;

        theRevi.SekoBi__c = Date.valueOf('2000-01-01');
        update theRevi; 

        Date theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0).Utiagebi__c;

        System.Debug('theActual'+ theActual);
    }
}