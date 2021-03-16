public class OpfcConfs {
    public class Config{
        public String base_url;
        public String opro_cid;
        public String opro_uid;
        public String opro_upw;
    }

    private static OpfcConfs__mdt mMetaDataCache = null;
    
    @TestVisible
    private static Environments.IEnv mEnv = new Environments.Env();

    private static OpfcConfs__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    base_url__c,
                    opro_cid__c,
                    opro_uid__c,
                    opro_upw__c
                    FROM OpfcConfs__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(){
        OpfcConfs__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.base_url = theMetaData.base_url__c;
        theConfig.opro_cid = theMetaData.opro_cid__c;
        theConfig.opro_uid = theMetaData.opro_uid__c;
        theConfig.opro_upw = theMetaData.opro_upw__c;
        return theConfig;
    }
}