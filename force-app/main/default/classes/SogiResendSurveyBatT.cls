@isTest
private class SogiResendSurveyBatT {

    private static Map<Integer, String> resendPattern = new Map<Integer, String>();
    private static Map<Integer, String> noResendPattern = new Map<Integer, String>();
    private static Map<Integer, String> exclusivePattern = new Map<Integer, String>();
    private static Map<Integer, String> calloutSmsErrorPattern = new Map<Integer, String>();
    private static final Datetime BEFORE_7DAY  = Date.today().addDays(-7);
    private static final Datetime BEFORE_14DAY = Date.today().addDays(-14);
    private static final Datetime BEFORE_6DAY  = Date.today().addDays(-6);
    private static final Datetime BEFORE_8DAY  = Date.today().addDays(-8);
    private static final Datetime BEFORE_15DAY = Date.today().addDays(-15);
    private static final String DT_FMT = 'yyyy-MM-dd';

    private static void setResendPattern(){
        resendPattern.put(1, '1_アンケート_SMS+Email');
        resendPattern.put(2, '2_アンケート_SMS');
        resendPattern.put(3, '3_アンケート_Email');
        resendPattern.put(4, '4_アンケート_SMS+Email_2週間後');
        resendPattern.put(5, '5_アンケート_SMS_2週間後');
        resendPattern.put(6, '6_アンケート_Email_2週間後');
    }

