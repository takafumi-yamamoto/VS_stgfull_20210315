/**
 * メール・メッセージトリガーハンドラーのテストクラス
 * ・メール-to-ケースで受けたメールの内容により、ケースの項目を更新する
 * ・メール-to-ケースで送信するときに不達フラグをはずす
 */
 @isTest
private class MailToCaseHandlerT {

    private static List<MailFuriwakeDef__mdt> mailFuriwakeServiceList = MailFuriwakeConfig.f_CachedMailFuriwakeList;
    private static List<MailLabelFuriwakeDef__mdt> labelFuriwakeList = MailFuriwakeConfig.f_CachedMailLabelFuriwakeList;
    private static List<MailKinkyuLevelFuriwakeDef__mdt> levelFuriwakeList = MailFuriwakeConfig.f_CachedMailKinkyuLevelFuriwakeList;
    private static List<MailFutatsuDef__mdt> futatsuList = MailFuriwakeConfig.f_CachedFutatsuAddressList;

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
        List<Case> insertCaseList = new List<Case>();
        for(Integer i = 0;i < 7;i++){
            case c=new case(accountid=dacc.id,
                            RecordTypeId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Mail'),
                            Firstname__c='Firstname',
                            Lastname__c='Lastname',
                            FirstNameKana__c='ファストカナ'+i,
                            LastNameKana__c='ラストカナ',
                            TelNo__c='080-8888-8888',
                            KiboAreaState__c='東京都',
                            KiboAreaCity__c='中央区',
                            MailAddress__c='test@i.ss.com',
                            MailFuriwakeServiceName__c='よりそうのお葬式サポート');
            insertCaseList.add(c);
        }
        
