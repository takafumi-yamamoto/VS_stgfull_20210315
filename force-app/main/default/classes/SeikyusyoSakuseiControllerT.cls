@isTest
public class SeikyusyoSakuseiControllerT {
    
    @isTest public static void doSave(){
        SeikyusyoSakuseiController.SeikyuRequest a_SeikyuRequest = new SeikyusyoSakuseiController.SeikyuRequest();

        SeikyusyoSakuseiController.SeikyuLine a_SeikyuLine = new SeikyusyoSakuseiController.SeikyuLine();
        a_SeikyuRequest.seikyuLines = new List<SeikyusyoSakuseiController.SeikyuLine>();
        a_SeikyuRequest.seikyuLines.add(a_SeikyuLine);

        String a_SeikyuRequest_json = JSON.serialize(a_SeikyuRequest);

        Test.startTest();
        SeikyusyoSakuseiController.doSave(a_SeikyuRequest_json);
        Test.stopTest();
    }
}