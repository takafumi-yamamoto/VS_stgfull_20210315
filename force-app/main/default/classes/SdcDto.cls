public class SdcDto {
	public Sdc__c sdc;
	public List<SdcMsg__c> sdcMsgs = new List<SdcMsg__c>();

	public static String InsertSdc(SdcDto pDto){
		INSERT pDto.sdc;
		
		for(SdcMsg__c aMsg : pDto.sdcMsgs){
			aMsg.SdcRef__c = pDto.sdc.Id;
		}
		INSERT pDto.sdcMsgs;

		return pDto.sdc.Id;
	}
}