@isTest
private class NPBuyersAuthResultBatT {
	
	@isTest static void test_method_one() {

		SampleData sample = new SampleData();
		Account soryo = sample.getAccountSoryoAccount();
		insert soryo;

		insert new Keiyaku__c(
				Name = 'テスト契約',
				Teikeisaki__c = soryo.Id,
				KeiyakuJokyo__c = '契約中',
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin')
			);

		new NPBuyersAuthResultBat().execute(null);

	}
	
}