public class SmSender {

    public enum Result {Success, Restricted, Failed}

    public class SendResult {
        public SmSender.Result result;
        public SendResult setResult(SmSender.Result result) {
            this.result = result;
            return this;
        }
    }

    public static SendResult sendSms(String phoneNo, String clientTag, String msgText) {
        SendResult sendresult = null;

        try{
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(phoneNo);
        }catch(Testers.NotTesterException ex){
            sendresult = new SendResult().setResult(SmSender.Result.Restricted);
        }

        try {
            if(sendresult == null){
                Aos_SMSTransUtility.SendResult theResult = Aos_SMSTransUtility.sendHttpRequest(clientTag, phoneNo, msgText);
                sendresult = new SendResult().setResult(theResult == Aos_SMSTransUtility.SendResult.Success ?
                                                    SmSender.Result.Success : SmSender.Result.Failed);
            }
            logSendSms(phoneNo, clientTag, msgText, sendresult.result);
        } catch(Exception e) {
            sendresult = new SendResult().setResult(SmSender.Result.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190822-1000-01', 'SmSender', 'Sms送信エラー')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
                        .putAttr('phoneNo', phoneNo)
                        .putAttr('clientTag', clientTag)
                        .putAttr('msgText', msgText)
            );
        }
        return sendresult;
    }

    private static void logSendSms(String phoneNo, String clientTag, String msgText, SmSender.Result result){
        Insert new SendSms__c(phoneNo__c=phoneNo, clientTag__c=clientTag, msgText__c=msgText, Result__c=result.name());
    }

}