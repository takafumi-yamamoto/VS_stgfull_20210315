@isTest
private class CtlSurveyT {

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
    static void testExclusives() {
        beginSetUp();
        TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
        surveyFactory.createSurvey();

        Opportunity oppNo1 = new Opportunity();
        oppNo1.Name = 'Webと紙';
        oppNo1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        oppNo1.StageName = '施工完了';
        oppNo1.CloseDate = Date.today().addDays(5);
        insert oppNo1;

        Survey__c svWeb = surveyFactory.getSurveyByName('斎場有_お坊無_v2');
        CaseSurveyVisca__c csWeb = surveyFactory.generateDelivery(oppNo1, svWeb, Date.today());
        csWeb.SmsSendFlg__c = true;
        csWeb.SmsSendCount__c = 1;
        csWeb.SmsSendDatetime__c = Date.today();
        csWeb.EmailSendFlg__c = true;
        csWeb.EmailSendCount__c = 1;
        csWeb.EmailSendDatetime__c = Date.today();
        csWeb.StopSendFlg__c = false;
        insert csWeb;

        Survey__c svPaper =  new Survey__c(
                Name = 'Paper'
        );
        insert svPaper;
        CaseSurveyVisca__c csPaper = new CaseSurveyVisca__c(
                PaperFlg__c = true
                ,SurveyUrl__c = 'https://xxxxx/paper'
                ,MoshuMailDatetime__c = Date.today()
                ,StopSendFlg__c = false
                ,SurveyRef__c = svPaper.Id
                ,OppRef__c = oppNo1.Id
        );
        insert csPaper;

        Map<String, String> answered = surveyFactory.generateDefaultAnswerMap();
        surveyFactory.createTaker(
            csWeb.Id, svWeb.Id, answered,
            '' ,'' ,'' ,'' ,''
        );
        endSetUp();

        test.startTest();
        List<CaseSurveyVisca__c> retSendList = CtlSurvey.getCaseSurveyPaperByOppId(oppNo1.Id);
        List<SurveyTaker__c> retTakerList    = CtlSurvey.getResListByOppId(oppNo1.Id);

        SurveyTaker__c taker = [SELECT Id FROM SurveyTaker__c LIMIT1];
        SurveyTaker__c retTakerWarning       = CtlSurvey.getWebPostingWarningByTakerId(taker.Id);
        List<SurveyQuestionResponse__c> retQuestionResponses = CtlSurvey.getSurveyQuestionResponseByTakerId(taker.Id);
        test.stopTest();

        System.assertEquals(2, retSendList.size(), 'send list fail');
        System.assertEquals(1, retTakerList.size(), 'res list fail ');

    }

}