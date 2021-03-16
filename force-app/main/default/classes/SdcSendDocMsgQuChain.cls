public class SdcSendDocMsgQuChain implements Queueable, Database.AllowsCallouts {
    private String f_SdcMsgId;
    public static void enque(String pSdcMsgId){
        SdcSendDocMsgQuChain theQue = new SdcSendDocMsgQuChain();
        theQue.f_SdcMsgId = pSdcMsgId;
        System.enqueueJob(theQue);
    }

    public void execute(QueueableContext context) {
        try{
            this.run();
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190830-1700', 'SdcSendDocMsgQuChain')
                    .putAttr('f_SdcMsgId', f_SdcMsgId)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    public void run(){

        SdcMsg__c theMsg = [
            SELECT Id, ClientTag__c, MsgTxt__c, SdcRef__c
            FROM SdcMsg__c
            WHERE Id = :this.f_SdcMsgId
        ].get(0);

        Sdc__c theSdc = [ SELECT Id, phoneNo__c, DeliveryStatus__c FROM Sdc__c WHERE Id =: theMsg.SdcRef__c FOR UPDATE].get(0);

        SmSender.SendResult sendresult = SmSender.sendSms(theSdc.phoneNo__c, theMsg.ClientTag__c, theMsg.MsgTxt__c);

        if(sendresult.result == SmSender.Result.Success){
            update new SdcMsg__c(Id=theMsg.Id, DeliveryStatus__c='Sent', SentDt__c=Datetime.now());
            if( theSdc.DeliveryStatus__c == 'Created' ){
                update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='Sending', SentDt__c=Datetime.now() );
            }
            this.sendNextMsg(theMsg.ClientTag__c);
        } else {
            update new SdcMsg__c(Id=theMsg.Id, DeliveryStatus__c='DeliveryFailed');
            if( theSdc.DeliveryStatus__c != 'DeliveryFailed' ){
                update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='DeliveryFailed');
            }
            SdcEvtQms.InsertAsRoot(theSdc.Id, 'DeliveryFailed');
        }
    }

    private void sendNextMsg(String prevMsgClientTag) {
        List<SdcMsg__c> theNextSdcMsg = [ SELECT Id FROM SdcMsg__c WHERE PrevMsgClientTag__c = :prevMsgClientTag];
        if(theNextSdcMsg.size() > 0) {
            SdcSendDocMsgQuChain.enque(theNextSdcMsg[0].Id);
        }
    }
}