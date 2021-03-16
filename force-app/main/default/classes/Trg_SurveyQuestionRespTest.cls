@isTest
public class Trg_SurveyQuestionRespTest {

    private static Map<Integer, String> okTestPattern = new Map<Integer, String>();

    private static void setOkTestPattern(){
        okTestPattern.put(1, '1_allチェック');
        okTestPattern.put(2, '2_位牌のみチェック');
        okTestPattern.put(3, '3_49法要＋永代チェック');
        okTestPattern.put(4, '4_同タイミングでの複数回答');
        okTestPattern.put(5, '5_チェックなし');
    }

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
        Insert new List<KaiinkibanSetting__c>{
            new KaiinkibanSetting__c(
                name='dev',
                client_id__c='5',
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true,
                IsShisetsuRenkeiYuko__c=true
            ),
            new KaiinkibanSetting__c(
                name='prod',
                client_id__c='5',
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true,
                IsShisetsuRenkeiYuko__c=true
            )
        };
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

    private static SogiSurveyAfterSell__c[] getResultData() {
        return new SogiSurveyAfterSell__c[([
            SELECT
                Id
                ,Status__c
                ,UserRef__c
                ,ExecuteDatetime__c
                ,GoodTimeTel__c
                ,HonIhaiAndButsudanFlg__c
                ,ShijukunichiHoyoFlg__c
                ,OtherHoyoFlg__c
                ,EitaiKuyoFlg__c
                ,KaiyoSankotsuFlg__c
                ,OpportunityRef__c
            FROM
                SogiSurveyAfterSell__c
        ])];
    }

    @isTest
    static void testOkNo1() {
        beginSetUp();
        setOkTestPattern();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        // No1
        Account accNo1 = new Account(
                Name = 'SMS+Email_A'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo1@example.com');
        insert accNo1;
        Opportunity oppNo1 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), accNo1);
        insert oppNo1;
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊有_v2');
        caseSurveyVisca__c cSurvey = surveyDataFactory.createDelivery(oppNo1, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurvey.Id
            ,survey.Id
            ,answerMap
            ,null
            ,null
            ,null
            ,null
            ,null
        );

        SogiSurveyAfterSell__c[] rslt = getResultData();

