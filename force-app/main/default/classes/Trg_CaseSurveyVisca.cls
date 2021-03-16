public class Trg_CaseSurveyVisca {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_CaseSurveyVisca(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<CaseSurveyVisca__c> newOnes) {
        update setMd5(newOnes);
    }

    private List<CaseSurveyVisca__c> setMd5(List<CaseSurveyVisca__c> updCaseSurveyViscas) {
        List<String> ids = new List<String>();
        for (CaseSurveyVisca__c cSurvey : updCaseSurveyViscas) {
            ids.add(cSurvey.Id);
        }

        List<CaseSurveyVisca__c> updOnes = [
            SELECT
                Id
                ,Md5__c
            FROM
                CaseSurveyVisca__c
            WHERE
                Id IN :ids
        ];
        for (CaseSurveyVisca__c cSurvey : updOnes) { 
            cSurvey.Md5__c = EncodingUtil.convertToHex(Crypto.generateDigest('md5', Blob.valueOf(cSurvey.Id)));
        }

        return updOnes;
    }
}