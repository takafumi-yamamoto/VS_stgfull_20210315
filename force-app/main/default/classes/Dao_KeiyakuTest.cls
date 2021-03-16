@isTest
public class Dao_KeiyakuTest {
    @isTest
    public static void doTest(){
        Account theAccount = new Account(
            Name = '_', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId()
        );
        Insert theAccount;
        Keiyaku__c theKeiyaku = new Keiyaku__c(
            Teikeisaki__c = theAccount.Id,
            RecordTypeId =  Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
        );
        Insert theKeiyaku;
        Dao_Keiyaku theTarget = Dao_Keiyaku.getInstance();

        Keiyaku__c theActual = theTarget.selectByIds( new List<Id>{ theKeiyaku.Id } ).get(0);
        System.Debug(theActual);

    }
}