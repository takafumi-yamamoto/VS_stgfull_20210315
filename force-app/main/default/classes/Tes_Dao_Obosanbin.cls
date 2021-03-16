@isTest
public class Tes_Dao_Obosanbin {

	static testMethod void testCase(){

		Test.startTest();

        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert sodansha;

        Account moshu = new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert moshu;

        Account taishosha = new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert taishosha;

        Obosanbin__c service = new Obosanbin__c(Taishosha1Ref__c = taishosha.Id, MoshuRef__c = moshu.Id);
        insert service;


		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = sodansha.Id,
											StageName = '問合せ受付',
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											ObosanbinRef__c = service.Id
										);
	    insert opp;

		Test.stopTest();
	}
}