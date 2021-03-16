@isTest
public class TcmsTaioRkImpT {
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
    }

    public class IOppCreator_Stub implements TcmsTaioRkImpOpp.IOppCreator{
        public String createOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData){ return null; }
    }
    public class IOppCreator_ErrStub implements TcmsTaioRkImpOpp.IOppCreator{
        public String createOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData){ throw new Exceptions.AnException(); }
    }
    public class ISogiShiryoSofuCreator_Stub implements TcmsTaioRkImpSogiShiryo.ISogiShiryoSofuCreator{
        public void createSogiShiryoSofu(String pOppId, TcmsTaioRkImpData__c pTcmsTaioRkImpData){ return; }
    }
    @isTest
    public static void TaioRerekiImporter_run_import(){
        beginSetUp();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1');
        INSERT the_TcmsTaioRkImpData;
        endSetUp();

        Test.startTest();
        new TcmsTaioRkImp.TaioRerekiImporter(
            new IOppCreator_Stub(),
            new ISogiShiryoSofuCreator_Stub(),
            new TcmsTaioRkImp.TcmsTaioRkImpDataSelector()
        ).run_import(the_TcmsTaioRkImpData.Id);
        Test.stopTest();
    }

    @isTest
    public static void TaioRerekiImporter_run_import_Err(){
        beginSetUp();
        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(TcmsSeqNo__c = '1');
        INSERT the_TcmsTaioRkImpData;
        endSetUp();

        Test.startTest();
        new TcmsTaioRkImp.TaioRerekiImporter(
            new IOppCreator_ErrStub(),
            new ISogiShiryoSofuCreator_Stub(),
            new TcmsTaioRkImp.TcmsTaioRkImpDataSelector()
        ).run_import(the_TcmsTaioRkImpData.Id);
        Test.stopTest();
    }
    @isTest
    public static void get_ITaioRerekiImporter_instance(){
        Test.startTest();
        TcmsTaioRkImp.get_ITaioRerekiImporter_instance();
        Test.stopTest();
    }
}