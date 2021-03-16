@isTest
public class AcrtDrTackRegisterT {
    @isTest public static void Register_InsertEntry(){

        AcrtSmsSender.Result theResult = new AcrtSmsSender.Result();
        theResult.delivery_id = '_';
        AcrtSmsSender.Req theReq = new AcrtSmsSender.Req();
        theResult.req = theReq;

        Test.startTest();
        new AcrtDrTackRegister.Register().InsertEntry(theResult);
        Test.stopTest();
    }
}