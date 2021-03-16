@isTest
private class NpYosinTorihikiKanogakuClearBatT {
	
	@isTest static void test_method_one() {
		insert new YosinTorihikiKanogaku__c();
		Integer theBatchSize = 1000;
        Database.executeBatch(new NpYosinTorihikiKanogakuClearBat(), theBatchSize);

        new NpYosinTorihikiKanogakuClearBat().execute(null);
	}
		
}