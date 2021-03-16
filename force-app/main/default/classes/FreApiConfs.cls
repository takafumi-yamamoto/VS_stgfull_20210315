public class FreApiConfs {

    public class Config{
        public String token_endpoint;
        public String grant_type;
        public String client_id;
        public String client_secret;
        public String redirect_uri;
        public String api_base_url;
        public Integer company_id;
    }

    private static FreApiConf__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static FreApiConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    token_endpoint__c,
                    grant_type__c,
                    client_id__c, 
                    client_secret__c,
                    redirect_uri__c,
                    api_base_url__c,
                    company_id__c
                    FROM FreApiConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(){
        FreApiConf__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.token_endpoint = theMetaData.token_endpoint__c;
        theConfig.grant_type = theMetaData.grant_type__c;
        theConfig.client_id = theMetaData.client_id__c;
        theConfig.client_secret = theMetaData.client_secret__c;
        theConfig.redirect_uri = theMetaData.redirect_uri__c;
        theConfig.api_base_url = theMetaData.api_base_url__c;
        theConfig.company_id = (Integer)theMetaData.company_id__c;
        return theConfig;
    }

}