global class OboResendSurveyBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        Database.executeBatch(new OboResendSurveyBat(), theBatchSize);
    }

    global List<CaseSurveyVisca__c> start(Database.BatchableContext BC) {
        Date beforeSentDate = Date.toDay().addDays(-8);

        List<CaseSurveyVisca__c> targetList = [
                SELECT
                    Id
                    ,OppRef__r.Id
                    ,OppRef__r.Account.LastName
                    ,OppRef__r.Account.FirstName
                    ,OppRef__r.Account.MailAddress__c
                    ,OppRef__r.Account.MobilePhoneFormula__c
                    ,PaperFlg__c
                    ,SurveyRef__r.Name
                    ,SurveyUrl__c
                    ,SmsSendFlg__c
                    ,SmsSendDatetime__c
                    ,SmsSendCount__c
                    ,EmailSendFlg__c
                    ,EmailSendDatetime__c
                    ,EmailSendCount__c
                FROM
                    CaseSurveyVisca__c
                WHERE
                    ((SmsSendCount__c = 1 AND DAY_ONLY(SmsSendDatetime__c) = :beforeSentDate)
                    OR
                    (EmailSendCount__c = 1 AND DAY_ONLY(EmailSendDatetime__c) = :beforeSentDate))
                AND
                    OppRef__r.RecordTypeId = :recordTypeIdOppObo
                AND
                    PaperFlg__c = false
                AND
                    StopSendFlg__c = false
        ];

        List<CaseSurveyVisca__c> resendList = super.getResendList(targetList);

        return resendList;
    }

    global void execute(Database.BatchableContext BC, List<CaseSurveyVisca__c> resendList) {

        super.setUtmSourceVal('survey_obosan');
        List<MailAlert__c> resendMailList = new List<MailAlert__c>();

        for (CaseSurveyVisca__c cs : resendList) {
            // sms
            if (cs.SmsSendFlg__c) {
                String msg = getMsgBySurveyName(cs);
                String paramUtm = Cnst.UTM_MEDIUM_SMS_AFTER_8DAY;
                msg = super.replaceMsgOnDynamicStr(
                    msg
                    ,cs.SurveyUrl__c
                    ,paramUtm
                    ,''
                );

                super.sendSms(cs, msg);
            // Eメール
            } else if (cs.EmailSendFlg__c) {
                String fullName = super.genFullName(cs.OppRef__r.Account);
                String subject = Cnst.EMAIL_SUBJECT_OBO_SURVEY_RESEND_AFTER_8DAY;
                String bodyText = getMsgBySurveyName(cs);
                String paramUtm = Cnst.UTM_MEDIUM_EMAIL_AFTER_8DAY;
                bodyText = bodyText + Cnst.EMAIL_BODY_OBO_SURVEY_SIGNATURE;
                bodyText = super.replaceMsgOnDynamicStr(
                    bodyText
                    ,cs.SurveyUrl__c
                    ,paramUtm
                    ,fullName
                );

                MailAlert__c ma = super.sendEmail(cs, subject, bodyText);
                if (ma != null) {
                    resendMailList.add(ma);
                }
            }
        }

        if (resendMailList.size() > 0) {
            insert resendMailList;
        }
        update resendList;
    }

    global void finish(Database.BatchableContext BC) {
    }

    private String getMsgBySurveyName(CaseSurveyVisca__c cs) {
        String msg = '';
        if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_葬儀読経')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_DOKKYO : Cnst.EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_DOKKYO; 
        } else if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_法要')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_HOYO : Cnst.EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_HOYO; 
        } else if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_戒名')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_KAIMYO : Cnst.EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_KAIMYO; 
        }

        return msg;
    }
}