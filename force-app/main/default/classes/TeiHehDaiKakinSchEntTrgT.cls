@isTest
private class TeiHehDaiKakinSchEntTrgT {

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

    @isTest
    public static void insertTest(){
        beginSetUp();
        Todays.setInstance( new Todays.TodayStub().setNow( Date.newInstance(2020,1,1) ) );
        endSetUp();

        Test.startTest();
        TeiHehDaiKakinSchEnt__c theTeiHehDaiKakinSchEnt = 
            New TeiHehDaiKakinSchEnt__c(
                BeginDate__c = Date.newInstance(2020,2,1)
            );
        INSERT theTeiHehDaiKakinSchEnt;
        Test.stopTest();
    }

    @isTest
    public static void updateTest(){
        beginSetUp();
        Todays.setInstance( new Todays.TodayStub().setNow( Date.newInstance(2020,1,1) ) );
        TeiHehDaiKakinSchEnt__c theTeiHehDaiKakinSchEnt = 
            New TeiHehDaiKakinSchEnt__c(
                BeginDate__c = Date.newInstance(2020,2,1)
            );
        INSERT theTeiHehDaiKakinSchEnt;
        endSetUp();

        Test.startTest();
        theTeiHehDaiKakinSchEnt.BeginDate__c = Date.newinstance(2020,3,1);
        UPDATE theTeiHehDaiKakinSchEnt;
        Test.stopTest();
    }
}