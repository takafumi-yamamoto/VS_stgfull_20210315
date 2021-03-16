/**
* クラス名           :   Trg_ShikugunTest
* クラス概要       :   市区郡トリガーハンドラー.テストクラス
* @created  :   2018/01/05
* @modified :   
*/
@isTest
public class Trg_ShikugunTest {
    static testMethod void Test1() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        //都道府県
        TodoufuKen__c TodoufuKen = new TodoufuKen__c();
        TodoufuKen.name='東京都';
        insert TodoufuKen;
        //市区郡
        Shikugun__c Shikugun=new Shikugun__c();
        Shikugun.Name='中央区';
        Shikugun.TodoufuKenRef__c=TodoufuKen.id;
        insert Shikugun;
        Shikugun.Name='中央区1-1';
        update Shikugun; 
        Test.stopTest();
        Shikugun__c[] result = [SELECT Id,
                                            Chiriichijouhou__latitude__s,
                                            Chiriichijouhou__longitude__s 
                                       from Shikugun__c 
                                      where id=:Shikugun.id];
        System.assertEquals(result[0].Chiriichijouhou__latitude__s, 37.4217550);
        System.assertEquals(result[0].Chiriichijouhou__longitude__s, -122.0846330);        
    }
}