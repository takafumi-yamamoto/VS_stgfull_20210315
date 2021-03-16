public class LineMsgConfig {
    private static LineMsgConfig__mdt f_CachedConfig = null;

    private LineMsgConfig__mdt loadConfig(){
    	if(f_CachedConfig != null) return f_CachedConfig;

    	String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
     	f_CachedConfig =
            [
                select id, DeveloperName, 
                CanSend__c, TorihikiSakiBangoForDebug__c
                from LineMsgConfig__mdt
                where DeveloperName = :theKeyName
            ]
            .get(0); 	
        return f_CachedConfig;
    }

    public Boolean canSend(String pTorihikisakiBango){
        this.loadConfig();
        if(Test.isRunningTest()) return true;
        if(f_CachedConfig.CanSend__c == 'Allowed') return true;
        if(f_CachedConfig.CanSend__c == 'OnlyTorihikiSakiBangoForDebug'){
            if( String.isBlank(f_CachedConfig.TorihikiSakiBangoForDebug__c ) ) return false;
            if( f_CachedConfig.TorihikiSakiBangoForDebug__c == pTorihikisakiBango ) return true;
            return false;
        }
        return false;
    }
}