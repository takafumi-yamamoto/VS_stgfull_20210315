public class TcmsTaioRkImpConf {
    public class Config{
        public Decimal batch_limit = 100;
    }
    private static TcmsTaioRkImpConf__mdt mMetaDataCache = null;

    @TestVisible
    private static Environments.IEnv mEnv = new Environments.Env();

    private static TcmsTaioRkImpConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    batch_limit__c
                    FROM TcmsTaioRkImpConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }
    public static Config getConfig(){
        TcmsTaioRkImpConf__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.batch_limit = theMetaData.batch_limit__c;
        return theConfig;
    }
}