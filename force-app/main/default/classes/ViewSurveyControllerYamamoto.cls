public class ViewSurveyControllerYamamoto {
    
    public String msg {get; set;}
    public String surveyId {get; set;}
    public String cMd5     {get; set;}
    public Boolean isConfirm  {get; set;}
    public Boolean isComplete {get; set;}
    public List<QuestionPreview> allQuestions {get; set;}
    public class QuestionPreview {
        public String  type       {get; set;}
        public Boolean isRequired {get; set;}
        public Boolean isError    {get; set;}
        public String  errMsg     {get; set;}
        public Integer orderNo    {get; set;}
        public String question    {get; set;}
        public List<SelectOption> options   {get; set;}
        public List<String> selectedOptions {get; set;}
        public String inputtedText {get; set;}
        public Integer textRowNo   {get; set;}
        public Integer inputtedNumber {get; set;}
        public String npsDisLike   {get; set;}
        public String npsLike      {get; set;}

        public QuestionPreview () {
            this.isRequired = false;
            this.isError    = false;
            this.options    = new List<SelectOption>();
            this.selectedOptions = new List<String>();
        }
    }
    private final Survey__c survey;

    public ViewSurveyControllerYamamoto(ApexPages.StandardController controller) {
        System.debug('AAAAA');
        try {
            this.msg = 'aaa';
            this.isConfirm  = false;
            this.isComplete = false;
            this.allQuestions = new List<QuestionPreview>();
            this.surveyId = ApexPages.CurrentPage().getParameters().get('id');
            System.debug('this.surveyId:' + this.surveyId);
            this.cMd5 = ApexPages.CurrentPage().getParameters().get('caId');
            System.debug('this.cMd5:' + this.cMd5);
            setInitSetQuestionPreviews(); 
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error
                                        ,'20219999999'
                                        ,'DebugNow')
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
    }

    public PageReference tttt() {
        System.debug('xxxx');
        this.msg = 'bbbb';

        return null;
    }

    public void init() {
        System.debug('hhhhh');
    }

    public PageReference confirm() {
        System.debug('BBBBB');
        this.isConfirm  = true;
        this.isComplete = false;
        this.msg = 'bbbb';

        return null;
    }

    public PageReference back() {
        this.isConfirm  = false;
        this.isComplete = false;
        return ApexPages.CurrentPage();
    }

    public PageReference submitResults() {
        this.isConfirm  = false;
        this.isComplete = true;
        return ApexPages.CurrentPage();
    }

    private List<SurveyQuestion__c> getSurveyQuestionsBySurveyId() {
        return [
            SELECT
                Id
                ,OrderNumber__c
                ,Required__c
                ,Type__c
                ,Question__c
                ,Choices__c
                ,NpsDislike__c
                ,NpsLike__c
            FROM
                SurveyQuestion__c
            WHERE
                SurveyRef__c = :this.surveyId
            ORDER BY
                OrderNumber__c
        ];
    }

    private void setInitSetQuestionPreviews() {
        List<SurveyQuestion__c> surveyQuestions = getSurveyQuestionsBySurveyId();
        for (SurveyQuestion__c q : surveyQuestions) {
            QuestionPreview qPreview = new QuestionPreview();

            qPreview.type       = q.Type__c;
            qPreview.orderNo    = Integer.valueOf(q.OrderNumber__c);
            qPreview.question   = q.Question__c;
            qPreview.isRequired = q.Required__c;

            if (q.Choices__c != null) {
                qPreview.options = convChoiseStrToSelectOption(q.Choices__c);
            }

            switch on q.Type__c {
                when 'Free Text - Single Row Visible' {
                    qPreview.type      = 'Free Text';
                    qPreview.textRowNo = 1;
                }
                when 'Free Text' {
                    qPreview.textRowNo = 3;
                }
                when 'NPS' {
                    qPreview.npsDisLike = q.NpsDislike__c;
                    qPreview.npsLike    = q.Npslike__c;
                }
                when else {
                }
            }
            this.allQuestions.add(qPreview);
        }
    }

    private List<SelectOption> convChoiseStrToSelectOption(String choiseStr) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        //selectOptions.add(new SelectOption(null, null));
        List<String> choicies = choiseStr.split('\n');
        for (Integer i = 1; i <= choicies.size(); i++) {
            String val   = String.valueOf(i);
            String label = choicies[i - 1];
            selectOptions.add(new SelectOption(val, label));
        }
        return selectOptions;
    }
}