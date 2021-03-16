@isTest
public class CustomLookupCtlT {
	
	@testSetup
	private static void setUp(){
        insert new Account( 
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
                Name = 'テストよりそう葬儀'
                );
    }

    @isTest
    static void test1(){
    	CustomLookupCtl.searchDB(
    							'Account', 
    							'Id', 
    							'Name', 
                                10, 
                                'Name', 
                                'AND RecordType.DeveloperName = \'Sogisya\'', 
                                'テスト');
    }
}