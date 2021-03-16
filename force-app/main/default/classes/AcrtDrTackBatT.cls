@isTest
public class AcrtDrTackBatT {

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

    public class AcrtSmsDrClient_Stub implements AcrtSmsDr.IClient{
        public AcrtSmsDr.Result sendRequest(AcrtSmsDr.Req pReq){
            AcrtSmsDr.Res theRes = new AcrtSmsDr.Res();
            theRes.result_code = AcrtApiSmsDr.result_code_delivered;
            theRes.delivery_id = pReq.delivery_id;
            theRes.message = 'delivered';

            AcrtSmsDr.Result theResult = new AcrtSmsDr.Result();
            theResult.res = theRes;
            theResult.req = pReq;

            return theResult;
        }
    }

    @isTest static void start(){

        beginSetUp();
        INSERT new AcrtDrTack__c(
            delivery_id__c = '_',
            expired_at__c = Datetime.newInstance(2020, 1, 2, 0, 0, 0),
            scheduled_at__c = Datetime.newInstance(2020, 1, 1, 0, 0, 0),
            send_dt__c = Datetime.newInstance(2020, 1, 1, 0, 0, 0),
            status__c = 'active'
        );

        AcrtDrTackBat.mTodayInstance = new Todays.TodayStub().setNow( Datetime.newInstance(2020, 1, 1, 0, 0, 0) );
        AcrtDrTackBat.mAcrtSmsDrClientInstance = new AcrtSmsDrClient_Stub();
        endSetUp();
        Test.startTest();
        AcrtDrTackBat.start();
        Test.stopTest();
    }
}