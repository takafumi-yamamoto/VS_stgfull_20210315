public class Trg_SurveyTaker {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_SurveyTaker(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<SurveyTaker__c> newOnes) {
        for (SurveyTaker__c taker : newOnes) {
            taker.AnswerdDatetime__c = Datetime.now();
        }
    }

    public void OnAfterUpdate(List<SurveyTaker__c> newOnes
                            ,Map<Id,SurveyTaker__c> oldOnes){

        CoreManageApi coreManageApi = new CoreManageApi();
        Map<String, Object> postBody = new Map<String, Object>();

        system.debug('====================surveyViscaSurveyTakerOnAfterUpdate.begin===================');
        for (SurveyTaker__c newSt : newOnes) {
            // 掲載取消
            if (oldOnes.get(newSt.Id).WebPostingStatus__c == '掲載中'
                    && newSt.WebPostingStatus__c == '掲載取消') {
                System.debug('deleteeeeeeeee');
                coreManageApi.surveyDelete(newSt.ExternalId__c);
            // 承認時
            } else if (oldOnes.get(newSt.Id).ApprovalApplyStatus__c == 'Pending'
                    && newSt.ApprovalApplyStatus__c == 'Approved') {

                    postBody = getSurveyWebPostingBaseItem(newSt.Id);
                    postBody.put('responses', getSurveyQuestionResponseList(newSt.Id));
                    switch on oldOnes.get(newSt.Id).WebPostingStatus__c {
                        when '未掲載', '掲載取消' {
                            System.debug('createeeeeee');
                            coreManageApi.surveyPost(postBody);
                        }
                        when '掲載中' {
                            System.debug('updateeeeeee');
                            coreManageApi.surveyPatch(postBody);
                        }
                    }

                if (oldOnes.get(newSt.Id).surveyAreaCode__c != (String) postBody.get('surveyAreaCode')) {
                    update new SurveyTaker__c(
                        Id = newSt.Id
                        ,surveyAreaCode__c = (String) postBody.get('surveyAreaCode')
                    );
                }
            }
        }
        system.debug('====================surveyViscaSurveyTakerOnAfterUpdate.end===================');
    }

    private Map<String, Object> getSurveyWebPostingBaseItem(String id) {
        Map<String, Object> resBaseInfo = new Map<String, Object>();

        System.debug(id);
        SurveyTaker__c surveyTaker = [
            SELECT
                Id
                ,CaseSurveyViscaRef__r.Id
                ,CaseSurveyViscaRef__r.OppRef__r.Id
                ,CaseSurveyViscaRef__r.PaperFlg__c
                ,yorisoComment__c
                ,saijoComment__c
                ,ExternalId__c
            FROM
                SurveyTaker__c
            WHERE
                Id = :id
        ];

        Opportunity opp = [
            SELECT
                id
                ,Utiagebi__c
                ,SimpleYasugoRef__r.SaijoRef__r.SaijoKeisaiJohoId__c
                ,SimpleYasugoRef__r.SaijoRef__r.AreaCode__c
                ,SimpleYasugoRef__r.KasobaShisetsu__r.KasobaKeisaiJohoId__c
                ,SimpleYasugoRef__r.KasobaShisetsu__r.AreaCode__c
                ,SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c
                ,SimpleYasugoRef__r.ZokugaraMoshuNitottenoTaishosha__c
                ,SimpleYasugoRef__r.TaishoshaRef__r.Age__pc
                ,SimpleYasugoRef__r.MosyuRef__r.PersonBirthdate
                ,SimpleYasugoRef__r.MosyuRef__r.Gender__pc
                ,SimpleYasugoRef__r.SogiAfterMoshuMailDatetime__c
                ,Account.PersonBirthdate
                ,Account.Gender__pc
                ,(SELECT
                    Product2.k_ShohinCategory_Name_exp__c
                    ,Product2.NameForCustomer__c
                  FROM
                    OpportunityLineItems
                  WHERE
                    HinmokuBunrui__c = :Cnst.PRODUCT2_BUNRUI_HONTAI)
            FROM
                Opportunity
            WHERE
                id = :surveyTaker.CaseSurveyViscaRef__r.OppRef__r.Id
        ];

        //resBaseInfo.put('id', surveyTaker.Id);
        resBaseInfo.put('id', surveyTaker.ExternalId__c);
        resBaseInfo.put('sekoDate', opp.Utiagebi__c.format().replace('/', '-'));
        resBaseInfo.put('kasobaId', opp.SimpleYasugoRef__r.KasobaShisetsu__r.KasobaKeisaiJohoId__c);
        resBaseInfo.put('deathAge', opp.SimpleYasugoRef__r.TaishoshaRef__r.Age__pc);
        resBaseInfo.put('yorisoComment', surveyTaker.yorisoComment__c);
        resBaseInfo.put('saijoComment', surveyTaker.saijoComment__c);
        // プラン名：安豪を一日葬,家族葬へ変換
        String sogiPlanTypeName = convertPlanTypeNameYasugoToNormalPlanName(
                opp.OpportunityLineItems.get(0).Product2.k_ShohinCategory_Name_exp__c,
                opp.OpportunityLineItems.get(0).Product2.NameForCustomer__c);
        resBaseInfo.put('sogiPlanTypeName', sogiPlanTypeName);
        // 一日葬以上のみ斎場を連携。(誤登録の可能性があるため。)
        if (isUseSaijo(sogiPlanTypeName)) {
            resBaseInfo.put('saijoId', opp.SimpleYasugoRef__r.SaijoRef__r.SaijoKeisaiJohoId__c);
        }
        // 紙時の喪主 > 相談者
        if (surveyTaker.CaseSurveyViscaRef__r.PaperFlg__c
//                && caseSurvey.MoshuMailDatetime__c != null) {
                && opp.SimpleYasugoRef__r.SogiAfterMoshuMailDatetime__c != null) {
            resBaseInfo.put('relationshipKojin', opp.SimpleYasugoRef__r.ZokugaraMoshuNitottenoTaishosha__c);
            resBaseInfo.put('age', calcAge(opp.SimpleYasugoRef__r.MosyuRef__r.PersonBirthdate, opp.Utiagebi__c));
            resBaseInfo.put('gender', opp.SimpleYasugoRef__r.MosyuRef__r.Gender__pc);
        } else {
            resBaseInfo.put('relationshipKojin', opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c);
            resBaseInfo.put('age', calcAge(opp.Account.PersonBirthdate, opp.Utiagebi__c));
            resBaseInfo.put('gender', opp.Account.Gender__pc);
        }
        // アンケートのエリアコード(フロント検索よう unique)
        // 斎場 > 火葬場
        if (isUseSaijo(sogiPlanTypeName)
                && opp.SimpleYasugoRef__r.SaijoRef__r.AreaCode__c != null) {
            resBaseInfo.put('surveyAreaCode', opp.SimpleYasugoRef__r.SaijoRef__r.AreaCode__c);
        } else if (opp.SimpleYasugoRef__r.KasobaShisetsu__r.AreaCode__c != null) {
            resBaseInfo.put('surveyAreaCode', opp.SimpleYasugoRef__r.KasobaShisetsu__r.AreaCode__c);
        }

        return resBaseInfo;
    }

    private Boolean isUseSaijo(String planTypeName) {
        if (planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI
                || planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU
                || planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_IPPAN) {
            return true;
        }

        return false;
    }

    private String convertPlanTypeNameYasugoToNormalPlanName(
        String planTypeName
        ,String planName
    ) {
        String cnvPlanTypeName = planTypeName;
        if (cnvPlanTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_YASUGO) {
            cnvPlanTypeName = planName;
            cnvPlanTypeName = cnvPlanTypeName.replace('お花いっぱいのお葬式', '');
            cnvPlanTypeName = cnvPlanTypeName.replaceAll('[\\s{1}(無宗教|仏式|お花増量)プラン$]', '');
        }

        return cnvPlanTypeName;
    }

    private List<Map<String, Object>> getSurveyQuestionResponseList(String surveyTakerId) {
        List<Map<String, Object>> responses = new List<Map<String, Object>>();

        List<SurveyQuestionResponse__c> resList = [
            SELECT
                Id
                ,SurveyTaker__c
                ,No__c
                ,SurveyQuestion__r.Name
                ,SurveyQuestion__r.Question__c
                ,questonType__c
                ,ResponseWebPosting__c
            FROM
                SurveyQuestionResponse__c
            WHERE
                SurveyTaker__c = :surveyTakerId
            AND
                SurveyQuestion__r.Name NOT IN :Cnst.SURVEY_WEB_POSTING_EXCLUSIVE_QUESTION_RESPONSE_LIST
            ORDER BY
                No__c
        ];

        for (SurveyQuestionResponse__c res : resList) {
            Map<String, Object> resDetailInfo = new Map<String, Object>();
            resDetailInfo.put('id', res.Id);
            resDetailInfo.put('surveyId', res.SurveyTaker__c);
            resDetailInfo.put('sortNo', res.No__c);
            resDetailInfo.put('questionName', res.SurveyQuestion__r.Name);
            resDetailInfo.put('question', res.SurveyQuestion__r.Question__c);
            resDetailInfo.put('questionTypeName', res.questonType__c);
            resDetailInfo.put('response', res.ResponseWebPosting__c);
            responses.add(resDetailInfo);
        }

        return responses;
    }

    private Integer calcAge(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return null;
        }

        Integer age = startDate.daysBetween(endDate) / 365;
        return age;
    }
}