global class Bat_SouryoClaimAggregate implements Database.Batchable<sObject>, Schedulable {
	
	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        Database.executeBatch(new Bat_SouryoClaimAggregate(), theBatchSize);
    }
	
	global Bat_SouryoClaimAggregate() {
		
	}
	
	global List<SObject> start(Database.BatchableContext BC){
		return [
			select 
				TaishoSoryoRef__c, 
				COUNT(Id)
			from Claim__c
			Where TaishoSoryoRef__c <> null
			GROUP BY TaishoSoryoRef__c
		];
	}

   	global void execute(Database.BatchableContext BC, List<AggregateResult> groupedResults) {
   		List<Account> accList = new List<Account>();
		for (AggregateResult ar : groupedResults)  {
		    String clainSoryo = (String)ar.get('TaishoSoryoRef__c');
		    Integer clainNum = Integer.valueOf(ar.get('expr0'));
		    accList.add(new Account(Id=clainSoryo, SouryoClaimNum__c=clainNum));
		}
		update accList;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}