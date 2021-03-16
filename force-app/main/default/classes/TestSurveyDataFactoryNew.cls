@isTest
public class TestSurveyDataFactoryNew {
    public static final String recordTypeIdOppSogi =
        Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    public static final String recordTypeIdOppObo  =
        Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
    public static final String recordTypeIdAccCustomer =
        Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

    public TestSurveyDataFactoryNew() {
    }

    public void createSurvey() {
        setProduct2();
        setSurveyAndSurveyWithP2Mapping();
        setSurveyQuestion();
    }

    private static void setProduct2() {
        List<String> categoryList = new List<String>();
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO);
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI);
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU);
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_IPPAN);
        categoryList.add(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_YASUGO);
        categoryList.add('割引');
        categoryList.add(Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO);
        categoryList.add(Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO);
        categoryList.add(Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_HOYO);
        categoryList.add(Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_KAIMYO);

        PriceBook2 pb2 = new PriceBook2(
            name = 'Standard Price Book'
            ,isActive = true
        );
        insert pb2;

        for (String ctgName : categoryList) {
            String idC;
            String nameFC;
            String pName;
            String hBunrui;
            switch on ctgName {
                when '直葬' {
                    idC = 'chokuso';
                    nameFC = 'よりそうのお葬式 火葬式 直葬プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_CURRENT + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '火葬式' {
                    idC = 'kasou';
                    nameFC = 'よりそうのお葬式 火葬式 仏式プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '一日葬' {
                    idC = 'ichinichi';
                    nameFC = 'よりそうのお葬式 一日葬 無宗教プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '家族葬' {
                    idC = 'kazokusou';
                    nameFC = 'よりそうのお葬式 家族葬 花束プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '一般葬' {
                    idC = 'ippansou';
                    nameFC = 'よりそうのお葬式 一般葬 仏式プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '安豪' {
                    idC = 'yasugou-kazoku';
                    nameFC = 'お花いっぱいのお葬式 家族葬 仏式プラン';
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE + nameFC;
                    hBunrui = Cnst.PRODUCT2_BUNRUI_HONTAI;
                }
                when '割引' {
                    idC = 'waribiki';
                    nameFC = Cnst.PRODUCT2_NAME_FOR_CUSTOMER_ATOSO;
                    pName = Cnst.PRODUCT2_NAME_PREFIX_VALID_CURRENT + nameFC;
                }
                when '葬儀読経' {
                    idC = 'sougidokyou';
                    nameFC = 'お坊さん便 葬儀読経';
                    pName = nameFC;
                }
                when '葬儀戒名' {
                    idC = 'sougikaimyou';
                    nameFC = 'お坊さん便 葬儀＋戒名';
                    pName = nameFC;
                }
                when '法要' {
                    idC = 'houyou';
                    nameFC = 'お坊さん便 法要';
                    pName = nameFC;
                }
                when '戒名' {
                    idC = 'kaimyou';
                    nameFC = 'お坊さん便 戒名';
                    pName = nameFC;
                }
            }
            k_ShohinCategory__c kCtg = new k_ShohinCategory__c(
                name = ctgName
                ,id__c = idC
            );
            insert kCtg;

            //String hBunrui = ctgName == '割引' ? null : '本体';

            Product2 p = new Product2(
                Name = pName
                ,HinmokuBunrui__c = hBunrui
                ,k_ShohinCategoryRef__c  = kCtg.Id
                ,NameForCustomer__c = nameFC
            );
            insert p;
            insert new PriceBookEntry(
                Pricebook2Id = Test.getStandardPricebookId()
                ,isActive = true
                ,UseStandardPrice = false
                ,unitPrice = 1000
                ,Product2Id = p.Id);
        }
    }

    private static void setSurveyAndSurveyWithP2Mapping() {
        // 葬儀アンケート
        Survey__c ttp = new Survey__c(name = '斎場有_お坊有_paper');
        insert ttp;
        Survey__c tfp = new Survey__c(name = '斎場有_お坊無_paper');
        insert tfp;
        Survey__c ftp = new Survey__c(name = '斎場無_お坊有_paper');
        insert ftp;
        Survey__c ffp = new Survey__c(name = '斎場無_お坊無_paper');
        insert ffp;
        Survey__c ttv2 = new Survey__c(name = '斎場有_お坊有_v2');
        insert ttv2;
        Survey__c tfv2 = new Survey__c(name = '斎場有_お坊無_v2');
        insert tfv2;
        Survey__c ftv2 = new Survey__c(name = '斎場無_お坊有_v2');
        insert ftv2;
        Survey__c ffv2 = new Survey__c(name = '斎場無_お坊無_v2');
        insert ffv2;
        Survey__c atv2 = new Survey__c(name = '後葬_お坊有_v2');
        insert atv2;
        Survey__c afv2 = new Survey__c(name = '後葬_お坊無_v2');
        insert afv2;
        // お坊さん便アンケート
        Survey__c oboDokkyo = new Survey__c(name = 'お坊さん便アンケート_葬儀読経');
        insert oboDokkyo;
        Survey__c oboHoyo = new Survey__c(name = 'お坊さん便アンケート_法要');
        insert oboHoyo;
        Survey__c oboKaimyo = new Survey__c(name = 'お坊さん便アンケート_戒名');
        insert oboKaimyo;
        Survey__c oboHoyoKaimyo = new Survey__c(name = 'お坊さん便アンケート_法要_戒名');
        insert oboHoyoKaimyo;

        List<Product2> pList = [
            SELECT
                Id
                ,k_ShohinCategory_Name_exp__c
            FROM
                Product2
        ];

        List<SurveyWithProduct2Mapping__c> surveyWithProd2List = new List<SurveyWithProduct2Mapping__c>();
        for (Product2 p : pList) {
            if (p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO
                    || p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO) {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ftp.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ffp.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ftv2.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = false
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ffv2.Id
                    ,UseSogiDokkyoFlg__c = false
                    ,PaperFlg__c = false
                ));
            } else if (p.k_ShohinCategory_Name_exp__c == '割引') {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = atv2.Id
                    ,UseSogiDokkyoFlg__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = afv2.Id
                    ,UseSogiDokkyoFlg__c = false
                ));
            } else if (p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO) {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = oboDokkyo.Id
                    ,withKaimyo__c = false
                ));
            } else if (p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO) {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = oboDokkyo.Id
                    ,withKaimyo__c = true
                ));
            } else if (p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_HOYO) {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = oboHoyoKaimyo.Id
                    ,withKaimyo__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = oboHoyo.Id
                    ,withKaimyo__c = false
                ));
            } else if (p.k_ShohinCategory_Name_exp__c == Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_KAIMYO) {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = oboKaimyo.Id
                    ,withKaimyo__c = true
                ));
            } else {
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ttp.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = tfp.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = true
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = ttv2.Id
                    ,UseSogiDokkyoFlg__c = true
                    ,PaperFlg__c = false
                ));
                surveyWithProd2List.add(new SurveyWithProduct2Mapping__c (
                    Product2Id__c = p.Id
                    ,SurveyRef__c = tfv2.Id
                    ,UseSogiDokkyoFlg__c = false
                    ,PaperFlg__c = false
                ));
            }
        }
        insert surveyWithProd2List;
    }

    private static void setSurveyQuestion() {
        List<Survey__c> surveyList = [SELECT Id, Name FROM Survey__c];

        for (Survey__c survey : surveyList) {
            List<SurveyQuestion__c> qList = new List<SurveyQuestion__c>();
            Integer addQCnt = 0;
            // create 基本 questions
            if (!survey.Name.contains('お坊さん便')) {
                for (String qName : Cnst.SURVEY_QUESTION_YORISO) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    SurveyQuestion__c ysQ = new SurveyQuestion__c();
                    ysQ.SurveyRef__c = survey.Id;
                    ysQ.Name = qName;
                    ysQ.Question__c = qName;
                    ysQ.OrderNumber__c = qNo;
                    if (qNo == 0) {
                        ysQ.Type__c = 'Section';
                    } else if (qNo == 1) {
                        ysQ.Type__c     = 'Picklist';
                        ysQ.Choices__c  = getPicklistSanretsusha();
                        ysQ.Required__c = true;
                    } else if (qNo == 2 || qNo == 10) {
                        ysQ.Type__c = 'Free Text';
                        ysQ.Required__c = true;
                    } else if (qNo == 3 || qNo ==  6 || qNo ==  8) {
                        ysQ.Type__c    = 'Picklist';
                        ysQ.Choices__c = getPicklistManzokudo();
                    } else if (qNo == 4) {
                        ysQ.Type__c = 'Free Text - Single Row Visible';
                        ysQ.Required__c = true;
                    } else if (qNo == 5) {
                        ysQ.Type__c = 'Number';
                        ysQ.Required__c = true;
                    } else if (qNo == 9) {
                        ysQ.Type__c        = 'NPS';
                        ysQ.Choices__c     = getNpsChoiceStr();
                        ysQ.NpsDislike__c = '全くすすめたくない';
                        ysQ.NpsLike__c    = '非常にすすめたい';
                        ysQ.NpsMax__c     = 10;
                        ysQ.NpsMin__c     = 0;
                        ysQ.Required__c = true;
                    } else if (qNo == 14) {
                        ysQ.Type__c = 'Multi-Select--Vertical';
                        ysQ.Choices__c = getMultiSelectComparedOtherServices();
                        ysQ.Required__c = true;
                    } else if (qNo == 15) {
                        ysQ.Type__c = 'Multi-Select--Vertical';
                        ysQ.Choices__c = getMultiSelectKnowFactors();
                    }
                    qList.add(ysQ);
                }
                addQCnt += Cnst.SURVEY_QUESTION_YORISO.size();
            }
            // create 後葬 questions
            if (survey.Name.contains('後葬')) {
                for (String qName : Cnst.SURVEY_QUESTION_YORISO_ATOSO) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    SurveyQuestion__c ysatQ = new SurveyQuestion__c();
                    ysatQ.SurveyRef__c = survey.Id;
                    ysatQ.Name = qName;
                    ysatQ.Question__c = qName;
                    ysatQ.OrderNumber__c = qNo;
                    if (qNo == 11 || qNo == 12) {
                        ysatQ.Type__c = 'Free Text';
                    } else if (qNo == 13) {
                        ysatQ.Type__c    = 'Single Select--Horizontal';
                        ysatQ.Choices__c = getSingleSelectAtosoInterview();
                    }
                }
                addQCnt += Cnst.SURVEY_QUESTION_YORISO_ATOSO.size();
            }
            // create CS questions
            if (!survey.Name.contains('お坊さん便')) {
                for (String qName : Cnst.SURVEY_QUESTION_CS) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    Integer orderNo = qNo + addQCnt;
                    SurveyQuestion__c csQ = new SurveyQuestion__c();
                    csQ.SurveyRef__c = survey.Id;
                    csQ.Name = qName;
                    csQ.Question__c = qName;
                    csQ.OrderNumber__c = orderNo;
                    if (qNo == 0) {
                        csQ.Type__c = 'Section';
                    } else if (qNo == 1 || qNo == 3 || qNo == 5 || qNo == 7 || qNo == 9 || qNo == 11) {
                        csQ.Type__c    = 'Picklist';
                        csQ.Choices__c = getPicklistManzokudo();
                    } else if (qNo == 2 || qNo == 13) {
                        csQ.Type__c = 'Free Text - Single Row Visible';
                    }
                    qList.add(csQ);
                }
                addQCnt += Cnst.SURVEY_QUESTION_CS.size();
            }
            // create 葬儀社 questions
            for (String qName : Cnst.SURVEY_QUESTION_SOGISHA) {
                Integer qNo = integer.valueof(qName.substring(2));
                Integer orderNo = qNo + addQCnt;
                SurveyQuestion__c sgQ = new SurveyQuestion__c();
                sgQ.SurveyRef__c = survey.Id;
                sgQ.Name = qName;
                sgQ.Question__c = qName;
                sgQ.OrderNumber__c = orderNo;
                if (qNo == 0) {
                    sgQ.Type__c = 'Section';
                } else if (qNo == 1 || qNo == 2 || qNo == 5 || qNo == 7) {
                    sgQ.Type__c    = 'Picklist';
                    sgQ.Choices__c = getPicklistManzokudo();
                } else if (qNo == 4) {
                    sgQ.Type__c = 'Free Text';
                } else if (qNo == 9) {
                    sgQ.Type__c        = 'NPS';
                    sgQ.Choices__c     = getNpsChoiceStr();
                    sgQ.NpsDislike__c = '全くすすめたくない';
                    sgQ.NpsLike__c    = '非常にすすめたい';
                    sgQ.NpsMax__c     = 10;
                    sgQ.NpsMin__c     = 0;
                }
                qList.add(sgQ);
            }
            addQCnt += Cnst.SURVEY_QUESTION_SOGISHA.size();
            // create 斎場 questions
            if (survey.Name.contains('斎場有')) {
                for (String qName : Cnst.SURVEY_QUESTION_SAIJO) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    Integer orderNo = qNo + addQCnt;
                    SurveyQuestion__c sjQ = new SurveyQuestion__c();
                    sjQ.SurveyRef__c = survey.Id;
                    sjQ.Name = qName;
                    sjQ.Question__c = qName;
                    sjQ.OrderNumber__c = orderNo;
                    if (qNo == 0) {
                        sjQ.Type__c = 'Section';
                    } else if (qNo == 1 || qNo == 3 || qNo == 5) {
                        sjQ.Type__c    = 'Picklist';
                        sjQ.Choices__c = getPicklistManzokudo();
                    } else if (qNo == 7) {
                        sjQ.Type__c = 'Free Text';
                    }
                    qList.add(sjQ);
                }
                addQCnt += Cnst.SURVEY_QUESTION_SAIJO.size();
            }
            // create 火葬場 questions
            if (!survey.Name.contains('後葬')) {
                for (String qName : Cnst.SURVEY_QUESTION_KASOBA) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    Integer orderNo = qNo + addQCnt;
                    SurveyQuestion__c ksQ = new SurveyQuestion__c();
                    ksQ.SurveyRef__c = survey.Id;
                    ksQ.Name = qName;
                    ksQ.Question__c = qName;
                    ksQ.OrderNumber__c = orderNo;
                    if (qNo == 0) {
                        ksQ.Type__c = 'Section';
                    } else if (qNo == 1 || qNo == 3) {
                        ksQ.Type__c    = 'Picklist';
                        ksQ.Choices__c = getPicklistManzokudo();
                    } else if (qNo == 5) {
                        ksQ.Type__c = 'Free Text';
                    }
                    qList.add(ksQ);
                }
                addQCnt += Cnst.SURVEY_QUESTION_KASOBA.size();
            }
            // create お坊さん questions
            if (survey.Name.contains('お坊')) {
                for (String qName : Cnst.SURVEY_QUESTION_OBO) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    Integer orderNo = qNo + addQCnt;
                    SurveyQuestion__c obQ = new SurveyQuestion__c();
                    obQ.SurveyRef__c = survey.Id;
                    obQ.Name = qName;
                    obQ.Question__c = qName;
                    obQ.OrderNumber__c = orderNo;
                    if (qNo == 0) {
                        obQ.Type__c = 'Section';
                    } else if (qNo == 1 || qNo == 2 || qNo == 3 || qNo == 6 || qNo == 7
                            || qNo == 8 || qNo == 9 || qNo == 10 || qNo == 11 || qNo == 13
                            || qNo == 14 || qNo == 15
                            || (qNo == 5 && !survey.Name.contains('後葬'))) {
                        obQ.Type__c    = 'Single Select--Horizontal';
                        obQ.Choices__c = getSingleSelectOboYesNo();
                    } else if (qNo == 4 || qNo == 12) {
                        obQ.Type__c    = 'Single Select--Vertical';
                        obQ.Choices__c = getSingleSelectOboRepeat();
                    }
                    qList.add(obQ);
                }

                addQCnt += Cnst.SURVEY_QUESTION_OBO.size();
            }
            // create 最終 questions
            if (survey.Name.contains('_v2')) {
                for (String qName : Cnst.SURVEY_QUESTION_LAST) {
                    Integer qNo = integer.valueof(qName.substring(2));
                    Integer orderNo = qNo + addQCnt;
                    SurveyQuestion__c ltQ = new SurveyQuestion__c();
                    ltQ.SurveyRef__c = survey.Id;
                    ltQ.Name = qName;
                    ltQ.Question__c = qName;
                    ltQ.OrderNumber__c = orderNo;
                    if (qNo == 0) {
                        ltQ.Type__c = 'Section';
                    } else if (qNo == 2) {
                        ltQ.Type__c = 'Multi-Select--Vertical';
                        ltQ.Choices__c = getMultiSelectInterestServices();
                    } else if (qNo == 3) {
                        ltQ.Type__c = 'Free Text';
                    }
                    qList.add(ltQ);
                }
            }

            insert qList;
        }
    }

    private static String getPicklistSanretsusha() {
        return '1〜10人' + Cnst.LF
            + '11〜20人' + Cnst.LF
            + '21〜30人' + Cnst.LF
            + '31〜40人' + Cnst.LF
            + '41〜50人' + Cnst.LF
            + '51人以上';
    }

    private static String getPicklistPlanTypeName() {
        return '直葬'  + Cnst.LF
            + '火葬式' + Cnst.LF
            + '一日葬' + Cnst.LF
            + '家族葬' + Cnst.LF
            + '一般葬';
    }

    private static String getPicklistGender() {
        return '男性'  + Cnst.LF
            + '女性';
    }

    private static String getPicklistManzokudo() {
        return '★★★★★ とても満足'  + Cnst.LF
            + '★★★★☆ まあまあ満足' + Cnst.LF
            + '★★★☆☆ 普通'        + Cnst.LF
            + '★★☆☆☆ やや不満'    + Cnst.LF
            + '★☆☆☆☆ 不満';
    }

    private static String getNpsChoiceStr() {
        return '0' + Cnst.LF
            + '1' + Cnst.LF
            + '2' + Cnst.LF
            + '3' + Cnst.LF
            + '4' + Cnst.LF
            + '5' + Cnst.LF
            + '6' + Cnst.LF
            + '7' + Cnst.LF
            + '8' + Cnst.LF
            + '9' + Cnst.LF
            + '10';
    }

    private static String getSingleSelectOboYesNo() {
        return 'はい' + Cnst.LF
            + 'どちらでもない' + Cnst.LF
            + 'いいえ';
    }

    private static String getSingleSelectOboRepeat() {
        return '機会があれば同じ僧侶にお願いしたい' + Cnst.LF
            + '機会があれば別の僧侶にお願いしたい' + Cnst.LF
            + 'お坊さん便は使いたくない';
    }

    private static String getMultiSelectInterestServices() {
        return Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI_FULL + Cnst.LF
            + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO_FULL + Cnst.LF
            + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO_FULL + Cnst.LF
            + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO_FULL + Cnst.LF
            + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU_FULL;
    }

    private static String getSingleSelectAtosoInterview() {
        return '都合があえば協力する' + Cnst.LF
            + '匿名なら協力する' + Cnst.LF
            + '協力しない';
    }

    private static String getMultiSelectComparedOtherServices() {
        return '小さなお葬式' + Cnst.LF
            + 'イオンのお葬式' + Cnst.LF
            + '平安会館' + Cnst.LF
            + '典礼会館' + Cnst.LF
            + '公益社' + Cnst.LF
            + 'セレモア' + Cnst.LF
            + 'JA葬祭' + Cnst.LF
            + 'ベルコ' + Cnst.LF
            + 'ティア' + Cnst.LF
            + 'ファミーユ' + Cnst.LF
            + 'いい葬儀' + Cnst.LF
            + '終活ねっと' + Cnst.LF
            + '地元の葬儀社' + Cnst.LF
            + 'その他' + Cnst.LF
            + '分からない・覚えていない' + Cnst.LF
            + '他に検討した葬儀社はない';
    }

    private static String getMultiSelectKnowFactors() {
        return 'テレビCM' + Cnst.LF
            + 'インターネット広告' + Cnst.LF
            + 'インターネット検索' + Cnst.LF
            + '親族・知人などからの紹介' + Cnst.LF
            + '比較サイトやクチコミサイト' + Cnst.LF
            + 'テレビ番組・ラジオ番組で紹介されていた' + Cnst.LF
            + '新聞・チラシ広告' + Cnst.LF
            + '雑誌' + Cnst.LF
            + '以前に利用したことがあった' + Cnst.LF
            + '覚えていない' + Cnst.LF
            + 'その他';
    }

    // 配信
    public CaseSurveyVisca__c generateDelivery(
        Opportunity opp
        ,Survey__c survey
        ,Datetime createdDt
    ) {
        CaseSurveyVisca__c cSurvey = new CaseSurveyVisca__c (
            OppRef__c = opp.Id
            ,CreatedDate = createdDt
            ,Md5__c = 'abcdef123456' + opp.Id
        );
        if (survey != null) {
            cSurvey.SurveyRef__c = survey.Id;
            cSurvey.SurveyUrl__c = Env.survey.Domain__c
                + '?sid='   + survey.Id
                + '&caid=' + cSurvey.md5__c;
            cSurvey.PaperFlg__c = survey.Name.contains('_paper')? true : false;
        } else {
            cSurvey.EmailSendFlg__c = true;
        }
        if (opp.SurveySendWayHopeSms__c) {
            cSurvey.SmsSendFlg__c = true;
        }
        if (opp.SurveySendWayHopeEmail__c) {
            cSurvey.EmailSendFlg__c = true;
        }

        return cSurvey;
    }

    public CaseSurveyVisca__c createDelivery(
        Opportunity opp
        ,Survey__c survey
    ) {
        CaseSurveyVisca__c cSurvey = generateDelivery(opp, survey, Date.today().addDays(-1));
        insert cSurvey;

        return cSurvey;
    }

    public CaseSurveyVisca__c createDeliveryObo(
        Opportunity opp
        ,Survey__c survey
        ,Account acc
        ,Datetime createDate
    ) {

        CaseSurveyVisca__c cSurvey = new CaseSurveyVisca__c (
            OppRef__c = opp.Id
            ,SurveyRef__c = survey.Id
            ,CreatedDate = createDate
            ,Md5__c = 'abcdef123456' + opp.Id
        );
        cSurvey.SurveyUrl__c = Env.survey.Domain__c
            + '?id='   + survey.Id
            + '&caid=' + cSurvey.Md5__c;
        if (acc.PermissionFlag__pc == Cnst.ACCOUNT_PERMISSIONFLAG_RECIEVE) {
            if (!acc.KoukokuSmsNg__c && String.isNotEmpty(acc.MobilePhone__c)) {
                cSurvey.SmsSendFlg__c = true;
            } else if (!acc.E_NG__pc && String.isNotEmpty(acc.MailAddress__c)) {
                cSurvey.EmailSendFlg__c = true;
            }
        }
        insert cSurvey;

        return cSurvey;
    }

    public Opportunity generateBaseOpp(String name, Account acc) {
        return new Opportunity(
            RecordTypeId = recordTypeIdOppSogi
            ,Name = name
            ,AccountId = acc.id
            ,Utiagebi__c = Date.toDay().addDays(-3)
            ,StageName = '施工完了'
            ,CloseDate = Date.today().addDays(5)
            ,SurveyDiscountAgreeStatus__c = Cnst.OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE
            ,SurveySendWayHopeSms__c = true
            ,SurveySendWayHopeEmail__c = true
        );
    }

    public Opportunity generateOppObo(
        String name
        ,Account acc
        ,Obosanbin__c obo
    ) {
        return new Opportunity(
            RecordTypeId = recordTypeIdOppObo
            ,Name = name
            ,Utiagebi__c = Date.toDay().addDays(-1)
            ,KakuteibiSyodan__c = Date.toDay().addDays(-5)
            ,StageName = '施工完了'
            ,CloseDate = Date.today().addDays(5)
            ,ObosanbinRef__c = obo.Id
            ,AccountId = acc.Id
        );
    }

    public Account generateAccCustomer(String fName) {
        return new Account(
            LastName = 'テスト'
            ,FirstName = fName
            ,RecordTypeId = recordTypeIdAccCustomer
            ,PermissionFlag__pc = Cnst.ACCOUNT_PERMISSIONFLAG_RECIEVE
        );
    }

    // 回答
    public void createTaker(
        String caseSurveryId
        ,String surveyId
        ,Map<String, String> answerMap
        ,String webPostingStatus
        ,String approveStatus 
        ,String surveyAreaCd
        ,String yorisoComment
        ,String saijoComment
    ) {
        SurveyTaker__c taker = new SurveyTaker__c(
            CaseSurveyViscaRef__c = caseSurveryId
            ,SurveyRef__c    = surveyId
            ,WebPostingStatus__c    = String.isEmpty(webPostingStatus)? '未掲載' : webPostingStatus
            ,ApprovalApplyStatus__c = String.isEmpty(approveStatus)   ? null : approveStatus
            ,surveyAreaCode__c      = String.isEmpty(surveyAreaCd)    ? null : surveyAreaCd
            ,YorisoComment__c       = String.isEmpty(yorisoComment)   ? null : yorisoComment
            ,SaijoComment__c        = String.isEmpty(saijoComment)    ? null : saijoComment
        );
        insert taker;

        SurveyQuestion__c[] qList = [
            SELECT
                Id
                ,Name
            FROM
                SurveyQuestion__c
            WHERE
                SurveyRef__c = :surveyId
        ];
        setQuestionResponse(qList, taker, answerMap);
    }

    public Map<String, String> generateDefaultAnswerMap() {
        Map<String, String> answerMap = new Map<String, String>();
        answerMap.put('OD001', '99999');
        answerMap.put('OD002', '9999888');
        answerMap.put('OD003', '9999999');
        answerMap.put('OD004', '2014-01-28');
        answerMap.put('OD005', '家族葬');
        answerMap.put('OD006', '88');
        answerMap.put('OD007', '52');
        answerMap.put('OD008', '男性');
        answerMap.put('YS001', '31〜40人');
        answerMap.put('YS002', '選んだ理由回答。');
        answerMap.put('YS003', '★★★★☆ まあまあ満足');
        answerMap.put('YS004', 'プラン選んだ理由回答。');
        answerMap.put('YS005', '1234567');
        answerMap.put('YS006', '★★★★☆ まあまあ満足');
        answerMap.put('YS008', '★★★★☆ まあまあ満足');
        answerMap.put('YS009', '7');
        answerMap.put('YS010', 'よりそうよかった点回答。');
        answerMap.put('YS011', '後葬心境変化回答。');
        answerMap.put('YS012', '後葬あったら良かったサービス回答。');
        answerMap.put('YS013', '匿名なら協力する');
        answerMap.put('YS014',
            '小さなお葬式' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'イオンのお葬式' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '平安会館' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '典礼会館' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '公益社' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'セレモア' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'JA葬祭' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'ベルコ' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'ティア' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'ファミーユ' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'いい葬儀' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '終活ねっと' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '地元の葬儀社' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'その他' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '分からない・覚えていない' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '他に検討した葬儀社はない'
        );
        answerMap.put('YS015',
            'テレビCM' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'インターネット広告' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'インターネット検索' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '親族・知人などからの紹介' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '比較サイトやクチコミサイト' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'テレビ番組・ラジオ番組で紹介されていた' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '新聞・チラシ広告' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '雑誌' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '以前に利用したことがあった' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + '覚えていない' + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER
            + 'その他'
        );
        answerMap.put('CS001', '★★★★☆ まあまあ満足');
        answerMap.put('CS003', '★★★★☆ まあまあ満足');
        answerMap.put('CS005', '★★★★☆ まあまあ満足');
        answerMap.put('CS007', '★★★★☆ まあまあ満足');
        answerMap.put('CS002', 'CS良かった点回答。');
        answerMap.put('CS013', 'たなかさん');
        answerMap.put('SG001', '★★★★☆ まあまあ満足');
        answerMap.put('SG002', '★★★★☆ まあまあ満足');
        answerMap.put('SG005', '★★★★☆ まあまあ満足');
        answerMap.put('SG007', '★★★★☆ まあまあ満足');
        answerMap.put('SG009', '7');
        answerMap.put('SG004', 'そうぎしゃ良かった点回答。');
        answerMap.put('SJ001', '★★★★☆ まあまあ満足');
        answerMap.put('SJ003', '★★★★☆ まあまあ満足');
        answerMap.put('SJ005', '★★★★☆ まあまあ満足');
        answerMap.put('SJ007', 'さいじょう良かった点回答。');
        answerMap.put('KS001', '★★★★☆ まあまあ満足');
        answerMap.put('KS003', '★★★★☆ まあまあ満足');
        answerMap.put('KS005', 'かそうば良かった点回答。');
        answerMap.put('OB001', 'どちらでもない');
        answerMap.put('OB002', 'どちらでもない');
        answerMap.put('OB003', 'どちらでもない');
        answerMap.put('OB004', '機会があれば別の僧侶にお願いしたい');
        answerMap.put('OB005', 'どちらでもない');
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES,
            Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO_FULL
            + Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER + Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU_FULL);
        answerMap.put(Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME, '平日の午後');

        return answerMap;
    }

    private static void setQuestionResponse(
        SurveyQuestion__c[] qList
        ,SurveyTaker__c taker
        ,Map<String, String> answerMap
    ) {
        List<SurveyQuestionResponse__c> resList = new List<SurveyQuestionResponse__c>();

        for (SurveyQuestion__c q : qList) {
            Integer qNo = integer.valueof(q.Name.substring(2));
            if (qNo == 0) {
                continue;
            }

            SurveyQuestionResponse__c res = new SurveyQuestionResponse__c();
            res.SurveyTaker__c = taker.Id;
            res.SurveyQuestion__c = q.Id;
            res.Response__c = answerMap.get(q.Name);
            resList.add(res);
        }

        if (resList.size() > 0) {
            insert resList;
        }
    }

    // getter
    public Survey__c getSurveyByName(String name) {
        return [
            SELECT
                Id
                ,Name
            FROM
                Survey__c
            WHERE
                Name = :name
            LIMIT 1
        ];
    }

    public Product2 getProduct2ByCategory(String ctg) {
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
            WHERE k_ShohinCategory_Name_exp__c = :ctg
        ];
    }
}