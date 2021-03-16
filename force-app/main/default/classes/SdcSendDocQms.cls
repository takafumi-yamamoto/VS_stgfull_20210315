public class SdcSendDocQms implements IHdlQms{
    public static String msgType = 'SdcSendDocQms';

    public class Data{
        public String sdcId;
    }

    public static void InsertAsRoot(String pSdcId){
        Data theData = new Data();
        theData.sdcId = pSdcId;
        INSERT QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
    }

    public void handleQms(Qms__c pQms){
        try{
            this.runQms(pQms);
        }catch(Exception ex){
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190826-1700', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){
        Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);

        Sdc__c sdc =
        [
            SELECT
            Id, data__c,phoneNo__c, SendOrderControll__c,smsDocType__c,
            (
                SELECT Id, ClientTag__c, MsgTxt__c, PrevMsgClientTag__c
                FROM SdcMsg__r
                WHERE DeliveryStatus__c = 'Created'
                ORDER BY LineNo__c
            )
            FROM Sdc__c WHERE id =: theData.sdcId
         ];

        if( sdc.SendOrderControll__c == 'DlrChian') {
            SdcSendDocMsgDlrChain.enque(sdc.SdcMsg__r[0].Id);
        }

        if( sdc.SendOrderControll__c == 'QueChian') {
            SdcSendDocMsgQuChain.enque(sdc.SdcMsg__r[0].Id);
        }

        UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
    }

}