@isTest
public class SpfyConfsT {
    @isTest public static void getConfig() {
        Test.startTest();
        SpfyConfs.Config theConfig = SpfyConfs.getConfig();
        Test.stopTest();
    }
}