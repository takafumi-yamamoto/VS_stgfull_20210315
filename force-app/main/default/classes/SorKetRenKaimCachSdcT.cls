@isTest
private class SorKetRenKaimCachSdcT {

    @testSetup
    static void setup() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
    }

    @isTest
    static void myUnitTest() {
        SorKetRenKaimCachSdc.CreateSdcReqArgs theArg = new SorKetRenKaimCachSdc.CreateSdcReqArgs();
        theArg.jiinName = 'テスト寺院名';
        theArg.jiinNameKana = 'テストジインメイカナ';
        theArg.shuha = '浄土真宗本願寺派';
        theArg.hoyoryo = 35000;
        theArg.to_phoneNo = '08012345678';
        theArg.shodanBango = '0662317';

        SdcDto theDto = SorKetRenKaimCachSdc.createSdc(theArg);
        String theSdcId = SdcDto.InsertSdc(theDto);
        SdcSendDocQms.InsertAsRoot(theSdcId);

        Test.startTest();
        SdcEvtQms.InsertAsRoot(theSdcId, SdcEvtQms.deliveryStatus_Delivered);
        Test.getEventBus().deliver();
        Test.stopTest();
    }
}