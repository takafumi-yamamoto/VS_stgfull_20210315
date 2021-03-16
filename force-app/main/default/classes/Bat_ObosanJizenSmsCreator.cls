public class Bat_ObosanJizenSmsCreator  {
	private static final String SMS_FROMAT_TYPE = 'ObosanJizenSms';

	/*
	FormatType: ObosanJizenSms
	TimeSpace: yyyyMMddHHmmss
	再起連番 : couner
	下4桁 : PhoneNumberの4桁
	taskId: taskId
	*/
	Public static String BuildClientTag(Integer sequence, String phoneNumber, String taskId){
		String tmpPhoneNumber = String.isBlank(phoneNumber) ? '' : phoneNumber.right(4);
	    return SMS_FROMAT_TYPE + ',' + Datetime.now().format('yyyyMMddHHmmss') + ',' + sequence + ',' + tmpPhoneNumber + ',' + taskId;
	}	
}