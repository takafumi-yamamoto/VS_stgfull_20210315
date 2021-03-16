public class AcrtSmsSendErrHistLogr{

	public static IErrHistoryLogr get_IErrHistoryLogr_instance(){
		return new ErrHistoryLogr();
	}

	public interface IErrHistoryLogr{
		void updateLogSmsHistory(String p_AcrtDrTack_Id);
	}

	public class ErrHistoryLogr implements IErrHistoryLogr{

		public void updateLogSmsHistory(String p_AcrtDrTack_Id){
			AcrtDrTack__c theAcrtDrTack = (AcrtDrTack__c)SobjectsExtension.firstOrNull(
				[
					SELECT id, delivery_id__c 
					FROM AcrtDrTack__c 
					WHERE Id = :p_AcrtDrTack_Id 
					LIMIT 1
				]
			);
			if( theAcrtDrTack.delivery_id__c != null){
				String the_Status_Id_Of_SosinErr = '3';
				SMSHistory__c theSMSHistory = (SMSHistory__c)SobjectsExtension.firstOrNull(
					[
					SELECT id, MessageId__c, StatusId__c 
					FROM SMSHistory__c 
					WHERE MessageId__c = :theAcrtDrTack.delivery_id__c 
					AND Provider__c = 'accrete'
					LIMIT 1
					]
				);
				if( theSMSHistory != null ){
					theSMSHistory.StatusId__c = the_Status_Id_Of_SosinErr;
					update theSMSHistory;
				}
			}
		}
	}

}