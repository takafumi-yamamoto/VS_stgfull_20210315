@isTest
private class SdcEvtQmsT {
    @testSetup
    static void setup() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
    }

    @isTest
    static void myUnitTest() {
/*        SorKetRenKaimCredSdc.CreateSdcReqArgs theArg = new SorKetRenKaimCredSdc.CreateSdcReqArgs();
        theArg.JiinName = 'テスト寺院名';
        theArg.JiinNameKana = 'テストジインメイカナ';
        theArg.Shuha = '浄土真宗本願寺派';
        theArg.Hoyoryo = 35000;
        theArg.to_phoneNo = '08012345678';
        theArg.to_atena = 'to_atena';
        theArg.shodanBango = '0662317';

        SdcDto theDto = SorKetRenKaimCredSdc.createSdc(theArg);
        String theSdcId = SdcDto.InsertSdc(theDto);
        SdcSendDocQms.InsertAsRoot(theSdcId);
*/
         List<Sdc__c> sdcList = new List<Sdc__c>();
         Sdc__c sdc0 = new Sdc__c();
         sdc0.sendordercontroll__c = 'DlrChian';   // SendOrderControll
         sdcList.add(sdc0);
         upsert sdcList;

         List<SdcMsg__c> sdcmsgList = new List<SdcMsg__c>();
         SdcMsg__c sdcmsg0 = new SdcMsg__c();
         sdcmsg0.clienttag__c = 'SorKetRenKaimCredSdc,cb6bfed3-9fb1-4fbf-a9a9-9c77a212ce62-ClientTag-test';   // ClientTag
         sdcmsg0.msgtxt__c = 'お世話になっております。お坊さん便でございます。 ご依頼いただきました戒名授与をご対応するお坊さまが決定いたしましたのでご連絡です。';   // MsgTxt
         sdcmsg0.SdcRef__c = sdc0.Id;
         // sdcmsg0.prevmsgclienttag__c = '';    // PrevMsgClientTag
         sdcmsgList.add(sdcmsg0);
         upsert sdcmsgList;

        List<SmsDlr__c> smsdlrList = new List<SmsDlr__c>();
        for(Integer i=0; i<1; i++){
            SmsDlr__c smsdlr = new SmsDlr__c();
            smsdlr.ClientTag__c = sdcmsg0.clienttag__c ;    //ClientTag
            smsdlr.DlrDt__c = DateTime.now();    //DlrDt
            smsdlr.MsgText__c = 'r2KUG7t' + string.valueof(i) ;    //MsgText
            smsdlr.PhoneNo__c = 'rN8ShXL' + string.valueof(i) ;    //PhoneNo
            smsdlr.Status__c = 'Delivered';    //Status
            smsdlrList.add(smsdlr);
        }
        insert smsdlrList;

        Test.startTest();
        SdcEvtQms.InsertAsRoot(sdc0.Id, SdcEvtQms.deliveryStatus_Delivered);
        Test.getEventBus().deliver();
        Test.stopTest();
    }
}