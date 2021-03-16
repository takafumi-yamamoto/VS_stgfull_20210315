public class FreAuthTknNew {

    public static ITokenInitializer get_ITokenInitializer_instance(){
        return new TokenInitializer(
            new Environments.Env(),
            FreApiAuthTknNewEx.get_IClient_instance()
        );
    }

    public interface ITokenInitializer{
        void initToken(String pAuthCode);
    }

    public class TokenInitializer implements ITokenInitializer{
        private Environments.IEnv mEnv;
        private FreApiAuthTknNewEx.IClient mAuthTknNewExClient;
        public TokenInitializer(Environments.IEnv pEnv, FreApiAuthTknNewEx.IClient pAuthTknNewExClient){
            this.mEnv = pEnv;
            this.mAuthTknNewExClient = pAuthTknNewExClient;
        }
        public void initToken(String pAuthCode){
            FreApiAuthTknNew.Result theResult = this.mAuthTknNewExClient.getNewAccessToken(pAuthCode);
            if(!theResult.isSuccess) throw new Exceptions.AnException('Failed to get an access token');
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