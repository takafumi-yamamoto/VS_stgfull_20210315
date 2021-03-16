@isTest
public class Ctl_OkyakusamaSeikyuMeisaiTest {

    @isTest(seeAllData=true)
    public static void setShiharaiKanrenJoho(){

        Map<String,Account> theAccounts = new Map<String,Account>{
            '1' => new Account( Name = '_')
        };
        Insert theAccounts.values();

        //RecordTypeCachedDaos.IRecordTypeCachedDao theRTDao = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                AccountId = theAccounts.get('1').Id,
                Name = '_',
                StageName = '_',
                CloseDate = Date.valueOf('1900-01-01')
            )
        };
        Insert theOpps.values();

        Map<String,OkyakusamaSeikyuMeisai__c> theSeikyus = new Map<String,OkyakusamaSeikyuMeisai__c>{
            '1' => new OkyakusamaSeikyuMeisai__c(
                OpportunityRef__c = theOpps.get('1').Id,
                SeikyuHouhou__c = '_'
            )
        };
        Insert theSeikyus.values();

        OkyakusamaSeikyuMeisai__c theSeikyuInWork =[
            select id,SeikyuHouhou__c
            from OkyakusamaSeikyuMeisai__c 
            where Id = :theSeikyus.get('1').Id
        ].get(0);

        Test.startTest();
        theSeikyuInWork.SeikyuHouhou__c = 'sousai';
        Update theSeikyuInWork;
        Test.stopTest();
        // Opportunity theOpp = [
        //     select Id, SimpleYasugoRef__c
        //     from Opportunity where Id = :theOpps.get('1').Id
        // ].get(0);

        // System.Debug(theOpp.SimpleYasugoRef__c);
    }

}