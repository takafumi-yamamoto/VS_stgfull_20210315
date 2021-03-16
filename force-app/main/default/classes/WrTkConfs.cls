public class WrTkConfs {
    public class Config {
        public Boolean is_WrTkSdKasoChokusoTokubetsuKakaku;
    }

    @TestVisible
    private static WrTksConfig__mdt mMetaDataCache = null;

    @TestVisible
    private static Environments.IEnv mEnv = new Environments.Env();

    private static WrTksConfig__mdt getMetaData(){
        if(mMetaDataCache == null ){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache = 
            [
                SELECT Id , DeveloperName,
                is_WrTkSdKasoChokusoTokubetsuKakaku__c 
                FROM WrTksConfig__mdt
                WHERE DeveloperName = :theKeyName
            ].get(0);
        }
        return mMetaDataCache;
    }

    public static Config getConfig(){
        WrTksConfig__mdt theMetaData = getMetaData();
        Config theConfig = new Config();
        theConfig.is_WrTkSdKasoChokusoTokubetsuKakaku = theMetaData.is_WrTkSdKasoChokusoTokubetsuKakaku__c;
        return theConfig;
    }

}