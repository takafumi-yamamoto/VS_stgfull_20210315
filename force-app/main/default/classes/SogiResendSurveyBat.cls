global class SogiResendSurveyBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {


    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        Database.executeBatch(new SogiResendSurveyBat(), theBatchSize);
    }

    global List<CaseSurveyVisca__c> start(Database.BatchableContext BC) {
        Date beforeSentDate = Date.toDay().addDays(-7);

        List<CaseSurveyVisca__c> targetList = [
                SELECT
                    Id
                    ,OppRef__r.Id
                    ,OppRef__r.Account.LastName
                    ,OppRef__r.Account.FirstName
                    ,OppRef__r.Account.MailAddress__c
                    ,OppRef__r.Account.MobilePhoneFormula__c
                    ,PaperFlg__c
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
                    ((SmsSendCount__c IN (1, 2) AND DAY_ONLY(SmsSendDatetime__c) = :beforeSentDate)
                    OR
                    (EmailSendCount__c IN (1, 2) AND DAY_ONLY(EmailSendDatetime__c) = :beforeSentDate))
                AND
                    OppRef__r.RecordTypeId = :recordTypeIdOppSogi
                AND
                    SurveyUrl__c != null
                AND
                    PaperFlg__c = false
                AND
                    StopSendFlg__c = false
        ];

        List<CaseSurveyVisca__c> resendList = super.getResendList(targetList);

        return resendList;
    }

    global void execute(Database.BatchableContext BC, List<CaseSurveyVisca__c> resendList) {

        AccreteSmsApi smsApi = new AccreteSmsApi();

        List<MailAlert__c> resendMailList = new List<MailAlert__c>();

        // sms送信リスト(post body)とメール送信メールアラートの作成
        for (CaseSurveyVisca__c cs : resendList) {
            if (cs.SmsSendFlg__c) {
                String msg = Cnst.SMS_MSG_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK;
                String paramUtm = Cnst.UTM_MEDIUM_SMS_AFTER_ONE_WEEK;
                if (cs.SmsSendCount__c == 2) {
                    msg = Cnst.SMS_MSG_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK;
                    paramUtm = Cnst.UTM_MEDIUM_SMS_AFTER_TWO_WEEK;
                }
                msg = super.replaceMsgOnDynamicStr(
                    msg
                    ,cs.SurveyUrl__c
                    ,paramUtm
                    ,''
                );

                super.sendSms(cs, msg);
            }

            if (cs.EmailSendFlg__c) {
                String fullName = super.genFullName(cs.OppRef__r.Account);
                String subject = Cnst.EMAIL_SUBJECT_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK;
                String bodyText = Cnst.EMAIL_BODY_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK;
                String paramUtm = Cnst.UTM_MEDIUM_EMAIL_AFTER_ONE_WEEK;
                if (cs.EmailSendCount__c == 2) {
                    subject = Cnst.EMAIL_SUBJECT_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK;
                    bodyText = Cnst.EMAIL_BODY_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK;
                    paramUtm = Cnst.UTM_MEDIUM_EMAIL_AFTER_TWO_WEEK;
                }
                bodyText = bodyText + Cnst.EMAIL_BODY_SOGI_SURVEY_SIGNATURE;
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
}