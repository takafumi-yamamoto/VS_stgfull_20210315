public with sharing class CtlSurvey {

    @AuraEnabled
    public static List<CaseSurveyVisca__c> getCaseSurveyPaperByOppId(String oppId) {

        return [
                SELECT
                    Id
                    ,Name
                    ,PaperFlg__c
                    ,SurveyUrl__c
                    ,SurveyRef__r.Name
                    ,SurveyViscaRef__r.Name
                    ,SmsSendFlg__c
                    ,SmsSendDatetime__c
                    ,SmsSendCount__c
                    ,EmailSendFlg__c
                    ,EmailSendDatetime__c
                    ,EmailSendCount__c
                    ,StopSendFlg__c 
                FROM
                    CaseSurveyVisca__c
                WHERE
                    OppRef__c = :oppId
                ORDER BY PaperFlg__c
        ];
    }

    @AuraEnabled
    public static List<SurveyTaker__c> getResListByOppId(String oppId) {

        return [
                SELECT
                    Id
                    ,SurveyRef__r.Name
                    ,AnswerdDatetime__c
                FROM
                    SurveyTaker__c
                WHERE
                    CaseSurveyViscaRef__r.OppRef__c = :oppId
        ];
    }

    @AuraEnabled
    public static SurveyTaker__c getWebPostingWarningByTakerId(String takerId) {
        return [
                SELECT
                    Id
                    ,CaseSurveyViscaRef__c
                    ,CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.KasobaShisetsu__r.KasobaKeisaiJohoId__c
                    ,CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.TaishoshaRef__r.Age__pc
                FROM
                    SurveyTaker__c
                WHERE
                    Id = :takerId
        ];
    }

    @AuraEnabled
    public static List<SurveyQuestionResponse__c> getSurveyQuestionResponseByTakerId(String takerId) {
        List<SurveyQuestionResponse__c> resList = [
                SELECT
                    Id
                    ,No__c
                    ,SurveyQuestion__r.name
                    ,SurveyQuestion__r.Question__c
                    ,SurveyQuestion__r.Choices__c
                    ,questonType__c
                    ,Response__c
                    ,ResponseWebPosting__c
                    ,CreatedDate
                    ,LastModifiedDate
                FROM
                    SurveyQuestionResponse__c
                WHERE
                    SurveyTaker__c = :takerId
                AND
                    SurveyQuestion__r.Name NOT IN :Cnst.SURVEY_WEB_POSTING_EXCLUSIVE_QUESTION_RESPONSE_LIST
                ORDER BY
                    No__c
        ];


        // Web掲載回答項目null時に自動更新する
        List<SurveyQuestionResponse__c> updResList = new List<SurveyQuestionResponse__c>();
        // 満足度星を数値(string)へ変換
        for (SurveyQuestionResponse__c res : resList) {
            if (res.ResponseWebPosting__c == null
                    && (res.CreatedDate == res.LastModifiedDate)
            ) {
                if (Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.containsKey(res.Response__c)) {
                    res.ResponseWebPosting__c = Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.get(res.Response__c);
                } else {
                    res.ResponseWebPosting__c = res.Response__c;
                }

                updResList.add(res);
            }
        }
        update updResList;

        return resList;
    }

    @AuraEnabled
    public static void updateSurveyQuestionResponse(List<SurveyQuestionResponse__c> respList) {
        update respList;
    }
}