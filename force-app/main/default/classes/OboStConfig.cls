public class OboStConfig {
    private static ObStConfig__mdt f_CachedConfig = null;

    private ObStConfig__mdt loadConfig(){
    	if(f_CachedConfig != null) return f_CachedConfig;

    	String theKeyName = Environments.isSandbox() ? 'dev' : 'prod';
     	f_CachedConfig =
            [
                select id, DeveloperName, 
                BaseEndPoint__c, client_id__c, client_secret__c, grant_type__c,
                ServiceRanksToBeInactivated__c
                from ObStConfig__mdt
                where DeveloperName = :theKeyName
            ]
            .get(0); 	
        return f_CachedConfig;
    }

    public String getBaseEndPoint(){ return this.loadConfig().BaseEndPoint__c; }
    public String getAuthGrantType(){ return this.loadConfig().grant_type__c; }
    public String getAuthClientId(){ return this.loadConfig().client_id__c; }
    public String getAuthClientSecret(){ return this.loadConfig().client_secret__c; }
    public  Boolean isServiceRankToBeInactivated(String pServiceRank){
        if( String.isBlank(pServiceRank) ) return false;

        String theTextExpression = this.loadConfig().ServiceRanksToBeInactivated__c;
        if( String.isBlank(theTextExpression) ) return false;

        Set<String> theServiceRankToBeInactivated = new Set<String>();
        for(String aValue : theTextExpression.split(',') ){
            theServiceRankToBeInactivated.add( aValue.trim() );
        }
        if( theServiceRankToBeInactivated.contains(pServiceRank) ) return true;
        return false;
    }


}