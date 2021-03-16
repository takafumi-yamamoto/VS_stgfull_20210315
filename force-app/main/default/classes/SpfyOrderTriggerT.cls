@isTest
public class SpfyOrderTriggerT {
    @isTest public static void before_insert() {
        Test.startTest();
        INSERT new SpfyOrder__c();
        Test.stopTest();
    }
}