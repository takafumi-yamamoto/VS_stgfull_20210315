public class LwsnConfig {
    private static LwsnConfig__mdt f_CachedConfig = null;
    private static String mAllianceKeiyakuId = null;

    private LwsnConfig__mdt loadConfig(){
    	if(f_CachedConfig != null) return f_CachedConfig;

    	String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
     	f_CachedConfig =
            [
                SELECT id, DeveloperName, AllianceKeiyakuBango__c
                FROM LwsnConfig__mdt
                WHERE DeveloperName = :theKeyName
            ]
            .get(0); 	
        
        Keiyaku__c theKeiyaku = (Keiyaku__c)SobjectsExtension.firstOrNull(
            [SELECT Id,KeiyakuBango__c FROM Keiyaku__c WHERE KeiyakuBango__c = :f_CachedConfig.AllianceKeiyakuBango__c LIMIT 1]
        );
        mAllianceKeiyakuId = theKeiyaku == null ? null : theKeiyaku.Id;
        
        return f_CachedConfig;
    }

	public String getAllianceKeiyakuBango(){ return this.loadConfig().AllianceKeiyakuBango__c; }

    public String getAllianceKeiyakuId(){ this.loadConfig(); return mAllianceKeiyakuId; }
}