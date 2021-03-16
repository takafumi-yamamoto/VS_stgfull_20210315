@isTest
public class RefHub4OppTriggerT {
    @isTest public static void before_insert() {
        Test.startTest();
        INSERT new RefHub4Opp__c();
        Test.stopTest();
    }
}