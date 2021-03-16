global class SogiSendSurveyBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        Database.executeBatch(new SogiSendSurveyBat(), theBatchSize);
    }

    global List<CaseSurveyVisca__c> start(Database.BatchableContext BC) {
        return [
            SELECT
                Id
                //,CaseRef__r.Id
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
                CreatedDate = YESTERDAY
            AND
                OppRef__r.RecordTypeId = :recordTypeIdOppSogi
            AND
                PaperFlg__c = false
            AND
                StopSendFlg__c = false
        ];
    }

    global void execute(Database.BatchableContext BC, List<CaseSurveyVisca__c> sendList) {

        List<MailAlert__c> sendMailList = new List<MailAlert__c>();

        for (CaseSurveyVisca__c cs : sendList) {
            // sms アンケート有のみ
            if (cs.SmsSendFlg__c && cs.SurveyUrl__c != null) {
                String msg = Cnst.SMS_MSG_SOGI_SURVEY_FIRST;
                msg = super.replaceMsgOnDynamicStr(
                    msg
                    ,cs.SurveyUrl__c
                    ,Cnst.UTM_MEDIUM_SMS
                    ,''
                );

                super.sendSms(cs, msg);
            }
            // メール
            if (cs.EmailSendFlg__c) {
                String fullName  = super.genFullName(cs.OppRef__r.Account);
                String subject   = Cnst.EMAIL_SUBJECT_SOGI_NO_SURVEY;
                String bodyText  = Cnst.EMAIL_BODY_SOGI_NO_SURVEY;
                String paramUtm  = Cnst.UTM_MEDIUM_EMAIL_NO_SURVEY;
                String surveyUrl = cs.SurveyUrl__c;
                // アンケート有
                if (cs.SurveyUrl__c != null) {
                    subject  = Cnst.EMAIL_SUBJECT_SOGI_SURVEY;
                    bodyText = Cnst.EMAIL_BODY_SOGI_SURVEY;
                    paramUtm = Cnst.UTM_MEDIUM_EMAIL;
                }
                bodyText = bodyText + Cnst.EMAIL_BODY_SOGI_SURVEY_SIGNATURE;
                bodyText = super.replaceMsgOnDynamicStr(
                    bodyText
                    ,cs.SurveyUrl__c
                    ,Cnst.UTM_MEDIUM_EMAIL
                    ,fullName
                );

                MailAlert__c ma = super.sendEmail(cs, subject, bodyText);
                if (ma != null) {
                    sendMailList.add(ma);
                }
            }
        }

        if (sendMailList.size() > 0) {
            insert sendMailList;
        }
        update sendList;
    }

    global void finish(Database.BatchableContext BC) {
    }
}