public without sharing class ViewSurveyController {
    
    private static final String PREVIEW_CODE = 'A8djjAWAnnE93h';

    private String cId        {get; set;}
    private Boolean isPreview {get; set;}

    public Survey__c survey       {get; private set;}
    public Boolean isConfirm      {get; private set;}
    public Boolean isComplete     {get; private set;}
    public Boolean isInvalidInput {get; private set;}

    public List<QuestionPreview> allQuestions {get; set;}
    public class QuestionPreview {
        private String surveyQuestionId {get; set;}

        public String  type       {get; set;}
        public Boolean isRequired {get; set;}
        public Boolean isInvalid  {get; set;}
        public String  errMsg     {get; set;}
        public Integer orderNo    {get; set;}
        public String  question   {get; set;}

        public String  inputtedText   {get; set;}
        public Integer textRowNo      {get; set;}
        public Integer inputtedNumber {get; set;}

        public List<SelectOption> options   {get; set;}
        public String selectedOption        {get; set;}
        public List<String> selectedOptions {get; set;}

        public String npsDisLike {get; set;}
        public String npsLike    {get; set;}

        public QuestionPreview () {
            this.isRequired = false;
            this.isInvalid  = false;

            this.options         = new List<SelectOption>();
            this.selectedOptions = new List<String>();
        }
    }
    
    public ViewSurveyController(ApexPages.StandardController controller) {
        this.isConfirm      = false;
        this.isComplete     = false;
        this.isInvalidInput = false;
        this.isPreview = false;
    }

    public PageReference init() {
        try {
            String surveyId = ApexPages.CurrentPage().getParameters().get('sid');
            String cMd5     = ApexPages.CurrentPage().getParameters().get('caId');
            String pcd      = ApexPages.CurrentPage().getParameters().get('pcd');
            if (PREVIEW_CODE == pcd) {
                this.isPreview = true;
            }

            List<Survey__c> surveys = getSurveyById(surveyId);
            this.cId = getCaseIdByMd5(cMd5);
            if (!this.isPreview) {
                if (surveys.size() != 1 || this.cId == null) {
                    return Page.SurveyAccessError;
                }
            }
            this.survey = surveys[0];

            Integer takerCount = getSurveyTakerCountByCaseId(this.cId);
            if (!this.isPreview && takerCount > 0) {
                return Page.SurveyAnswered;
            }

            this.allQuestions = new List<QuestionPreview>();
            genAllQuestions(); 

        } catch (Exception e) {
            writeErrorLogging('20210220111111', e);
            return Page.SurveyError;
        }

        return null;
    }

    public PageReference confirm() {
        validate();
        if (!this.isInvalidInput) {
            this.isConfirm  = true;
        }

        return null;
    }

    public PageReference back() {
        this.isConfirm  = false;
        this.isComplete = false;

        return null;
    }

    public PageReference submitResults() {
        this.isConfirm  = false;
        this.isComplete = true;

        try {
            if (!this.isPreview) {
                registSurveyAnswers();
            }
        } catch (Exception e) {
            writeErrorLogging('20210220111112', e);
            return Page.SurveyError;
        }
        
        return null;
    }

    private void validate() {
        Boolean isInvalid = false;
        for (QuestionPreview qPreview : allQuestions) {
            switch on qPreview.type {
                when 'Section' {
                    continue;
                }
                when 'Free Text' {
                    if (qPreview.isRequired && String.isEmpty(qPreview.inputtedText)) {
                        setInvalidRequired(qPreview);
                        isInvalid = true;
                    } else {
                        clearInvalidRequired(qPreview);
                    }
                }
                when 'Number' {
                    if (qPreview.isRequired && qPreview.inputtedNumber == null) {
                        setInvalidRequired(qPreview);
                        isInvalid = true;
                    } else {
                        clearInvalidRequired(qPreview);
                    }
                }
                when 'Multi-Select--Vertical' {
                    if (qPreview.isRequired && qPreview.selectedOptions.size() < 1) {
                        setInvalidRequired(qPreview);
                        isInvalid = true;
                    } else {
                        clearInvalidRequired(qPreview);
                    }
                }
                when else {
                    if (qPreview.isRequired && String.isEmpty(qPreview.selectedOption)) {
                        setInvalidRequired(qPreview);
                        isInvalid = true;
                    } else {
                        clearInvalidRequired(qPreview);
                    }
                }
            }
        }

        this.isInvalidInput = isInvalid;
    }
    
    private void setInvalidRequired(QuestionPreview qp) {
        qp.isInvalid = true;
        qp.errMsg    = '値を入力してください。';
    }

    private void clearInvalidRequired(QuestionPreview qp) {
        qp.isInvalid = false;
        qp.errMsg    = null;
    }

    private String getCaseIdByMd5(String md5) {
        String cId = null;

        List<CaseSurveyVisca__c> sSurveys = new List<CaseSurveyVisca__c>([
            SELECT
                Id
            FROM
                CaseSurveyVisca__c
            WHERE
                Md5__c = :md5
        ]);

        if (sSurveys.size() == 1) {
            cId = sSurveys[0].Id;
        }

        return cId;
    }

    private List<Survey__c> getSurveyById(String sid) {
        return [
            SELECT
                Id
                ,SurveyFooter__c
                ,SurveyHeader__c
                ,ThankYouText__c
                ,Description__c
                ,PrivacyPolicy__c
                ,HidePrivacyPolicy__c
                ,Css__c
            FROM
                Survey__c
            WHERE
                Id = :sid
            LIMIT 1
        ];
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
                SurveyRef__c = :this.survey.Id
            ORDER BY
                OrderNumber__c
        ];
    }

    private Integer getSurveyTakerCountByCaseId(String cId) {
        return [
            SELECT
                COUNT()
            FROM
                SurveyTaker__c
            WHERE
                CaseSurveyViscaRef__c = :cId
            LIMIT 1
        ];
    }

    private void genAllQuestions() {
        List<SurveyQuestion__c> surveyQuestions = getSurveyQuestionsBySurveyId();
        Integer orderNo = 0;
        for (SurveyQuestion__c q : surveyQuestions) {
            QuestionPreview qPreview = new QuestionPreview();
            orderNo++;

            qPreview.type             = q.Type__c;
            qPreview.question         = q.Question__c;
            qPreview.isRequired       = q.Required__c;
            qPreview.surveyQuestionId = q.Id;

            if (String.isNotEmpty(q.Choices__c)) {
                qPreview.options = convChoiciesStrToSelectOptions(q.Choices__c, q.Type__c);
            }

            switch on q.Type__c {
                when 'Section' {
                    orderNo--;
                }
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
            qPreview.orderNo = orderNo;
            this.allQuestions.add(qPreview);
        }
    }

    private List<SelectOption> convChoiciesStrToSelectOptions(String choiciesStr, String type) {
        List<SelectOption> selectOptions = new List<SelectOption>();
        List<String> optionLabels        = new List<String>();

        if (type == 'Picklist') {
            selectOptions.add(new SelectOption('', ''));
        }

        List<String> choicies = choiciesStr.replace(Cnst.CRLF, Cnst.LF).split(Cnst.LF);
        for (Integer i = 1; i <= choicies.size(); i++) {
            String val   = String.valueOf(i);
            String label = choicies[i - 1];
            selectOptions.add(new SelectOption(val, label));
        }
        return selectOptions;
    }

    private void registSurveyAnswers() {
        SurveyTaker__c taker = new SurveyTaker__c();
        taker.CaseSurveyViscaRef__c = this.cId;
        taker.SurveyRef__c     = this.survey.Id;
        insert taker;

        List<SurveyQuestionResponse__c> answers = new List<SurveyQuestionResponse__c>();
        for (QuestionPreview qPreview : this.allQuestions) {
            if (qPreview.type == 'Section') {
                continue;
            }

            SurveyQuestionResponse__c answer = new SurveyQuestionResponse__c();
            answer.SurveyQuestion__c = qPreview.surveyQuestionId;
            answer.SurveyTaker__c    = taker.Id;

            switch on qPreview.type {
                when 'Free Text' {
                    if (String.isNotEmpty(qPreview.inputtedText)) {
                        answer.Response__c = qPreview.inputtedText;
                    }
                }
                when 'Number' {
                    if (qPreview.inputtedNumber > 0) {
                        answer.Response__c = String.valueOf(qPreview.inputtedNumber);
                    }
                }
                when 'Multi-Select--Vertical' {
                    if (qPreview.selectedOptions.size() > 0) {
                        List<String> tmp = new List<String>();
                        for (String val : qPreview.selectedOptions) {
                            tmp.add(getSelectOptionLabelByValue(qPreview.options, val));
                        }
                        answer.Response__c = String.join(tmp, Cnst.SURVEY_ANSWER_MULTI_CHECK_DELIMITER);
                    }
                }
                when 'NPS' {
                    if (String.isNotEmpty(qPreview.selectedOption)) {
                        answer.Response__c = getSelectOptionLabelByValue(qPreview.options, qPreview.selectedOption);
                        answer.NpsScore__c = Integer.valueOf(answer.Response__c);
                    }
                }
                when else {
                    if (String.isNotEmpty(qPreview.selectedOption)) {
                        answer.Response__c = getSelectOptionLabelByValue(qPreview.options, qPreview.selectedOption);
                    }
                }
            }
            answers.add(answer);
        }
        insert answers;
    }

    private String getSelectOptionLabelByValue(List<SelectOption> selectOptions, String selectVal) {
        for (SelectOption so : selectOptions) {
            if (so.getValue() == selectVal) {
                return so.getLabel();
            }
        }

        return null;
    }

    private void writeErrorLogging(String placeCode, Exception e) {
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error
                                    ,placeCode
                                    ,'ViewSurveyController')
                .putAttr('caId：', this.cId)
                .putAttr('Exception：', e.getMessage())
                .putAttr('LineNumber：', '' + e.getLineNumber())
                .putAttr('getStackTraceString：', e.getStackTraceString())
        );
    }

}