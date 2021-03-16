public class JcshConf {

    private static IProvider IProvider_instance;
    public static IProvider get_IProvider_instance(){
        if( IProvider_instance == null ) IProvider_instance = new Provider();
        return IProvider_instance;
    }

    private static JcshConf__mdt mMetaDataCache = null;
    private static Environments.IEnv mEnv = new Environments.Env();
    private static JcshConf__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    slack_user_name__c,
                    slack_channel__c
                    FROM JcshConf__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }

    public class Config{
        public String slack_user_name;
        public String slack_channel;
    }

    public interface IProvider{
        Config getConfig();
    }
    public class Provider implements IProvider{
        public Config getConfig(){
            JcshConf__mdt theMetaData = getMetaData();
            Config theConfig = new Config();
            theConfig.slack_user_name = theMetaData.slack_user_name__c;
            theConfig.slack_channel = theMetaData.slack_channel__c;
            return theConfig;
        }
    }
}