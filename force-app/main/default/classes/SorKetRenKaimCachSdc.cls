public class SorKetRenKaimCachSdc implements IHdlSdcEvt {

	public static String m_docType = 'SorKetRenKaimCachSdc';

    private static SdcTemplates.Template m_Template = new SdcTemplates().getTemplate(m_docType);

	public class CreateSdcReqArgs{
		public String to_phoneNo;
		public String shodanBango;
		public String jiinName;
		public String jiinNameKana;
		public String shuha;
		public Decimal hoyoryo;
	}
	public class DocData{
		public String shodanBango;
	}
	public static SdcDto createSdc(CreateSdcReqArgs pArgs){

        if( String.isBlank(pArgs.to_phoneNo) ) throw new RequestInvalidException();
        if( String.isBlank(pArgs.shodanBango) ) throw new RequestInvalidException();
        if( String.isBlank(pArgs.jiinName) ) throw new RequestInvalidException();
        if( String.isBlank(pArgs.shuha) ) throw new RequestInvalidException();
        if( pArgs.hoyoryo == 0 || pArgs.hoyoryo == null ) throw new RequestInvalidException();

		DocData theDocData = new DocData();
		theDocData.shodanBango = pArgs.shodanBango;

		Sdc__c theSdc =
			new Sdc__c(
				smsDocType__c = m_docType,
				phoneNo__c = pArgs.to_phoneNo,
				SendOrderControll__c = 'DlrChian',
				DeliveryStatus__c = 'Created',
				data__c = JSON.serialize( theDocData )
			);

		List<SdcMsg__c> theSdcMsgs = new List<SdcMsg__c>();

		List<String> theMsgs = m_Template.getBody()
			.replace('{窓口僧侶寺院名}', pArgs.jiinName)
			.replace('{窓口僧侶寺院名カナ}', String.isBlank(pArgs.jiinNameKana) ? '' : pArgs.jiinNameKana )
			.replace('{窓口僧侶宗派}', pArgs.shuha)
			.replace('{法要料}', pArgs.hoyoryo.format())
			.split('\\{SPLIT\\}');

		Integer theLineNo = 0;
		for(String aMsg : theMsgs){
			theLineNo ++;
			String theClientTag = SmsClientTags.genClientTag(m_docType);
			SdcMsg__c theMsg =
				new SdcMsg__c(
					ClientTag__c = theClientTag,
					DeliveryStatus__c = 'Created',
					LineNo__c = theLineNo,
					MsgTxt__c = aMsg
				);
			if(theLineNo > 1){
				theMsg.PrevMsgClientTag__c = theSdcMsgs.get( theSdcMsgs.size() - 1 ).ClientTag__c;
			}
			theSdcMsgs.add(theMsg);
		}

		SdcDto theSdcDto = new SdcDto();
		theSdcDto.sdc = theSdc;
		theSdcDto.sdcMsgs = theSdcMsgs;
		return theSdcDto;
	}
	public void onSdcEvtRelayed(Qms__c pQms, SdcEvtQms.Data pEvtData){
		String theDeliveryStatus;
		Sdc__c theSdc =
			(Sdc__c)SobjectsExtension.firstOrNull(
				[SELECT Id, smsDocType__c, data__c FROM Sdc__c WHERE Id = : pEvtData.sdcId]
			);
		SorKetRenKaimCachSdc.DocData theDocData = (SorKetRenKaimCachSdc.DocData)JSON.deserialize(theSdc.Data__c, SorKetRenKaimCachSdc.DocData.class);

		Opportunity theOpp =
			(Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT Id, SubPhase__c, SoryoKetteiRenrakuHoho__c FROM Opportunity WHERE ShodanBango__c = : theDocData.shodanBango
				]
			);

		if(pEvtData.deliveryStatus == SdcEvtQms.deliveryStatus_DeliveryFailed) {
			if(theOpp.SoryoKetteiRenrakuHoho__c != '電話'){
				UPDATE new Opportunity(Id = theOpp.Id, SoryoKetteiRenrakuHoho__c = '電話');
			}
		}

		if(pEvtData.deliveryStatus == SdcEvtQms.deliveryStatus_Delivered) {
			if(theOpp.SubPhase__c == '僧侶決定連絡'){
				try{
					UPDATE new Opportunity(Id = theOpp.Id, SubPhase__c = '依頼書・手配報告書作成');
				} catch (Exception ex){
					SorKetRenErrMail.CreateMailArg theArg = new SorKetRenErrMail.CreateMailArg();
	                theArg.ShodanId = theOpp.Id;
					theArg.ShodanBango = theDocData.shodanBango;
	                theArg.errorMessage = '僧侶決定連絡は完了しましたが、フェーズを更新中にエラーが発生しました。';
	                INSERT new SorKetRenErrMail().createMail(theArg);
				}
			}
		}
	}
	public class RequestInvalidException extends Exception{}
}