        insert insertCaseList;

    }

    // メール受信時のテスト（サービスの振分）
    static testMethod void ReceiveMailFuriwakeService(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];
        for(Case c:testCaseList){
            c.MailFuriwakeServiceName__c = 'SMS';
        }
        update testCaseList;
        Test.startTest();
        //メールメッセージの作成
        //　メールアドレス　|  件名  |  本文
        //  　　　有       |   有   |   有
        List<EmailMessage> emList = new List<EmailMessage>();
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'test@yoriso.com';
        em.FromAddress = 'test@salesforce.com';
        em.Incoming = true;
        em.Subject = 'test';
        em.TextBody = 'test';
        emList.add(em);
        //  　　　有       |   有   |   無
        EmailMessage em2 = new EmailMessage();
        em2.ParentId = testCaseList.get(1).Id;
        em2.ToAddress = 'test@yoriso.com';
        em2.FromAddress = 'test@salesforce.com';
        em2.Incoming = true;
        em2.Subject = 'test2';
        em2.TextBody = '　';
        emList.add(em2);
        //  　　　有       |   無   |   有
        EmailMessage em3 = new EmailMessage();
        em3.ParentId = testCaseList.get(2).Id;
        em3.ToAddress = 'test@yoriso.com';
        em3.FromAddress = 'test@salesforce.com';
        em3.Incoming = true;
        em3.Subject = '';
        em3.TextBody = 'test3';
        emList.add(em3);
        //  　　　有       |   無   |   無
        EmailMessage em4 = new EmailMessage();
        em4.ParentId = testCaseList.get(3).Id;
        em4.ToAddress = 'test4@yoriso.com';
        em4.FromAddress = 'test@salesforce.com';
        em4.Incoming = true;
        em4.Subject = 'test4';
        em4.TextBody = 'test4 honbun';
        emList.add(em4);
        //  　　　無       |   有   |   有
        EmailMessage em5 = new EmailMessage();
        em5.ParentId = testCaseList.get(4).Id;
        em5.ToAddress = 'test5@yoriso.com';
        em5.FromAddress = 'test@salesforce.com';
        em5.Incoming = true;
        em5.Subject = 'test5';
        em5.TextBody = 'test5honbun';
        emList.add(em5);
        //  　　　無       |   有   |   無
        EmailMessage em6 = new EmailMessage();
        em6.ParentId = testCaseList.get(5).Id;
        em6.ToAddress = 'test5@yoriso.com';
        em6.FromAddress = 'test@salesforce.com';
        em6.Incoming = true;
        em6.Subject = 'SMS';
        em6.TextBody = ' ';
        emList.add(em6);
        //  　　　無       |   無   |   有
        EmailMessage em7 = new EmailMessage();
        em7.ParentId = testCaseList.get(6).Id;
        em7.ToAddress = 'test5@yoriso.com';
        em7.FromAddress = 'test@salesforce.com';
        em7.Incoming = true;
        em7.Subject = '';
        em7.TextBody = 'SMS';
        emList.add(em7);

        insert emList;
        Test.stopTest();

        List<Case> resultCaseList = [SELECT Id,MailFuriwakeServiceName__c FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];
        for(Case c:resultCaseList){
            System.assertEquals('SMS',c.MailFuriwakeServiceName__c);
        }

    }

    // メール受信時のテスト(メール不達のテスト)
    static testMethod void ReceiveMailFutatsuChk(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];
        
        Test.startTest();
        //メールメッセージの作成
        //　メールアドレス　|  件名  |  本文
        List<EmailMessage> emList = new List<EmailMessage>();
        //  　　　有       |   無   |   無
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'sougi-service@yoriso.com';
        em.FromAddress = 'mailer-daemon@salesforce.com';
        em.Incoming = true;
        emList.add(em);
        //  　　　有       |   有   |   有
        EmailMessage em2 = new EmailMessage();
        em2.ParentId = testCaseList.get(1).Id;
        em2.ToAddress = 'sougi-service@yoriso.com';
        em2.FromAddress = 'no-reply@sns.amazonaws.com';
        em2.Incoming = true;
        em2.Subject = 'メール未達';
        em2.TextBody = 'メールが送信できません';
        emList.add(em2);
        //  　　　無       |   有   |   無
        EmailMessage em3 = new EmailMessage();
        em3.ParentId = testCaseList.get(2).Id;
        em3.ToAddress = 'sougi-service@yoriso.com';
        em3.FromAddress = 'test@sns.amazonaws.com';
        em3.Incoming = true;
        em3.Subject = 'Undeliverable';
        em3.TextBody = '';
        emList.add(em3);
        //  　　　無       |   無   |   有
        EmailMessage em4 = new EmailMessage();
        em4.ParentId = testCaseList.get(3).Id;
        em4.ToAddress = 'sougi-service@yoriso.com';
        em4.FromAddress = 'no-reply@sns.amazonaws.com';
        em4.Incoming = true;
        em4.Subject = '';
        em4.TextBody = '送信されなかった可能性';
        emList.add(em4);

        insert emList;
        Test.stopTest();

        List<Case> resultCaseList = [SELECT Id,MailFutatsu__c FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c LIMIT 4];
        for(Case c:resultCaseList){
            System.assert(c.MailFutatsu__c);
        }

    }

    // メール受信時のテスト(ラベルの振分テスト)
    static testMethod void ReceiveMailFuriwakeLabel(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];

        Test.startTest();
        //メールメッセージの作成
        //　メールアドレス　|  件名  |  本文
        //  　　　有       |   有   |   有
        List<EmailMessage> emList = new List<EmailMessage>();
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'sougi-service@yoriso.com';
        em.FromAddress = 'test@salesforce.com';
        em.Subject = 'Web決済 / 完了通知';
        em.TextBody = 'クレカ (GMO)';
        em.Incoming = true;
        emList.add(em);
        //  　　　有       |   無   |   有
        EmailMessage em2 = new EmailMessage();
        em2.ParentId = testCaseList.get(0).Id;
        em2.ToAddress = 'sougi-service@yoriso.com';
        em2.FromAddress = 'test@salesforce.com';
        em2.Subject = 'お問い合わせ';
        em2.TextBody = '死亡';
        em2.Incoming = true;
        emList.add(em2);


        EmailMessage em3 = new EmailMessage();
        em3.ParentId = testCaseList.get(1).Id;
        em3.ToAddress = 'sougi-service@yoriso.com';
        em3.FromAddress = 'zook@eajt.co.jp';
        em3.Subject = '信託';
        em3.TextBody = 'test';
        em3.Incoming = true;
        emList.add(em3);

        insert emList;
        Test.stopTest();

        Case resultCase1 = [
                    SELECT
                        Id
                        ,MailLabel__c
                    FROM Case
                    WHERE Id = :testCaseList.get(0).Id
        ];
        System.assertEquals('01-お問い合わせ', resultCase1.MailLabel__c);
        Case resultCase2 = [
                    SELECT
                        Id
                        ,MailLabel__c
                    FROM Case
                    WHERE Id = :testCaseList.get(1).Id
        ];
        System.assertEquals('12-EAJ信託', resultCase2.MailLabel__c);
    }

    // メール受信時のテスト(レベルの振分テスト)
    static testMethod void ReceiveMailFuriwakeLevel(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];

        List<MailKinkyuLevelFuriwakeDef__mdt> levelfuriwakeCondList = [
                                                                SELECT
                                                                    ID
                                                                    ,MasterLabel
                                                                FROM MailKinkyuLevelFuriwakeDef__mdt
                                                                WHERE ToMailAddress__c = 'sougi-service@yoriso.com'
                                                                AND TargetContents__c like '%死亡%'
                                                            ];
        
        String shiboLevel = levelfuriwakeCondList.get(0).MasterLabel;



        Test.startTest();
        //メールメッセージの作成
        //　メールアドレス　|  件名  |  本文
        //  　　　有       |   無   |   有
        List<EmailMessage> emList = new List<EmailMessage>();
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'sougi-service@yoriso.com';
        em.FromAddress = 'test@salesforce.com';
        em.Subject = 'xxxxxx';
        em.TextBody = '死亡';
        em.Incoming = true;
        emList.add(em);
        //  　　　有       |   有   |   有
        EmailMessage em2 = new EmailMessage();
        em2.ParentId = testCaseList.get(0).Id;
        em2.ToAddress = 'mailtocase-test@yoriso.com';
        em2.FromAddress = 'test@salesforce.com';
        em2.Subject = '健在';
        em2.TextBody = '健在';
        em2.Incoming = true;
        emList.add(em2);

        insert emList;
        Test.stopTest();

        Case resultCase = [
                    SELECT
                        Id
                        ,EmergencyLevelMail__c
                    FROM Case
                    WHERE Id = :testCaseList.get(0).Id
        ];

        if(String.isNotBlank(shiboLevel)){
            System.assertEquals(shiboLevel, resultCase.EmergencyLevelMail__c);
        }
    }


    // メール送信時のテスト1
    static testMethod void SendMail1(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];
        testCaseList.get(0).MailFutatsu__c = true;
        update testCaseList.get(0);

        Test.startTest();
        //メールメッセージの作成
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'sougi-service@yoriso.com';
        em.FromAddress = 'sougi-service@yoriso.com';
        em.Incoming = false;
        insert em;
        Test.stopTest();

        Case resultCase = [
                    SELECT
                        Id
                        ,MailFutatsu__c
                    FROM Case
                    WHERE Id = :testCaseList.get(0).Id
        ];
        System.assert(!resultCase.MailFutatsu__c);
    }
    // メールメッセージ更新時のテスト
    static testMethod void EmailMessageUpdate(){

        String masterlabel;
        String mailaddress;
        for(MailFuriwakeDef__mdt mfuriwake:mailFuriwakeServiceList){
            if('sougi-service@yoriso.com'.equals(mfuriwake.ToMailAddress__c) && String.isBlank(mfuriwake.TargetSubject__c) && String.isBlank(mfuriwake.TargetContents__c)){
                masterlabel = mfuriwake.MasterLabel;
                mailaddress = mfuriwake.ToMailAddress__c;
                break;
            }
        }

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];
        testCaseList.get(0).MailFuriwakeServiceName__c = masterlabel;
        update testCaseList.get(0);

        Test.startTest();
        //メールメッセージの作成
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'test@yoriso.com';
        em.FromAddress = mailaddress;
        em.Incoming = false; //送信
        em.PassWordMail__c = 'password_test';
        em.PasswordAri__c = true;
        insert em;

        em.ApproveStatus__c = MailToCaseHandler.APPRV_STATUS_SHONIN;
        update em;

        Test.stopTest();

    }

    // メールメッセージ更新時のテスト（エラー時）FromAddressNothingException 発生時
    static testMethod void EmailMessageUpdateError(){

        List<Case> testCaseList = [SELECT Id FROM Case WHERE MailAddress__c = 'test@i.ss.com' Order By FirstNameKana__c];

        Test.startTest();
        //メールメッセージの作成
        EmailMessage em = new EmailMessage();
        em.ParentId = testCaseList.get(0).Id;
        em.ToAddress = 'sougi-service@yoriso.com';
        // em.FromAddress = 'test@yoriso.com';
        em.FromAddress = 'mailtocase-test@yoriso.com';
        em.Incoming = false; //送信
        em.PassWordMail__c = 'password_test';
        em.PasswordAri__c = true;
        insert em;
        em.ApproveStatus__c = MailToCaseHandler.APPRV_STATUS_SHONIN;
        update em;

        Test.stopTest();

    }

}