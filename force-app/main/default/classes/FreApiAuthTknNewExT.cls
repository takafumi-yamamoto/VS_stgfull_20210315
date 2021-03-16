@isTest
public class FreApiAuthTknNewExT {

    public class FreApiAuthTknNew_IClient_Stub implements FreApiAuthTknNew.IClient{
        public FreApiAuthTknNew.Result sendRequest(String pEndPoint, FreApiAuthTknNew.Request pReq){
            return null;
        }
    }

    @isTest public static void get_IClient_instance(){
        Test.startTest();
        FreApiAuthTknNewEx.get_IClient_instance();
        Test.stopTest();
    }
    @isTest public static void Client_getNewAccessToken() {
        Test.startTest();
        new FreApiAuthTknNewEx.Client(
            new FreApiConfs.Config(),
            new FreApiAuthTknNew_IClient_Stub()
        )
        .getNewAccessToken(null);
        Test.stopTest();
    }
}