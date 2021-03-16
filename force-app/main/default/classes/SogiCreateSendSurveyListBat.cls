global class SogiCreateSendSurveyListBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable  {

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 15;
        Database.executeBatch(new SogiCreateSendSurveyListBat(), theBatchSize);
    }

    global List<Opportunity> start(Database.BatchableContext BC) {
        Date fromDate = Date.toDay().addDays(-10);
        List<Opportunity> oppListAll = [
            SELECT
                Id
                ,Utiagebi__c
                ,SurveyDiscountAgreeStatus__c
                ,SurveySendWayHopeSms__c
                ,SurveySendWayHopeEmail__c
                ,DmSofuNg__c
                ,SmsSofuNg__c
                ,ClaimAllNum__c
                ,Account.MailAddress__c
                ,Account.MobilePhoneFormula__c
                // コンタクトのクレーム
                ,(
                    SELECT
                        Id
                    FROM
                        tasks
                    WHERE
                        Claim__c = true
                )
                // 斎場利用と後葬
                ,(
                    SELECT
                        Id
                        ,Product2Id
                        ,Product2.NameForCustomer__c
                    FROM
                        OpportunityLineItems
                    WHERE
                        HinmokuBunrui__c = :Cnst.PRODUCT2_BUNRUI_HONTAI
                    OR
                        Product2.NameForCustomer__c = :Cnst.PRODUCT2_NAME_FOR_CUSTOMER_ATOSO
                )
                // お坊さん便利用
                ,(
                    SELECT
                        Id
                    FROM
                        SougiSyoudans__r
                    WHERE
                        ObosanbinRef__r.MemorialServicePlan__c IN (
                            :Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_KASO
                            ,:Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_ICHINICHI
                            ,:Cnst.OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN
                        )
                )
                // 作成済除外用
                ,(
                    SELECT
                        Id
                    FROM
                        CaseSurveyOpps__r
                )
            FROM
                Opportunity
            WHERE
                RecordTypeId = :recordTypeIdOppSogi
            AND
                (Utiagebi__c <= YESTERDAY
                AND
                Utiagebi__c >= :fromDate)
        ];

        List<Opportunity> oppList = new List<Opportunity>();
        for (Opportunity opp : oppListAll) {
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

        List<CaseSurveyVisca__c> cSurveyList = new List<CaseSurveyVisca__c>();
        for (Opportunity opp : sendTargetList) {
            System.debug('START');
            System.debug(opp);
            CaseSurveyVisca__c cSurvey = null;

            if (opp.SurveyDiscountAgreeStatus__c == Cnst.OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE) {
                String surveyId = getTargetSurveyId(opp.SougiSyoudans__r, opp.OpportunityLineItems);
                // 対象アンケートが見つからない
                if (String.isEmpty(surveyId)) {
                    continue;
                }
                cSurvey = super.generateCaseSurvey(opp.Id, surveyId);
                if (opp.SurveySendWayHopeSms__c) {
                    cSurvey.SmsSendFlg__c = true;
                }
                if (opp.SurveySendWayHopeEmail__c) {
                    cSurvey.EmailSendFlg__c = true;
                }
            // アンケート割未同意で、Dm類NGなし。
            } else {
                cSurvey = new CaseSurveyVisca__c(
                    EmailSendFlg__c = true
                    ,OppRef__c = opp.Id
                );
                insert cSurvey;
            }

            cSurveyList.add(cSurvey);
        }

        update cSurveyList;
    }

    global void finish(Database.BatchableContext BC) {
    }

    private Boolean isNoCreateSurvey(Opportunity opp) {
        // アンケート割未同意でDm類NG
        if (opp.SurveyDiscountAgreeStatus__c != Cnst.OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE) {
            if (opp.DmSofuNg__c
                    || opp.SmsSofuNg__c
                    || opp.ClaimAllNum__c > 0
                    || opp.Tasks.size() > 0
                    || String.isEmpty(opp.Account.MailAddress__c)) {
                return true;
            }
        // アンケート割同意だが、送付方法不明
        } else {
            if (!opp.SurveySendWayHopeSms__c && !opp.SurveySendWayHopeEmail__c) {
                return true;
            }
        }
        // 既に作成済み
        if (opp.CaseSurveyOpps__r.size() > 0) {
            return true;
        }

        return false;
    }

    private String getTargetSurveyId(
        Opportunity[] sogiShodanOpps
        ,OpportunityLineItem[] oppLineItems
    ) {
        String surveyId = '';
        Boolean useSogiDokkyo = sogiShodanOpps.size() == 0 ? false : true;
        String targetProd2Id = null;
        Boolean isAtoso = oppLineItems.size() == 2 ? true : false;
        for (OpportunityLineItem oppLineItem : oppLineItems) {
            if (isAtoso) {
                if (oppLineItem.Product2.NameForCustomer__c.contains(Cnst.PRODUCT2_NAME_FOR_CUSTOMER_ATOSO)) {
                    targetProd2Id = oppLineItem.Product2Id;
                }
            } else {
                targetProd2Id = oppLineItem.Product2Id;
            }
        }

        for (SurveyWithProduct2Mapping__c mapping : surveyWithProduct2MappingList) {
            if (mapping.Product2Id__c == targetProd2Id
                    && mapping.UseSogiDokkyoFlg__c == useSogiDokkyo) {
                surveyId = mapping.SurveyRef__c;
            }
        }

        return surveyId;
    }
}