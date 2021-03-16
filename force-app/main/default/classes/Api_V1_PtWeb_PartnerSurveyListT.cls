@isTest
public class Api_V1_PtWeb_PartnerSurveyListT {
    private static Map<Integer, String> okTestPattern = new Map<Integer, String>();

    private static void setOkTestPattern(){
        okTestPattern.put(1, '1_1回答');
        okTestPattern.put(2, '2_複数回答');
        okTestPattern.put(3, '3_回答無し');
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

    private static Saijo__c createSaijoJisha() {
        Shikugun__c areaA = getShikugunByAreaCode('1520');
        Saijo__c saijoJisha = new Saijo__c(
            Name = 'てすと斎場_自社'
            ,ShikugunRef__c = areaA.Id
            ,SaijoKeisaiJohoIdOld__c = '11111111'
            ,ShisetsuKubun__c = '自社'
        );
        insert saijoJisha;

        return saijoJisha;
    }

    private static Saijo__c createSaijoKoei() {
        Shikugun__c areaB = getShikugunByAreaCode('42204');
        Saijo__c saijoB = new Saijo__c(
            Name = 'てすと斎場_公営'
            ,ShikugunRef__c = areaB.Id
            ,SaijoKeisaiJohoIdOld__c = '11111112'
            ,ShisetsuKubun__c = '公営'
        );
        insert saijoB;

        return saijoB;
    }

    private static Shisetsu__c createKasoba() {
        Shikugun__c areaA = getShikugunByAreaCode('1520');
        Shisetsu__c kasoba = new Shisetsu__c(
            Name = 'てすと火葬場_A'
            ,Shikugun__c = areaA.Id
            ,KasobaKeisaiJohoId__c = '21111111'
            ,ShisetsuShubetsu__c = '火葬場'
        );
        insert kasoba;

        return kasoba;
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

    private static Account createSogisha() {
        String rTypeIdSogisha = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();

        Account sogisha = new Account(
            Name = 'test葬儀社'
        );
        insert sogisha;

        return sogisha;
    }

    private static Account getOneAccountById(String id) {
        return [
            SELECT
                Id
                ,TorihikisakiBango__c
            FROM
                Account 
            WHERE
                Id = :id
            LIMIT 1
        ];
    } 

    private static Product2 getProduct2ByName(String name) {
        return [
            SELECT
                Id
                ,(
                    SELECT
                        Id
                    FROM
                        PricebookEntries
                )
            FROM
                Product2
            WHERE 
                Name = :name
            LIMIT 1
        ];
    }

    private static Keiyaku__c createKeiyakuSimpleYasugo(String sogishaId) {
        String rTypeIdSimpleYasugo = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

        Keiyaku__c keiyaku = new Keiyaku__c(
            RecordTypeId = rTypeIdSimpleYasugo
            ,Teikeisaki__c = sogishaId
        );
        insert keiyaku;

        return keiyaku;
    }

    private static string setTestData(
        Integer testNo
        ,Integer makeCnt
    ) {
        TestSurveyDataFactoryNew surveyDataFactory = new TestSurveyDataFactoryNew();
        setOkTestPattern();
        // 単レコードが必要なobjs
        // 斎場
        Saijo__c saijoJisha = createSaijoJisha();
        Saijo__c saijoKoei  = createSaijoKoei();
        // 火葬場
        Shisetsu__c kasoba = createKasoba();
        // 葬儀社
        Account sogisha = createSogisha();
        sogisha = getOneAccountById(sogisha.Id);
        // パートナー契約
        Keiyaku__c keiyakuSimpleYasugo = createKeiyakuSimpleYasugo(sogisha.Id);

        // 複数レコードが必要なobjs
        for (Integer i = 0; i < makeCnt; i++) {
            // 可変したい値郡
            String simpleYasugoSaijoRefId = saijoJisha.Id;
            Product2 p2 = getProduct2ByName('【19.12】お花いっぱいのお葬式 一日葬 お花増量プラン');
            String surveyName = 'お客様アンケート_葬儀読経なし_v2';
            Map<String, String> answerMap = surveyDataFactory.generateDefaultAnswerMap();
            if (i == 1) {
                simpleYasugoSaijoRefId = saijoKoei.Id;
                p2 = getProduct2ByName('【19.12】よりそうのお葬式 家族葬 仏式プラン');
                surveyName = 'お客様アンケート_葬儀読経なし_v2';
                answerMap.put('SG001', '★★★☆☆ 普通');
                answerMap.put('SG002', '★★☆☆☆ やや不満');
                answerMap.put('SG005', '★☆☆☆☆ 不満');
                answerMap.put('SG007', '');
            } else if (i == 2) {
                simpleYasugoSaijoRefId = null;
                p2 = getProduct2ByName('【20.06】よりそうのお葬式 火葬式 直葬プラン');
                surveyName = 'お客様アンケート_葬儀読経なし_斎場使用なし_v2';
                answerMap.remove('SJ001');
                answerMap.remove('SJ003');
                answerMap.remove('SJ005');
            }

            // 相談者
            Account sodansha = generateBaseAcc(
                'テスト'
                ,'相談者_' + i
                ,'sodansha' + i + '@example.com'
            );
            insert sodansha;
            // 対象者
            Account taishosha = generateBaseAcc(
                'テスト'
                ,'対象者_' + i
                ,'taishosha' + i + '@example.com'
            );
            insert taishosha;
            // シンプル安豪
            SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(
                SaijoRef__c = simpleYasugoSaijoRefId
                ,KasobaShisetsu__c = kasoba.Id
                ,SimpleYasugoKeiyakuRef__c = keiyakuSimpleYasugo.Id
                ,TaiouKanouRiyu__c = '対応可能（斎場優先）'
            );
            insert simpleYasugo;
            // 商談
            Opportunity opp = surveyDataFactory.generateBaseOpp(okTestPattern.get(testNo) + '_' + i, sodansha);
            opp.SimpleYasugoRef__c = simpleYasugo.Id;
            opp.TaishosyaRef__c = taishosha.Id;
            insert opp;
            // 商談商品
            //Product2 p2 = getProduct2ByName('【19.12】よりそうのお葬式 家族葬 仏式プラン');
            insert new OpportunityLineItem(
                HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
                ,OpportunityId = opp.Id
                ,Product2Id = p2.Id
                ,PricebookEntryId = p2.PricebookEntries[0].Id
            );
            // ケースアンケート
            Survey__c survey = surveyDataFactory.getSurveyByName(surveyName);
            CaseSurveyVisca__c cSurvey = surveyDataFactory.createDelivery(opp, survey);

            surveyDataFactory.createTaker(
                cSurvey.Id
                ,survey.Id
                ,answerMap
                ,'未掲載'
                ,'Pending'
                ,null
                ,'てすとよりそうこめ_' + okTestPattern.get(testNo) + i
                ,'てすと斎場こめ_' + okTestPattern.get(testNo) + i
            );
        }

        return sogisha.TorihikisakiBango__c;
    }

    @isTest(SeeAllData=true)
    static void testOkNo1() {
        Utility_Common.isMimicExecAsDataIkouProfile = true;
        String torihikisakiBango = setTestData(1, 1);
        Utility_Common.isMimicExecAsDataIkouProfile = false;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/partnersurvey/list';
        req.httpMethod = 'GET';
        req.params.put('torihikisaki_bango', torihikisakiBango);
        req.params.put('limit', '20');
        req.params.put('offset', '0');
        RestContext.request  = req;
        RestContext.response = res;
        Api_V1_PtWeb_PartnerSurveyList.doGet();
        Test.stopTest();

        Map<String, Object> rslt = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        List<Object> rsltAnswers = (List<Object>) rslt.get('answers');
        System.assertEquals(1, rslt.get('total_count'), 'No1 total_count to fail');
        System.assertEquals(4, rslt.get('summary_sogisha_total'), 'No1 summary_sogisha_total to fail');
        System.assertEquals(4, rslt.get('summary_sogisha_correspond'), 'No1 summary_sogisha_correspond to fail');
        System.assertEquals(4, rslt.get('summary_sogisha_grooming'), 'No1 summary_sogisha_grooming to fail');
        System.assertEquals(4, rslt.get('summary_sogisha_cooking'), 'No1 summary_sogisha_cooking to fail');
        System.assertEquals(4, rslt.get('summary_saijo_access'), 'No1 summary_saijo_access to fail');
        System.assertEquals(4, rslt.get('summary_saijo_atmosphere'), 'No1 summary_saijo_atmosphere to fail');
        System.assertEquals(4, rslt.get('summary_saijo_decoration'), 'No1 summary_saijo_decoration to fail');
        System.assertEquals(1, rsltAnswers.size(), 'No3 answers count to faile');
    }

    @isTest(SeeAllData=true)
    static void testOkNo2() {
        Utility_Common.isMimicExecAsDataIkouProfile = true;
        String torihikisakiBango = setTestData(2, 3);
        Utility_Common.isMimicExecAsDataIkouProfile = false;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/partnersurvey/list';
        req.httpMethod = 'GET';
        req.params.put('torihikisaki_bango', torihikisakiBango);
        req.params.put('limit', '2');
        req.params.put('offset', '2');
        RestContext.request  = req;
        RestContext.response = res;
        Api_V1_PtWeb_PartnerSurveyList.doGet();
        Test.stopTest();

        Map<String, Object> rslt = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
//        for(String k : rslt.keyset()) {
//            if (k == 'answers') {
//                List<Object> l = (List<Object>)rslt.get(k);
//                System.debug(l);
//                for (Object ans : l) {
//                    Map<String, Object> bb = (Map<String, Object>) ans;
//                    System.debug(bb.get('sogisha_total'));
//                    System.debug(bb.get('sogisha_correspond'));
//                    System.debug(bb.get('sogisha_grooming'));
//                    System.debug(bb.get('sogisha_cooking'));
//                    System.debug(bb.get('saijo_access'));
//                    System.debug(bb.get('saijo_atmosphere'));
//                    System.debug(bb.get('saijo_decoration'));
//                }
//            } else {
//                System.debug(rslt.get(k));
//            }
//        }
        List<Object> rsltAnswers = (List<Object>) rslt.get('answers');
        System.assertEquals(3,   rslt.get('total_count'), 'No2 total_count to fail');
        System.assertEquals(3.7, rslt.get('summary_sogisha_total'), 'No2 summary_sogisha_total to fail');
        System.assertEquals(3.3, rslt.get('summary_sogisha_correspond'), 'No2 summary_sogisha_correspond to fail');
        System.assertEquals(3,   rslt.get('summary_sogisha_grooming'), 'No2 summary_sogisha_grooming to fail');
        System.assertEquals(2.7, rslt.get('summary_sogisha_cooking'), 'No2 summary_sogisha_cooking to fail');
        System.assertEquals(4,   rslt.get('summary_saijo_access'), 'No2 summary_saijo_access to fail');
        System.assertEquals(4,   rslt.get('summary_saijo_atmosphere'), 'No2 summary_saijo_atmosphere to fail');
        System.assertEquals(4,   rslt.get('summary_saijo_decoration'), 'No2 summary_saijo_decoration to fail');
        System.assertEquals(1, rsltAnswers.size(), 'No3 answers count to faile');
    }

    @isTest(SeeAllData=true)
    static void testOkNo3() {
        Utility_Common.isMimicExecAsDataIkouProfile = true;
        String torihikisakiBango = setTestData(3, 1);
        SurveyTaker__c delTaker = [
            SELECT
                Id
            FROM
                SurveyTaker__c
            WHERE
                CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.TeikesakiTorihikisakiBango__c = :torihikisakiBango
        ];
        delete delTaker;
        Utility_Common.isMimicExecAsDataIkouProfile = false;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/partnersurvey/list';
        req.httpMethod = 'GET';
        req.params.put('torihikisaki_bango', torihikisakiBango);
        req.params.put('limit', '20');
        req.params.put('offset', '0');
        RestContext.request  = req;
        RestContext.response = res;
        Api_V1_PtWeb_PartnerSurveyList.doGet();
        Test.stopTest();

        Map<String, Object> rslt = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        List<Object> rsltAnswers = (List<Object>) rslt.get('answers');
        System.assertEquals(0, rslt.get('total_count'), 'No3 total_count to fail');
        System.assertEquals(0, rslt.get('summary_sogisha_total'), 'No3 summary_sogisha_total to fail');
        System.assertEquals(0, rslt.get('summary_sogisha_correspond'), 'No3 summary_sogisha_correspond to fail');
        System.assertEquals(0, rslt.get('summary_sogisha_grooming'), 'No3 summary_sogisha_grooming to fail');
        System.assertEquals(0, rslt.get('summary_sogisha_cooking'), 'No3 summary_sogisha_cooking to fail');
        System.assertEquals(0, rslt.get('summary_saijo_access'), 'No3 summary_saijo_access to fail');
        System.assertEquals(0, rslt.get('summary_saijo_atmosphere'), 'No3 summary_saijo_atmosphere to fail');
        System.assertEquals(0, rslt.get('summary_saijo_decoration'), 'No3 summary_saijo_decoration to fail');
        System.assertEquals(0, rsltAnswers.size(), 'No3 answers count to faile');
    }

    @isTest
    static void testNgBadrequestTorihikisaBnagoNathing() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/partnersurvey/list';
        req.httpMethod = 'GET';
        //req.params.put('torihikisaki_bango', '');
        RestContext.request  = req;
        RestContext.response = res;
        Api_V1_PtWeb_PartnerSurveyList.doGet();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'fail BadRequest');
    }

    @isTest
    static void testNgBadrequestOffsetWrong() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/api/v1/partnersurvey/list';
        req.httpMethod = 'GET';
        req.params.put('torihikisaki_bango', 'ACNT-xxxxxxx');
        req.params.put('limit', '20');
        req.params.put('limit', 'a');
        RestContext.request  = req;
        RestContext.response = res;
        Api_V1_PtWeb_PartnerSurveyList.doGet();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'fail BadRequest');
    }
}