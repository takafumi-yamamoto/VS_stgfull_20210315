@isTest
public class TcmsTaioRkImpConfT {
    @isTest public static void getConfig(){
        Test.startTest();
        TcmsTaioRkImpConf.Config the_config = TcmsTaioRkImpConf.getConfig();
        Test.stopTest();
        System.assertEquals(true, the_config != null);
    }
}