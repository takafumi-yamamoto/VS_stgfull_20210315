global class Bat_SokyakusuShukei implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts, Schedulable {

	global Map<ID, List<Opportunity>> simpleYasugoIdMap = new Map<ID, List<Opportunity>>();

	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        //System.debug('### Returned batch process ID: ' + Database.executeBatch(new Bat_SokyakusuShukei(), theBatchSize));
        Database.executeBatch(new Bat_SokyakusuShukei(), theBatchSize);
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

   		for(Opportunity simpleYasugoOpportunity : [select Id, SimpleYasugoRef__c, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c from Opportunity where Utiagebi__c = THIS_MONTH and RecordType.DeveloperName = 'SimpleYasugo']){
   			List<Opportunity> opportunityTempList = new List<Opportunity>();
   			if(simpleYasugoIdMap.containsKey(simpleYasugoOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c)){
   				opportunityTempList = simpleYasugoIdMap.get(simpleYasugoOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c);
   			}
   			opportunityTempList.add(simpleYasugoOpportunity);
   			System.debug('simpleYasugoOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c:' + simpleYasugoOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c);
   			simpleYasugoIdMap.put(simpleYasugoOpportunity.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, opportunityTempList);
   		}

		String query = 'Select Id, ' +
					'( ' +
					    'select id, ' +
					    		'TogetsuSokyakusu__c ' +
					    'from KeiyakusSyuKeiyaku__r ' +
					    'where RecordType.DeveloperName = \'TokuyakuTen\' ' +
					') ' +
				'from Keiyaku__c where RecordType.DeveloperName = \'SimpleYasugo\' ';
		System.debug('query:' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Keiyaku__c> shuKeiyakuList) {
		
		System.debug('Bat_SokyakusuShukei.execute start');

		System.debug('simpleYasugoIdMap:' + simpleYasugoIdMap);

		List<Keiyaku__c> updateKeiyakuList = new List<Keiyaku__c>();
   		for(Keiyaku__c shukeiyaku : shuKeiyakuList){
   			System.debug('shukeiyaku.Id:' + shukeiyaku.Id);
   			for(Keiyaku__c tokuyakutenKeiyaku : shukeiyaku.KeiyakusSyuKeiyaku__r){
				Integer togetsuSokyakusuNum = 0;
				if(simpleYasugoIdMap.containsKey(shukeiyaku.Id)){
	   				System.debug('simpleYasugoIdMap.get(shukeiyaku.Id).size():' + simpleYasugoIdMap.get(shukeiyaku.Id).size());
	   				togetsuSokyakusuNum = simpleYasugoIdMap.get(shukeiyaku.Id).size();
	   			}

				tokuyakutenKeiyaku.TogetsuSokyakusu__c = togetsuSokyakusuNum;
				updateKeiyakuList.add(tokuyakutenKeiyaku);
	   		}
   		}

   		update updateKeiyakuList;

   		System.debug('Bat_SokyakusuShukei.execute end');
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}