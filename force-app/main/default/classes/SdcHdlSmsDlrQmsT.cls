@isTest
private class SdcHdlSmsDlrQmsT {

    private static void beginSetUp(){
        Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
    private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
        Utility_Common.isMimicExecAsDataIkouProfile = false;
        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c(
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c(
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };
    }

    @isTest
    static void doTest(){
        Test.startTest();
        beginSetUp();
        String pSmsDlrId = '1234';
        String pSdcMsgId = '525';
        Qms__c qms = SdcHdlSmsDlrQms.CreateQmsAsRoot(pSmsDlrId,  pSdcMsgId);
        insert qms;
        new SdcHdlSmsDlrQms().handleQms(qms);
        endSetUp();
        Test.getEventBus().deliver();
        Test.stopTest();
    }

    @isTest
    static void doTest_Exception(){
        SmsDlr__c pSmsDlr = new SmsDlr__c(Status__c='Delivered');
        insert pSmsDlr;

        List<Sdc__c> sdcList = new List<Sdc__c>();
        Sdc__c sdc0 = new Sdc__c();
        sdc0.sendordercontroll__c = 'DlrChian';   // SendOrderControll
        sdcList.add(sdc0);
        upsert sdcList;

        List<SdcMsg__c> sdcmsgList = new List<SdcMsg__c>();
        SdcMsg__c sdcmsg0 = new SdcMsg__c();
        sdcmsg0.sdcref__c = 'a3u0w0000009CnzAAE';   // SdcRef
        sdcmsg0.clienttag__c = 'SorKetRenKaimCredSdc,cb6bfed3-9fb1-4fbf-a9a9-9c77a212ce62';   // ClientTag
        sdcmsg0.msgtxt__c = 'お世話になっております。お坊さん便でございます。 ご依頼いただきました戒名授与をご対応するお坊さまが決定いたしましたのでご連絡です。';   // MsgTxt
        sdcmsg0.SdcRef__c = sdc0.Id;
        // sdcmsg0.prevmsgclienttag__c = '';    // PrevMsgClientTag
        sdcmsgList.add(sdcmsg0);
        upsert sdcmsgList;

        Test.startTest();
        beginSetUp();
        Qms__c qms = SdcHdlSmsDlrQms.CreateQmsAsRoot(pSmsDlr.Id,  sdcmsg0.id);
        insert qms;
        new SdcHdlSmsDlrQms().handleQms(qms);
        endSetUp();
        Test.getEventBus().deliver();
        Test.stopTest();
    }
}