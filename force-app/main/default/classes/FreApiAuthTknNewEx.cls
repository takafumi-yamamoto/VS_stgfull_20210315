public class FreApiAuthTknNewEx {
    public static IClient get_IClient_instance(){
        return new Client(
            FreApiConfs.getConfig(),
            FreApiAuthTknNew.get_IClient_instance()
        );
    }

    public interface IClient {
        FreApiAuthTknNew.Result getNewAccessToken(String pAuthCode);
    }
    public class Client implements IClient{
        private FreApiConfs.Config mConfig;
        private FreApiAuthTknNew.IClient mApiClient;

        public Client(FreApiConfs.Config pConfig, FreApiAuthTknNew.IClient pApiClient){
            this.mConfig = pConfig;
            this.mApiClient = pApiClient;
        }
        public FreApiAuthTknNew.Result getNewAccessToken(String pAuthCode){
            FreApiAuthTknNew.Request theReq = new FreApiAuthTknNew.Request();
            theReq.grant_type = this.mConfig.grant_type;
            theReq.client_id = this.mConfig.client_id;
            theReq.client_secret = this.mConfig.client_secret;
            theReq.code = pAuthCode;
            theReq.redirect_uri = this.mConfig.redirect_uri;
            return this.mApiClient.sendRequest(this.mConfig.token_endPoint, theReq);
        }
    }
}