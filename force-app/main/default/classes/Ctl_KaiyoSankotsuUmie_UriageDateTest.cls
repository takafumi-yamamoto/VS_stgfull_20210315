@isTest
public class Ctl_KaiyoSankotsuUmie_UriageDateTest {
    @isTest(seeAllData=true)
    public static void doTest(){

        Account theAccount = new Account(
            Name = '_'
        );
        Insert theAccount;
        KaiyoSankotsuUmie__c theUmie = new KaiyoSankotsuUmie__c();
        Insert theUmie;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_',
            KaiyoSankotsuUmieRef__c = theUmie.Id
        );
        Insert theOpp;

        theUmie.KetteiSankotsuNichiji__c = DateTime.valueOfGmt('2000-01-01 00:00:00');
        update theUmie; 

        Date theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0).Utiagebi__c;

        System.Debug('theActual'+ theActual);
    }
}