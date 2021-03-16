@isTest public class QmsEvtTriggerT {
    @isTest
    public static void doTest(){
        Test.startTest();
        EventBus.publish( new QmsEvt__e(MsgType__c = 'QmsDpcr.dispatchQmses', Data__c = 'this is test') );
        Test.stopTest();
    }

    @isTest public static void doTest_for_error(){
        TestCtx.set_toRaiseException(true);
        Test.startTest();
        EventBus.publish( new QmsEvt__e(MsgType__c = 'QmsDpcr.dispatchQmses', Data__c = 'this is test') );
        Test.stopTest();
    }
}