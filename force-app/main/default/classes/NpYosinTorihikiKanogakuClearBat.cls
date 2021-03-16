global class NpYosinTorihikiKanogakuClearBat implements Database.Batchable<sObject>, Schedulable{
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT ID FROM YosinTorihikiKanogaku__c]);
	}

   	global void execute(Database.BatchableContext BC, List<YosinTorihikiKanogaku__c> yosinTorihikiKanogakuList) {
   		if(yosinTorihikiKanogakuList.size() > 0) delete yosinTorihikiKanogakuList;
	}
	
	global void finish(Database.BatchableContext BC) {
        Integer theBatchSize = 200;
        Database.executeBatch(new NpYosinTorihikiKanogakuBat(), theBatchSize);		
	}
	
	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1000;
        Database.executeBatch(new NpYosinTorihikiKanogakuClearBat(), theBatchSize);
    }
}