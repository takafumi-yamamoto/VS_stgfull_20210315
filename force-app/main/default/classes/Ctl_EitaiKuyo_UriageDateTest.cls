@isTest
public class Ctl_EitaiKuyo_UriageDateTest {
    @isTest(seeAllData=true)
    public static void doTest(){

        Account theAccount = new Account(
            Name = '_'
        );
        Insert theAccount;
        EitaiKuyo__c theEitai = new EitaiKuyo__c();
        Insert theEitai;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_',
            EitaiKuyoRef__c = theEitai.Id
        );
        Insert theOpp;

        theEitai.EitaiKuyoKaishibi__c = Date.valueOf('2000-01-01');
        update theEitai; 

        Date theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0).Utiagebi__c;

        System.Debug('theActual'+ theActual);
    }
}