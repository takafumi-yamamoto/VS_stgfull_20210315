@isTest
public class Trg_SurveyTakerT {

    private static Map<Integer, String> okTestPattern = new Map<Integer, String>();

    private static void setOkTestPattern(){
        okTestPattern.put(1, '1_掲載登録_未掲載_エリアコード斎場_安豪');
        okTestPattern.put(2, '2_掲載登録_掲載取消中_エリアコード火葬場_斎場登録有');
        okTestPattern.put(3, '3_掲載更新_掲載中_エリアコード火葬場_直葬');
        okTestPattern.put(4, '4_掲載取消_掲載中_エリアコード変更無');
        okTestPattern.put(5, '5_掲載更新_掲載中_紙');
//        okTestPattern.put(5, '5_旧_掲載登録_未掲載');
//        okTestPattern.put(6, '6_旧_掲載更新_掲載中');
    }

    private static Account generateBaseAcc(
        String lName
        ,String fName
        ,String mailAddress
    ) {
        String rTypeIdCustomer = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        return new Account(
            RecordTypeId = rTypeIdCustomer
            ,LastName        = lName
            ,FirstName       = fName
            ,MailAddress__c  = mailAddress
            ,PersonBirthdate = date.newInstance(1973, 7, 12)
            ,Gender__pc      = '男性'
        );
    }

    private static void setArea() {
        List<Shikugun__c> areaList = new List<Shikugun__c>();

        Shikugun__c areaA = new Shikugun__c();
        areaA.AreaCode__c = '1520';
        areaA.Name='北海道天塩郡幌延町';
        areaList.add(areaA);

        Shikugun__c areaB = new Shikugun__c();
        areaB.AreaCode__c = '42204';
        areaB.Name='長崎県諫早市';
        areaList.add(areaB);

        insert areaList;
    }

    private static Shikugun__c getShikugunByAreaCode(String areaCd) {
        return [
            SELECT
                AreaCode__c
                ,Name
            FROM
                Shikugun__c
            WHERE
                AreaCode__c = :areaCd
        ];
    }

    private static Saijo__c createSaijoA() {
        Shikugun__c areaA = getShikugunByAreaCode('1520');
        Saijo__c saijoA = new Saijo__c(
            Name = 'てすと斎場_A'
            ,ShikugunRef__c = areaA.Id
            ,SaijoKeisaiJohoIdOld__c = '11111111'
        );
        insert saijoA;

        return saijoA;
    }

    private static Saijo__c createSaijoB() {
        Shikugun__c areaB = getShikugunByAreaCode('42204');
        Saijo__c saijoB = new Saijo__c(
            Name = 'てすと斎場_B'
            ,ShikugunRef__c = areaB.Id
            ,SaijoKeisaiJohoIdOld__c = '11111112'
        );
        insert saijoB;

        return saijoB;
    }

    private static Shisetsu__c createKasobaA() {
        Shikugun__c areaA = getShikugunByAreaCode('1520');
        Shisetsu__c kasobaA = new Shisetsu__c(
            Name = 'てすと火葬場_A'
            ,Shikugun__c = areaA.Id
            ,KasobaKeisaiJohoId__c = '21111111'
            ,ShisetsuShubetsu__c = '火葬場'
        );
        insert kasobaA;

        return kasobaA;
    }

    private static Shisetsu__c createKasobaB() {
        Shikugun__c areaB = getShikugunByAreaCode('42204');
        Shisetsu__c kasobaB = new Shisetsu__c(
            Name = 'てすと火葬場_B'
            ,Shikugun__c = areaB.Id
            ,KasobaKeisaiJohoId__c = '21111112'
            ,ShisetsuShubetsu__c = '火葬場'
        );
        insert kasobaB;

        return kasobaB;
    }

    private static SurveyTaker__c getBeforeTestTaker(
        String WebPostingStatus
        ,String approveStatus
    ) {
        return [
            SELECT
                Id
                ,ApprovalApplyStatus__c
                ,surveyAreaCode__c
            FROM
                SurveyTaker__c
            WHERE
                WebPostingStatus__c    = :webPostingStatus
            AND
                ApprovalApplyStatus__c = :approveStatus
        ];
    } 

