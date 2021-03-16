@isTest
private class SogiSendSurveyBatT {

    private static Map<Integer, String> sendPattern = new Map<Integer, String>();
    private static Map<Integer, String> noSendPattern = new Map<Integer, String>();
    private static Map<Integer, String> calloutSmsErrorPattern = new Map<Integer, String>();
    private static final String DT_FMT = 'yyyy-MM-dd';

    private static void setSendPattern(){
        sendPattern.put(1, '1_アンケート_SMS+Email');
        sendPattern.put(2, '2_アンケート_SMS');
        sendPattern.put(3, '3_アンケート_Email');
        sendPattern.put(4, '4_Noアンケート_Email');
    }

    private static void setSendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = sendPattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(nameNo1, accNo1);
        insert oppSogiNo1;
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 = surveyFactory.createDelivery(oppSogiNo1, surveyNo1);
        // No2
        String nameNo2 = sendPattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-0000-0000';
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(nameNo2, accNo2);
        oppSogiNo2.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo2;
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo2 = surveyFactory.createDelivery(oppSogiNo2, surveyNo2);
        // No3
        String nameNo3 = sendPattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MailAddress__c = 'accNo3@example.com';
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(nameNo3, accNo3);
        oppSogiNo3.SurveySendWayHopeSms__c = false;
        insert oppSogiNo3;
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('後葬_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo3 = surveyFactory.createDelivery(oppSogiNo3, surveyNo3);
        // No4
        String nameNo4 = sendPattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(nameNo4, accNo4);
        oppSogiNo4.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo4.SurveySendWayHopeSms__c = false;
        oppSogiNo4.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo4;
        CaseSurveyVisca__c cSurveyNo4 = surveyFactory.createDelivery(oppSogiNo4, null);
    }

    private static void setNoSendPattern() {
        noSendPattern.put(1, '1_作成日が前々日');
        noSendPattern.put(2, '2_作成日が当日');
        noSendPattern.put(3, '3_送信停止フラグON');
        noSendPattern.put(4, '4_携帯電話番号とメアド削除された');
        noSendPattern.put(5, '5_葬儀商談じゃない');
    }

    private static void setNoSendDate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = noSendPattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(nameNo1, accNo1);
        insert oppSogiNo1;
        Survey__c surveyNo1 = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 =
            surveyFactory.generateDelivery(oppSogiNo1, surveyNo1, Date.today().addDays(-2));
        insert cSurveyNo1;
        // No2
        String nameNo2 = noSendPattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-0000-0000';
        accNo2.MailAddress__c = 'accNo2@example.com';
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(nameNo2, accNo2);
        insert oppSogiNo2;
        Survey__c surveyNo2 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo2 =
            surveyFactory.generateDelivery(oppSogiNo2, surveyNo2, Date.today());
        insert cSurveyNo2;
        // No3
        String nameNo3 = noSendPattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MobilePhone__c = '090-0000-0000';
        accNo3.MailAddress__c = 'accNo3@example.com';
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(nameNo3, accNo3);
        insert oppSogiNo3;
        Survey__c surveyNo3 = surveyFactory.getSurveyByName('斎場有_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo3 =
            surveyFactory.generateDelivery(oppSogiNo3, surveyNo3, Date.today().addDays(-1));
        cSurveyNo3.StopSendFlg__c = true;
        insert cSurveyNo3;
        // No4
        String nameNo4 = noSendPattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MobilePhone__c = '090-0000-0000';
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(nameNo4, accNo4);
        insert oppSogiNo4;
        Survey__c surveyNo4 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo4 = surveyFactory.createDelivery(oppSogiNo4, surveyNo4);
        accNo4.MobilePhone__c = null;
        accNo4.MailAddress__c = null;
        update accNo4;
        // No5
        String nameNo5 = noSendPattern.get(5);
        Survey__c surveyNo5 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo5.MobilePhone__c = '090-0000-0000';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Obosanbin__c oboNo5 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
            ,KokubetsuDateTime_Inp__c = Date.toDay().addDays(-3)
        );
        insert oboNo5;
        Opportunity oppOboNo5 = surveyFactory.generateOppObo(nameNo5, accNo5, oboNo5);
        oppOboNo5.Iriguchi__c = 'FD';
        oppOboNo5.SurveyDiscountAgreeStatus__c = Cnst.OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE;
        oppOboNo5.SurveySendWayHopeSms__c = true;
        oppOboNo5.SurveySendWayHopeEmail__c = true;
        insert oppOboNo5;
        CaseSurveyVisca__c cSurveyNo5 = surveyFactory.createDelivery(oppOboNo5, surveyNo5);
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
        CaseSurveyVisca__c cSurveyNo1 = surveyFactory.createDelivery(oppSogiNo1, surveyNo1);
    }

    private static List<CaseSurveyVisca__c> getRslts() {
        return [
            SELECT
                CaseRef__r.TorihikiShodanRef__r.Name
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
        System.debug(cs.CaseRef__r.TorihikiShodanRef__r.Name);
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
        System.schedule('TestSogiSendSurveyBatT' + year + month + day + hour + minute + second, sch, new SogiSendSurveyBat());
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
        SogiSendSurveyBat batchable = new SogiSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<MailAlert__c> rsltMailAlerts = getRsltMailAlerts();
        System.assertEquals(3, rsltMailAlerts.size(), 'email all send count fail');

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.CaseRef__r.TorihikiShodanRef__r.Name == sendPattern.get(1)) {
                assertSend(r, 'No1', 'sms');
                assertSend(r, 'No1', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == sendPattern.get(2)) {
                assertSend(r,   'No2', 'sms');
                assertUnsend(r, 'No2', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == sendPattern.get(3)) {
                assertUnsend(r, 'No3', 'sms');
                assertSend(r,   'No3', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == sendPattern.get(4)) {
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
        SogiSendSurveyBat batchable = new SogiSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.CaseRef__r.TorihikiShodanRef__r.Name == noSendPattern.get(1)) {
                assertUnsend(r, 'No1', 'sms');
                assertUnsend(r, 'No1', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == noSendPattern.get(2)) {
                assertUnsend(r, 'No2', 'sms');
                assertUnsend(r, 'No2', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == noSendPattern.get(3)) {
                assertUnsend(r, 'No3', 'sms');
                assertUnsend(r, 'No3', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == noSendPattern.get(4)) {
                assertUnsend(r, 'No4', 'sms');
                assertUnsend(r, 'No4', 'email');
            } else if (r.CaseRef__r.TorihikiShodanRef__r.Name == noSendPattern.get(5)) {
                assertUnsend(r, 'No5', 'sms');
                assertUnsend(r, 'No5', 'email');
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
        SogiSendSurveyBat batchable = new SogiSendSurveyBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            if (r.CaseRef__r.TorihikiShodanRef__r.Name == calloutSmsErrorPattern.get(1)) {
                assertUnsend(r, 'No1', 'sms');
                assertSend(r,   'No1', 'email');
            }
        }
    }
}