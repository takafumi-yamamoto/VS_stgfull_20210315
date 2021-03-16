@isTest
public class ViewSurveyControllerTest {

    private static TestSurveyDataFactoryNew surveyFactory = new TestSurveyDataFactoryNew();
    private static String sid;
    private static String caid;
    private static String cSurveyId;

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
    private static void endSetUp(){
        Insert new TriggerIsActive__c( Name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
        Utility_Common.isMimicExecAsDataIkouProfile = false;
    }

    private static ViewSurveyController generateExtentionCtl() {
        surveyFactory.createSurvey();
        Account acc = new Account(
                Name = 'アンケート回答テスト相談者'
                ,MobilePhone__c = '090-0000-0000'
                ,MailAddress__c = 'acc@example.com');
        insert acc;
        Opportunity opp = surveyFactory.generateBaseOpp('アンケート回答テスト商談', acc);
        insert opp;
        Survey__c survey = surveyFactory.getSurveyByName('斎場有_お坊有_v2');
        sid = survey.Id;
        CaseSurveyVisca__c cSurvey = surveyFactory.createDelivery(opp, survey);
        caid = cSurvey.Md5__c;
        cSurveyId = cSurvey.Id;

        ApexPages.StandardController stdCtl = new ApexPages.StandardController(survey);
        return new ViewSurveyController(stdCtl);
    }

    @isTest
    private static void success() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid',  sid);
        pageRef.getParameters().put('caid', caid);
        Test.setCurrentPage(pageRef);
        extCtl.init();
        // validationエラー
        extCtl.confirm();
        for (Integer i = 0; i < extCtl.allQuestions.size(); i++) {
            switch on extCtl.allQuestions.get(i).type {
                when 'Section' {
                    continue;
                }
                when 'Free Text' {
                    extCtl.allQuestions.get(i).inputtedText = 'あああ';
                }
                when 'Number' {
                    extCtl.allQuestions.get(i).inputtedNumber = 123;
                }
                when 'Multi-Select--Vertical' {
                    extCtl.allQuestions.get(i).selectedOptions = new String[]{'1', '2'};
                }
                when else {
                    extCtl.allQuestions.get(i).selectedOption = '1';
                }
            }
        }
        extCtl.confirm();
        extCtl.back();
        extCtl.confirm();
        extCtl.submitResults();
 
        Test.stopTest();
    }

    @isTest
    private static void viewPreview() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid', sid);
        pageRef.getParameters().put('pcd', 'A8djjAWAnnE93h');
        Test.setCurrentPage(pageRef);
        extCtl.init();
        Test.stopTest();
    }

    @isTest
    private static void viewAccessErrorBySurveyNothing() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid',  sid.substring(1));
        pageRef.getParameters().put('caid', caid);
        Test.setCurrentPage(pageRef);
        String nextPage = extCtl.init().getUrl();
        Test.stopTest();

        System.assertEquals('/apex/surveyaccesserror', nextPage);
    }

    @isTest
    private static void viewAccessErrorByMd5Nothing() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid',  sid);
        pageRef.getParameters().put('caid', caid.substring(1));
        Test.setCurrentPage(pageRef);
        String nextPage = extCtl.init().getUrl();
        Test.stopTest();

        System.assertEquals('/apex/surveyaccesserror', nextPage);
    }

    @isTest
    private static void viewAnswered() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        surveyFactory.createTaker(
            cSurveyId
            ,sid
            ,surveyFactory.generateDefaultAnswerMap(),
            '', '', '', '', ''
        );
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid',  sid);
        pageRef.getParameters().put('caid', caid);
        Test.setCurrentPage(pageRef);
        String nextPage = extCtl.init().getUrl();
        Test.stopTest();

        System.assertEquals('/apex/surveyanswered', nextPage);
    }

    @isTest
    private static void viewSystemError() {
        beginSetUp();
        ViewSurveyController extCtl = generateExtentionCtl();
        endSetUp();

        Test.startTest();
        PageReference pageRef = Page.SurveyTaker;
        pageRef.getParameters().put('sid',  sid);
        pageRef.getParameters().put('caid', caid);
        Test.setCurrentPage(pageRef);
        String nextPage = extCtl.submitResults().getUrl();
        Test.stopTest();

        System.assertEquals('/apex/surveyerror', nextPage);
    }
}