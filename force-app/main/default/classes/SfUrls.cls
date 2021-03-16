public class SfUrls {

	public static String getLexRecPageUrlStr(Id pObjectId){
		String theObjectName = pObjectId.getSObjectType().getDescribe().getName();
		String theUrl = URL.getOrgDomainUrl().toExternalForm();
		theUrl += '/lightning/r/';
		theUrl += theObjectName;
		theUrl += '/';
		theUrl += pObjectId;
		theUrl += '/view';
		return theUrl;
	}
}