@isTest
public class TeiHehDaiKakinsLocksT {
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
	@isTest public static void getInstance(){
		Test.startTest();
		TeiHehDaiKakinsLocks.getInstance();
		Test.stopTest();
	}
	@isTest public static void TeiHehDaiKakinsLock_onTeiHehDaiKakinSchEnt_Before_Upsert(){
		beginSetUp();
		Date theDate = Date.newInstance(2020,1,1);
		String theRenewTargetYmKey = 
			new TeiHehDaiKakinsExeLogs.TargetYmKeys().genTargetYmKey(theDate);
		INSERT New TeiHehDaiKakinsExeLog__c(
			RenewTargetYmKey__c = theRenewTargetYmKey,
			StartedTime__c = Datetime.newInstance(2020,1,1,12,0,0) ,
			FinishedTime__c = Datetime.newInstance(2020,1,1,12,0,0) 
		);
		endSetUp();
		Test.startTest();
		List<TeiHehDaiKakinSchEnt__c> theNewOnes = new List<TeiHehDaiKakinSchEnt__c>{
			new TeiHehDaiKakinSchEnt__c(
				BeginDate__c = theDate
			)
		};

		new TeiHehDaiKakinsLocks.TeiHehDaiKakinsLock( TeiHehDaiKakinsExeLogs.getInstance() )
			.onTeiHehDaiKakinSchEnt_Before_Upsert(theNewOnes);
		Test.stopTest();
	}
	@isTest public static void TeiHehDaiKakinsLock_turnOnValidaton(){
		Test.startTest();
		new TeiHehDaiKakinsLocks.TeiHehDaiKakinsLock( TeiHehDaiKakinsExeLogs.getInstance() )
			.turnOnValidaton();
		Test.stopTest();
	}
	@isTest public static void TeiHehDaiKakinsLock_turnOffValidaton(){
		Test.startTest();
		new TeiHehDaiKakinsLocks.TeiHehDaiKakinsLock( TeiHehDaiKakinsExeLogs.getInstance() )
			.turnOffValidaton();
		Test.stopTest();
	}
}