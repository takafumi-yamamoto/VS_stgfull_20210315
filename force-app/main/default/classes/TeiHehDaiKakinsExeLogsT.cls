@isTest
public class TeiHehDaiKakinsExeLogsT {

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

	@isTest public static void Logger_logStart(){
		Test.startTest();
		new TeiHehDaiKakinsExeLogs.Logger( new TeiHehDaiKakinsExeLogs.TargetYmKeys() )
			.logStart(
				Date.newInstance(2020,1,1), 
				Datetime.newInstance(2020,1,1,12,0,0) 
			);
		Test.stopTest();
	}
	@isTest public static void Logger_logFinish(){
		Test.startTest();
		new TeiHehDaiKakinsExeLogs.Logger( new TeiHehDaiKakinsExeLogs.TargetYmKeys() )
			.logFinish(
				Date.newInstance(2020,1,1), 
				Datetime.newInstance(2020,1,1,12,0,0) 
			);
		Test.stopTest();
	}
	@isTest public static void Logger_getShoriStatus(){
		Test.startTest();
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
		TeiHehDaiKakinsExeLogs.ShoriStatus theActual =
			new TeiHehDaiKakinsExeLogs.Logger( new TeiHehDaiKakinsExeLogs.TargetYmKeys() )
				.getShoriStatus( Date.newInstance(2020,1,1) );
		System.assertEquals(
			TeiHehDaiKakinsExeLogs.ShoriStatus.Finished,
			theActual
		);
		Test.stopTest();
	}
}