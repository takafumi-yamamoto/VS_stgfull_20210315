public class PtWebApi_Configs {
    private static PtWebConfig__mdt f_CachedConfig = null;

	public static PtWebConfig__mdt getConfig(){
        if(f_CachedConfig == null){
            String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
            f_CachedConfig =
                [
                    select id, DeveloperName, 
                    BaseEndPoint__c, client_id__c, client_secret__c, code__c, grant_type__c, redirect_uri__c
                    from PtWebConfig__mdt
                    where DeveloperName = :theKeyName
                ]
                .get(0);
        }
        return f_CachedConfig;
	}
}