public class FreApiAuthTknReflEx {

    public static IClient get_IClient_instance(){
        return new Client(
            FreApiConfs.getConfig(),
            FreApiAuthTknRefl.get_IClient_Instance()
        );
    } 

    public interface IClient {
        FreApiAuthTknRefl.Result getNewAccessToken(String pRefleshToken);
    }
    public class Client implements IClient{
        private FreApiConfs.Config mConfig;
        private FreApiAuthTknRefl.IClient mApiClient;

        public Client(FreApiConfs.Config pConfig, FreApiAuthTknRefl.IClient pApiClient){
            this.mConfig = pConfig;
            this.mApiClient = pApiClient;
        }
        public FreApiAuthTknRefl.Result getNewAccessToken(String pRefleshToken){
            FreApiAuthTknRefl.Request theReq = new FreApiAuthTknRefl.Request();
            theReq.grant_type = 'refresh_token';
            theReq.client_id = this.mConfig.client_id;
            theReq.client_secret = this.mConfig.client_secret;
            theReq.refresh_token = pRefleshToken;
            theReq.redirect_uri = this.mConfig.redirect_uri;
            return this.mApiClient.sendRequest(this.mConfig.token_endPoint, theReq);
        }
    }
}