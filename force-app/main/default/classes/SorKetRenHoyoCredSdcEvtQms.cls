public class SorKetRenHoyoCredSdcEvtQms implements IHdlQms{
	public static String msgType = 'SorKetRenHoyoCredSdcEvtQms';
	public class Data{
		public String sdcId;
		public String deliveryStatus;
	}
	public static String deliveryStatus_Delivered = 'Delivered';
	public static String deliveryStatus_DeliveryFailed = 'DeliveryFailed';

	public static void InsertAsChild(Qms__c pParentQms, String pSdcId, String pDeliveryStatus){
		Data theData = new Data();
		theData.sdcId = pSdcId;
		theData.deliveryStatus = pDeliveryStatus;
		INSERT QmsBld.newChild(pParentQms).setMsgType( msgType ).setData( JSON.serialize( theData ) ).build(); 
	}

	public void handleQms(Qms__c pQms){
		try{
			this.runQms(pQms);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190827-1955', msgType)
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
				[SELECT Id, smsDocType__c, data__c FROM Sdc__c WHERE Id = : theData.sdcId]
			);

		SorKetRenHoyoCredSdc.DocData theDocData = (SorKetRenHoyoCredSdc.DocData)JSON.deserialize(theSdc.Data__c, SorKetRenHoyoCredSdc.DocData.class);

		Opportunity theOpp = 
			(Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT Id, SubPhase__c, SoryoKetteiRenrakuHoho__c FROM Opportunity WHERE ShodanBango__c = : theDocData.shodanBango
				]
			);

		if( theData.deliveryStatus ==  deliveryStatus_DeliveryFailed){
			if(theOpp.SoryoKetteiRenrakuHoho__c != '電話'){
				UPDATE new Opportunity(Id = theOpp.Id, SoryoKetteiRenrakuHoho__c = '電話');
			}
		}

		if( theData.deliveryStatus ==  deliveryStatus_Delivered){
			if(theOpp.SubPhase__c == '僧侶決定連絡'){
				UPDATE new Opportunity(Id = theOpp.Id, SubPhase__c = 'クレジットカード決済待ち');
			}
		}

		UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
	}
}