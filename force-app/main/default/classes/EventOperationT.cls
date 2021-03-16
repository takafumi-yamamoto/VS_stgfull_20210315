@isTest
public class EventOperationT {

    @testSetup
    static void setup() {
        Account sacc=new Account();
        sacc.Name='soryo';
        sacc.Phone='088-0000-0001';
        sacc.MobilePhone__c='888-0000-0001';
        sacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
        insert sacc;

        Contact scon = new Contact();
        scon.AccountId = sacc.Id;
        scon.LastName = 'soryo';
        scon.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId();
        insert scon;

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        //acc.LastNameFurigana__pc ='defualt';
        //acc.FirstNameFurigana__pc ='defualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
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
                            RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawaseWebForm').getRecordTypeId(),
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
    static void auraGetEventHistorys(){
        List<Opportunity> oList = [select Id from Opportunity where RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()];
        Event evt = new Event();
        evt.WhatId = oList.get(0).Id;
        evt.WhoId = [select Id from Contact where LastName = 'soryo'].Id;
        EventOperation.auraGetEventHistorys(oList.get(0).Id);
    }
    
}