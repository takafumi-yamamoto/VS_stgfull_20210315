@isTest
private class OboSendSurveyBatT {

    private static Map<Integer, String> sendPattern = new Map<Integer, String>();
    private static Map<Integer, String> noSendPattern = new Map<Integer, String>();
    private static Map<Integer, String> calloutSmsErrorPattern = new Map<Integer, String>();
    private static final String DT_FMT = 'yyyy-MM-dd';

    private static void setSendPattern(){
        sendPattern.put(1, '1_SMS_葬儀読経アンケート');
        sendPattern.put(2, '2_Eメール_法要_戒名アンケート');
        sendPattern.put(3, '3_SMS_法要アンケート');
        sendPattern.put(4, '4_Eメール_戒名アンケート');
    }

    private static void setSendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = sendPattern.get(1);
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-5549-1867';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(nameNo1, accNo1, oboNo1);
        oppOboNo1.Iriguchi__c = 'FD';
        insert oppOboNo1;
        CaseSurveyVisca__c cSurveyNo1 = surveyFactory.createDeliveryObo(oppOboNo1, surveyNo1, accNo1, Date.today());
        // No2
        String nameNo2 = sendPattern.get(2);
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('お坊さん便アンケート_法要_戒名');
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MailAddress__c = 'accNo2@example.com';
        insert accNo2;
        Obosanbin__c oboNo2 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo2;
        Opportunity oppOboNo2 = surveyFactory.generateOppObo(nameNo2, accNo2, oboNo2);
        oppOboNo2.Iriguchi__c = 'FD';
        insert oppOboNo2;
        CaseSurveyVisca__c cSurveyNo2 = surveyFactory.createDeliveryObo(oppOboNo2, surveyNo2, accNo2, Date.today());
        // No3
        String nameNo3 = sendPattern.get(3);
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('お坊さん便アンケート_法要');
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MobilePhone__c = '090-5549-1867';
        insert accNo3;
        Obosanbin__c oboNo3 = new Obosanbin__c(
            MemorialServicePlan__c = '三回忌法要'
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo3;
        Opportunity oppOboNo3 = surveyFactory.generateOppObo(nameNo3, accNo3, oboNo3);
        oppOboNo3.Iriguchi__c = 'FD';
        insert oppOboNo3;
        CaseSurveyVisca__c cSurveyNo3 = surveyFactory.createDeliveryObo(oppOboNo3, surveyNo3, accNo3, Date.today());
        // No4
        String nameNo4 = sendPattern.get(4);
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('お坊さん便アンケート_戒名');
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MobilePhone__c = '090-5549-1867';
        accNo4.MailAddress__c = 'accNo4@example.com';
        accNo4.KoukokuSmsNg__c = true;
        insert accNo4;
        Obosanbin__c oboNo4 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KAIMYO_OR_HOMYO_ONLY
        );
        insert oboNo4;
        Opportunity oppOboNo4 = surveyFactory.generateOppObo(nameNo4, accNo4, oboNo4);
        oppOboNo4.Iriguchi__c = 'FD';
        insert oppOboNo4;
        CaseSurveyVisca__c cSurveyNo4 = surveyFactory.createDeliveryObo(oppOboNo4, surveyNo4, accNo4, Date.today());
        
    }

    private static void setNoSendPattern() {
        noSendPattern.put(1, '1_作成日昨日');
        noSendPattern.put(2, '2_送信停止');
        noSendPattern.put(3, '3_携帯電番号削除された');
        noSendPattern.put(4, '4_メールアドレス削除された');
    }

    private static void setNoSendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = noSendPattern.get(1);
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-5549-1867';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(nameNo1, accNo1, oboNo1);
        oppOboNo1.Iriguchi__c = 'FD';
        insert oppOboNo1;
        CaseSurveyVisca__c cSurveyNo1 = surveyFactory.createDeliveryObo(oppOboNo1, surveyNo1, accNo1, Date.today().addDays(-1));
        // No2
        String nameNo2 = noSendPattern.get(2);
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-5549-1867';
        accNo2.MailAddress__c = 'accNo2@example.com';
        insert accNo2;
        Obosanbin__c oboNo2 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo2;
        Opportunity oppOboNo2 = surveyFactory.generateOppObo(nameNo2, accNo2, oboNo2);
        oppOboNo2.Iriguchi__c = 'FD';
        insert oppOboNo2;
        CaseSurveyVisca__c cSurveyNo2 = surveyFactory.createDeliveryObo(oppOboNo2, surveyNo2, accNo2, Date.today());
        cSurveyNo2.StopSendFlg__c = true;  
        update cSurveyNo2;
        // No3
        String nameNo3 = noSendPattern.get(3);
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MobilePhone__c = '090-5549-1867';
        accNo3.MailAddress__c = 'accNo3@example.com';
        insert accNo3;
        Obosanbin__c oboNo3 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo3;
        Opportunity oppOboNo3 = surveyFactory.generateOppObo(nameNo3, accNo3, oboNo3);
        oppOboNo3.Iriguchi__c = 'FD';
        insert oppOboNo3;
        CaseSurveyVisca__c cSurveyNo3 = surveyFactory.createDeliveryObo(oppOboNo3, surveyNo3, accNo3, Date.today().addDays(-1));
        accNo3.MobilePhone__c = null;
        update accNo3;
        // No4
        String nameNo4 = noSendPattern.get(4);
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Obosanbin__c oboNo4 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo4;
        Opportunity oppOboNo4 = surveyFactory.generateOppObo(nameNo4, accNo4, oboNo4);
        oppOboNo4.Iriguchi__c = 'FD';
        insert oppOboNo4;
        CaseSurveyVisca__c cSurveyNo4 = surveyFactory.createDeliveryObo(oppOboNo4, surveyNo4, accNo4, Date.today().addDays(-1));
        accNo4.MailAddress__c = null;
        update accNo4;
    }

    private static void setCalloutSmsErrorPattern(){
        calloutSmsErrorPattern.put(1, '1_AccreteSmsError');
    }

    private static void setCalloutSmsErrorDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = calloutSmsErrorPattern.get(1);
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-5549-1867';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(nameNo1, accNo1, oboNo1);
        oppOboNo1.Iriguchi__c = 'FD';
        insert oppOboNo1;
        CaseSurveyVisca__c cSurveyNo1 = surveyFactory.createDeliveryObo(oppOboNo1, surveyNo1, accNo1, Date.today());
    }

    private static List<CaseSurveyVisca__c> getRslts() {
        return [
            SELECT
                OppRef__r.Name
                ,SmsSendFlg__c
                ,SmsSendDatetime__c
                ,SmsSendCount__c
                ,EmailSendFlg__c
                ,EmailSendDatetime__c
                ,EmailSendCount__c
            FROM
                CaseSurveyVisca__c
        ];
    } 

    private static List<MailAlert__c> getRsltMailAlerts() {
        return [
            SELECT
                Id
            FROM
                MailAlert__c
        ];
    }

    private static void debugRslt(CaseSurveyVisca__c cs) {
        System.debug(cs.OppRef__r.Name);
        System.debug(cs.SmsSendFlg__c);
        System.debug(cs.SmsSendDatetime__c);
        System.debug(cs.SmsSendCount__c);
        System.debug(cs.EmailSendFlg__c);
        System.debug(cs.EmailSendDatetime__c);
        System.debug(cs.EmailSendCount__c);
    }

    private static void assertSend(CaseSurveyVisca__c cs, String no, String sendMethod) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c; 
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(
            Datetime.now().format(DT_FMT)
            ,sendDt.format(DT_FMT)
            ,failMsgPrefix + ' datetime fail'
        );
        System.assertEquals(1, sendCnt, failMsgPrefix + ' count fail');
    }

    private static void assertUnsend(CaseSurveyVisca__c cs, String no, String sendMethod) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c; 
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(null, sendDt,  failMsgPrefix + ' datetime fail');
        System.assertEquals(0,    sendCnt, failMsgPrefix + ' count fail');
    }

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
    private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
        Utility_Common.isMimicExecAsDataIkouProfile = false;
    }

    @isTest
    static void testSchedule() {
        Test.startTest();
        Datetime sendDate = Datetime.now().addSeconds(10);
        String year = String.valueOf(sendDate.year());      // 年
        String month = String.valueOf(sendDate.month());    // 月
        String day = String.valueOf(sendDate.day());        // 日
        String hour = String.valueOf(sendDate.hour());      // 時間
        String minute = String.valueOf(sendDate.minute());  // 分
        String second = String.valueOf(sendDate.second());  // 秒

        String sch = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ' + '?' + ' ' + year;
        System.schedule('TestOboSendSurveyBatT' + year + month + day + hour + minute + second, sch, new OboSendSurveyBat());
        Test.stopTest();
    }

    @isTest
    static void testSends() {
        beginSetUp();
        setSendPattern();
        setSendDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        OboSendSurveyBat batchable = new OboSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<MailAlert__c> rsltMailAlerts = getRsltMailAlerts();
        System.assertEquals(2, rsltMailAlerts.size(), 'email all send count fail');

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == sendPattern.get(1)) {
                assertSend(r,   'No1', 'sms');
                assertUnsend(r, 'No1', 'email');
            } else if (r.OppRef__r.Name == sendPattern.get(2)) {
                assertUnsend(r, 'No2', 'sms');
                assertSend(r,   'No2', 'email');
            } else if (r.OppRef__r.Name == sendPattern.get(3)) {
                assertSend(r,   'No3', 'sms');
                assertUnsend(r, 'No3', 'email');
            } else if (r.OppRef__r.Name == sendPattern.get(4)) {
                assertUnsend(r, 'No4', 'sms');
                assertSend(r,   'No4', 'email');
            }
        }
    }

    @isTest
    static void testNoSend() {
        beginSetUp();
        setNoSendPattern();
        setNoSendDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        OboSendSurveyBat batchable = new OboSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == noSendPattern.get(1)) {
                assertUnsend(r, 'No1', 'sms');
                assertUnsend(r, 'No1', 'email');
            } else if (r.OppRef__r.Name == noSendPattern.get(2)) {
                assertUnsend(r, 'No2', 'sms');
                assertUnsend(r, 'No2', 'email');
            } else if (r.OppRef__r.Name == noSendPattern.get(3)) {
                assertUnsend(r, 'No3', 'sms');
                assertUnsend(r, 'No3', 'email');
            } else if (r.OppRef__r.Name == noSendPattern.get(4)) {
                assertUnsend(r, 'No4', 'sms');
                assertUnsend(r, 'No4', 'email');
            }
        }
    }

    @isTest
    static void testCalloutErrorSmsReg() {
        beginSetUp();
        setCalloutSmsErrorPattern();
        setCalloutSmsErrorDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(502);
        Test.setMock(HttpCalloutMock.class, mock);
        OboSendSurveyBat batchable = new OboSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            if (r.OppRef__r.Name == calloutSmsErrorPattern.get(1)) {
                assertUnsend(r, 'No1', 'sms');
            }
        }
    }
}