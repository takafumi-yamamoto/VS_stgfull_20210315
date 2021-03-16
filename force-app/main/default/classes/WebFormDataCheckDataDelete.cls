global class WebFormDataCheckDataDelete implements Schedulable, Database.Batchable<sObject> {
		
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 200;
        Database.executeBatch(new WebFormDataCheckDataDelete(), theBatchSize);
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		// 本番テストデータ削除	
		List<Id> accIds = new List<Id>();	
		accIds.add('0017F00000g3iWYQAY'); // お坊さん便資料請求Web受付1abcd123451234543215 太郎	
		accIds.add('0017F00000wOefBQAS'); // お坊さん便資料請求２ 太郎２	
		accIds.add('0017F00000g3lk5QAA'); // シンプル安豪問合せWeb受付1abcd123451234543215 太郎	
		accIds.add('0017F00000g3lkFQAQ'); // シンプル安豪問合せWeb受付2abcd123451234543215 太郎2	
		return Database.getQueryLocator([ SELECT Id FROM Account Where id = :accIds ]);
	}

   	global void execute(Database.BatchableContext BC, List<Account> accounts) {
   		List<Account> accList = [SELECT	
									Id,	
									LastName,	
									FirstName,	
									(select id, name, SimpleYasugoRef__c, ObosanbinRef__c, TorihikiShodanRef__c from Opportunities),	
									(select id, Lastname__c from Cases),	
									(select id, name from TorihikisakiWebAccountIrais__r)
									FROM Account	
									Where id = :accounts
								];
	
		Set<Opportunity> oppSet = new Set<Opportunity>();	
		Set<Case> caseSet = new Set<Case>();	
		Set<SimpleYasugo__c> simpleSet = new Set<SimpleYasugo__c>();	
		Set<Obosanbin__c> oboSet = new Set<Obosanbin__c>();	
		Set<WebAccountTourokuIrai__c> webAccountTourokuIraiSet = new Set<WebAccountTourokuIrai__c>();	
			
		System.debug(accList);	
		for(Account acc : accList){	
			for(Opportunity aOpp : acc.Opportunities){
				oppSet.add(new Opportunity(Id=aOpp.Id));
				if(String.isNotBlank(aOpp.TorihikiShodanRef__c)) oppSet.add(new Opportunity(Id=aOpp.TorihikiShodanRef__c));
				if(String.isNotBlank(aOpp.SimpleYasugoRef__c)) simpleSet.add(new SimpleYasugo__c(Id=aOpp.SimpleYasugoRef__c));
				if(String.isNotBlank(aOpp.ObosanbinRef__c)) oboSet.add(new Obosanbin__c(Id=aOpp.ObosanbinRef__c));
			}

			caseSet.addAll(acc.Cases); //ケース
			webAccountTourokuIraiSet.addAll(acc.TorihikisakiWebAccountIrais__r);
		}	

		List<Opportunity> oppList = new List<Opportunity>(oppSet);
		List<Case> caseList = new List<Case>(caseSet);
		List<SimpleYasugo__c> simpleList = new List<SimpleYasugo__c>(simpleSet);
		List<Obosanbin__c> oboList = new List<Obosanbin__c>(oboSet);
		List<WebAccountTourokuIrai__c> iraiList = new List<WebAccountTourokuIrai__c>(webAccountTourokuIraiSet);
		try{
			delete oppList;
			delete caseList;
			delete simpleList;
			delete oboList;
			delete iraiList;
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Info, '20180821-1430-01', 'WebFormDataCheckDataDelete')
	                .putAttr('Case', string.join(caseList,',\n'))
	                .putAttr('Opportunity', string.join(oppList,',\n'))
	                .putAttr('SimpleYasugo__c', string.join(simpleList,',\n'))
	                .putAttr('Obosanbin__c', string.join(oboList,',\n'))
	                .putAttr('WebAccountTourokuIrai__c', string.join(iraiList,',\n'))
	                .putAttr('Account', string.join(accList,',\n'))
	        );

		}catch(Exception ex){
			System.debug(ex);
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20180821-1430-01', 'WebFormDataCheckDataDelete')
	                .putAttr('Case', string.join(caseList,',\n'))
	                .putAttr('Opportunity', string.join(oppList,',\n'))
	                .putAttr('SimpleYasugo__c', string.join(simpleList,',\n'))
	                .putAttr('Obosanbin__c', string.join(oboList,',\n'))
	                .putAttr('WebAccountTourokuIrai__c', string.join(iraiList,',\n'))
	                .putAttr('Account', string.join(accList,',\n'))
	                .putAttr('Exception', ex.getMessage())
	        );
		}

	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}