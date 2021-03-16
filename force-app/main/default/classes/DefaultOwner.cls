public class DefaultOwner {
	private static DefaultOwner__mdt f_cachedData = null;

    private static DefaultOwner__mdt loadConfig(){
    	if(f_cachedData != null) return f_cachedData;

		String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';

        f_cachedData =
            [
                SELECT id, OwnerId__c
                FROM DefaultOwner__mdt
                WHERE DeveloperName = :theKeyName
            ]
            .get(0);

        return f_cachedData;
    }

    public static String getOwnerId(){
        return loadConfig().OwnerId__c;
    }
}