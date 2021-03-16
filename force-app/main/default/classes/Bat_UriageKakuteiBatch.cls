/**
* [Batch, BatchSize <= 50]
* GMO 売上確定バッチ
* + 売上確定対象を抽出する
* + 売上確定タスクを投入する
*/
global class Bat_UriageKakuteiBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {

    ///////////////////////////////////////Schedule
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        System.debug('### Returned batch process ID: ' + Database.executeBatch(new Bat_UriageKakuteiBatch(), theBatchSize));
    }

    ///////////////////////////////////////Batch
    // Batch query
    private String buildQuery(){
        String query_str = '';
        query_str += ' SELECT ';
        query_str += ' Id ';
        query_str += ' FROM OkyakusamaSeikyuMeisai__c ';
        query_str += ' WHERE SeikyuStatus__c = \'決済済\' ';
        query_str += ' AND SeikyuHouhou__c = \'gmo_credit\' ';
        query_str += ' AND SeikyuOya__c = null ';
        query_str += ' AND IsDeleted = false ';
        return query_str;
    }

    // Schedule
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(buildQuery());
    }

    // Execute
    global void execute(Database.BatchableContext BC, List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiList) {
        for(OkyakusamaSeikyuMeisai__c seikyuMeisai : okyakusamaSeikyuMeisaiList){
            UriageKakuteiProcessor taskProcessor = new UriageKakuteiProcessor(seikyuMeisai);
            System.enqueueJob(taskProcessor);
        }
    }

    // End of Batch
    global void finish(Database.BatchableContext BC) {

    }

	
}