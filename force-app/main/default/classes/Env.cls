global class Env {
    global static EnvSurvey__mdt survey = [
        SELECT
            Domain__c
            ,FromMailAddress__c
            ,AccreteSmsApiUrl__c
            ,TestTelNo__c
            ,WebFrontBaseUrl__c
            ,SfMaintenaceInfoMsg__c
        FROM
            EnvSurvey__mdt
        WHERE
            DeveloperName = :Environments.isSandbox() ? 'dev' : 'prod'
    ].get(0);
}