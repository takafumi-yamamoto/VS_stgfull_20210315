public class SlackApiPostMsgConf {

    private static IProvider IProvider_instance;
    public static IProvider get_IProvider_instance(){
        if( IProvider_instance == null ) IProvider_instance = new Provider();
        return IProvider_instance;
    }

    private static SlackApiPostMsgConf__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static SlackApiPostMsgConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    endpoint__c
                    FROM SlackApiPostMsgConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }

    public class Config{
        public String endpoint;
    }

    public interface IProvider{
        Config getConfig();
    }
    public class Provider implements IProvider{
        public Config getConfig(){
            SlackApiPostMsgConf__mdt theMetaData = getMetaData();
            Config theConfig = new Config();
            theConfig.endpoint = theMetaData.endpoint__c;
            return theConfig;
        }
    }
    
}