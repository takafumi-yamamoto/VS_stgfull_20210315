global class NPBuyersAuthResultBat implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {
	
	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = Integer.valueof(NPkakebaraiConfig.getConfig().BAT_SIZE__c);
        Database.executeBatch(new NPBuyersAuthResultBat(), theBatchSize);
    }

	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		return Database.getQueryLocator([
			SELECT ID, Teikeisaki__c, Teikeisaki__r.TorihikisakiBango__c 
			FROM Keiyaku__c
			WHERE KeiyakuJokyo__c in ('契約中', '失効中')
			AND RecordType.DeveloperName = 'Obosanbin'
			AND Teikeisaki__r.RecordType.DeveloperName = 'SoryoAccount'
		]);
	}

   	global void execute(Database.BatchableContext BC, List<Keiyaku__c> keiyakus) {
		Set<String> torihikisakiBangoSet = new Set<String>();
		for(Keiyaku__c keiyaku : keiyakus){
			torihikisakiBangoSet.add(keiyaku.Teikeisaki__r.TorihikisakiBango__c);
		}
		new NPBuyersAuthResult().NpKonyuKigyoKekkaTorikomi(new List<String>(torihikisakiBangoSet));
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}