    private static void setResendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = resendPattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(nameNo1, accNo1);
        insert oppSogiNo1;
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 =
            surveyFactory.generateDelivery(oppSogiNo1, surveyNo1, BEFORE_8DAY);
        cSurveyNo1.SmsSendCount__c = 1;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo1.EmailSendCount__c = 1;
        cSurveyNo1.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo1;
        // No2
        String nameNo2 = resendPattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-0000-0000';
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(nameNo2, accNo2);
        insert oppSogiNo2;
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo2 =
            surveyFactory.generateDelivery(oppSogiNo2, surveyNo2, BEFORE_8DAY);
        cSurveyNo2.SmsSendCount__c = 1;
        cSurveyNo2.SmsSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo2;
        // No3
        String nameNo3 = resendPattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MailAddress__c = 'accNo1@example.com';
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(nameNo3, accNo3);
        insert oppSogiNo3;
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('後葬_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo3 =
            surveyFactory.generateDelivery(oppSogiNo3, surveyNo3, BEFORE_8DAY);
        cSurveyNo3.EmailSendCount__c = 1;
        cSurveyNo3.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo3;
        // No4
        String nameNo4 = resendPattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MobilePhone__c = '090-0000-0000';
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(nameNo4, accNo4);
        insert oppSogiNo4;
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo4 =
            surveyFactory.generateDelivery(oppSogiNo4, surveyNo4, BEFORE_15DAY);
        cSurveyNo4.SmsSendCount__c = 2;
        cSurveyNo4.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo4.EmailSendCount__c = 2;
        cSurveyNo4.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo4;
        // No5
        String nameNo5 = resendPattern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo5.MobilePhone__c = '090-0000-0000';
        insert accNo5;
        Opportunity oppSogiNo5 = surveyFactory.generateBaseOpp(nameNo5, accNo5);
        insert oppSogiNo5;
        Survey__c surveyNo5 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo5 =
            surveyFactory.generateDelivery(oppSogiNo5, surveyNo5, BEFORE_15DAY);
        cSurveyNo5.SmsSendCount__c = 2;
        cSurveyNo5.SmsSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo5;
        // No6
        String nameNo6 = resendPattern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(nameNo6);
        accNo6.MailAddress__c = 'accNo1@example.com';
        insert accNo6;
        Opportunity oppSogiNo6 = surveyFactory.generateBaseOpp(nameNo6, accNo6);
        insert oppSogiNo6;
        Survey__c surveyNo6 = surveyFactory.getSurveyByName('後葬_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo6 =
            surveyFactory.generateDelivery(oppSogiNo6, surveyNo6, BEFORE_15DAY);
        cSurveyNo6.EmailSendCount__c = 2;
        cSurveyNo6.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo6;
    }

    private static void setNoResendPattern() {
        noResendPattern.put(1, '1_SMS+Email送信回数が3');
        noResendPattern.put(2, '2_SMS送信日時が-8day_送信回数2');
        noResendPattern.put(3, '3_SMS送信日時が-6day_送信回数1');
        noResendPattern.put(4, '4_Email送信日時が-6day_送信回数2');
        noResendPattern.put(5, '5_Email送信日時が-8day_送信回数1');
        noResendPattern.put(6, '6_アンケートURLがnull');
        noResendPattern.put(7, '7_送信停止フラグON');
        noResendPattern.put(8, '8_携帯電話番号とメアド削除された');
        noResendPattern.put(9, '9_葬儀商談でない');
        noResendPattern.put(10, '10_回答済み');
    }

    private static void setNoResendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = noResendPattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(nameNo1, accNo1);
        insert oppSogiNo1;
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 =
            surveyFactory.generateDelivery(oppSogiNo1, surveyNo1, Date.today().addDays(-15));
        cSurveyNo1.SmsSendCount__c = 3;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo1.EmailSendCount__c = 3;
        cSurveyNo1.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo1;
        // No2
        String nameNo2 = noResendPattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-0000-0000';
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(nameNo2, accNo2);
        insert oppSogiNo2;
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo2 =
            surveyFactory.generateDelivery(oppSogiNo2, surveyNo2, Date.today().addDays(-16));
        cSurveyNo2.SmsSendCount__c = 2;
        cSurveyNo2.SmsSendDatetime__c = BEFORE_8DAY;
        insert cSurveyNo2;
        // No3
        String nameNo3 = noResendPattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MobilePhone__c = '090-0000-0000';
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(nameNo3, accNo3);
        insert oppSogiNo3;
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo3 =
            surveyFactory.generateDelivery(oppSogiNo3, surveyNo3, Date.today().addDays(-7));
        cSurveyNo3.SmsSendCount__c = 1;
        cSurveyNo3.SmsSendDatetime__c = BEFORE_6DAY;
        insert cSurveyNo3;
        // No4
        String nameNo4 = noResendPattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(nameNo4, accNo4);
        insert oppSogiNo4;
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo4 =
            surveyFactory.generateDelivery(oppSogiNo4, surveyNo4, Date.today().addDays(-7));
        cSurveyNo4.EmailSendCount__c = 2;
        cSurveyNo4.EmailSendDatetime__c = BEFORE_6DAY;
        insert cSurveyNo4;
        // No5
        String nameNo5 = noResendPattern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Opportunity oppSogiNo5 = surveyFactory.generateBaseOpp(nameNo5, accNo5);
        insert oppSogiNo5;
        Survey__c surveyNo5 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo5 =
            surveyFactory.generateDelivery(oppSogiNo5, surveyNo5, Date.today().addDays(-9));
        cSurveyNo5.EmailSendCount__c = 1;
        cSurveyNo5.EmailSendDatetime__c = BEFORE_8DAY;
        insert cSurveyNo5;
        // No6
        String nameNo6 = noResendPattern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(nameNo6);
        accNo6.MailAddress__c = 'accNo6@example.com';
        insert accNo6;
        Opportunity oppSogiNo6 = surveyFactory.generateBaseOpp(nameNo6, accNo6);
        oppSogiNo6.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo6.SurveySendWayHopeSms__c = false;
        oppSogiNo6.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo6;
        CaseSurveyVisca__c cSurveyNo6 =
            surveyFactory.generateDelivery(oppSogiNo6, null, BEFORE_8DAY);
        cSurveyNo6.EmailSendCount__c = 1;
        cSurveyNo6.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyno6;
        // No7
        String nameNo7 = noResendPattern.get(7);
        Account accNo7 = surveyFactory.generateAccCustomer(nameNo7);
        accNo7.MobilePhone__c = '090-0000-0000';
        accNo7.MailAddress__c = 'accNo7@example.com';
        insert accNo7;
        Opportunity oppSogiNo7 = surveyFactory.generateBaseOpp(nameNo7, accNo7);
        insert oppSogiNo7;
        Survey__c surveyNo7 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo7 =
            surveyFactory.generateDelivery(oppSogiNo7, surveyNo7, BEFORE_8DAY);
        cSurveyNo7.SmsSendCount__c = 1;
        cSurveyNo7.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo7.EmailSendCount__c = 1;
        cSurveyNo7.EmailSendDatetime__c = BEFORE_7DAY;
        cSurveyNo7.StopSendFlg__c = true;
        insert cSurveyNo7;
        // No8
        String nameNo8 = noResendPattern.get(8);
        Account accNo8 = surveyFactory.generateAccCustomer(nameNo8);
        accNo8.MobilePhone__c = '090-0000-0000';
        accNo8.MailAddress__c = 'accNo8@example.com';
        insert accNo8;
        Opportunity oppSogiNo8 = surveyFactory.generateBaseOpp(nameNo8, accNo8);
        insert oppSogiNo8;
        Survey__c surveyNo8 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo8 =
            surveyFactory.generateDelivery(oppSogiNo8, surveyNo8, BEFORE_8DAY);
        cSurveyNo8.SmsSendCount__c = 1;
        cSurveyNo8.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo8.EmailSendCount__c = 1;
        cSurveyNo8.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo8;
        accNo8.MobilePhone__c = null;
        accNo8.MailAddress__c = null;
        update accNo8;
        // No9
        String nameNo9 = noResendPattern.get(9);
        Survey__c surveyNo9 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo9 = surveyFactory.generateAccCustomer(nameNo9);
        accNo9.MobilePhone__c = '090-5549-1867';
        insert accNo9;
        Obosanbin__c oboNo9 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo9;
        Opportunity oppOboNo9 = surveyFactory.generateOppObo(nameNo9, accNo9, oboNo9);
        oppOboNo9.Iriguchi__c = 'FD';
        insert oppOboNo9;
        CaseSurveyVisca__c cSurveyNo9 =
            surveyFactory.createDeliveryObo(oppOboNo9, surveyNo9, accNo9, BEFORE_8DAY);
        cSurveyNo9.SmsSendCount__c = 1;
        cSurveyNo9.SmsSendDatetime__c = BEFORE_7DAY;
        update cSurveyNo9;
        // No10
        String nameNo10 = noResendPattern.get(10);
        Account accNo10 = surveyFactory.generateAccCustomer(nameNo10);
        accNo10.MobilePhone__c = '090-0000-0000';
        accNo10.MailAddress__c = 'accNo1@example.com';
        insert accNo10;
        Opportunity oppSogiNo10 = surveyFactory.generateBaseOpp(nameNo10, accNo10);
        insert oppSogiNo10;
        Survey__c surveyNo10 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo10 =
            surveyFactory.generateDelivery(oppSogiNo10, surveyNo10, BEFORE_8DAY);
        cSurveyNo10.SmsSendCount__c = 1;
        cSurveyNo10.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo10.EmailSendCount__c = 1;
        cSurveyNo10.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo10;
        Map<String, String> answersNo10 = surveyFactory.generateDefaultAnswerMap();
        surveyFactory.createTaker(
            cSurveyNo10.Id
            ,surveyNo10.Id
            ,answersNo10
            ,'' ,'' ,'' ,'' ,''
        );
    }

