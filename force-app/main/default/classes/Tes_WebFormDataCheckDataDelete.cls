@isTest
private class Tes_WebFormDataCheckDataDelete {
	
	@isTest static void test_method_one() {
		Integer theBatchSize = 200;
        Database.executeBatch(new WebFormDataCheckDataDelete(), theBatchSize);
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}