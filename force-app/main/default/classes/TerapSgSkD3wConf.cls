public class TerapSgSkD3wConf {

    @TestVisible
    private static Environments.IEnv mEnv = new Environments.Env();

    private static IProvider IProvider_instance;
    public static IProvider get_IProvider_instance(){
        if( IProvider_instance == null ) IProvider_instance = new Provider();
        return IProvider_instance;
    }

    private static TerapSgSkD3wConfig__mdt mMetaDataCache = null;
    
    private static TerapSgSkD3wConfig__mdt getMetaData(){
        if(mMetaDataCache == null){
            String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';
            mMetaDataCache =
                [
                    SELECT Id, DeveloperName,
                    d3w_work_name__c
                    FROM TerapSgSkD3wConfig__mdt
                    WHERE DeveloperName = :theKeyName
                ]
                .get(0); 	
        }
        return mMetaDataCache;
    }

    public class Config{
        public String d3w_work_name;
    }

    public interface IProvider{
        Config getConfig();
    }
    public class Provider implements IProvider{
        public Config getConfig(){
            TerapSgSkD3wConfig__mdt theMetaData = getMetaData();
            Config theConfig = new Config();
            theConfig.d3w_work_name = theMetaData.d3w_work_name__c;
            return theConfig;
        }
    }
}