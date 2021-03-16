@isTest
public class ProvinceCodesT {
    @isTest public static void getName() {
        Test.startTest();
        String theName = ProvinceCodes.getName('JP-01');
        Test.stopTest();
        System.assertEquals('北海道', theName);
    }
}