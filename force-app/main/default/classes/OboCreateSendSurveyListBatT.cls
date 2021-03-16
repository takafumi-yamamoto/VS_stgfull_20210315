@isTest
private class OboCreateSendSurveyListBatT {

    private static Map<Integer, String> successPatern = new Map<Integer, String>();
    private static Map<Integer, String> noCreatePattern = new Map<Integer, String>();

    public static void setSuccessPatern() {
        successPatern.put(1, '1_葬儀戒名_sms');
        successPatern.put(2, '2_葬儀読経_email_携帯番号なし');
        successPatern.put(3, '3_法要_email_携帯番号不正060');
        successPatern.put(4, '4_戒名_email_携帯番号不正12桁');
        successPatern.put(5, '5_法要_戒名_email_携帯番号不正全角数値');
        successPatern.put(6, '6_葬儀戒名_法要_sms_商品・サービス案内EメールSMSがなし');
        successPatern.put(7, '7_葬儀読経_戒名_sms');
        successPatern.put(8, '8_法要_戒名_email_SMSng_葬儀施行');
    }

    private static void setDataSuccess() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = successPatern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(nameNo1, accNo1, oboNo1);
        oppOboNo1.StageName = Cnst.OPPORTUNITY_PHASE_KETTEI;
        oppOboNo1.RyunyumotoService__c = Cnst.OPPORTUNITY_INFROW_SERVICE_SOGI + '-リピート';
        insert oppOboNo1;
        Product2 pNo1 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo1.Id
            ,Product2Id = pNo1.Id
            ,PricebookEntryId = pNo1.PricebookEntries[0].Id
        );
        // No2
        String nameNo2 = successPatern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MailAddress__c = 'accNo2@example.com';
        insert accNo2;
        Obosanbin__c oboNo2 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KASO
        );
        insert oboNo2;
        Opportunity oppOboNo2 = surveyFactory.generateOppObo(nameNo2, accNo2, oboNo2);
        oppOboNo2.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_WAIT;
        oppOboNo2.RyunyumotoService__c = '葬儀レビ';
        insert oppOboNo2;
        Product2 pNo2 = surveyFactory.getProduct2ByCategory('葬儀読経');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo2.Id
            ,Product2Id = pNo2.Id
            ,PricebookEntryId = pNo2.PricebookEntries[0].Id
        );
        // No3
        String nameNo3 = successPatern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo1.MobilePhone__c = '060-0000-0000';
        accNo3.MailAddress__c = 'accNo3@example.com';
        insert accNo3;
        Obosanbin__c oboNo3 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
        );
        insert oboNo3;
        Opportunity oppOboNo3 = surveyFactory.generateOppObo(nameNo3, accNo3, oboNo3);
        oppOboNo3.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo3;
        Product2 pNo3 = surveyFactory.getProduct2ByCategory('法要');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo3.Id
            ,Product2Id = pNo3.Id
            ,PricebookEntryId = pNo3.PricebookEntries[0].Id
        );
        // No4
        String nameNo4 = successPatern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo1.MobilePhone__c = '080000000001';
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Obosanbin__c oboNo4 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KAIMYO_OR_HOMYO_ONLY
        );
        insert oboNo4;
        Opportunity oppOboNo4 = surveyFactory.generateOppObo(nameNo4, accNo4, oboNo4);
        oppOboNo4.StageName = Cnst.OPPORTUNITY_PHASE_CLOSE;
        insert oppOboNo4;
        Product2 pNo4 = surveyFactory.getProduct2ByCategory('戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo4.Id
            ,Product2Id = pNo4.Id
            ,PricebookEntryId = pNo4.PricebookEntries[0].Id
        );
        // No5
        String nameNo5 = successPatern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo1.MobilePhone__c = '０７０００００００００';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Obosanbin__c oboNo5 = new Obosanbin__c(
            MemorialServicePlan__c = '初七日法要'
            ,Kaimyojuyo__c = '戒名の授与を希望する'
        );
        insert oboNo5;
        Opportunity oppOboNo5 = surveyFactory.generateOppObo(nameNo5, accNo5, oboNo5);
        oppOboNo5.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo5;
        Product2 pNo5 = surveyFactory.getProduct2ByCategory('法要');
        Product2 pKaimyoNo5 = surveyFactory.getProduct2ByCategory('戒名');
        List<Product2> productsNo5 = new List<Product2>();
        productsNo5.add(pNo5);
        productsNo5.add(pKaimyoNo5);
        List<OpportunityLineItem> oppLineItemsNo5 = genOppLineItems(oppOboNo5, productsNo5);
        insert oppLineItemsNo5;
        // No6
        String nameNo6 = successPatern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(nameNo6);
        accNo6.MobilePhone__c = '0704000-0000';
        accNo6.MailAddress__c = 'accNo6@example.com';
        accNo6.PermissionFlag__pc = null;
        insert accNo6;
        Obosanbin__c oboNo6 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KASO
            ,Kaimyojuyo__c = '戒名の授与を希望しない'
        );
        insert oboNo6;
        Opportunity oppOboNo6 = surveyFactory.generateOppObo(nameNo6, accNo6, oboNo6);
        oppOboNo6.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo6;
        Product2 pNo6 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        Product2 pHoyoNo6 = surveyFactory.getProduct2ByCategory('法要');
        List<Product2> productsNo6 = new List<Product2>();
        productsNo6.add(pNo6);
        productsNo6.add(pHoyoNo6);
        List<OpportunityLineItem> oppLineItemsNo6 = genOppLineItems(oppOboNo6, productsNo6);
        insert oppLineItemsNo6;
        // No7
        String nameNo7 = successPatern.get(7);
        Account accNo7 = surveyFactory.generateAccCustomer(nameNo7);
        accNo7.MobilePhone__c = '080-00000000';
        accNo7.MailAddress__c = 'accNo7@example.com';
        insert accNo7;
        Obosanbin__c oboNo7 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_ICHINICHI
            ,Kaimyojuyo__c = '戒名の授与を希望する'
        );
        insert oboNo7;
        Opportunity oppOboNo7 = surveyFactory.generateOppObo(nameNo7, accNo7, oboNo7);
        oppOboNo7.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo7;
        Product2 pNo7 = surveyFactory.getProduct2ByCategory('葬儀読経');
        Product2 pKaimyoNo7 = surveyFactory.getProduct2ByCategory('戒名');
        List<Product2> productsNo7 = new List<Product2>();
        productsNo7.add(pNo7);
        productsNo7.add(pKaimyoNo7);
        List<OpportunityLineItem> oppLineItemsNo7 = genOppLineItems(oppOboNo7, productsNo7);
        insert oppLineItemsNo7;
        // No8
        String nameNo8 = successPatern.get(8);
        Account accNo8 = surveyFactory.generateAccCustomer(nameNo8);
        accNo8.MobilePhone__c = '090-0000-0000';
        accNo8.MailAddress__c = 'accNo8@example.com';
        accNo8.KoukokuSmsNg__c = true;
        insert accNo8;
        Opportunity oppSogiNo8 = surveyFactory.generateBaseOpp(nameNo8, accNo8);
        insert oppSogiNo8;
        Obosanbin__c oboNo8 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo8;
        Opportunity oppOboNo8 = surveyFactory.generateOppObo(nameNo8, accNo8, oboNo8);
        oppOboNo8.SougiSyoudanRef__c = oppSogiNo8.Id;
        oppOboNo8.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo8;
        Product2 pNo8 = surveyFactory.getProduct2ByCategory('法要');
        Product2 pKaimyoNo8 = surveyFactory.getProduct2ByCategory('戒名');
        List<Product2> productsNo8 = new List<Product2>();
        productsNo8.add(pNo8);
        productsNo8.add(pKaimyoNo8);
        List<OpportunityLineItem> oppLineItemsNo8 = genOppLineItems(oppOboNo8, productsNo8);
        insert oppLineItemsNo8;
    }

    public static void setNoCreatePattern() {
        noCreatePattern.put(1, '1_僧侶手配代行-リピート(3回目)');
        noCreatePattern.put(2, '2_商品・サービス案内EメールSMSが受け取らない');
        noCreatePattern.put(3, '3_SMSNG_EmailNG');
        noCreatePattern.put(4, '4_葬儀で読経ありアンケート送付済み');
        noCreatePattern.put(5, '5_重複');
        noCreatePattern.put(6, '6_アンケートなし');
        noCreatePattern.put(7, '7_送付方法なし');
        noCreatePattern.put(8, '8_有効フェーズ以外');
        noCreatePattern.put(9, '9_てらぱす');
        noCreatePattern.put(10, '10_商品なし');
    }    

    public static void setDataNoCreate() {
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();
        // No1
        String nameNo1 = noCreatePattern.get(1);
        Account accNo1 = surveyFactory.generateAccCustomer(nameNo1);
        accNo1.MobilePhone__c = '090-0000-0000';
        accNo1.MailAddress__c = 'accNo1@example.com';
        insert accNo1;
        Obosanbin__c oboNo1 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
        );
        insert oboNo1;
        Opportunity oppOboNo1 = surveyFactory.generateOppObo(nameNo1, accNo1, oboNo1);
        oppOboNo1.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo1.RyunyumotoService__c = Cnst.OPPORTUNITY_INFROW_SERVICE_SORYO_TEHAI_DAIKO + '-リピート(3回目)';
        insert oppOboNo1;
        Product2 pNo1 = surveyFactory.getProduct2ByCategory('法要');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo1.Id
            ,Product2Id = pNo1.Id
            ,PricebookEntryId = pNo1.PricebookEntries[0].Id
        );
        // No2
        String nameNo2 = noCreatePattern.get(2);
        Account accNo2 = surveyFactory.generateAccCustomer(nameNo2);
        accNo2.MobilePhone__c = '090-0000-0000';
        accNo2.MailAddress__c = 'accNo2@example.com';
        accNo2.PermissionFlag__pc = Cnst.ACCOUNT_PERMISSIONFLAG_NORECIEVE;
        insert accNo2;
        Obosanbin__c oboNo2 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo2;
        Opportunity oppOboNo2 = surveyFactory.generateOppObo(nameNo2, accNo2, oboNo2);
        oppOboNo2.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo2;
        Product2 pNo2 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo2.Id
            ,Product2Id = pNo2.Id
            ,PricebookEntryId = pNo2.PricebookEntries[0].Id
        );
        // No3
        String nameNo3 = noCreatePattern.get(3);
        Account accNo3 = surveyFactory.generateAccCustomer(nameNo3);
        accNo3.MobilePhone__c = '090-0000-0000';
        accNo3.MailAddress__c = 'accNo3@example.com';
        accNo3.KoukokuSmsNg__c = true;
        accNo3.E_NG__pc = true;
        insert accNo3;
        Obosanbin__c oboNo3 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo3;
        Opportunity oppOboNo3 = surveyFactory.generateOppObo(nameNo3, accNo3, oboNo3);
        oppOboNo3.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo3;
        Product2 pNo3 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo3.Id
            ,Product2Id = pNo3.Id
            ,PricebookEntryId = pNo3.PricebookEntries[0].Id
        );
        // No4
        String nameNo4 = noCreatePattern.get(4);
        Account accNo4 = surveyFactory.generateAccCustomer(nameNo4);
        accNo4.MobilePhone__c = '090-0000-0000';
        accNo4.MailAddress__c = 'accNo4@example.com';
        insert accNo4;
        Opportunity oppSogiNo4 = surveyFactory.generateBaseOpp(nameNo4, accNo4);
        insert oppSogiNo4;
        Obosanbin__c oboNo4 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo4;
        Opportunity oppOboNo4 = surveyFactory.generateOppObo(nameNo4, accNo4, oboNo4);
        oppOboNo4.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo4.SougiSyoudanRef__c = oppSogiNo4.Id;
        oppOboNo4.RyunyumotoService__c = Cnst.OPPORTUNITY_INFROW_SERVICE_SOGI;
        insert oppOboNo4;
        Product2 pNo4 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo4.Id
            ,Product2Id = pNo4.Id
            ,PricebookEntryId = pNo4.PricebookEntries[0].Id
        );
        // No5
        String nameNo5 = noCreatePattern.get(5);
        Account accNo5 = surveyFactory.generateAccCustomer(nameNo5);
        accNo5.MobilePhone__c = '07000000000';
        accNo5.MailAddress__c = 'accNo5@example.com';
        insert accNo5;
        Obosanbin__c oboNo5 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo5;
        Opportunity oppOboNo5 = surveyFactory.generateOppObo(nameNo5, accNo5, oboNo5);
        oppOboNo5.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo5;
        Product2 pNo5 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo5.Id
            ,Product2Id = pNo5.Id
            ,PricebookEntryId = pNo5.PricebookEntries[0].Id
        );
        Survey__c surveyNo5 = surveyFactory.getSurveyByName('お坊さん便アンケート_葬儀読経');
        CaseSurveyVisca__c cSurveyNo5 = surveyFactory.createDelivery(oppOboNo5, surveyNo5);
        // No6
        String nameNo6 = noCreatePattern.get(6);
        Account accNo6 = surveyFactory.generateAccCustomer(nameNo6);
        accNo6.MobilePhone__c = '09000000000';
        accNo6.MailAddress__c = 'accNo6@example.com';
        insert accNo6;
        Obosanbin__c oboNo6 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo6;
        Opportunity oppOboNo6 = surveyFactory.generateOppObo(nameNo6, accNo6, oboNo6);
        oppOboNo6.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo6;
        k_ShohinCategory__c kCtgNo6 = [SELECT Id FROM k_ShohinCategory__c WHERE Name = '法要'];
        Product2 pNo6 = new Product2(
            Name = 'ノーマッピング法要'
            ,k_ShohinCategoryRef__c  = kCtgNo6.Id
            ,NameForCustomer__c = 'ノーマッピング法要'
        );
        insert pNo6;
        PriceBookEntry pBookNo6 = new PriceBookEntry(
                Pricebook2Id = Test.getStandardPricebookId()
                ,isActive = true
                ,UseStandardPrice = false
                ,unitPrice = 1000
                ,Product2Id = pNo6.Id
        );
        insert pBookNo6;
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo6.Id
            ,Product2Id = pNo6.Id
            ,PricebookEntryId = pBookNo6.Id
        );
        // No7
        String nameNo7 = noCreatePattern.get(7);
        Account accNo7 = surveyFactory.generateAccCustomer(nameNo7);
        insert accNo7;
        Obosanbin__c oboNo7 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo7;
        Opportunity oppOboNo7 = surveyFactory.generateOppObo(nameNo7, accNo7, oboNo7);
        oppOboNo7.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo7;
        Product2 pNo7 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo7.Id
            ,Product2Id = pNo7.Id
            ,PricebookEntryId = pNo7.PricebookEntries[0].Id
        );
        // No8
        String nameNo8 = noCreatePattern.get(8);
        Account accNo8 = surveyFactory.generateAccCustomer(nameNo8);
        accNo8.MobilePhone__c = '090-0000-0000';
        accNo8.MailAddress__c = 'accNo8@example.com';
        insert accNo8;
        Obosanbin__c oboNo8 = new Obosanbin__c(
            MemorialServicePlan__c = Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
        );
        insert oboNo8;
        Opportunity oppOboNo8 = surveyFactory.generateOppObo(nameNo8, accNo8, oboNo8);
        oppOboNo8.StageName = '除外';
        insert oppOboNo8;
        Product2 pNo8 = surveyFactory.getProduct2ByCategory('葬儀戒名');
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo8.Id
            ,Product2Id = pNo8.Id
            ,PricebookEntryId = pNo8.PricebookEntries[0].Id
        );
        // No9
        String nameNo9 = noCreatePattern.get(9);
        Account accNo9 = surveyFactory.generateAccCustomer(nameNo9);
        accNo9.MobilePhone__c = '090-0000-0000';
        accNo9.MailAddress__c = 'accNo9@example.com';
        insert accNo9;
        Obosanbin__c oboNo9 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
        );
        insert oboNo9;
        Opportunity oppOboNo9 = surveyFactory.generateOppObo(nameNo9, accNo9, oboNo9);
        oppOboNo9.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        oppOboNo9.RyunyumotoService__c = Cnst.OPPORTUNITY_INFROW_SERVICE_TERAPASS;
        insert oppOboNo9;
        k_ShohinCategory__c kCtgNo9 = [SELECT Id FROM k_ShohinCategory__c WHERE Name = '法要'];
        Product2 pNo9 = new Product2(
            Name = '定額僧侶手配代行'
            ,k_ShohinCategoryRef__c  = kCtgNo9.Id
            ,NameForCustomer__c = '定額僧侶手配代行'
        );
        insert pNo9;
        PriceBookEntry pBookNo9 = new PriceBookEntry(
                Pricebook2Id = Test.getStandardPricebookId()
                ,isActive = true
                ,UseStandardPrice = false
                ,unitPrice = 1000
                ,Product2Id = pNo9.Id
        );
        insert pBookNo9;
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo9.Id
            ,Product2Id = pNo9.Id
            ,PricebookEntryId = pBookNo9.Id
        );
        // No10
        String nameNo10 = noCreatePattern.get(10);
        Account accNo10 = surveyFactory.generateAccCustomer(nameNo10);
        accNo10.MobilePhone__c = '090-0000-0000';
        accNo10.MailAddress__c = 'accNo10@example.com';
        insert accNo10;
        Obosanbin__c oboNo10 = new Obosanbin__c(
            MemorialServicePlan__c = '四十九日法要'
        );
        insert oboNo10;
        Opportunity oppOboNo10 = surveyFactory.generateOppObo(nameNo10, accNo10, oboNo10);
        oppOboNo10.StageName = Cnst.OPPORTUNITY_PHASE_SEKO_END;
        insert oppOboNo10;
        k_ShohinCategory__c kCtgNo10 = new k_ShohinCategory__c(
            name = '追加法要'
            ,id__c = 'houyou-add'
        );
        insert kCtgNo10;
        Product2 pNo10 = new Product2(
            Name = 'お坊さん便　納骨法要'
            ,k_ShohinCategoryRef__c  = kCtgNo10.Id
            ,NameForCustomer__c = 'お坊さん便　納骨法要'
        );
        insert pNo10;
        PriceBookEntry pBookNo10 = new PriceBookEntry(
                Pricebook2Id = Test.getStandardPricebookId()
                ,isActive = true
                ,UseStandardPrice = false
                ,unitPrice = 1000
                ,Product2Id = pNo10.Id
        );
        insert pBookNo10;
        insert new OpportunityLineItem(
            OpportunityId = oppOboNo10.Id
            ,Product2Id = pNo10.Id
            ,PricebookEntryId = pBookNo10.Id
        );
    }

    private static List<OpportunityLineItem> genOppLineItems(
        Opportunity opp
        ,List<Product2> products
    ) {
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (Product2 p : products) {
            oppLineItems.add(new OpportunityLineItem(
                OpportunityId = opp.Id
                ,Product2Id = p.Id
                ,PricebookEntryId = p.PricebookEntries[0].Id
            ));
        }

        return oppLineItems;
    }

    private static List<CaseSurveyVisca__c> getRslts() {
         return [
            SELECT
                Id
                ,OppRef__r.Id
                ,OppRef__r.name
                ,OppRef__r.Account.name
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
        System.schedule('TestOboCreateSendSurveyListBatT' + year + month + day + hour + minute + second, sch, new OboCreateSendSurveyListBat());
        Test.stopTest();

    }

    @isTest
    static void testSuccess() {
        beginSetUp();
        setSuccessPatern();
        setDataSuccess();
        endSetUp();

        Test.startTest();
        OboCreateSendSurveyListBat batchable = new OboCreateSendSurveyListBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();

        System.assertEquals(8, rslts.size());

        for (CaseSurveyVisca__c cSurvey : rslts) {
            if (cSurvey.OppRef__r.Name == successPatern.get(1)) {
                System.assertEquals(true,  cSurvey.SmsSendFlg__c, 'No1 fail sms flag.');
                System.assertEquals(false, cSurvey.EmailSendFlg__c, 'No1 fail email flag.');
                System.assertEquals('お坊さん便アンケート_葬儀読経', cSurvey.SurveyRef__r.name, 'No1 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(2)) {
                System.assertEquals(false, cSurvey.SmsSendFlg__c, 'No2 fail sms flag.');
                System.assertEquals(true,  cSurvey.EmailSendFlg__c, 'No2 fail email flag.');
                System.assertEquals('お坊さん便アンケート_葬儀読経', cSurvey.SurveyRef__r.name, 'No2 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(3)) {
                System.assertEquals(false, cSurvey.SmsSendFlg__c, 'No3 fail sms flag.');
                System.assertEquals(true,  cSurvey.EmailSendFlg__c, 'No3 fail email flag.');
                System.assertEquals('お坊さん便アンケート_法要', cSurvey.SurveyRef__r.name, 'No3 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(4)) {
                System.assertEquals(false, cSurvey.SmsSendFlg__c, 'No4 fail sms flag.');
                System.assertEquals(true,  cSurvey.EmailSendFlg__c, 'No4 fail email flag.');
                System.assertEquals('お坊さん便アンケート_戒名', cSurvey.SurveyRef__r.name, 'No4 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(5)) {
                System.assertEquals(false, cSurvey.SmsSendFlg__c, 'No5 fail sms flag.');
                System.assertEquals(true,  cSurvey.EmailSendFlg__c, 'No5 fail email flag.');
                System.assertEquals('お坊さん便アンケート_法要_戒名', cSurvey.SurveyRef__r.name, 'No5 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(6)) {
                System.assertEquals(true,  cSurvey.SmsSendFlg__c, 'No6 fail sms flag.');
                System.assertEquals(false, cSurvey.EmailSendFlg__c, 'No6 fail email flag.');
                System.assertEquals('お坊さん便アンケート_葬儀読経', cSurvey.SurveyRef__r.name, 'No6 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(7)) {
                System.assertEquals(true,  cSurvey.SmsSendFlg__c, 'No7 fail sms flag.');
                System.assertEquals(false, cSurvey.EmailSendFlg__c, 'No7 fail email flag.');
                System.assertEquals('お坊さん便アンケート_葬儀読経', cSurvey.SurveyRef__r.name, 'No7 fail survey.');
            } else if (cSurvey.OppRef__r.Name == successPatern.get(8)) {
                System.assertEquals(false,  cSurvey.SmsSendFlg__c, 'No8 fail sms flag.');
                System.assertEquals(true, cSurvey.EmailSendFlg__c, 'No8 fail email flag.');
                System.assertEquals('お坊さん便アンケート_法要_戒名', cSurvey.SurveyRef__r.name, 'No8 fail survey.');
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
        OboCreateSendSurveyListBat batchable = new OboCreateSendSurveyListBat();
        Database.executeBatch(batchable);
        Test.stopTest();

        List<CaseSurveyVisca__c> rslts = getRslts();
        // 重複用データのみ
        System.assertEquals(1, rslts.size());
    }
}