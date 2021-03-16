@isTest
public class Tes_ShodanNavigaterController {

	static testMethod void testCase1(){

		// 取引先作成
        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
		Account acc = new Account(LastName = 'テスト', FirstName = 'タロウ', RecordTypeId = accRecordTypeId);
		insert acc;

		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = acc.Id,
											StageName = '問合せ受付',
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											TaishoushaJokyo__c = '_'
										);
	    insert opp;

	    ShodanNavigaterController.getDataContext(opp.Id);
	}

}