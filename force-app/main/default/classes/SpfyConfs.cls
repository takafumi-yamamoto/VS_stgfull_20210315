public class SpfyConfs {

    public class Config{
        public String basic_auth_username;
        public String basic_auth_password;
        public String api_base_url;
        public String hmac_secret;
        public String ShohinBango_For_OppLineItem;
        public Boolean stopSyncBatch;
        public Boolean hmac_enabled;
    }

    private static SpfyConf__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static SpfyConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    basic_auth_username__c,
                    basic_auth_password__c,
                    api_base_url__c,
                    hmac_secret__c,
                    ShohinBango_For_OppLineItem__c,
                    stopSyncBatch__c,
                    hmac_enabled__c
                    FROM SpfyConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(){
        SpfyConf__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.basic_auth_username = theMetaData.basic_auth_username__c;
        theConfig.basic_auth_password = theMetaData.basic_auth_password__c;
        theConfig.api_base_url = theMetaData.api_base_url__c;
        theConfig.hmac_secret = theMetaData.hmac_secret__c;
        theConfig.ShohinBango_For_OppLineItem = theMetaData.ShohinBango_For_OppLineItem__c;
        theConfig.stopSyncBatch = theMetaData.stopSyncBatch__c;
        theConfig.hmac_enabled = theMetaData.hmac_enabled__c;

        //2623989678240 , 1018

        //2623870632096 , 1016
        // theConfig.basic_auth_username = 'f94cb3d17c9f334008e5a8380155cd69';
        // theConfig.basic_auth_password = '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';
        // theConfig.api_base_url = 'https://prod-yoriso-com.myshopify.com';
        return theConfig;
    }

}