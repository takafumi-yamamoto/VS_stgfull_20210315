public class GoogleMapApiConfig {

	public static GoogleMapApiConfig__mdt getConfig(){
        String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
        GoogleMapApiConfig__mdt f_CachedConfig =
            [
                select Id, Endpoint__c, ApiKey__c
                from GoogleMapApiConfig__mdt
                where DeveloperName = :theKeyName
            ]
            .get(0);
        return f_CachedConfig;
	}
}