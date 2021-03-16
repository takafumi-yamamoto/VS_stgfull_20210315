@isTest
public class ContactCreateCtlT {
	
    @testSetup
    static void setup() {
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        //シンプル安豪-資料請求Webフォーム
        case c=new case(accountid=dacc.id,
                            RecordTypeId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm'),
                            Firstname__c='Firstname',
                            Lastname__c='Lastname',
                            FirstNameKana__c='ファストカナ',
                            LastNameKana__c='ラストカナ',
                            TelNo__c='080-8888-8888',
                            KiboAreaState__c='東京都',
                            KiboAreaCity__c='中央区',
                            MailAddress__c='test@i.ss.com');
        insert c;
    }

    @isTest
	static void test1() {
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        ContactCreateCtl.auraGetDefaultCallValue(oList.get(0).Id);
    }

    @isTest
	static void test2() {
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        ContactCreateCtl.auraGetDefaultVOCValue(oList.get(0).Id, 'シンプル安豪');
    }

    @isTest
    static void test3(){
    	List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        insert t;
        ContactCreateCtl.auraGetHikitsugiTask(oList.get(0).Id);
    }

    @isTest
    static void test4(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        ContactCreateCtl.auraSetPhase(oList.get(0).Id);
    }
    
    @isTest
    static void test5(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        ContactCreateCtl.auraGetHasshinsakiToValue(oList.get(0).Id, 'パートナー(葬儀社)');
    }

    @isTest
    static void test6(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        ContactCreateCtl.auraCallSave(t);
    }
    
    @isTest
    static void test7(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        VOC__c v = new VOC__c();
        v.TaishoOpportunityRef__c = oList.get(0).Id;
        ContactCreateCtl.auraVocSave(v);
    }
}