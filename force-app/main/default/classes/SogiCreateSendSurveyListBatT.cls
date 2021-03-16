@isTest
private class SogiCreateSendSurveyListBatT {

    private static Map<Integer, String> successPatern = new Map<Integer, String>();
    private static Map<Integer, String> noCreatePattern = new Map<Integer, String>();

    public static void setSuccessPatern() {
        successPatern.put(1, '1_同意_SMS+Eメール_斎場有_お坊有_売上日10日前_クレーム有');
        successPatern.put(2, '2_同意_SMS_斎場有_お坊なし_売上日1日前_SmsNG_戒名のみ');
        successPatern.put(3, '3_同意_Email_斎場なし_お坊有_DmNG');
        successPatern.put(4, '4_同意_SMS_斎場なし_お坊なし');
        successPatern.put(5, '5_未同意_Eメール');
        successPatern.put(6, '6_同意_SMS+Eメール_後葬_お坊有');
        successPatern.put(7, '7_同意_SMS+Eメール_後葬_お坊なし');
    }

    private static void setDataSuccess() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String NameNo1 = successPatern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(NameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(NameNo1, accNo1);
        oppSogiNo1.Utiagebi__c = Date.toDay().addDays(-10);
        insert oppSogiNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(NameNo1, accNo1, oboNo1);
        oppOboNo1.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo1.SougiSyoudanRef__c = oppSogiNo1.Id;
        insert oppOboNo1;
        Product2 pNo1 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_IPPAN);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo1.Id
            ,Product2Id = pNo1.Id
            ,PricebookEntryId = pNo1.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        insert new Task(
            WhatId = oppSogiNo1.Id
            ,Claim__c = true
        );
        // No2
        String NameNo2 = successPatern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(NameNo2);
        accNo2.MobilePhone__c = '09000000000';
        accNo2.KoukokuSmsNg__c = true;
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(NameNo2, accNo2);
        oppSogiNo2.Utiagebi__c = Date.toDay().addDays(-1);
        oppSogiNo2.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo2;
        Obosanbin__c oboNo2 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KAIMYO_OR_HOMYO_ONLY
        );
        insert oboNo2;
        Opportunity oppOboNo2 = surveyFactory.generateOppObo(NameNo2, accNo2, oboNo2);
        oppOboNo2.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo2.SougiSyoudanRef__c = oppSogiNo2.Id;
        insert oppOboNo2;
        Product2 pNo2 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo2.Id
            ,Product2Id = pNo2.Id
            ,PricebookEntryId = pNo2.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No3
        String NameNo3 = successPatern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(NameNo3);
        accNo3.MailAddress__c = 'accNo3@example.com';
        accNo3.KoukokuDmNg__c = true;
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(NameNo3, accNo3);
        oppSogiNo3.SurveySendWayHopeSms__c = false;
        insert oppSogiNo3;
        Obosanbin__c oboNo3 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KASO
        );
        insert oboNo3;
        Opportunity oppOboNo3 = surveyFactory.generateOppObo(NameNo3, accNo3, oboNo3);
        oppOboNo3.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo3.SougiSyoudanRef__c = oppSogiNo3.Id;
        insert oppOboNo3;
        Product2 pNo3 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo3.Id
            ,Product2Id = pNo3.Id
            ,PricebookEntryId = pNo3.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No4
        String NameNo4 = successPatern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(NameNo4);
        accNo4.MobilePhone__c = '09000000000';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(NameNo4, accNo4);
        oppSogiNo4.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo4;
        Product2 pNo4 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo4.Id
            ,Product2Id = pNo4.Id
            ,PricebookEntryId = pNo4.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No5
        String NameNo5 = successPatern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(NameNo5);
        accNo5.MobilePhone__c = '07000000000';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Opportunity oppSogiNo5 = surveyFactory.generateBaseOpp(NameNo5, accNo5);
        oppSogiNo5.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo5.SurveySendWayHopeSms__c = false;
        oppSogiNo5.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo5;
        Product2 pNo5 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo5.Id
            ,Product2Id = pNo5.Id
            ,PricebookEntryId = pNo5.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No6
        String NameNo6 = successPatern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(NameNo6);
        accNo6.MobilePhone__c = '090-0000-0000';
        accNo6.MailAddress__c = 'accNo6@example.com';
        insert accNo6;
        Opportunity oppSogiNo6 = surveyFactory.generateBaseOpp(NameNo6, accNo6);
        insert oppSogiNo6;
        Obosanbin__c oboNo6 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_ICHINICHI
        );
        insert oboNo6;
        Opportunity oppOboNo6 = surveyFactory.generateOppObo(NameNo6, accNo6, oboNo6);
        oppOboNo6.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo6.SougiSyoudanRef__c = oppSogiNo6.Id;
        insert oppOboNo6;
        Product2 pNo6 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo6.Id
            ,Product2Id = pNo6.Id
            ,PricebookEntryId = pNo6.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        Product2 pAtosoNo6 = surveyFactory.getProduct2ByCategory('割引');
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo6.Id
            ,Product2Id = pAtosoNo6.Id
            ,PricebookEntryId = pAtosoNo6.PricebookEntries[0].Id
        );
        // No7
        String NameNo7 = successPatern.get(7);
        Account accNo7 = surveyFactory.generateAccCustomer(NameNo7);
        accNo7.MobilePhone__c = '0800000-0000';
        accNo7.MailAddress__c = 'accNo7@example.com';
        insert accNo7;
        Opportunity oppSogiNo7 = surveyFactory.generateBaseOpp(NameNo7, accNo7);
        insert oppSogiNo7;
        Product2 pNo7 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo7.Id
            ,Product2Id = pNo7.Id
            ,PricebookEntryId = pNo7.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        Product2 pAtosoNo7 = surveyFactory.getProduct2ByCategory('割引');
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo7.Id
            ,Product2Id = pAtosoNo7.Id
            ,PricebookEntryId = pAtosoNo7.PricebookEntries[0].Id
        );
    }

    public static void setNoCreatePattern() {
        noCreatePattern.put(1, '1_DmNg');
        noCreatePattern.put(2, '2_SmsNg');
        noCreatePattern.put(3, '3_クレーム有');
        noCreatePattern.put(4, '4_コンタクトクレーム有');
        noCreatePattern.put(5, '5_対象アンケート見つからない');
        noCreatePattern.put(6, '6_売上日11日前');
        noCreatePattern.put(7, '7_売上日当日');
        noCreatePattern.put(8, '8_送信データ作成済');
        noCreatePattern.put(9, '9_Ngなしでメアドなし');
        noCreatePattern.put(10, '10_葬儀商談ではない');
        noCreatePattern.put(11, '11_同意済みだが送信方法希望チェックなし');
    }

    private static void setDataNoCreate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String NameNo1 = noCreatePattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(NameNo1);
        accNo1.MailAddress__c = 'accNo1@example.com';
        accNo1.KoukokuDmNg__c = true;
        insert accNo1;
        Opportunity oppSogiNo1 = surveyFactory.generateBaseOpp(NameNo1, accNo1);
        oppSogiNo1.SurveyDiscountAgreeStatus__c = '検討中';
        oppSogiNo1.SurveySendWayHopeSms__c = false;
        oppSogiNo1.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo1;
        Product2 pNo1 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo1.Id
            ,Product2Id = pNo1.Id
            ,PricebookEntryId = pNo1.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No2
        String NameNo2 = noCreatePattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(NameNo2);
        accNo2.MailAddress__c  = 'accNo2@example.com';
        accNo2.KoukokuSmsNg__c = true;
        insert accNo2;
        Opportunity oppSogiNo2 = surveyFactory.generateBaseOpp(NameNo2, accNo2);
        oppSogiNo2.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo2.SurveySendWayHopeSms__c = false;
        oppSogiNo2.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo2;
        Product2 pNo2 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo2.Id
            ,Product2Id = pNo2.Id
            ,PricebookEntryId = pNo2.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No3
        String NameNo3 = noCreatePattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(NameNo3);
        accNo3.MailAddress__c  = 'accNo3@example.com';
        accNo3.KoukokuSmsNg__c = true;
        insert accNo3;
        Opportunity oppSogiNo3 = surveyFactory.generateBaseOpp(NameNo3, accNo3);
        oppSogiNo3.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo3.SurveySendWayHopeSms__c = false;
        oppSogiNo3.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo3;
        Product2 pNo3 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo3.Id
            ,Product2Id = pNo3.Id
            ,PricebookEntryId = pNo3.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        insert new Claim__c(
            OpportunityRef__c = oppSogiNo3.Id
            ,OkyakusamaRef__c = accNo3.Id
        );
        // No4
        String NameNo4 = noCreatePattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(NameNo4);
        accNo4.MailAddress__c  = 'accNo4@example.com';
        accNo4.KoukokuSmsNg__c = true;
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(NameNo4, accNo4);
        oppSogiNo4.SurveyDiscountAgreeStatus__c = '未提案';
        oppSogiNo4.SurveySendWayHopeSms__c = false;
        oppSogiNo4.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo4;
        Product2 pNo4 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo4.Id
            ,Product2Id = pNo4.Id
            ,PricebookEntryId = pNo4.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        insert new Task(
            WhatId = oppSogiNo4.Id
            ,Claim__c = false
        );
        insert new Task(
            WhatId = oppSogiNo4.Id
            ,Claim__c = true
        );
        // No5
        String NameNo5 = noCreatePattern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(NameNo5);
        accNo5.MobilePhone__c = '0800000-0000';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Opportunity oppSogiNo5 = surveyFactory.generateBaseOpp(NameNo5, accNo5);
        insert oppSogiNo5;
        Product2 pNosurveyNo5 = new Product2(
            Name = 'アンケートマッピングなし'
            ,NameForCustomer__c = 'アンケートマッピングなし'
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        insert pNosurveyNo5;
        insert new PriceBookEntry(
                Pricebook2Id = Test.getStandardPricebookId()
                ,isActive = true
                ,UseStandardPrice = false
                ,unitPrice = 1000
                ,Product2Id = pNosurveyNo5.Id);
        pNosurveyNo5 = [SELECT Id,(SELECT Id FROM PricebookEntries) FROM Product2 WHERE Name = 'アンケートマッピングなし'];
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo5.Id
            ,Product2Id = pNosurveyNo5.Id
            ,PricebookEntryId = pNosurveyNo5.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No6
        String NameNo6 = noCreatePattern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(NameNo6);
        accNo6.MobilePhone__c = '08000000000';
        accNo6.MailAddress__c = 'accNo6@example.com';
        insert accNo6;
        Opportunity oppSogiNo6 = surveyFactory.generateBaseOpp(NameNo6, accNo6);
        oppSogiNo6.Utiagebi__c = Date.today().addDays(-11);
        insert oppSogiNo6;
        Product2 pNo6 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo6.Id
            ,Product2Id = pNo6.Id
            ,PricebookEntryId = pNo6.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No7
        String NameNo7 = noCreatePattern.get(7);
        Account accNo7 = surveyFactory.generateAccCustomer(NameNo7);
        accNo7.MobilePhone__c = '08000000000';
        accNo7.MailAddress__c = 'accNo7@example.com';
        insert accNo7;
        Opportunity oppSogiNo7 = surveyFactory.generateBaseOpp(NameNo7, accNo7);
        oppSogiNo7.Utiagebi__c = Date.today();
        insert oppSogiNo7;
        Product2 pNo7 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo7.Id
            ,Product2Id = pNo7.Id
            ,PricebookEntryId = pNo7.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No8
        String NameNo8 = noCreatePattern.get(8);
        Account accNo8 = surveyFactory.generateAccCustomer(NameNo8);
        accNo8.MobilePhone__c = '08000000000';
        accNo8.MailAddress__c = 'accNo8@example.com';
        insert accNo8;
        Opportunity oppSogiNo8 = surveyFactory.generateBaseOpp(NameNo8, accNo8);
        insert oppSogiNo8;
        Product2 pNo8 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo8.Id
            ,Product2Id = pNo8.Id
            ,PricebookEntryId = pNo8.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        Survey__c surveyNo8 = surveyFactory.getSurveyByName('斎場無_お坊無_v2');
        surveyFactory.createDelivery(oppSogiNo8, surveyNo8);
        // No9
        String NameNo9 = noCreatePattern.get(9);
        Account accNo9 = surveyFactory.generateAccCustomer(NameNo9);
        accNo9.MobilePhone__c = '08000000000';
        insert accNo9;
        Opportunity oppSogiNo9 = surveyFactory.generateBaseOpp(NameNo9, accNo9);
        oppSogiNo9.SurveyDiscountAgreeStatus__c = '拒否';
        oppSogiNo9.SurveySendWayHopeSms__c = false;
        oppSogiNo9.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo9;
        Product2 pNo9 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_KASO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo9.Id
            ,Product2Id = pNo9.Id
            ,PricebookEntryId = pNo9.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No10
        String NameNo10 = noCreatePattern.get(10);
        Account accNo10 = surveyFactory.generateAccCustomer(NameNo1);
        accNo10.MobilePhone__c = '090-0000-0000';
        accNo10.MailAddress__c = 'accNo10@example.com';
        insert accNo10;
        Obosanbin__c oboNo10 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo10;
        Opportunity oppOboNo10 = surveyFactory.generateOppObo(NameNo10, accNo10, oboNo10);
        oppOboNo10.SurveyDiscountAgreeStatus__c = Cnst.OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE;
        oppOboNo10.SurveySendWayHopeSms__c = true;
        oppOboNo10.SurveySendWayHopeEmail__c = true;
        oppOboNo10.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo10;
        Product2 pNo10 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_IPPAN);
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo10.Id
            ,Product2Id = pNo10.Id
            ,PricebookEntryId = pNo10.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
        // No11
        String NameNo11 = noCreatePattern.get(11);
        Account accNo11 = surveyFactory.generateAccCustomer(NameNo11);
        accNo11.MobilePhone__c = '09000000000';
        accNo10.MailAddress__c = 'accNo11@example.com';
        insert accNo11;
        Opportunity oppSogiNo11 = surveyFactory.generateBaseOpp(NameNo11, accNo11);
        oppSogiNo11.SurveySendWayHopeSms__c = false;
        oppSogiNo11.SurveySendWayHopeEmail__c = false;
        insert oppSogiNo11;
        Product2 pNo11 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO);
        insert new OpportunityLineItem(
            OpportunityId = oppSogiNo11.Id
            ,Product2Id = pNo11.Id
            ,PricebookEntryId = pNo11.PricebookEntries[0].Id
            ,HinmokuBunrui__c = Cnst.PRODUCT2_BUNRUI_HONTAI
        );
    }

    public static void setOneExecMaxDataPatern() {
        successPatern.put(1, '1_15件');
    }

    private static void setDataOneExecMax() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();

        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 15; i++) {
            String Name = '多重データ_' + i;
            Account acc = surveyFactory.generateAccCustomer(Name);
            acc.MobilePhone__c = '08000000000';
            acc.MailAddress__c = 'acc_' + i + '@example.com';
            accs.add(acc);
        }
        insert accs;

        List<Opportunity> opps = new List<Opportunity>();
        for (Account acc : accs) {
            String oppName = '葬儀商談_' + acc.Name;
            Opportunity opp = surveyFactory.generateBaseOpp(oppName, acc);
            opps.add(opp);
        }
        insert opps;

        Product2 p2 = surveyFactory.getProduct2ByCategory(Cnst.PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO);
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (Opportunity opp : opps) {
           oppLineItems.add(new OpportunityLineItem(
                    HinmokuBunrui__c = '本体'
                    ,OpportunityId = opp.Id
                    ,Product2Id = p2.Id
                    ,PricebookEntryId = p2.PricebookEntries[0].Id
            ));
        }
        insert oppLineItems;
    }

    private static List<CaseSurveyVisca__c> getRslts() {
        return [
            SELECT
                Id
                ,OppRef__r.Id
                ,OppRef__r.Name
                ,OppRef__r.Account.Name
                ,PaperFlg__c
                ,SurveyUrl__c
                ,SmsSendFlg__c
                ,SmsSendDatetime__c
                ,SmsSendCount__c
                ,EmailSendFlg__c
                ,EmailSendDatetime__c
                ,EmailSendCount__c
                ,SurveyRef__r.Name
            FROM
                CaseSurveyVisca__c
        ];
    }

    private static void assertCreated(
        CaseSurveyVisca__c cs
        ,String no
        ,String exptSurveyName
        ,Boolean exptSmsFlg
        ,Boolean exptEmailFlg
    ) {
        System.assertEquals(0,       cs.SmsSendCount__c,      no + ' sms send count fail');
        System.assertEquals(null,    cs.SmsSendDatetime__c,   no + ' sms send datetime fail');
        System.assertEquals(0,       cs.EmailSendCount__c,    no + ' email send count fail');
        System.assertEquals(null,    cs.EmailSendDatetime__c, no + ' email send datetime fail');
        System.assertEquals(exptSurveyName, cs.SurveyRef__r.Name, no + ' survey fail');
        System.assertEquals(exptSmsFlg,     cs.SmsSendFlg__c,     no + ' sms flg fail');
        System.assertEquals(exptEmailFlg,   cs.EmailSendFlg__c,   no + ' email flg fail');
        if (exptSurveyName == null) {
            System.assertEquals(null,    cs.SurveyUrl__c, no + ' survey url fail');
        } else {
            System.assertNotEquals(null, cs.SurveyUrl__c, no + ' survey url fail');
        }
    }

    private static void debugRslt(CaseSurveyVisca__c cs) {
        System.debug(cs.OppRef__r.Name);
        System.debug(cs.SmsSendFlg__c);
        System.debug(cs.SmsSendDatetime__c);
        System.debug(cs.SmsSendCount__c);
        System.debug(cs.EmailSendFlg__c);
        System.debug(cs.EmailSendDatetime__c);
        System.debug(cs.EmailSendCount__c);
        System.debug(cs.SurveyUrl__c);
    }

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
    private static void endSetUp(){
        Insert new TriggerIsActive__c( Name='default', isActive__c=true );
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
        System.schedule('TestSogiCreateSendSurveyListBatT' + year + month + day + hour + minute + second, sch, new SogiCreateSendSurveyListBat());
        Test.stopTest();

    }

    @isTest
    static void testSuccess() {
        beginSetUp();
        setSuccessPatern();
        setDataSuccess();
        endSetUp();

        Test.startTest();
        SogiCreateSendSurveyListBat batchable = new SogiCreateSendSurveyListBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        System.assertEquals(7, rslts.size());

        for (CaseSurveyVisca__c r : rslts) {
            debugRslt(r);
            if (r.OppRef__r.Name == successPatern.get(1)) {
                assertCreated(r, 'No1', '斎場有_お坊有_v2', true, true);
            } else if (r.OppRef__r.Name == successPatern.get(2)) {
                assertCreated(r, 'No2', '斎場有_お坊無_v2', true, false);
            } else if (r.OppRef__r.Name == successPatern.get(3)) {
                assertCreated(r, 'No3', '斎場無_お坊有_v2', false, true);
            } else if (r.OppRef__r.Name == successPatern.get(4)) {
                assertCreated(r, 'No4', '斎場無_お坊無_v2', true, false);
            } else if (r.OppRef__r.Name == successPatern.get(5)) {
                assertCreated(r, 'No5', null, false, true);
            } else if (r.OppRef__r.Name == successPatern.get(6)) {
                assertCreated(r, 'No6', '後葬_お坊有_v2', true, true);
            } else if (r.OppRef__r.Name == successPatern.get(7)) {
                assertCreated(r, 'No7', '後葬_お坊無_v2', true, true);
            }
        }
    }

    @isTest
    static void testNoCreate() {
        beginSetUp();
        setNoCreatePattern();
        setDataNoCreate();
        endSetUp();

        Test.startTest();
        SogiCreateSendSurveyListBat batchable = new SogiCreateSendSurveyListBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        for (CaseSurveyVisca__c r : rslts) {
            System.debug('kkkkkkkkk');
            debugRslt(r);
        }
        // 重複用データのみ
        System.assertEquals(1, rslts.size());
    }

    @isTest
    static void testOneExecMaxCreate() {
        beginSetUp();
        setOneExecMaxDataPatern();
        setDataOneExecMax();
        endSetUp();

        Test.startTest();
        SogiCreateSendSurveyListBat batchable = new SogiCreateSendSurveyListBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        System.assertEquals(15, rslts.size(), 'Not except record is exist.');
    }
}