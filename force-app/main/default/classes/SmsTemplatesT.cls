@isTest
public class SmsTemplatesT {
    @isTest
    public static void getTemplate(){
        Test.startTest();
        new SmsTemplates().getTemplate('ObHokoSm');
        Test.stopTest();
    }
}