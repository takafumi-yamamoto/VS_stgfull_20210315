public class d3wConf {

    private static IProvider IProvider_instance;
    public static IProvider get_IProvider_instance(){
        if( IProvider_instance == null ) IProvider_instance = new Provider();
        return IProvider_instance;
    }

    private static d3wConfig__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static d3wConfig__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    api_base_url__c,
                    tenant_id__c,
                    UID__c,
                    UPW__c
                    FROM d3wConfig__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }

    public class Config{
        public String api_base_url;
        public String tenant_id;
        public String UID;
        public String UPW;
    }

    public interface IProvider{
        Config getConfig();
    }
    public class Provider implements IProvider{
        public Config getConfig(){
            d3wConfig__mdt theMetaData = getMetaData();
            Config theConfig = new Config();
            theConfig.api_base_url = theMetaData.api_base_url__c;
            theConfig.tenant_id = theMetaData.tenant_id__c;
            theConfig.UID = theMetaData.UID__c;
            theConfig.UPW = theMetaData.UPW__c;
            return theConfig;
        }
    }
}