        System.assertEquals(1, rslt.size());
        System.assertEquals(oppNo1.Id, rslt.get(0).OpportunityRef__c);
        System.assertEquals(answerMap.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rslt.get(0).GoodTimeTel__c);
        System.assertEquals(true, rslt.get(0).HonIhaiAndButsudanFlg__c);
        System.assertEquals(true, rslt.get(0).ShijukunichiHoyoFlg__c);
        System.assertEquals(true, rslt.get(0).OtherHoyoFlg__c);
        System.assertEquals(true, rslt.get(0).EitaiKuyoFlg__c);
        System.assertEquals(true, rslt.get(0).KaiyoSankotsuFlg__c);
    }

    @isTest
    static void testOkNo2() {
        beginSetUp();
        setOkTestPattern();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        // No2
        Account accNo2 = new Account(
                Name = 'SMS_B'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo2@example.com');
        insert accNo2;
        Opportunity oppNo2 = surveyDataFactory.generateBaseOpp(okTestPattern.get(2), accNo2);
        oppNo2.SurveySendWayHopeEmail__c = false;
        insert oppNo2;
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊無_v2');
        caseSurveyVisca__c cSurvey = surveyDataFactory.createDelivery(oppNo2, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI_FULL
        );
        endSetUp();

        surveyDataFactory.createTaker(
            cSurvey.Id
            ,survey.Id
            ,answerMap
            ,null
            ,null
            ,null
            ,null
            ,null
        );

        SogiSurveyAfterSell__c[] rslt = getResultData();

        System.assertEquals(1, rslt.size());
        System.assertEquals(oppNo2.Id, rslt.get(0).OpportunityRef__c);
        System.assertEquals(answerMap.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rslt.get(0).GoodTimeTel__c);
        System.assertEquals(true, rslt.get(0).HonIhaiAndButsudanFlg__c);
        System.assertEquals(false, rslt.get(0).ShijukunichiHoyoFlg__c);
        System.assertEquals(false, rslt.get(0).OtherHoyoFlg__c);
        System.assertEquals(false, rslt.get(0).EitaiKuyoFlg__c);
        System.assertEquals(false, rslt.get(0).KaiyoSankotsuFlg__c);
    }

    @isTest
    static void testOkNo3() {
        beginSetUp();
        setOkTestPattern();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        // No3
        Account accNo3 = new Account(
                Name = 'SMS+Email_E'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo3@example.com');
        insert accNo3;
        Opportunity oppNo3 = surveyDataFactory.generateBaseOpp(okTestPattern.get(3), accNo3);
        insert oppNo3;
        Survey__c survey = surveyDataFactory.getSurveyByName('後葬_お坊無_v2');
        caseSurveyVisca__c cSurvey = surveyDataFactory.createDelivery(oppNo3, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO_FULL
        );
        endSetUp();

        surveyDataFactory.createTaker(
            cSurvey.Id
            ,survey.Id
            ,answerMap
            ,null
            ,null
            ,null
            ,null
            ,null
        );

        SogiSurveyAfterSell__c[] rslt = getResultData();

        System.assertEquals(1, rslt.size());
        System.assertEquals(oppNo3.Id, rslt.get(0).OpportunityRef__c);
        System.assertEquals(answerMap.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rslt.get(0).GoodTimeTel__c);
        System.assertEquals(false, rslt.get(0).HonIhaiAndButsudanFlg__c);
        System.assertEquals(true, rslt.get(0).ShijukunichiHoyoFlg__c);
        System.assertEquals(false, rslt.get(0).OtherHoyoFlg__c);
        System.assertEquals(true, rslt.get(0).EitaiKuyoFlg__c);
        System.assertEquals(false, rslt.get(0).KaiyoSankotsuFlg__c);
    }

    @isTest
    static void testOkNo4() {
        beginSetUp();
        setOkTestPattern();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        // No4
        Account accNo4_1 = new Account(
                Name = 'SMS+Email_F_1'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo4_1@example.com');
        insert accNo4_1;
        Account accNo4_2 = new Account(
                Name = 'SMS+Email_F_2'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo4_2@example.com');
        insert accNo4_2;
        Account accNo4_3 = new Account(
                Name = 'SMS+Email_F_3'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo4_3@example.com');
        insert accNo4_3;
        Opportunity oppNo4_1 = surveyDataFactory.generateBaseOpp(okTestPattern.get(5) + '_1', accNo4_1);
        insert oppNo4_1;
        Opportunity oppNo4_2 = surveyDataFactory.generateBaseOpp(okTestPattern.get(5) + '_2', accNo4_2);
        insert oppNo4_2;
        Opportunity oppNo4_3 = surveyDataFactory.generateBaseOpp(okTestPattern.get(5) + '_3', accNo4_3);
        insert oppNo4_3;
        Survey__c survey_1 = surveyDataFactory.getSurveyByName('斎場有_お坊有_v2');
        caseSurveyVisca__c cSurvey_1 = surveyDataFactory.createDelivery(oppNo4_1, survey_1);
        Map<String, String> answerMap_1 = surveyDataFactory.generateDefaultAnswerMap();
        answerMap_1.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO_FULL);
        Survey__c survey_2 = surveyDataFactory.getSurveyByName('斎場無_お坊無_v2');
        caseSurveyVisca__c cSurvey_2 = surveyDataFactory.createDelivery(oppNo4_2, survey_2);
        Map<String, String> answerMap_2 = surveyDataFactory.generateDefaultAnswerMap();
        answerMap_2.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SOZOKU_FULL);
        Survey__c survey_3 = surveyDataFactory.getSurveyByName('後葬_お坊有_v2');
        caseSurveyVisca__c cSurvey_3 = surveyDataFactory.createDelivery(oppNo4_3, survey_3);
        Map<String, String> answerMap_3 = surveyDataFactory.generateDefaultAnswerMap();
        answerMap_3.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SOZOKU_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO_FULL
        );
        answerMap_3.put(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME, null);
        endSetUp();

        surveyDataFactory.createTaker(
            cSurvey_1.Id
            ,survey_1.Id
            ,answerMap_1
            ,null
            ,null
            ,null
            ,null
            ,null
        );
        surveyDataFactory.createTaker(
            cSurvey_2.Id
            ,survey_2.Id
            ,answerMap_2
            ,null
            ,null
            ,null
            ,null
            ,null
        );
        surveyDataFactory.createTaker(
            cSurvey_3.Id
            ,survey_3.Id
            ,answerMap_3
            ,null
            ,null
            ,null
            ,null
            ,null
        );

        SogiSurveyAfterSell__c[] rslt = getResultData();

        System.assertEquals(3, rslt.size());
        for (SogiSurveyAfterSell__c rt : rslt) {
            if (rt.OpportunityRef__c == oppNo4_1.Id) {
                System.assertEquals(oppNo4_1.Id, rt.OpportunityRef__c);
                System.assertEquals(answerMap_1.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rt.GoodTimeTel__c);
                System.assertEquals(false, rt.HonIhaiAndButsudanFlg__c);
                System.assertEquals(false, rt.ShijukunichiHoyoFlg__c);
                System.assertEquals(true, rt.OtherHoyoFlg__c);
                System.assertEquals(false, rt.EitaiKuyoFlg__c);
                System.assertEquals(false, rt.KaiyoSankotsuFlg__c);
            } else if (rt.OpportunityRef__c == oppNo4_2.Id) {
                System.assertEquals(oppNo4_2.Id, rt.OpportunityRef__c);
                System.assertEquals(answerMap_2.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rt.GoodTimeTel__c);
                System.assertEquals(false, rt.HonIhaiAndButsudanFlg__c);
                System.assertEquals(false, rt.ShijukunichiHoyoFlg__c);
                System.assertEquals(false, rt.OtherHoyoFlg__c);
                System.assertEquals(false, rt.EitaiKuyoFlg__c);
                System.assertEquals(false, rt.KaiyoSankotsuFlg__c);
            } else if (rt.OpportunityRef__c == oppNo4_3.Id) {
                System.assertEquals(oppNo4_3.Id, rt.OpportunityRef__c);
                System.assertEquals(answerMap_3.get(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME), rt.GoodTimeTel__c);
                System.assertEquals(true, rt.HonIhaiAndButsudanFlg__c);
                System.assertEquals(false, rt.ShijukunichiHoyoFlg__c);
                System.assertEquals(false, rt.OtherHoyoFlg__c);
                System.assertEquals(true, rt.EitaiKuyoFlg__c);
                System.assertEquals(false, rt.KaiyoSankotsuFlg__c);
            }
        }
    }

    @isTest
    static void testOkNo5() {
        beginSetUp();
        setOkTestPattern();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        // No5
        Account accNo5 = new Account(
                Name = 'SMS+Email_G'
                ,MobilePhone__c = '090-5549-1867'
                ,MailAddress__c = 'accNo5@example.com');
        insert accNo5;
        Opportunity oppNo5 = surveyDataFactory.generateBaseOpp(okTestPattern.get(5), accNo5);
        insert oppNo5;
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊有_v2');
        caseSurveyVisca__c cSurvey = surveyDataFactory.createDelivery(oppNo5, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES, null);
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME, null);
        endSetUp();

        surveyDataFactory.createTaker(
            cSurvey.Id
            ,survey.Id
            ,answerMap
            ,null
            ,null
            ,null
            ,null
            ,null
         );

        SogiSurveyAfterSell__c[] rslt = getResultData();

        System.assertEquals(0, rslt.size());
    }
}