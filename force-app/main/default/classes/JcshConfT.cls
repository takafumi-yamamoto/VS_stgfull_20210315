@isTest public class JcshConfT {
    @isTest public static void Provider_getConfig() {
        Test.startTest();
        new JcshConf.Provider().getConfig();
        Test.stopTest();
    }
}