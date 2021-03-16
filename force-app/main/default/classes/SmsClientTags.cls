public class SmsClientTags {
	public static String genClientTag(String pMsgType){
		String theGuid = GuidUtil.NewGuid();
		return pMsgType + ',' + theGuid;
	}
}