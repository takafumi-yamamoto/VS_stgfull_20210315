public class NPkakebaraiConfig {
	
	public static NPkakebaraiConfig__mdt getConfig(){
        String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
        NPkakebaraiConfig__mdt f_CachedConfig =
            [
                select id, BaseEndPoint__c, SP_CODE__c, TERMINAL_ID__c, BAT_SIZE__c
                from NPkakebaraiConfig__mdt
                where DeveloperName = :theKeyName
            ]
            .get(0);
        return f_CachedConfig;
	}
}