    private static SurveyTaker__c getResultData(SurveyTaker__c taker) {
        return [
            SELECT
                Id
                ,WebPostingStatus__c
                ,surveyAreaCode__c
            FROM
                SurveyTaker__c
            WHERE
                Id = :taker.Id
        ];
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

    @isTest
    static void testOkNo1() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        setOkTestPattern();
        setArea();
        // 相談者
        Account sodanshaNo1 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'相談者_生年月日あり_性別あり男_A'
            ,'sodanshaA@example.com'
        );
        insert sodanshaNo1;
        // 喪主
        Account moshuNo1 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'喪主_A'
            ,'moshuA@example.com'
        );
        moshuNo1.PersonBirthdate = date.newInstance(1983, 7, 12);
        moshuNo1.Gender__pc = '女性';
        insert moshuNo1;
        // 斎場
        Saijo__c saijoA = createSaijoA();
        // 火葬場
        Shisetsu__c kasobaA = createKasobaA();
        // シンプル安豪
        SimpleYasugo__c simpleYasugoA = new SimpleYasugo__c(
            SaijoRef__c        = saijoA.Id
            ,KasobaShisetsu__c = kasobaA.Id
            ,MoshuRef__c       = moshuNo1.Id
        );
        insert simpleYasugoA;
        // 商談
        Opportunity oppNo1 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), sodanshaNo1);
        oppNo1.SimpleYasugoRef__c = simpleYasugoA.Id;
        insert oppNo1;
        // 商談商品
        Product2 p2 = surveyDataFactory.getProduct2ByCategory('安豪'); 
        insert new OpportunityLineItem(
            HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
            ,OpportunityId = oppNo1.Id
            ,Product2Id = p2.Id
            ,PricebookEntryId = p2.PricebookEntries[0].Id
        );
        // ケースアンケート
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo1 = surveyDataFactory.createDelivery(oppNo1, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurveyNo1.Id
            ,survey.Id
            ,answerMap
            ,'未掲載'
            ,'Pending'
            ,null
            ,'てすとよりそうこめ_' + okTestPattern.get(1)
            ,'てすと斎場こめ_' + okTestPattern.get(1)
        );

        Test.startTest();
        SurveyTaker__c taker = getBeforeTestTaker(
            '未掲載'
            ,'Pending'
        );
        taker.ApprovalApplyStatus__c = 'Approved';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200));
        update taker;
        Test.stopTest();

        SurveyTaker__c rslt = getResultData(taker);

        System.assertEquals('1520', rslt.surveyAreaCode__c, 'No1 surveyAreaCode__c Not Saijo');
    }

    @isTest
    static void testOkNo2() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        setOkTestPattern();
        setArea();
        // 相談者
        Account sodanshaNo2 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'相談者_生年月日あり_性別あり男_A'
            ,'sodanshaA@example.com'
        );
        insert sodanshaNo2;
        // 喪主
        Account moshuNo2 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'喪主_A'
            ,'moshuA@example.com'
        );
        moshuNo2.PersonBirthdate = null;
        moshuNo2.Gender__pc = '女性';
        insert moshuNo2;
        // 斎場
        Saijo__c saijoA = createSaijoA();
        // 火葬場
        Shisetsu__c kasobaB = createKasobaB();
        // シンプル安豪
        SimpleYasugo__c simpleYasugoB = new SimpleYasugo__c(
            SaijoRef__c        = saijoA.Id
            ,KasobaShisetsu__c = kasobaB.Id
            ,MoshuRef__c       = moshuNo2.Id
        );
        insert simpleYasugoB;
        // 商談
        Opportunity oppNo2 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), sodanshaNo2);
        oppNo2.SimpleYasugoRef__c = simpleYasugoB.Id;
        insert oppNo2;
        // 商談商品
        Product2 p2 = surveyDataFactory.getProduct2ByCategory('火葬式'); 
        insert new OpportunityLineItem(
            HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
            ,OpportunityId = oppNo2.Id
            ,Product2Id = p2.Id
            ,PricebookEntryId = p2.PricebookEntries[0].Id
        );
        // ケースアンケート
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場無_お坊有_v2');
        CaseSurveyVisca__c cSurveyNo2 = surveyDataFactory.createDelivery(oppNo2, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurveyNo2.Id
            ,survey.Id
            ,answerMap
            ,'掲載取消'
            ,'Pending'
            ,null
            ,null
            ,null
        );

        Test.startTest();
        SurveyTaker__c taker = getBeforeTestTaker(
            '掲載取消'
            ,'Pending'
        );
        taker.ApprovalApplyStatus__c = 'Approved';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200));
        update taker;
        Test.stopTest();

        SurveyTaker__c rslt = getResultData(taker);

        System.assertEquals('42204', rslt.surveyAreaCode__c, 'No2 surveyAreaCode__c Not Kasoba');
    }

    @isTest
    static void testOkNo3() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        setOkTestPattern();
        setArea();
        // 相談者
        Account sodanshaNo3 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'相談者_生年月日あり_性別あり男_A'
            ,'sodanshaA@example.com'
        );
        insert sodanshaNo3;
        // 喪主
        Account moshuNo3 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'喪主_A'
            ,'moshuA@example.com'
        );
        moshuNo3.PersonBirthdate = date.newInstance(1983, 7, 12);
        moshuNo3.Gender__pc = '女性';
        insert moshuNo3;
        // 斎場
