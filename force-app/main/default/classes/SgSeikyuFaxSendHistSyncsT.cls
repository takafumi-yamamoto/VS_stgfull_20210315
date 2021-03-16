@isTest
public class SgSeikyuFaxSendHistSyncsT {

    @isTest
    public static void test1() {

        PartnerSeikyuSogisha__c p = new PartnerSeikyuSogisha__c();
        insert p;

        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub(), new Environments.EnvStub().setIsSandBoxFalse());

        Test.startTest();

        SgSeikyuFaxSendHistSyncs.ISgSeikyuFaxSendHistCreateSyncer mSgSeikyuFaxSendHistSyncer = SgSeikyuFaxSendHistSyncs.getSgSeikyuFaxSendHistCreateSyncer();
        mSgSeikyuFaxSendHistSyncer.syncSgSeikyuFaxSendHist(p.Id, '0300000000', '', '');

        Test.stopTest();
    }

    @isTest
    public static void test2() {

        insert new PartnerSeikyuSogisha__c();
        insert new PartnerSeikyuSendHistory__c(
            SendType__c = 'Fax',
            SendRequestStatus__c = '送信依頼OK',
            SendResultStatus__c = '未処理'
        );

        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub(), new Environments.EnvStub().setIsSandBoxFalse());

        Test.startTest();
        
        SgSeikyuFaxSendHistSyncs.ISgSeikyuFaxSendHistUpdateSyncer mSgSeikyuFaxSendHistUpdateSyncer = SgSeikyuFaxSendHistSyncs.getSgSeikyuFaxSendHistUpdateSyncer();

        SgSeikyuFaxSendHistSyncs.SgSeikyuFaxSendHistUpdateSyncer syncer = new SgSeikyuFaxSendHistSyncs.SgSeikyuFaxSendHistUpdateSyncer(
            new FaximoApiSendRsltReqEx.Request(), 
            new FaximoApiSendRsltReqExClient_Stub()
        );
        syncer.syncSgSeikyuFaxSendHistUpdate();

        Test.stopTest();
    }

    public class FaximoApiSendRsltReqExClient_Stub implements FaximoApiSendRsltReqEx.IClient{
        public FaximoApiSendRsltReqEx.Result sendRequest(FaximoApiSendRsltReqEx.Request pReq){

            FaximoApiSendRsltReqEx.SendResultListInfo sendResultListInfo = new FaximoApiSendRsltReqEx.SendResultListInfo();
            FaximoApiSendRsltReqEx.Response stub_response = new FaximoApiSendRsltReqEx.Response();
            stub_response.SendResultList = new List<FaximoApiSendRsltReqEx.SendResultListInfo>();
            stub_response.SendResultList.add(sendResultListInfo);

            FaximoApiSendRsltReqEx.Result theResult = new FaximoApiSendRsltReqEx.Result();
            theResult.isSuccess = true;
            theResult.response = stub_response;
            return theResult;
        }
    }
}