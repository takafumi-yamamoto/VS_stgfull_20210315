@isTest
public class AcrtDrResultHdlrPvdrT {
    @isTest public static void Provider_resolveHandler() {
        Test.startTest();
        new AcrtDrResultHdlrPvdr.Provider().resolveHandler('SampleMsgType');
        Test.stopTest();
    }
}