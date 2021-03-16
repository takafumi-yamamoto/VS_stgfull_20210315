@isTest
public class Trg_CaseSurveyViscaT {

    @isTest
    public static void success() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        insert new CaseSurveyVisca__c();
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = [
            SELECT
                Id
                ,Md5__c
            FROM
                CaseSurveyVisca__c
        ];

        System.assertEquals(1,  rslts.size(), 'get size not 1');
        System.assertEquals(32, rslts.get(0).Md5__c.length(), 'no create md5');
    }
}