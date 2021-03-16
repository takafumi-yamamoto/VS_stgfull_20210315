public virtual class SurveyBase {
    public static final String recordTypeIdOppSogi =
        Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    public static final String recordTypeIdOppObo  =
        Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
    //public static final String recordTypeIdCaseSurvey =
    //    Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('surveyVisca').getRecordTypeId();
    public static final Site surveySite = [
        SELECT
            Id
            ,UrlPathPrefix
        FROM
            Site
        WHERE
            Name = 'surveyDeliver'
        AND
            Status = 'Active'
    ];
    public static final List<SurveyWithProduct2Mapping__c> surveyWithProduct2MappingList = [
        SELECT
            Id
            ,SurveyRef__c
            ,Product2Id__c
            ,UseSogiDokkyoFlg__c
            ,WithKaimyo__c
            ,PaperFlg__c
        FROM
            SurveyWithProduct2Mapping__c
        WHERE
            PaperFlg__c = false 
    ];

    private String utmSourceVal = 'survey';

    public SurveyBase() {
    }

    public void setUtmSourceVal(String val) {
        this.utmSourceVal = val;
    }

    public String createOrgUrl(String surveyId, String cMd5){
        String surveyBaseUrl = Env.survey.domain__c + surveySite.UrlPathPrefix;
        String url = surveyBaseUrl
            + '/' + Cnst.SURVEY_TAKER_URL_FILENAME
            + '?sid=' + surveyId
            + '&caId=' + cMd5
            + '&';
        url = appendUtmParams(url);
        return url;
    }

    private String appendUtmParams(String url) {
        return url
            + 'utm_source=' + this.utmSourceVal
            + '&utm_medium=';
    }

    public CaseSurveyVisca__c generateCaseSurvey(
        String oppId
        ,String surveyId
    ) {
        CaseSurveyVisca__c cSurvey = new CaseSurveyVisca__c(
            OppRef__c = oppId
            ,SurveyRef__c = surveyId
        );
        insert cSurvey;
        cSurvey = [
            SELECT
                Id
                ,Md5__c
            FROM
                CaseSurveyVisca__c
            WHERE
                Id = :cSurvey.Id
        ];
        cSurvey.SurveyUrl__c = createOrgUrl(surveyId, cSurvey.Md5__c);

        return cSurvey;
    }

    public String genFullName(Account acc) {
        return acc.LastName
            + Cnst.BLANK_ZENKAKU
            + acc.FirstName;
    }

    public void sendSms(
        CaseSurveyVisca__c cs
        ,String msg
    ) {
        AccreteSmsApi smsApi = new AccreteSmsApi();

        if (smsApi.isValidTelNo(cs.OppRef__r.Account.MobilePhoneFormula__c)) {
            Datetime sendDate = Datetime.now();

            try {
                smsApi.smsReg(
                    msg
                    ,cs.OppRef__r.Account.MobilePhoneFormula__c
                    ,cs.OppRef__r.Id
                );
                cs.SmsSendCount__c++;
                cs.SmsSendDatetime__c = sendDate;
            } catch (Exception e) {
            }
        } else {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info
                                        ,'2021022211111101'
                                        ,'SurveyBase')
                    .putAttr('OpportunityId', cs.OppRef__r.Id)
                    .putAttr('Message', 'Cant send sms. Wrang MobilePhoneNo.')
            );
        }
    }

    public MailAlert__c sendEmail(
        CaseSurveyVisca__c cs
        ,String subject
        ,String bodyText
    ) {
        MailAlert__c ma = null;
        if (String.isNotEmpty(cs.OppRef__r.Account.MailAddress__c)) {
            Datetime sendDate = Datetime.now();

            ma = new MailAlert__c(
                SashidashininMail__c = Env.survey.FromMailAddress__c
                ,ToAddress__c = cs.OppRef__r.Account.MailAddress__c
                ,Title__c = subject
                ,Body__c = bodyText
            );

            cs.EmailSendCount__c++;
            cs.EmailSendDatetime__c = sendDate;
        } else {
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info
                                        ,'2021022211111102'
                                        ,'SurveyBase')
                    .putAttr('OpportunityId', cs.OppRef__r.Id)
                    .putAttr('Message', 'Cant send email. Wrang email address.')
            );
        }

        return ma;
    }

    public CaseSurveyVisca__c[] getResendList(CaseSurveyVisca__c[] targetList) {
        List<CaseSurveyVisca__c> resendList = new List<CaseSurveyVisca__c>();

        List<String> cSurveyIds = new List<String>();
        for (CaseSurveyVisca__c cs : targetList) {
            cSurveyIds.add(cs.Id);
        }

        List<SurveyTaker__c> takerList = [
            SELECT
                CaseSurveyViscaRef__c
            FROM
                SurveyTaker__c
            WHERE
                CaseSurveyViscaRef__c IN :cSurveyIds
        ];

        List<String> answereds = new List<String>();
        for (SurveyTaker__c taker : takerList) {
            answereds.add(taker.CaseSurveyViscaRef__c);
        }

        for (CaseSurveyVisca__c cs : targetList) {
            if (!answereds.contains(cs.Id)) {
                resendList.add(cs);
            }
        }

        return resendList;
    }

    public String replaceMsgOnDynamicStr(String msg, String surveyUrl, String paramUtm, String fullName) {
        String mainteMsgAfter = Cnst.STR_EMPTY;
        if (String.isNotEmpty(Env.survey.SfMaintenaceInfoMsg__c)) {
            mainteMsgAfter = Env.survey.SfMaintenaceInfoMsg__c + Cnst.LF + Cnst.LF;
        }
        msg = msg.replace(Cnst.REPLACE_WORD_SF_MAINTENACE_INFO_MSG, mainteMsgAfter);
        msg = msg.replace(Cnst.REPLACE_WORD_SURVEY_SHORT_URL, surveyUrl + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_KODEN_GAESHI_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'pdf/gift?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_SOZOKU_SODAN_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'pdf/support?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_IHAI_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'butsudan/ihai/?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_OBO_TOP_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'obosan/?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_49HOYO_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'obosan/houji/houyou49/?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_EITAI_KUYO_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'eitaikuyo/?') + paramUtm);
        msg = msg.replace(
            Cnst.REPLACE_WORD_KAIYO_SANKOTU_URL
            ,appendUtmParams(Env.survey.WebFrontBaseUrl__c + 'kaiyo/?') + paramUtm);
        msg = msg.replace(Cnst.REPLACE_WORD_USER_NAME, fullName);
        msg = msg.replace(Cnst.REPLACE_WORD_YORISO_URL, Env.survey.WebFrontBaseUrl__c);
        msg = msg.replace(Cnst.REPLACE_WORD_SOGI_URL, Env.survey.WebFrontBaseUrl__c + 'sogi/');
        msg = msg.replace(Cnst.REPLACE_WORD_OBO_URL, Env.survey.WebFrontBaseUrl__c + 'obosan/');


        return msg;
    }
}