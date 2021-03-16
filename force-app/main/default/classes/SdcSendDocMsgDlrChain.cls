public class SdcSendDocMsgDlrChain implements Queueable, Database.AllowsCallouts {

    //Queable Begin
    private String f_SdcMsgId;
    public static void enque(String pSdcMsgId){
        SdcSendDocMsgDlrChain theQue = new SdcSendDocMsgDlrChain();
        theQue.f_SdcMsgId = pSdcMsgId;
        System.enqueueJob(theQue);
    }
    public void execute(QueueableContext context) {
        try{
            this.run();
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190828-1700', 'SdcSendDocMsgDlrChain')
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

        Sdc__c theSdc = [ SELECT Id, phoneNo__c, DeliveryStatus__c FROM Sdc__c WHERE Id =: theMsg.SdcRef__c].get(0);

        SmSender.SendResult sendresult = SmSender.sendSms(theSdc.phoneNo__c, theMsg.ClientTag__c, theMsg.MsgTxt__c);


        if(sendresult.result == SmSender.Result.Success){
            update new SdcMsg__c(Id=theMsg.Id, DeliveryStatus__c='Sent', SentDt__c=Datetime.now());
        } else {
            update new SdcMsg__c(Id=theMsg.Id, DeliveryStatus__c='DeliveryFailed');
        }


        if(sendresult.result == SmSender.Result.Success){
            if( theSdc.DeliveryStatus__c == 'Created' ){
                update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='Sending', SentDt__c=Datetime.now() );
            }
        } else {
            if( theSdc.DeliveryStatus__c != 'DeliveryFailed' ){
                update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='DeliveryFailed');
                SdcEvtQms.InsertAsRoot(theSdc.Id, 'DeliveryFailed');
            }
        }

    }
}