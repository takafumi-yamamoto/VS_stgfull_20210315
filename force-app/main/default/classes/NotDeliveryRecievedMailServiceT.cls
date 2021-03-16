@isTest
private class NotDeliveryRecievedMailServiceT {

@testSetup
    static void initializeTestData() {
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = defualtAccountRT.Id;
        insert dacc;

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        //ケース（レコードタイプ：メールの場合）
        case c=new case(accountid=dacc.id,
                            RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mail').getRecordTypeId(),
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
    //ケースのセッションIDを作り出せないため、紐づくケースがない場合のテストのみ
    private static testMethod void execute_success() {

        Case mailcase = [SELECT ID FROM Case WHERE Firstname__c = 'Firstname'];
        Test.startTest();

        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test Success';
        email.fromname = 'FirstName LastName';
        email.fromAddress = 'fromaddress@email.com';
        email.toAddresses = new List<String>{'toaddress@email.com'};
        email.plainTextBody = 'ref:_00Dxx1gEW._500xxYktl:ref';
        //バイナリの添付ファイル
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>();
        Messaging.InboundEmail.BinaryAttachment batt = new Messaging.InboundEmail.BinaryAttachment();
        batt.body = Blob.toPDF('TestString');
        batt.fileName = 'TestFileName';

        email.binaryAttachments.add(batt);
        //テキストの添付ファイル
        email.textAttachments = new List<Messaging.InboundEmail.TextAttachment>();
        Messaging.InboundEmail.TextAttachment tatt = new Messaging.InboundEmail.TextAttachment();
        tatt.body = 'textAttachment';
        tatt.charset = 'utf-8';
        tatt.fileName = 'ForwardedAttachment_1.txt';
        email.textAttachments.add(tatt);

        NotDeliveryRecievedMailService emailService = new NotDeliveryRecievedMailService();
        Messaging.InboundEmailResult res = emailService.handleInboundEmail(email, env);
        
        Test.stopTest();
  }

}