//        Saijo__c saijoA = createSaijoA();
        // 火葬場
        Shisetsu__c kasobaB = createKasobaB();
        // シンプル安豪
        SimpleYasugo__c simpleYasugoC = new SimpleYasugo__c(
            SaijoRef__c        = null
            ,KasobaShisetsu__c = kasobaB.Id
            ,MoshuRef__c       = moshuNo3.Id
        );
        insert simpleYasugoC;
        // 商談
        Opportunity oppNo3 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), sodanshaNo3);
        oppNo3.SimpleYasugoRef__c = simpleYasugoC.Id;
        insert oppNo3;
        // 商談商品
        Product2 p2 = surveyDataFactory.getProduct2ByCategory('直葬'); 
        insert new OpportunityLineItem(
            HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
            ,OpportunityId = oppNo3.Id
            ,Product2Id = p2.Id
            ,PricebookEntryId = p2.PricebookEntries[0].Id
        );
        // ケースアンケート
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場無_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo3 = surveyDataFactory.createDelivery(oppNo3, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurveyNo3.Id
            ,survey.Id
            ,answerMap
            ,'掲載中'
            ,'Pending'
            ,'1111'
            ,'よりそこめ' + okTestPattern.get(3)
            ,null
        );

        Test.startTest();
        SurveyTaker__c taker = getBeforeTestTaker(
            '掲載中'
            ,'Pending'
        );
        taker.ApprovalApplyStatus__c = 'Approved';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200));
        update taker;
        Test.stopTest();

        SurveyTaker__c rslt = getResultData(taker);

        System.assertEquals('42204', rslt.surveyAreaCode__c, 'No3 surveyAreaCode__c Not Kasoba');
    }

    @isTest
    static void testOkNo4() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        setOkTestPattern();
        setArea();
        // 相談者
        Account sodanshaNo4 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'相談者_生年月日あり_性別あり男_A'
            ,'sodanshaA@example.com'
        );
        insert sodanshaNo4;
        // 喪主
        Account moshuNo4 = generateBaseAcc(
            '生年月日あり_性別あり男'
            ,'喪主_A'
            ,'moshuA@example.com'
        );
        moshuNo4.PersonBirthdate = date.newInstance(1983, 7, 12);
        moshuNo4.Gender__pc = '女性';
        insert moshuNo4;
        // 斎場
        Saijo__c saijoA = createSaijoA();
        // 火葬場
        Shisetsu__c kasobaA = createKasobaA();
        // シンプル安豪
        SimpleYasugo__c simpleYasugoA = new SimpleYasugo__c(
            SaijoRef__c        = saijoA.Id
            ,KasobaShisetsu__c = kasobaA.Id
            ,MoshuRef__c       = moshuNo4.Id
        );
        insert simpleYasugoA;
        // 商談
        Opportunity oppNo4 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), sodanshaNo4);
        oppNo4.SimpleYasugoRef__c = simpleYasugoA.Id;
        insert oppNo4;
        // 商談商品
        Product2 p2 = surveyDataFactory.getProduct2ByCategory('家族葬'); 
        insert new OpportunityLineItem(
            HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
            ,OpportunityId = oppNo4.Id
            ,Product2Id = p2.Id
            ,PricebookEntryId = p2.PricebookEntries[0].Id
        );
        // ケースアンケート
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊無_v2');
        CaseSurveyVisca__c cSurveyNo4 = surveyDataFactory.createDelivery(oppNo4, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurveyNo4.Id
            ,survey.Id
            ,answerMap
            ,'掲載中'
            ,'Approved'
            ,'12345'
            ,null
            ,'てすと斎場こめ_' + okTestPattern.get(4)
        );

        Test.startTest();
        SurveyTaker__c taker = getBeforeTestTaker(
            '掲載中'
            ,'Approved'
        );
        taker.WebPostingStatus__c = '掲載取消';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200));
        update taker;
        Test.stopTest();

        SurveyTaker__c rslt = getResultData(taker);

        System.assertEquals('12345', rslt.surveyAreaCode__c, 'No4 surveyAreaCode__c Change');
    }

    @isTest
    static void testOkNo5() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        surveyDataFactory.createSurvey();
        setOkTestPattern();
        setArea();
        // 相談者
        Account sodanshaNo5 = generateBaseAcc(
            '相談者'
            ,'No5'
            ,'sodanshaNo5@example.com'
        );
        insert sodanshaNo5;
        // 喪主
        Account moshuNo5 = generateBaseAcc(
            '喪主'
            ,'No5'
            ,'moshuNo5@example.com'
        );
        moshuNo5.PersonBirthdate = null;
        moshuNo5.Gender__pc = '女性';
        insert moshuNo5;
        // 斎場
        Saijo__c saijoA = createSaijoA();
        // 火葬場
        Shisetsu__c kasobaA = createKasobaA();
        // シンプル安豪
        SimpleYasugo__c simpleYasugoA = new SimpleYasugo__c(
            SaijoRef__c        = saijoA.Id
            ,KasobaShisetsu__c = kasobaA.Id
            ,MoshuRef__c       = moshuNo5.Id
        );
        simpleYasugoA.SogiAfterMoshuMailDatetime__c = Date.today().addDays(-1);
        insert simpleYasugoA;
        // 商談
        Opportunity oppNo5 = surveyDataFactory.generateBaseOpp(okTestPattern.get(1), sodanshaNo5);
        oppNo5.SimpleYasugoRef__c = simpleYasugoA.Id;
        insert oppNo5;
        // 商談商品
        Product2 p2 = surveyDataFactory.getProduct2ByCategory('安豪'); 
        insert new OpportunityLineItem(
            HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
            ,OpportunityId = oppNo5.Id
            ,Product2Id = p2.Id
            ,PricebookEntryId = p2.PricebookEntries[0].Id
        );
        // ケースアンケート
        Survey__c survey = surveyDataFactory.getSurveyByName('斎場有_お坊有_paper');
        CaseSurveyVisca__c cSurveyNo5 = surveyDataFactory.createDelivery(oppNo5, survey);
        Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
        endSetUp();

        surveyDataFactory.createTaker(
            cSurveyNo5.Id
            ,survey.Id
            ,answerMap
            ,'未掲載'
            ,'Pending'
            ,'1520'
            ,'てすとよりそうこめ_' + okTestPattern.get(5)
            ,'てすと斎場こめ_' + okTestPattern.get(5)
        );

        Test.startTest();
        SurveyTaker__c taker = getBeforeTestTaker(
            '未掲載'
            ,'Pending'
        );
        taker.ApprovalApplyStatus__c = 'Approved';
        Test.setMock(HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200));
        update taker;
        Test.stopTest();

        SurveyTaker__c rslt = getResultData(taker);

        System.assertEquals('1520', rslt.surveyAreaCode__c, 'No5 surveyAreaCode__c Not Saijo');
    }

}