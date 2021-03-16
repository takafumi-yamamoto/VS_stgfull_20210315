public class Trg_SurveyQuestionResp {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_SurveyQuestionResp(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<SurveyQuestionResponse__c> newOnes){
        createAfterSell(newOnes);
    }

    private void createAfterSell(List<SurveyQuestionResponse__c> newOnes) {
        SogiSurveyAfterSell__c aftrSell = new SogiSurveyAfterSell__c();
        List<String> chkServices = new List<String>();
        Map<ID, SurveyQuestion__c> targetQuestions = getTargetQuestions(newOnes);

        for (SurveyQuestionResponse__c res : newOnes) {
            if (targetQuestions.containsKey(res.SurveyQuestion__c)) {
                if (targetQuestions.get(res.SurveyQuestion__c).Name == Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES
                        && !String.isEmpty(res.Response__c)) {
                    String tmp = res.Response__c
                        .replaceAll('[\\r\\n ]+', '');
                    if (string.isNotEmpty(tmp)) {
                        chkServices = tmp.split(';');
                    }
                    if (chkServices.size() > 0) {
                        SurveyTaker__c taker = getCaseIdByTakerId(res.SurveyTaker__c);
                        aftrSell.OpportunityRef__c = taker.CaseSurveyViscaRef__r.OppRef__c;
                    }
                } else if (targetQuestions.get(res.SurveyQuestion__c).Name == Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME
                        && !String.isEmpty(res.Response__c)) {
                    aftrSell.GoodTimeTel__c = res.Response__c;
                }
            }
        }

        if (chkServices.size() > 0) {
            if (chkServices.toString().contains(Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI)) {
                aftrSell.HonIhaiAndButsudanFlg__c = true;
            }
            if (chkServices.toString().contains(Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO)) {
                aftrSell.ShijukunichiHoyoFlg__c = true;
            }
            if (chkServices.toString().contains(Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO)) {
                aftrSell.OtherHoyoFlg__c = true;
            }
            if (chkServices.toString().contains(Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO)) {
                aftrSell.EitaiKuyoFlg__c = true;
            }
            if (chkServices.toString().contains(Cnst.SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU)) {
                aftrSell.KaiyoSankotsuFlg__c = true;
            }
            insert aftrSell;
        }
    }

    private Map<ID, SurveyQuestion__c> getTargetQuestions(List<SurveyQuestionResponse__c> qResList) {
        List<String> questionIds = new List<String>();

        for (SurveyQuestionResponse__c r : qResList) {
            questionIds.add(r.SurveyQuestion__c);
        }
        return new Map<ID, SurveyQuestion__c>([
            SELECT
                Id
                ,Name
            FROM
                SurveyQuestion__c
            WHERE
                Id IN :questionIds
            AND
                Name IN (:Cnst.SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES
                        ,:Cnst.SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME)
        ]);
    }

    private SurveyTaker__c getCaseIdByTakerId(String takerId) {
        SurveyTaker__c takerObj = [
            SELECT
                CaseSurveyViscaRef__r.OppRef__c
            FROM
                SurveyTaker__c
            WHERE
                Id = :takerId
            LIMIT 1
        ];

        return takerObj;
    }
}