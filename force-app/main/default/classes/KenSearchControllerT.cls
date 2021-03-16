@isTest
private class KenSearchControllerT {
	@isTest static void test_method_one() {
		Insert new Ken_all__c(post_code__c='1500001',todofuken__c='東京',shikugun__c='品川区',tyoumei__c='五反田');
		Test.startTest();

		KenSearchController.Zyusho zyusho = KenSearchController.search('150-0001');
		System.debug(zyusho);

		KenSearchController.Location loc = KenSearchController.getLocation('150-0001', '', '', '', '');
		System.debug(loc);

		Test.stopTest();
	}

}