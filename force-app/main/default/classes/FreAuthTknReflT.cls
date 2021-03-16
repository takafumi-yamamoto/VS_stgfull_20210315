@isTest
public class FreAuthTknReflT {

    public class FreApiAuthTknReflEx_IClient_Stub implements FreApiAuthTknReflEx.IClient{
        public FreApiAuthTknRefl.Result getNewAccessToken(String pRefleshToken){
            FreApiAuthTknRefl.Result a_result = new FreApiAuthTknRefl.Result();
            a_result.isSuccess = true;
            FreApiAuthTknRefl.Response a_response = new FreApiAuthTknRefl.Response();
            a_result.response = a_response;
            return a_result; 
        }
    }
    public class FreAuthTkn_ITokenProvider_Stub implements FreAuthTkn.ITokenProvider{
        public FreAuthTkn.TokenInfo getTokenInfo(){
            return new FreAuthTkn.TokenInfo();
        }
    }
    @isTest public static void TokenReflesher_refleshToken(){
        Test.startTest();
        new FreAuthTknRefl.TokenReflesher(
            new Environments.Env(),
            new FreApiAuthTknReflEx_IClient_Stub(),
            new FreAuthTkn_ITokenProvider_Stub()
        )
        .refleshToken();
        Test.stopTest();
    }
}