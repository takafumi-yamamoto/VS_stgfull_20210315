/**
* クラス名           :   Trg_Account
* クラス概要       :   取引先トリガーハンドラー.テストクラス
* @created  :   2018/01/05
* @modified :   
*/
@isTest
public class Trg_AccountTest {
    static testMethod void Test1() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;          
        //取引先
        Account acc=new Account();
        acc.Name='テスト用００１';
        acc.BillingCountry='日本';
        acc.BillingState='東京都';
        acc.BillingCity='中央区';
        acc.BillingStreet='１－１－１';
        acc.BillingPostalCode='335-0016';
        insert acc;
        acc.Name='テスト用００１更新';
        update acc; 
        Test.stopTest();
        Account[] result = [SELECT Id,
                                   BillingLatitude,
                                   BillingLongitude
                              from Account 
                             where id=:acc.id];
        //System.assertEquals(result[0].BillingLatitude, 37.4217550);
        //System.assertEquals(result[0].BillingLongitude, -122.0846330);        
    }        
    static testMethod void TestInsertBillingPostalCodeChange() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;          
        //取引先
        Account acc=new Account();
        acc.Name='テスト用００１';
        acc.BillingCountry='日本';
        acc.BillingState='東京都';
        acc.BillingCity='中央区';
        acc.BillingStreet='１－１－１';
        acc.BillingPostalCode='〒3３5ー０016';
        acc.SeikyuSakiAddrPostalCode__c='3３６ー００２6';
        insert acc;
        
        Test.stopTest();
        Account[] result = [SELECT Id
                                   ,BillingPostalCode
                                   ,SeikyuSakiAddrPostalCode__c
                              from Account 
                             where id=:acc.id];
        System.assertEquals('335-0016', result.get(0).BillingPostalCode);   
        System.assertEquals('336-0026', result.get(0).SeikyuSakiAddrPostalCode__c);      
    } 
    static testMethod void TestUpdateBillingPostalCodeChange() {
        Test.startTest(); 
        TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;          
        //取引先
        Account acc=new Account();
        acc.Name='テスト用００１';
        acc.BillingCountry='日本';
        acc.BillingState='東京都';
        acc.BillingCity='中央区';
        acc.BillingStreet='１－１－１';
        acc.BillingPostalCode='112-0034';
        acc.SeikyuSakiAddrPostalCode__c='3３６ー００２6';
        insert acc;
        acc.BillingPostalCode='〒112００２４';
        acc.SeikyuSakiAddrPostalCode__c='〒3３６００２6';
        update acc;
        Test.stopTest();
        Account[] result = [SELECT Id
                                   ,BillingPostalCode
                                   ,SeikyuSakiAddrPostalCode__c
                              from Account 
                             where id=:acc.id];
        System.assertEquals('112-0024', result.get(0).BillingPostalCode);
        System.assertEquals('336-0026', result.get(0).SeikyuSakiAddrPostalCode__c);      
    }        
}