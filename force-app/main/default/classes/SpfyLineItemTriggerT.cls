@isTest
public class SpfyLineItemTriggerT {
    @isTest public static void before_insert() {
        Test.startTest();
        INSERT New SpfyLineItem__c();
        Test.stopTest();
    }
}