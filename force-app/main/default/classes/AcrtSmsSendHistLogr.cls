public class AcrtSmsSendHistLogr implements IAcrtSmsSendHistLogr{
	public static IAcrtSmsSendHistLogr get_IAcrtSmsSendHistLogr_instance(){
		return new AcrtSmsSendHistLogr();
	}

	public interface IAcrtSmsSendHistLogr{
		void logSmsHistory(AcrtSmsSender.Result pAcrtSmsSenderResult);
	}

	public void logSmsHistory(AcrtSmsSender.Result pAcrtSmsSenderResult){

		String the_Status_Id_Of_Sosin = '2';
		INSERT new SMSHistory__c(
			RecordTypeId = Schema.SObjectType.SMSHistory__c.getRecordTypeInfosByDeveloperName().get('DLR').getRecordTypeId(),
			ClientTag__c = 'accrete_' + pAcrtSmsSenderResult.delivery_id,
			MessageText__c = 
			pAcrtSmsSenderResult.req.text_long.length() > 100
			? pAcrtSmsSenderResult.req.text_long.left(100) + '\r\n...'
			: pAcrtSmsSenderResult.req.text_long,
			LongText__c = pAcrtSmsSenderResult.req.text_long.left(1500),
			MessageId__c = pAcrtSmsSenderResult.delivery_id,
			PhoneNumber__c = pAcrtSmsSenderResult.req.telno,
			Pkey__c = GuidUtil.NewGuid(),
			Account__c = pAcrtSmsSenderResult.req.account_id,
			Opportunity__c = pAcrtSmsSenderResult.req.opp_id,
			DateTime__c = pAcrtSmsSenderResult.send_dt.format('yyyy/MM/dd+HH:mm:ss'),
			StatusId__c = the_Status_Id_Of_Sosin,
			Provider__c = 'accrete'
			);
	}

}