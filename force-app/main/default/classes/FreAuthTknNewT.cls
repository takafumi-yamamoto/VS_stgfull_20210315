@isTest
public  class FreAuthTknNewT {

    public class FreApiAuthTknNewEx_IClient_Stub implements FreApiAuthTknNewEx.IClient{
        public FreApiAuthTknNew.Result getNewAccessToken(String pAuthCode){
            FreApiAuthTknNew.Result a_result = new FreApiAuthTknNew.Result();
            a_result.isSuccess = true;
            FreApiAuthTknNew.Response a_response = new FreApiAuthTknNew.Response();
            a_result.response = a_response;
            return a_result;
        }
    }
    @isTest public static void TokenInitializer_initToken(){
        Test.startTest();
        new FreAuthTknNew.TokenInitializer(
            new Environments.Env(),
            new FreApiAuthTknNewEx_IClient_Stub()
        )
        .initToken('authcode');
        Test.stopTest();
    }
}