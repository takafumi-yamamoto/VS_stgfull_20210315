public class FaximoConfs {

    public class Config{
        public String userId;
        public String password;
        public String api_base_url;
        public String faximoProcesskey;
    }

    private static FaximoConf__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static FaximoConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, 
                    DeveloperName,
                    userid__c,
                    password__c,
                    api_base_url__c
                    FROM FaximoConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(String pFaximoProcesskey){
        FaximoConf__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.userId = theMetaData.userid__c;
        theConfig.password = theMetaData.password__c;
        theConfig.api_base_url = theMetaData.api_base_url__c;
        theConfig.faximoProcesskey = pFaximoProcesskey;
        return theConfig;
    }
}