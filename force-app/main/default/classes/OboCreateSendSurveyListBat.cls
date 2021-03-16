global class OboCreateSendSurveyListBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable  {

    private static final String SEND_METHOD_SMS = 'sms';
    private static final String SEND_METHOD_EMAIL = 'email';
    private static String regexSogiDokkyo       =
        '^(' + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO + '|'
        + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO + ')$';
    private static String regexSogiDokkyoKaimyo =
        '^' + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO +'$';
    private static String regexSogiDokkyoOnly   =
        '^' + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO +'$';
    private static String regexHoyo             =
        '^' + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_HOYO +'$';
    private static String regexKaimyo           =
        '^' + Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_KAIMYO +'$';

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 15;
        Database.executeBatch(new OboCreateSendSurveyListBat(), theBatchSize);
    }

    global List<Opportunity> start(Database.BatchableContext BC) {
        List<Opportunity> oppListAll = [
            SELECT
                Id
                ,Utiagebi__c
                ,RyunyumotoService__c
                ,Account.KoukokuSmsNg__c
                ,Account.E_NG__pc
                ,Account.MobilePhoneFormula__c
                ,Account.MailAddress__c
                // 商談商品
                ,(
                    SELECT
                        Id
                        ,Product2Id
                        ,Product2.NameForCustomer__c
                        ,Product2.k_ShohinCategory_Name_exp__c
                    FROM
                        OpportunityLineItems
                    WHERE
                        Product2.k_ShohinCategory_Name_exp__c IN (
                            :Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO
                            ,:Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO
                            ,:Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_HOYO
                            ,:Cnst.PRODUCT2_SHOHIN_CATEGORY_NAME_KAIMYO
                        )
                )
                // 送信済除外用
                ,(
                    SELECT
                        Id
                    FROM
                        CaseSurveyOpps__r
                )
            FROM
                Opportunity
            WHERE
                RecordTypeId = :recordTypeIdOppObo
            AND
                Utiagebi__c = YESTERDAY
            AND
                stageName IN (
                    :Cnst.OPPORTUNITY_PHASE_KETTEI
                    ,:Cnst.OPPORTUNITY_PHASE_SEKO_WAIT
                    ,:Cnst.OPPORTUNITY_PHASE_SEKO_END
                    ,:Cnst.OPPORTUNITY_PHASE_CLOSE
                )
            AND
                Account.PermissionFlag__pc != :Cnst.ACCOUNT_PERMISSIONFLAG_NORECIEVE
            AND
            (
                Account.KoukokuSmsNg__c = false
                OR
                Account.E_NG__pc = false
            )
            AND
                // てらぱす除外
                RyunyumotoService__c != :Cnst.OPPORTUNITY_INFROW_SERVICE_TERAPASS
            AND
                // 僧侶手配代行除外
                (NOT RyunyumotoService__c LIKE :Cnst.OPPORTUNITY_INFROW_SERVICE_SORYO_TEHAI_DAIKO + '%')
        ];

        List<Opportunity> oppList = new List<Opportunity>();
        for (Opportunity opp : oppListAll) {
            // 送信データ作らないものを除外
            if (!isNoCreateSurvey(opp)) {
                oppList.add(opp);
            }
        }

        System.debug('=======GetOppListSize=========');
        System.debug(oppListAll.size());
        System.debug(oppList.size());
        return oppList;
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> sendTargetList) {
        System.debug('========CreateOppListSize============');
        System.debug(sendTargetList.size());

        super.setUtmSourceVal('survey_obosan');
        AccreteSmsApi smsApi = new AccreteSmsApi();
        List<CaseSurveyVisca__c> cSurveyList = new List<CaseSurveyVisca__c>();

        for (Opportunity opp : sendTargetList) {
            System.debug('START');
            System.debug(opp);

            // 対象アンケート取得
            String surveyId = getTargetSurveyId(opp.OpportunityLineItems);
            if (String.isEmpty(surveyId)) {
                continue;
            }
            // 送付方法判別
            String sendMethod = getSendMethod(opp, smsApi);
            if (String.isEmpty(sendMethod)) {
                continue;
            }
            // 送付データ生成
            CaseSurveyVisca__c cSurvey = super.generateCaseSurvey(
                opp.Id
                ,surveyId
            );
            if (sendMethod.equals(SEND_METHOD_SMS)) {
                cSurvey.SmsSendFlg__c = true;
            } else {
                cSurvey.EmailSendFlg__c = true;
            }
            cSurveyList.add(cSurvey);
        }
        update cSurveyList;
    }

    global void finish(Database.BatchableContext BC) {
    }

    private Boolean isNoCreateSurvey(Opportunity opp) {
        // 商品なし
        if (opp.OpportunityLineItems.size() < 1) {
            return true;
        }
        // 葬儀で読経ありアンケート送付済み
        if (opp.RyunyumotoService__c == Cnst.OPPORTUNITY_INFROW_SERVICE_SOGI
                && String.isNotEmpty(getProduct2IdByCategoryNameRegex(opp.OpportunityLineItems, regexSogiDokkyo))) {
            return true;
        }
        // 既に作成済み
        if (opp.CaseSurveyOpps__r.size() > 0) {
            return true;
        }

        return false;
    }

    private String getProduct2IdByCategoryNameRegex(
        OpportunityLineItem[] items
        ,String regex
    ) {
        String pId = '';
        Pattern p = pattern.compile(regex);

        for (OpportunityLineItem item : items) {
            Matcher m = p.matcher(item.Product2.k_ShohinCategory_Name_exp__c);
            if (m.matches()) {
                pId = item.Product2Id;
            }
        }

        return pId;
    }

    private String getTargetSurveyId(OpportunityLineItem[] oppLineItems) {
        String surveyId  = '';

        String targetProd2Id = '';
        Boolean withKaimyo = false;
        String dokkyoKaimyoPId = getProduct2IdByCategoryNameRegex(oppLineItems, regexSogiDokkyoKaimyo);
        String dokkyoPId       = getProduct2IdByCategoryNameRegex(oppLineItems, regexSogiDokkyoOnly);
        String hoyoPId         = getProduct2IdByCategoryNameRegex(oppLineItems, regexHoyo);
        String kaimyoPId       = getProduct2IdByCategoryNameRegex(oppLineItems, regexKaimyo);
        if (String.isNotEmpty(dokkyoKaimyoPId)) {
            targetProd2Id = dokkyoKaimyoPId;
            withKaimyo = true;
        } else if (String.isNotEmpty(dokkyoPId)) {
            targetProd2Id = dokkyoPId;
        } else if (String.isNotEmpty(hoyoPId)) {
            targetProd2Id = hoyoPId;
            if (String.isNotEmpty(kaimyoPId)) {
                withKaimyo = true;
            }
        } else {
            targetProd2Id = kaimyoPId;
            withKaimyo = true;
        }

        for (SurveyWithProduct2Mapping__c mapping : surveyWithProduct2MappingList) {
            if (mapping.Product2Id__c == targetProd2Id
                    && mapping.WithKaimyo__c == withKaimyo) {
                surveyId = mapping.SurveyRef__c;
            }
        }

        return surveyId;
    }

    private String getSendMethod(
        Opportunity opp
        ,AccreteSmsApi smsApi
    ) {
        // sms送付
        if (!opp.Account.KoukokuSmsNg__c
                && smsApi.isValidTelNo(opp.Account.MobilePhoneFormula__c)) {
            return SEND_METHOD_SMS;
        }
        // Eメール送付
        if (!opp.Account.E_NG__pc
                && String.isNotEmpty(opp.Account.MailAddress__c)) {
            return SEND_METHOD_EMAIL;
        }

        return '';
    }
}