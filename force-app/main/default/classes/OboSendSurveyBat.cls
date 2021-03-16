global class OboSendSurveyBat extends SurveyBase implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        Database.executeBatch(new OboSendSurveyBat(), theBatchSize);
    }

    global List<CaseSurveyVisca__c> start(Database.BatchableContext BC) {
        return [
            SELECT
                Id
                ,OppRef__r.Id
                ,OppRef__r.Account.LastName
                ,OppRef__r.Account.FirstName
                ,OppRef__r.Account.MailAddress__c
                ,OppRef__r.Account.MobilePhoneFormula__c
                ,PaperFlg__c
                ,SurveyUrl__c
                ,SurveyRef__r.Name
                ,SmsSendFlg__c
                ,SmsSendDatetime__c
                ,SmsSendCount__c
                ,EmailSendFlg__c
                ,EmailSendDatetime__c
                ,EmailSendCount__c
            FROM
                CaseSurveyVisca__c
            WHERE
                CreatedDate = TODAY
            AND
                OppRef__r.RecordTypeId = :recordTypeIdOppObo
            AND
                PaperFlg__c = false
            AND
                StopSendFlg__c = false
        ];
    }

    global void execute(Database.BatchableContext BC, List<CaseSurveyVisca__c> sendList) {

        super.setUtmSourceVal('survey_obosan');
        List<MailAlert__c> sendMailList = new List<MailAlert__c>();

        for (CaseSurveyVisca__c cs : sendList) {
            // sms送信
            if (cs.SmsSendFlg__c) {
                String msg = getMsgBySurveyName(cs);
                msg = super.replaceMsgOnDynamicStr(
                    msg
                    ,cs.SurveyUrl__c
                    ,Cnst.UTM_MEDIUM_SMS
                    ,''
                );

                sendSms(cs, msg);
            // メール
            } else if (cs.EmailSendFlg__c) {
                String fullName = super.genFullName(cs.OppRef__r.Account);
                String bodyText = getMsgBySurveyName(cs);
                bodyText = bodyText + Cnst.EMAIL_BODY_OBO_SURVEY_SIGNATURE;
                bodyText = super.replaceMsgOnDynamicStr(
                    bodyText
                    ,cs.SurveyUrl__c
                    ,Cnst.UTM_MEDIUM_EMAIL
                    ,fullName
                );

                MailAlert__c ma = super.sendEmail(cs, Cnst.EMAIL_SUBJECT_OBO_SURVEY, bodyText);
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

    private String getMsgBySurveyName(CaseSurveyVisca__c cs) {
        String msg = '';
        if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_葬儀読経')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_FIRST_DOKKYO : Cnst.EMAIL_BODY_OBO_SURVEY_DOKKYO; 
        } else if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_法要')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_FIRST_HOYO : Cnst.EMAIL_BODY_OBO_SURVEY_HOYO; 
        } else if (cs.SurveyRef__r.Name.contains('お坊さん便アンケート_戒名')) {
            msg = cs.SmsSendFlg__c? Cnst.SMS_MSG_OBO_SURVEY_FIRST_KAIMYO : Cnst.EMAIL_BODY_OBO_SURVEY_KAIMYO; 
        }

        return msg;
    }
}