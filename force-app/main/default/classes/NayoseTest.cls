@isTest
public class NayoseTest {
	
	private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void partnerNayoseTest1(){

        setUp();

        Test.startTest();

        Insert new Account(
            Name = 'テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
            Phone = '11111111111',
            Phone2__c = '22222222222',
            MailAddress__c = 'testsogisha1@yoriso.com',
            MailAddress2__c = 'testsogisha2@yoriso.com'
        );

        Test.stopTest();
    }

    @isTest
    public static void partnerNayoseTest2(){

        setUp();

        Insert new Account(
            Name = 'テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
            Phone = '',
            Phone2__c = '',
            MailAddress__c = 'testsogisha1@yoriso.com',
            MailAddress2__c = 'testsogisha2@yoriso.com'
        );

        Test.startTest();

        try{
		    Insert new Account(
		        Name = 'テスト葬儀社',
		        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId(),
		        Phone = '11111111111',
		        Phone2__c = '22222222222',
		        MailAddress__c = 'testsogisha2@yoriso.com',
		        MailAddress2__c = 'testsogisha1@yoriso.com'
		    );
		}
		catch(Exception e){

		}

        Test.stopTest();
    }

    @isTest
    public static void partnerNayoseTest3(){

        setUp();

        Insert new Account(
            Name = 'テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
            Phone = '11111111111',
            Phone2__c = '',
            MailAddress__c = '',
            MailAddress2__c = 'testsogisha2@yoriso.com'
        );

        Test.startTest();

        try{
		    Insert new Account(
		        Name = 'テスト葬儀社',
		        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
		        Phone = '11111111111',
		        Phone2__c = '22222222222',
		        MailAddress__c = 'testsogisha2@yoriso.com',
		        MailAddress2__c = 'testsogisha1@yoriso.com'
		    );
		}
		catch(Exception e){

		}

        Test.stopTest();
    }

    @isTest
    public static void partnerNayoseTest4(){

        setUp();

        Account a = new Account(
            Name = 'テスト葬儀社',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
            Phone = '11111111111',
            Phone2__c = '22222222222',
            MailAddress__c = '',
            MailAddress2__c = ''
        );

        Insert a;

        Test.startTest();

	    a.MailAddress2__c = 'testsogisha2@yoriso.com';
	    update a;

        Test.stopTest();
    }
}