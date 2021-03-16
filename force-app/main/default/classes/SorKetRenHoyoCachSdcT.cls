@isTest
private class SorKetRenHoyoCachSdcT {

    @testSetup
    static void setup() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
    }

    @isTest
    static void myUnitTest() {
        SorKetRenHoyoCachSdc.CreateSdcReqArgs theArg = new SorKetRenHoyoCachSdc.CreateSdcReqArgs();
        theArg.jiinName = 'テスト寺院名';
        theArg.jiinNameKana = 'テストジインメイカナ';
        theArg.shuha = '浄土真宗本願寺派';
        theArg.hoyoBashoName = 'hoyoBashoName';
        theArg.tsuikaHoyoBashoName = 'tsuikaHoyoBashoName';
        theArg.hoyoryo = 35000;
        theArg.to_phoneNo = '08012345678';
        theArg.shodanBango = '0662317';
        theArg.nichiji = Datetime.now();


        SdcDto theDto = SorKetRenHoyoCachSdc.createSdc(theArg);
        String theSdcId = SdcDto.InsertSdc(theDto);
        SdcSendDocQms.InsertAsRoot(theSdcId);

        Test.startTest();
        SdcEvtQms.InsertAsRoot(theSdcId, SdcEvtQms.deliveryStatus_Delivered);
        Test.getEventBus().deliver();
        Test.stopTest();
    }
}