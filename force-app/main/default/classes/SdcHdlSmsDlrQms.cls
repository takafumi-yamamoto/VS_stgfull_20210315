public class SdcHdlSmsDlrQms implements IHdlQms{
    public static String msgType = 'SdcHdlSmsDlrQms';

    public class Data{
        public String smsDlrId;
		public String sdcMsgId;
    }

    public static Qms__c CreateQmsAsRoot(String pSmsDlrId, String pSdcMsgId){
        Data theData = new Data();
        theData.smsDlrId = pSmsDlrId;
		theData.sdcMsgId = pSdcMsgId;
        return QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
    }

    public void handleQms(Qms__c pQms){
        try{
            this.runQms(pQms);
        }catch(Exception ex){
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20191121-1837', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private void runQms(Qms__c pQms){
        Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);

		SdcMsg__c pSdcMsg =
			[
				SELECT  Id, SdcRef__c, ClientTag__c, MsgTxt__c, PrevMsgClientTag__c
				FROM SdcMsg__c
				WHERE Id = :theData.sdcMsgId
			].get(0);

        Sdc__c theSdc =
			[
				SELECT Id, SendOrderControll__c, DeliveryStatus__c FROM Sdc__c WHERE Id =: pSdcMsg.SdcRef__c FOR UPDATE
			].get(0);

		SmsDlr__c pSmsDlr =
			[
				SELECT Id, Status__c FROM SmsDlr__c WHERE Id = :theData.smsDlrId
			].get(0);

        if(pSmsDlr.Status__c == 'Delivered') {

            update new SdcMsg__c(Id=pSdcMsg.Id, DeliveryStatus__c='Delivered', DlrResultDt__c=Datetime.now());

            Boolean theIsAllMsgDelivered = this.isAllMsgDelivered(theSdc, pSdcMsg);

            if( !theIsAllMsgDelivered){
				if( theSdc.SendOrderControll__c == 'DlrChian'){
					SdcMsg__c theNextSdcMsg =   [ SELECT Id FROM SdcMsg__c WHERE PrevMsgClientTag__c = :pSdcMsg.ClientTag__c].get(0);
					SdcSendDocMsgDlrChain.enque(theNextSdcMsg.Id);
				}
            }

            if( theIsAllMsgDelivered ){
                if(theSdc.DeliveryStatus__c != 'Delivered'){
                    update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='Delivered');
                    SdcEvtQms.InsertAsChild(theSdc.Id, SdcEvtQms.deliveryStatus_Delivered, pQms);
                }
            }
        }

        if(pSmsDlr.Status__c == 'DeliveryFailed') {

            update new SdcMsg__c(Id=pSdcMsg.Id, DeliveryStatus__c='DeliveryFailed', DlrResultDt__c=Datetime.now());

            if(theSdc.DeliveryStatus__c != 'DeliveryFailed'){
                update new Sdc__c(Id=theSdc.Id, DeliveryStatus__c='DeliveryFailed');
				SdcEvtQms.InsertAsChild(theSdc.Id, SdcEvtQms.deliveryStatus_DeliveryFailed, pQms);
            }
        }

        UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
    }

    private Boolean isAllMsgDelivered(Sdc__c sdc, SdcMsg__c sdcMsg){
        AggregateResult result = [SELECT count(Id) cnt FROM SdcMsg__c WHERE SdcRef__c = :sdc.Id AND DeliveryStatus__c != 'Delivered'];
        return Integer.valueOf(result.get('cnt')) == 0;
    }
}