public class AcrtSmsConf {
    public class Config{
        public String base_url;
        public String accrete_account_id;
        public String request_id;
        public String request_pass;
    }

    private static AcrtSmsConf__mdt mMetaDataCache = null;
    
    @TestVisible
    private static Environments.IEnv mEnv = new Environments.Env();

    private static AcrtSmsConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    base_url__c,
                    accrete_account_id__c,
                    request_id__c,
                    request_pass__c
                    FROM AcrtSmsConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(){
        AcrtSmsConf__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.base_url = theMetaData.base_url__c;
        theConfig.accrete_account_id = theMetaData.accrete_account_id__c;
        theConfig.request_id = theMetaData.request_id__c;
        theConfig.request_pass = theMetaData.request_pass__c;
        return theConfig;
    }
}