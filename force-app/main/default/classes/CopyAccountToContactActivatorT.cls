@isTest
public class CopyAccountToContactActivatorT {
	
	@isTest static void doTest_scheduleNew(){
		Test.startTest();
		new CopyAccountToContact().ATC();
		new CopyAccountToContactBat().ATC();
		new CopyAccountToContactActivator().ATC();
        Test.stopTest();
        

		/*
		Id CustomerrecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'Customer');
		//取引先の「お客様」データ作成
		Account acc = new Account(
			LastName ='TEST',
			FirstName ='特約店手数料対応',
			MobilePhone__c ='080-0000-0001',
			MailAddress__c = 'aaa.bbb@xxx.com',
			RecordTypeId = CustomerrecordTypeId
		);
		Database.SaveResult lsracc = Database.insert(acc);

		//取引先の「お客様」データ作成
		 Account acc2 = new Account(
			LastName ='TEST2',
			FirstName ='AAA',
			MobilePhone__c ='090-0000-1234',
			MailAddress__c = 'bbb.cccb@ZZZ.com',
			RecordTypeId = CustomerrecordTypeId
		);
		Database.SaveResult lsracc2 = Database.insert(acc2);

		Test.startTest();
		Account acc3 = new Account(
			id = lsracc2.getId(),
			KoukokuDmNg__c = TRUE
			);
		Database.SaveResult lsracc3 = Database.update(acc3);

		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		CopyAccountToContact__c addatc = new CopyAccountToContact__c(
														AccIdBango__c = lsracc3.getId(),
														OppVersion__c = LongDate,
														LastProcVersion__c = 0
										);
		UPSERT addatc;
		CopyAccountToContactActivator TESTJOB = new CopyAccountToContactActivator();
		TESTJOB.scheduleNew();
		Test.stopTest();
		*/
	}
}