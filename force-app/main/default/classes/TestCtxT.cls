@isTest
public class TestCtxT {

    @isTest public static void doTest(){
        Test.startTest();
        TestCtx.set_toRaiseException(true);
        TestCtx.get_toRaiseException();
        Test.stopTest();
    }
}