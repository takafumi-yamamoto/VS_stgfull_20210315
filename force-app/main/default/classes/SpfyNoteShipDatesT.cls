@isTest public class SpfyNoteShipDatesT {
    @isTest public static void SpfyNoteShipDate_getShipDate() {
        Test.startTest();
        Date theShipDate = new SpfyNoteShipDates.SpfyNoteShipDate().getShipDate('test\r\nddd出荷日=2020-07-13test');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2020,7,13), theShipDate);
    }
}