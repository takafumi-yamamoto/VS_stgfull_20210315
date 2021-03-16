@isTest
public class TaskOperationT {

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
	static void auraGetHikitsugiTaskHikitsugiTaskAri() {
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        TaskOperation.auraGetHikitsugiTask(oList.get(0).Id);
    }

    @isTest
	static void auraGetHikitsugiTaskHikitsugiTaskNashi() {
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        insert t;
        TaskOperation.auraGetHikitsugiTask(oList.get(0).Id);
    }

    @isTest
    static void auraGetUserId(){
        TaskOperation.auraGetUserId();
    }

    @isTest
    static void auraGetDefaultCallValue(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        TaskOperation.auraGetDefaultCallValue(oList.get(0).Id);
    }
    
    @isTest
    static void auraGetDefaultTaskValue(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        TaskOperation.auraGetDefaultTaskValue(oList.get(0).Id);
    }

    @isTest
    static void auraGetCallHistorys(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        TaskOperation.auraGetCallHistorys(oList.get(0).Id);
    }
    
    @isTest
    static void auraGetTaskHistorys(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        TaskOperation.auraGetTaskHistorys(oList.get(0).Id);
    }

    @isTest
    static void auraGetTaskOwner(){
        TaskOperation.auraGetTaskOwner(UserInfo.getUserId());
    }

    @isTest
    static void auraCallSave(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Call';
        TaskOperation.auraCallSave(t);
    }

    @isTest
    static void auraTaskSave(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        t.OwnerId = UserInfo.getUserId();
        TaskOperation.auraTaskSave(t);
    }

    @isTest
    static void auraUpdateTask(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        t.OwnerId = UserInfo.getUserId();
        insert t;
        TaskOperation.auraUpdateTask(t);
    }

    @isTest
    static void auraDelTask(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')];
        Task t = new Task();
        t.WhatId = oList.get(0).Id;
        t.TaskSubtype = 'Task';
        t.OwnerId = UserInfo.getUserId();
        insert t;
        TaskOperation.auraDelTask(t);
    }
}