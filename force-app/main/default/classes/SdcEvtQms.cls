public class SdcEvtQms implements IHdlQms {
	public static String msgType = 'SdcEvtQms';
	public static String deliveryStatus_Delivered = 'Delivered';
	public static String deliveryStatus_DeliveryFailed = 'DeliveryFailed';

	public class Data{
		public String sdcId;
		public String deliveryStatus;
	}

	public static void InsertAsRoot(String pSdcId, String pDeliveryStatus){
		Data theData = new Data();
		theData.sdcId = pSdcId;
		theData.deliveryStatus = pDeliveryStatus;
		INSERT QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
	}
	public static void InsertAsChild(String pSdcId, String pDeliveryStatus, Qms__c pQms){
		Data theData = new Data();
		theData.sdcId = pSdcId;
		theData.deliveryStatus = pDeliveryStatus;
		INSERT QmsBld.newChild(pQms).setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
	}

	public void handleQms(Qms__c pQms){
		try{
			this.runQms(pQms);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190827-1827', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	public void runQms(Qms__c pQms){
		//some logic here.
		Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
		Sdc__c theSdc =
			(Sdc__c)SobjectsExtension.firstOrNull(
				[SELECT Id, smsDocType__c FROM Sdc__c WHERE Id = : theData.sdcId]
			);

		SdcEvtHdlPvdr.ResolveHandlerResult theResolveHandlerResult = SdcEvtHdlPvdr.resolveHandler(theSdc.smsDocType__c);
		if( theResolveHandlerResult.handler != null ){
			theResolveHandlerResult.handler.onSdcEvtRelayed(pQms, theData);
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}

		if( theResolveHandlerResult.handler == null ){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}

	}

}