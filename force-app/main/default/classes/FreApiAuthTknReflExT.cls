@isTest
public class FreApiAuthTknReflExT {

    public class FreApiAuthTknRefl_IClinet_Stub implements FreApiAuthTknRefl.IClient{
        public FreApiAuthTknRefl.Result sendRequest(String pEndPoint, FreApiAuthTknRefl.Request pReq){
            return null;
        }
    }
    @isTest public static void get_IClient_instance(){
        Test.startTest();
        FreApiAuthTknReflEx.get_IClient_instance();
        Test.stopTest();
    }
    @isTest public static void Client_getNewAccessToken(){
        Test.startTest();
        new FreApiAuthTknReflEx.Client(
            new FreApiConfs.Config(),
            new FreApiAuthTknRefl_IClinet_Stub()
        )
        .getNewAccessToken('reflesh_token');
        Test.stopTest();
    }
}