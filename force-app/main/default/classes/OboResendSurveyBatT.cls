@isTest
private class OboResendSurveyBatT {

    private static Map<Integer, String> resendPattern = new Map<Integer, String>();
    private static Map<Integer, String> noResendPattern = new Map<Integer, String>();
    private static Map<Integer, String> exclusivePattern = new Map<Integer, String>();
    private static Map<Integer, String> calloutSmsErrorPattern = new Map<Integer, String>();
    private static final Datetime BEFORE_8DAY = Date.today().addDays(-8);
    private static final Datetime BEFORE_7DAY = Date.today().addDays(-7);
    private static final Datetime BEFORE_9DAY = Date.today().addDays(-9);
    private static final String DT_FMT = 'yyyy-MM-dd';

    private static void setResendPattern(){
        resendPattern.put(1, '1_SMS_葬儀読経アンケート');
        resendPattern.put(2, '2_Eメール_法要_戒名アンケート');
        resendPattern.put(3, '3_SMS_法要アンケート');
        resendPattern.put(4, '4_Eメール_戒名アンケート');
    }

    private static void setResendData() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = resendPattern.get(1);
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
        cSurveyNo1.SmsSendCount__c = 1;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo1;
        // No2
        String nameNo2 = resendPattern.get(2);
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
        cSurveyNo2.EmailSendCount__c = 1;
        cSurveyNo2.EmailSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo2;
        // No3
        String nameNo3 = resendPattern.get(3);
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
        cSurveyNo3.SmsSendCount__c = 1;
        cSurveyNo3.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo3;
        // No4
        String nameNo4 = resendPattern.get(4);
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
        cSurveyNo4.EmailSendCount__c = 1;
        cSurveyNo4.EmailSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo4;
    }

    private static void setNoResendPattern() {
        noResendPattern.put(1, '1_SMS_送信回数2');
        noResendPattern.put(2, '2_Email_送信回数2');
        noResendPattern.put(3, '3_SMS送信日時が-7day_送信回数1');
        noResendPattern.put(4, '4_Email送信日時が-9day_送信回数1');
        noResendPattern.put(5, '5_送信停止フラグON');
        noResendPattern.put(6, '6_回答済み');
        noResendPattern.put(7, '7_携帯電番号削除された');
        noResendPattern.put(8, '8_メールアドレス削除された');
        noResendPattern.put(9, '9_お坊商談でない');
    }

    private static void setNoResendData() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = noResendPattern.get(1);
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
        cSurveyNo1.SmsSendCount__c = 2;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo1;
        // No2
        String nameNo2 = noResendPattern.get(2);
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
        cSurveyNo2.EmailSendCount__c = 2;
        cSurveyNo2.EmailSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo2;
        // No3
        String nameNo3 = noResendPattern.get(3);
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
        CaseSurveyVisca__c cSurveyNo3 = surveyFactory.createDeliveryObo(oppOboNo3, surveyNo3, accNo3, Date.today());
        cSurveyNo3.SmsSendCount__c = 1;
        cSurveyNo3.SmsSendDatetime__c = BEFORE_7DAY;
        update cSurveyNo3;
        // No4
        String nameNo4 = noResendPattern.get(4);
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('お坊さん便アンケート_法要_戒名');
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Obosanbin__c oboNo4 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo4;
        Opportunity oppOboNo4 = surveyFactory.generateOppObo(nameNo4, accNo4, oboNo4);
        oppOboNo4.Iriguchi__c = 'FD';
        insert oppOboNo4;
        CaseSurveyVisca__c cSurveyNo4 = surveyFactory.createDeliveryObo(oppOboNo4, surveyNo4, accNo4, Date.today());
        cSurveyNo4.EmailSendCount__c = 1;
        cSurveyNo4.EmailSendDatetime__c = BEFORE_9DAY;
        update cSurveyNo4;
        // No5
        String nameNo5 = noResendPattern.get(5);
        Survey__c surveyNo5 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo5.MobilePhone__c = '090-5549-1867';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Obosanbin__c oboNo5 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo5;
        Opportunity oppOboNo5 = surveyFactory.generateOppObo(nameNo5, accNo5, oboNo5);
        oppOboNo5.Iriguchi__c = 'FD';
        insert oppOboNo5;
        CaseSurveyVisca__c cSurveyNo5 = surveyFactory.createDeliveryObo(oppOboNo5, surveyNo5, accNo5, Date.today());
        cSurveyNo5.SmsSendCount__c = 1;
        cSurveyNo5.SmsSendDatetime__c = BEFORE_8DAY;
        cSurveyNo5.StopSendFlg__c = true;
        update cSurveyNo5;
        // No6
        String nameNo6 = noResendPattern.get(6);
        Survey__c surveyNo6 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo6 = surveyFactory.generateAccCustomer(nameNo6);
        accNo6.MobilePhone__c = '090-5549-1867';
        accNo6.MailAddress__c = 'accNo6@example.com';
        insert accNo6;
        Obosanbin__c oboNo6 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo6;
        Opportunity oppOboNo6 = surveyFactory.generateOppObo(nameNo6, accNo6, oboNo6);
        oppOboNo6.Iriguchi__c = 'FD';
        insert oppOboNo6;
        CaseSurveyVisca__c cSurveyNo6 = surveyFactory.createDeliveryObo(oppOboNo6, surveyNo6, accNo6, Date.today());
        cSurveyNo6.SmsSendCount__c = 1;
        cSurveyNo6.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo6;
        Map<String, String> answersNo6 = surveyFactory.generateDefaultAnswerMap();
        surveyFactory.createTaker(
            cSurveyNo6.Id
            ,surveyNo6.Id
            ,answersNo6
            ,'' ,'' ,'' ,'' ,''
        );
        // No7
        String nameNo7 = noResendPattern.get(7);
        Survey__c surveyNo7 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo7 = surveyFactory.generateAccCustomer(nameNo7);
        accNo7.MobilePhone__c = '090-5549-1867';
        accNo7.MailAddress__c = 'accNo7@example.com';
        insert accNo7;
        Obosanbin__c oboNo7 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo7;
        Opportunity oppOboNo7 = surveyFactory.generateOppObo(nameNo7, accNo7, oboNo7);
        oppOboNo7.Iriguchi__c = 'FD';
        insert oppOboNo7;
        CaseSurveyVisca__c cSurveyNo7 = surveyFactory.createDeliveryObo(oppOboNo7, surveyNo7, accNo7, Date.today());
        cSurveyNo7.SmsSendCount__c = 1;
        cSurveyNo7.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo7;
        accNo7.MobilePhone__c = null;
        update accNo7;
        // No8
        String nameNo8 = noResendPattern.get(8);
        Survey__c surveyNo8 = surveyFactory.getSurveyByName('お坊さん便アンケート_法要_戒名');
        Account accNo8 = surveyFactory.generateAccCustomer(nameNo8);
        accNo8.MailAddress__c = 'accNo8@example.com';
        insert accNo8;
        Obosanbin__c oboNo8 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo8;
        Opportunity oppOboNo8 = surveyFactory.generateOppObo(nameNo8, accNo8, oboNo8);
        oppOboNo8.Iriguchi__c = 'FD';
        insert oppOboNo8;
        CaseSurveyVisca__c cSurveyNo8 = surveyFactory.createDeliveryObo(oppOboNo8, surveyNo8, accNo8, Date.today());
        cSurveyNo8.EmailSendCount__c = 1;
        cSurveyNo8.EmailSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo8;
        accNo8.MailAddress__c = null;
        update accNo8;
        // No9
        String nameNo9 = noResendPattern.get(9);
        Survey__c surveyNo9 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        Account accNo9 = surveyFactory.generateAccCustomer(nameNo9);
        accNo9.MobilePhone__c = '090-5549-1867';
        accNo9.MailAddress__c = 'accNo9@example.com';
        insert accNo9;
        Opportunity oppSogiNo9 = surveyFactory.generateBaseOpp(nameNo9, accNo9);
        insert oppSogiNo9;
        CaseSurveyVisca__c cSurveyNo9 = surveyFactory.createDelivery(oppSogiNo9, surveyNo9);
        cSurveyNo9.SmsSendCount__c = 1;
        cSurveyNo9.SmsSendDatetime__c = BEFORE_8DAY;
        cSurveyNo9.EmailSendCount__c = 1;
        cSurveyNo9.EmailSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo9;
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
        cSurveyNo1.SmsSendCount__c = 1;
        cSurveyNo1.SmsSendDatetime__c = BEFORE_8DAY;
        update cSurveyNo1;
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

    private static void assertResend(CaseSurveyVisca__c cs, String no, String sendMethod) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c; 
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(
            Datetime.now().format(DT_FMT)
            ,sendDt.format(DT_FMT)
            ,failMsgPrefix + ' datetime fail'
        );
        System.assertEquals(2, sendCnt, failMsgPrefix + ' count fail');
    }

    private static void assertUnresend(CaseSurveyVisca__c cs, String no, String sendMethod, Datetime exptSendDt, Integer exptSendCnt) {
        Datetime sendDt = (sendMethod == 'sms')? cs.SmsSendDatetime__c : cs.EmailSendDatetime__c; 
        Integer sendCnt = (sendMethod == 'sms')? (Integer)cs.SmsSendCount__c : (Integer)cs.EmailSendCount__c;
        String failMsgPrefix = no + ' ' + sendMethod + ' send ';
        System.assertEquals(
            exptSendDt.format(DT_FMT)
            ,sendDt.format(DT_FMT)
            ,failMsgPrefix + ' datetime fail'
        );
        System.assertEquals(sendCnt, exptSendCnt, failMsgPrefix + ' count fail');
    }

    private static void assertUnset(CaseSurveyVisca__c cs, String no, String sendMethod) {
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
        System.schedule('TestOboResendSurveyBatT' + year + month + day + hour + minute + second, sch, new OboResendSurveyBat());
        Test.stopTest();

    }

    @isTest
    static void testResend() {
        beginSetUp();
        setResendPattern();
        setResendData();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        OboResendSurveyBat batchable = new OboResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<MailAlert__c> rsltMailAlerts = getRsltMailAlerts();
        System.assertEquals(2, rsltMailAlerts.size(), 'email all send count fail');

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == resendPattern.get(1)) {
                assertResend(r, 'No1', 'sms');
                assertUnset(r,  'No1', 'email');
            } else if (r.OppRef__r.Name == resendPattern.get(2)) {
                assertUnset(r,  'No2', 'sms');
                assertResend(r, 'No2', 'email');
            } else if (r.OppRef__r.Name == resendPattern.get(3)) {
                assertResend(r, 'No3', 'sms');
                assertUnset(r,  'No3', 'email');
            } else if (r.OppRef__r.Name == resendPattern.get(4)) {
                assertUnset(r,  'No4', 'sms');
                assertResend(r, 'No4', 'email');
            }
        }
    }

    @isTest
    static void testNoResend() {
        beginSetUp();
        setNoResendPattern();
        setNoResendData();
        endSetUp();

        Test.startTest();
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
        mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        OboResendSurveyBat batchable = new OboResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == noResendPattern.get(1)) {
                assertUnresend(r, 'No1', 'sms', BEFORE_8DAY, 2);
                assertUnset(r,    'No1', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(2)) {
                assertUnset(r,    'No2', 'sms');
                assertUnresend(r, 'No2', 'email', BEFORE_8DAY, 2);
            } else if (r.OppRef__r.Name == noResendPattern.get(3)) {
                assertUnresend(r, 'No3', 'sms', BEFORE_7DAY, 1);
                assertUnset(r,    'No3', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(4)) {
                assertUnset(r,    'No4', 'sms');
                assertUnresend(r, 'No4', 'email', BEFORE_9DAY, 1);
            } else if (r.OppRef__r.Name == noResendPattern.get(5)) {
                assertUnresend(r, 'No5', 'sms', BEFORE_8DAY, 1);
                assertUnset(r,    'No5', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(6)) {
                assertUnresend(r, 'No6', 'sms', BEFORE_8DAY, 1);
                assertUnset(r,    'No6', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(7)) {
                assertUnresend(r, 'No7', 'sms', BEFORE_8DAY, 1);
                assertUnset(r,    'No7', 'email');
            } else if (r.OppRef__r.Name == noResendPattern.get(8)) {
                assertUnset(r,    'No8', 'sms');
                assertUnresend(r, 'No8', 'email', BEFORE_8DAY, 1);
            } else if (r.OppRef__r.Name == noResendPattern.get(9)) {
                assertUnresend(r, 'No9', 'sms', BEFORE_8DAY, 1);
                assertUnresend(r, 'No9', 'email', BEFORE_8DAY, 1);
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
        OboResendSurveyBat batchable = new OboResendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            if (r.OppRef__r.Name == calloutSmsErrorPattern.get(1)) {
                assertUnresend(r, 'No1', 'sms', BEFORE_8DAY, 1);
            }
        }
    }
}