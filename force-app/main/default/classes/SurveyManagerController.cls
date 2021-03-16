public class SurveyManagerController {
    
    public String exText {get; set;}
    private final Survey__c survey;
    
    public SurveyManagerController(ApexPages.StandardController controller) {
        
        this.survey = (Survey__c)controller.getRecord();

        this.exText = getCaseIdByMd5('527736adfdd55049ca9bcb0a89e256a1');
    }
    public void init() {}
    private String getCaseIdByMd5(String md5) {
        String recordTypeIdCaseSurvey =
            Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('surveyVisca').getRecordTypeId();
        String cId = null;

        List<Case> cases = new List<Case>([
            SELECT
                Id
            FROM
                Case
            WHERE
                surveyVisca__md5__c = :md5
            AND
                RecordTypeId = :recordTypeIdCaseSurvey
        ]);

        if (cases.size() == 1) {
            cId = cases[0].Id;
        }

        return cId;
    }
    
}