    private static void setCalloutSmsErrorPattern(){
        calloutSmsErrorPattern.put(1, '1_アンケート_SMSError+Email');
    }

    private static void setCalloutSmsErrorDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = calloutSmsErrorPattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(nameNo1, accNo1);
        insert oppSogiNo1;
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 =
            surveyFactory.generateDelivery(oppSogiNo1, surveyNo1, BEFORE_8DAY);
        cSurveyNo1.SmsSendCount__c = 1;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_7DAY;
        cSurveyNo1.EmailSendCount__c = 1;
        cSurveyNo1.EmailSendDatetime__c = BEFORE_7DAY;
        insert cSurveyNo1;
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

    private static void assertResend(CaseSurveyVisca__c cs, String no, String sendMethod, Integer exptSendCnt) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c;
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(
            Datetime.now().format(DT_FMT)
            ,sendDt.format(DT_FMT)
            ,failMsgPrefix + ' datetime fail'
        );
        System.assertEquals(exptSendCnt, sendCnt, failMsgPrefix + ' count fail');
    }

    private static void assertUnresend(CaseSurveyVisca__c cs, String no, String sendMethod, Integer exptSendCnt, Datetime exptSendDt) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c;
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(
            exptSendDt.format(DT_FMT)
            ,sendDt.format(DT_FMT)
            ,failMsgPrefix + ' datetime fail'
        );
        System.assertEquals(exptSendCnt, sendCnt, failMsgPrefix + ' count fail');
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
        System.schedule('TestSogiResendSurveyBatT' + year + month + day + hour + minute + second, sch, new SogiResendSurveyBat());
        Test.stopTest();

    }

    @isTest
    static void testResend() {
        beginSetUp();
        setResendPattern();
        setResendDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        SogiResendSurveyBat batchable = new SogiResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<MailAlert__c> rsltMailAlerts = getRsltMailAlerts();
        //System.assertEquals(4, rsltMailAlerts.size(), 'email all send count fail');

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == resendPattern.get(1)) {
                assertResend(r, 'No1', 'sms',   2);
                assertResend(r, 'No1', 'email', 2);
            } else if (r.OppRef__r.Name == resendPattern.get(2)) {
                assertResend(r, 'No2', 'sms',   2);
                assertUnsend(r, 'No2', 'email');
            } else if (r.OppRef__r.Name == resendPattern.get(3)) {
                assertUnsend(r, 'No3', 'sms');
                assertResend(r, 'No3', 'email', 2);
            } else if (r.OppRef__r.Name == resendPattern.get(4)) {
                assertResend(r, 'No4', 'sms',   3);
                assertResend(r, 'No4', 'email', 3);
            } else if (r.OppRef__r.Name == resendPattern.get(5)) {
                assertResend(r, 'No5', 'sms',   3);
                assertUnsend(r, 'No5', 'email');
            } else if (r.OppRef__r.Name == resendPattern.get(6)) {
                assertUnsend(r, 'No6', 'sms');
                assertResend(r, 'No6', 'email', 3);
            }
        }
    }

    @isTest
    static void testNoResend() {
        beginSetUp();
        setNoResendPattern();
        setNoResendDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        SogiResendSurveyBat batchable = new SogiResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == noResendPattern.get(1)) {
                assertUnresend(r, 'No1', 'sms',   3, BEFORE_7DAY);
                assertUnresend(r, 'No1', 'email', 3, BEFORE_7DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(2)) {
                assertUnresend(r, 'No2', 'sms',   2, BEFORE_8DAY);
                assertUnsend(r,   'No2', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(3)) {
                assertUnresend(r, 'No3', 'sms',   1, BEFORE_6DAY);
                assertUnsend(r,   'No3', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(4)) {
                assertUnsend(r,   'No4', 'sms');
                assertUnresend(r, 'No4', 'email', 2, BEFORE_6DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(5)) {
                assertUnsend(r,   'No5', 'sms');
                assertUnresend(r, 'No5', 'email', 1, BEFORE_8DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(6)) {
                assertUnsend(r,   'No6', 'sms');
                assertUnresend(r, 'No6', 'email', 1, BEFORE_7DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(7)) {
                assertUnresend(r, 'No7', 'sms',   1, BEFORE_7DAY);
                assertUnresend(r, 'No7', 'email', 1, BEFORE_7DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(8)) {
                assertUnresend(r, 'No8', 'sms',   1, BEFORE_7DAY);
                assertUnresend(r, 'No8', 'email', 1, BEFORE_7DAY);
            } else if (r.OppRef__r.Name == noResendPattern.get(9)) {
                assertUnresend(r, 'No9', 'sms',   1, BEFORE_7DAY);
                assertUnsend(r,   'No9', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(10)) {
                assertUnresend(r, 'No10', 'sms',   1, BEFORE_7DAY);
                assertUnresend(r, 'No10', 'email', 1, BEFORE_7DAY);
            }
        }
    }

    @isTest
    static void testCalloutSmsError() {
        beginSetUp();
        setCalloutSmsErrorPattern();
        setCalloutSmsErrorDate();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(502);
        Test.setMock(HttpCalloutMock.class, mock);
        SogiResendSurveyBat batchable = new SogiResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            if (r.OppRef__r.Name == CalloutSmsErrorPattern.get(1)) {
                assertUnresend(r, 'No1', 'sms', 1, BEFORE_7DAY);
                assertResend(r,   'No1', 'email', 2);
            }
        }
    }
}