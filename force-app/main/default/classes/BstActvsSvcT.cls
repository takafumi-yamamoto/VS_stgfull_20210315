@isTest
public class BstActvsSvcT {
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
    @isTest public static void get_activities(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'ベス仏商談' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT theOpps.values();

        Map<String, Task> theTasks = new Map<String, Task>{
            '活動' => new Task(
                WhatId = theOpps.get('ベス仏商談').Id,
                Description = '_'
            )
        };
        INSERT theTasks.values();
        endSetUp();

        Test.startTest();
        BstActvsSvc.get_activities_req the_req = new BstActvsSvc.get_activities_req();
        the_req.opp_id = theOpps.get('ベス仏商談').Id;
        BstActvsSvc.get_activities(the_req);
        Test.stopTest();
    }
}