@isTest
public class SlackApiPostMsgConfT {
    @isTest public static void Provider_getConfig() {
        Test.startTest();
        new SlackApiPostMsgConf.Provider().getConfig();
        Test.stopTest();
    }
}