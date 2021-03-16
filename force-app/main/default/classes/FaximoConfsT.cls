@isTest
public class FaximoConfsT {
    
    @isTest public static void getConfig() {
    
        String faximoProcesskey = datetime.now().format('yyyy-MM-dd HH:mm:sss');
        
        Test.startTest();
        FaximoConfs.Config theConfig = FaximoConfs.getConfig(faximoProcesskey);
        Test.stopTest();
    }
}