public class FreAuthTkn{

    private static ITokenProvider m_ITokenProvider_instance = null;
    public static ITokenProvider get_ITokenProvider_instance(){
        if( m_ITokenProvider_instance != null ) return m_ITokenProvider_instance;
        return new TokenProvider(
            new Environments.Env()
        );
    }

    public class TokenInfo{
        public String access_token;
        public Decimal created_at;
        public Decimal expires_in;
        public String refresh_token;
        public String token_type;
    }

    public interface ITokenProvider {
        TokenInfo getTokenInfo();
    }
    private class TokenProvider implements ITokenProvider{
        private FreApiAuthTkn__c mFreApiAuthTknCache = null;

        private Environments.IEnv mEnv;

        public TokenProvider(Environments.IEnv pEnv){
            this.mEnv = pEnv;
        }
        public TokenInfo getTokenInfo(){
            FreApiAuthTkn__c theFreApiAuthTkn = this.getFreApiAuthTkn();
            TokenInfo theTokenInfo = new TokenInfo();
            theTokenInfo.access_token = theFreApiAuthTkn.access_token__c;
            theTokenInfo.created_at = theFreApiAuthTkn.created_at__c;
            theTokenInfo.expires_in = theFreApiAuthTkn.expires_in__c;
            theTokenInfo.refresh_token = theFreApiAuthTkn.refresh_token__c;
            theTokenInfo.token_type = theFreApiAuthTkn.token_type__c;
            return theTokenInfo;
        }

        private FreApiAuthTkn__c getFreApiAuthTkn(){
            if( this.mFreApiAuthTknCache == null ){
                String theKeyName = mEnv.isSandbox() ? 'dev' : 'prod';

                FreApiAuthTkn__c the_token_record = (FreApiAuthTkn__c)SobjectsExtension.firstOrNull(
                    [
                        SELECT Id, Env__c,
                        access_token__c,
                        created_at__c,
                        expires_in__c, 
                        refresh_token__c,
                        token_type__c
                        FROM FreApiAuthTkn__c
                        WHERE Env__c = :theKeyName
                        LIMIT 10
                    ]
                );

                if( the_token_record == null && Test.isRunningTest() ){
                    the_token_record = new FreApiAuthTkn__c(Env__c = theKeyName);
                }

                mFreApiAuthTknCache = the_token_record;
            }
            return mFreApiAuthTknCache;
        }
    }

}