public class FreAuthTknRefl {

    public static ITokenReflesher get_ITokenReflesher_instance(){
        return new TokenReflesher(
            new Environments.Env(),
            FreApiAuthTknReflEx.get_IClient_instance(),
            FreAuthTkn.get_ITokenProvider_instance()
        );
    }
    public interface ITokenReflesher {
        void refleshToken();
    }
    public class TokenReflesher implements ITokenReflesher{
        private Environments.IEnv mEnv;
        private FreApiAuthTknReflEx.IClient mAuthTknReflExClient;
        private FreAuthTkn.ITokenProvider mITokenProvider;
        public TokenReflesher(Environments.IEnv pEnv, FreApiAuthTknReflEx.IClient pAuthTknReflExClient, FreAuthTkn.ITokenProvider pITokenProvider){
            this.mEnv = pEnv;
            this.mAuthTknReflExClient = pAuthTknReflExClient;
            this.mITokenProvider = pITokenProvider;
        }
        public void refleshToken(){
            FreAuthTkn.TokenInfo theCurToken = this.mITokenProvider.getTokenInfo();

            FreApiAuthTknRefl.Result theResult = this.mAuthTknReflExClient.getNewAccessToken(theCurToken.refresh_token);
            if(!theResult.isSuccess) throw new Exceptions.AnException('Failed to reflesh an access token');
            String theEnv = mEnv.isSandbox() ? 'dev' : 'prod';
            UPSERT New FreApiAuthTkn__c(
                Env__c = theEnv,
                access_token__c = theResult.response.access_token,
                created_at__c = theResult.response.created_at,
                expires_in__c = theResult.response.expires_in,
                refresh_token__c = theResult.response.refresh_token,
                token_type__c = theResult.response.token_type
            ) Env__c;
        }
    }

}