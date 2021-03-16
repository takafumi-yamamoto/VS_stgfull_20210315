/**
 * メール・メッセージトリガーハンドラー
 * ・メール-to-ケースで受けたメールの内容により、ケースの項目を更新する
 * ・メール-to-ケースで送信するときに不達フラグをはずす
 */
public class MailToCaseHandler {

    public static final String APPRV_STATUS_SHONIN = '承認済み'; 
    public static final String ERROR_MSG_FROMADDRNOTHING_ERROR = '送信元アドレスが組織アドレスに登録されていません ';
    public class FromAddressNothingException extends Exception {}

    public MailToCaseHandler() {

    }

    public void caseUpdate(List<EmailMessage> newList){
        Set<Id> caseIdSet = new Set<ID>();
        try{
            for(EmailMessage emailmsg:newList){
                if(emailmsg.ParentId!=null && chkCaseId(emailmsg.ParentId)) caseIdSet.add(emailmsg.ParentId);
            }
            if(caseIdSet.size() > 0){
                Map<Id,Case> casemap = new Map<Id,Case>([
                    SELECT
                        Id
                        ,MailLabel__c
                        ,EmergencyLevelMail__c
                        ,MailFuriwakeServiceName__c
                        ,ToiawaseDate__c
                    FROM Case
                    WHERE Id in :caseIdSet
                ]);

                //ケースの情報の更新
                Map<Id,Case> updateIncomeMap = new Map<Id,Case>();

                for(EmailMessage emailmsg:newList){
                    if(emailmsg.ParentId!=null && chkCaseId(emailmsg.ParentId)){
                        Case updatecase = casemap.get(emailmsg.ParentId);
                        updatecase.LatestMailDatetime__c = Datetime.now();
                        if(updatecase.ToiawaseDate__c == null)updatecase.ToiawaseDate__c = Datetime.now();
                        //メール受信の場合
                        if(emailmsg.Incoming ){
                            updatecase.Status = '新規';
                            updatecase.MailFutatsu__c = chkFutatsu(emailmsg);
                            if(!updatecase.MailFutatsu__c){
                                String mailFuriwakesakiService = chkMailFuriwakeService(emailmsg);
                                String mailLabel = chkLabel(emailmsg);
                                String elevel = chkEmergencyLevel(emailmsg);
                                if(String.isBlank(updatecase.MailFuriwakeServiceName__c) && String.isNotBlank(mailFuriwakesakiService))updatecase.MailFuriwakeServiceName__c = mailFuriwakesakiService;
                                if(String.isBlank(updatecase.MailLabel__c) && String.isNotBlank(mailLabel))updatecase.MailLabel__c = mailLabel;
                                if(String.isBlank(updatecase.EmergencyLevelMail__c) && String.isNotBlank(elevel))updatecase.EmergencyLevelMail__c = elevel;
                            }

                            updateIncomeMap.put(updatecase.Id,updatecase);
                        }
                        //メール送信の場合
                        if(!emailmsg.Incoming){
                            updatecase.Status = '対応中';
                            updatecase.MailFutatsu__c = false;
                            updateIncomeMap.put(updatecase.Id,updatecase);
                        }
                    }

                }

                if(updateIncomeMap.size() > 0) update updateIncomeMap.values();
                
            }
        }catch(Exception e){
            Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20190917-1400-01', 'MailToCaseHandler.caseUpdate()', 'メールメッセージオブジェクト生成時　ケース更新時の例外発生')
                            .putAttr('Exception', e.getMessage())
                            .putAttr('LineNumber', '' + e.getLineNumber())
                            .putAttr('TypeName', e.getTypeName())
                            .putAttr('Cause', '' + e.getCause())
                );
        }
    }

    public void copySendMail(List<EmailMessage> newList, Map<Id, EmailMessage> oldMap){
        try{
            //承認された送信メールをコピーして本文をパスワードメールに変更して送信する   
            List<Messaging.Email> messageList = new List<Messaging.Email>();
            Map<String,Id> mailAddrMailAddressIdMap = new Map<String,Id>();
            Set<String> fromaddressSet = new Set<String>();
            for(EmailMessage emailmessage:newList){
                if(String.isNotBlank(emailmessage.FromAddress))fromaddressSet.add(emailmessage.FromAddress);
            }
            //組織メールアドレスの一覧を取得する
            if(fromaddressSet.size() > 0){
                mailAddrMailAddressIdMap = this.getOrgWideEmailAddressByEmailAddress(fromaddressSet);
            }

            for(EmailMessage emailmessage:newList){

                if(!emailmessage.Incoming){
                    EmailMessage oldEmailmessage = oldMap.get(emailmessage.Id);
                    if(APPRV_STATUS_SHONIN.equals(emailmessage.ApproveStatus__c) && oldEmailmessage.ApproveStatus__c != emailmessage.ApproveStatus__c 
                    && String.isNotBlank(emailmessage.PassWordMail__c) && emailmessage.PasswordAri__c){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(emailmessage.ToAddress.split(';'));
                        email.setReplyTo(emailmessage.FromAddress);
                        email.setSubject('パスワード送付');
                        email.setPlainTextBody(emailmessage.PassWordMail__c);
                        email.setWhatId(emailmessage.ParentId);
                        ID orgWideEmailAddressId = mailAddrMailAddressIdMap.get(emailmessage.FromAddress);
                        if(orgWideEmailAddressId!=null) email.setOrgWideEmailAddressId(orgWideEmailAddressId);
                        else throw new FromAddressNothingException(ERROR_MSG_FROMADDRNOTHING_ERROR + emailmessage.FromAddress);
                        messageList.add(email);

                    }
                }
            }

            if(messageList.size() > 0){
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(messageList, false);
                if (!results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20190917-1400-02', 'MailToCaseHandler.copySendMail()', 'パスワードメール送信　送信エラー')
                                .putAttr('statusCode', String.valueOf(statusCode))
                                .putAttr('errorMessage', errorMessage)
                    );
                }    
            }
        }catch(Exception e){
            Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20190917-1400-03', 'MailToCaseHandler.copySendMail()', 'パスワードメール送信　例外発生')
                            .putAttr('Exception', e.getMessage())
                            .putAttr('LineNumber', '' + e.getLineNumber())
                            .putAttr('TypeName', e.getTypeName())
                            .putAttr('Cause', '' + e.getCause())
                );
        }

    }

    //サービスの振り分け
    private static String chkMailFuriwakeService(EmailMessage emmsg){
        return MailFuriwakeConfig.chkMailConditon(emmsg,MailFuriwakeConfig.FURIWAKE_METADATA_SERVICE);
    }

    //ラベルの振り分け
    private static String chkLabel(EmailMessage emmsg){
        return MailFuriwakeConfig.chkMailConditon(emmsg,MailFuriwakeConfig.FURIWAKE_METADATA_LABEL);
    }

    //レベルの振り分け
    private Static String chkEmergencyLevel(EmailMessage emmsg){
        return MailFuriwakeConfig.chkMailConditon(emmsg,MailFuriwakeConfig.FURIWAKE_METADATA_KINKYU);
    }

    //不達のお知らせメールか
    private Static Boolean chkFutatsu(EmailMessage emmsg){
        String chkresult = MailFuriwakeConfig.chkMailConditon(emmsg,MailFuriwakeConfig.FURIWAKE_METADATA_FUTATSU);

        return ('true'.equals(chkresult)?true:false);
    }

    //ParentIdがCaseのものかどうかを調べる
    private boolean chkCaseId(String chkId){
        boolean resultFlg = false;
        SObjectType sObjectType = Schema.getGlobalDescribe().get('case');

        String head = chkId.left(3);
    
        if(sObjectType.getDescribe().getKeyPrefix().equals(head)) resultFlg = true;
        return resultFlg;
    }

    private Map<String,ID> getOrgWideEmailAddressByEmailAddress(Set<String> emailAddressSet) {

        Map<String,ID> addressIdMap = new Map<String,Id>();
        List<OrgWideEmailAddress> mailAdressIdList = [
            SELECT
                Id
                ,Address
            FROM
                OrgWideEmailAddress
            WHERE
                Address in :emailAddressSet
        ];
        for(OrgWideEmailAddress oaddress:mailAdressIdList){
            addressIdMap.put(oaddress.Address,oaddress.Id);
        }
       
        return addressIdMap;
    }
}