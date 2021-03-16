@isTest
public class AcrtDrResultQmsT {

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
    private class IErrHistoryLogr_Stub implements  AcrtSmsSendErrHistLogr.IErrHistoryLogr{
        public void updateLogSmsHistory(String p_AcrtDrTack_Id){return;}
    }
    @isTest public static void handleQms() {
        beginSetUp();
        Qms__c theQms = AcrtDrResultQms.createQms('_','_','0003', false);
        INSERT theQms;
        AcrtDrResultQms.mIErrHistoryLogr = new IErrHistoryLogr_Stub();
        endSetUp();

        Test.startTest();
        new AcrtDrResultQms().handleQms(theQms);
        Test.stopTest();
    }
    @isTest public static void handleQms_error() {
        beginSetUp();
        Qms__c theQms = AcrtDrResultQms.createQms('_','SampleMsgType','0003', false);
        INSERT theQms;
        AcrtDrResultQms.mIErrHistoryLogr = new IErrHistoryLogr_Stub();
        endSetUp();

        Test.startTest();

        AcrtDrResultQms.raise_err_for_test_coverage = true;
        try{
            new AcrtDrResultQms().handleQms(theQms);
        }catch(Exception ex){
            //ignore
        }
       
        Test.stopTest();
    }
}