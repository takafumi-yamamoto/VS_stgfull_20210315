global class Bat_ObosanJizenSmsSender implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {

	/** スケジュール起動*/
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 1;
        Database.executeBatch(new Bat_ObosanJizenSmsSender(), theBatchSize);
    }
		
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
				Select 
					id, 
					OpportunityRef__c,
					JizenKakuninKbn__c,
					( Select id, ClientTag__c, MsgBody__c, PhoneNo__c FROM JizenKakuninSmsTaskMsgs__r )
				FROM JizenKakuninSmsTask__c
				WHERE ShoriStatus__c = 'Created'
			]);
	}

   	global void execute(Database.BatchableContext BC, List<JizenKakuninSmsTask__c> tasks) {
		sendSms(tasks);
		updateOboStatus(tasks);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	private void sendSms(List<JizenKakuninSmsTask__c> tasks){

		for(JizenKakuninSmsTask__c task : tasks){
			Boolean isError = false;

			if(String.isBlank(task.OpportunityRef__c) || String.isBlank(task.JizenKakuninKbn__c)){
				isError = true;
				continue;
			}

			//phone check
			for(JizenKakuninSmsTaskMsg__c msg : task.JizenKakuninSmsTaskMsgs__r){
				if(String.isBlank(msg.PhoneNo__c) || !msg.PhoneNo__c.isNumeric()){
					isError = true;
					break;
				}
			}

			//send sms
			if(!isError){
				for(JizenKakuninSmsTaskMsg__c msg : task.JizenKakuninSmsTaskMsgs__r){
					Aos_SMSTransUtility.SendResult theResult = Aos_SMSTransUtility.sendHttpRequest(msg.ClientTag__c, msg.PhoneNo__c, msg.MsgBody__c);
					if(theResult == Aos_SMSTransUtility.SendResult.Fault) isError = true;
				}				
			}

			task.ShoriStatus__c = isError ? 'Faulted' : 'Completed';		
		}
		update tasks;
	}

	private void updateOboStatus(List<JizenKakuninSmsTask__c> tasks){
		Map<Id, Opportunity> oppMap = getOpportunityMap(tasks);
		List<Obosanbin__c> oboList = new List<Obosanbin__c>();
		List<Opportunity> oppList = new List<Opportunity>();
		Set<Id> keiyakuOboIds = new Set<Id>();

		for(JizenKakuninSmsTask__c task : tasks){
			Boolean sendSmsStatus = task.ShoriStatus__c == 'Completed'; //送達ステータス 
			String result = sendSmsStatus ? '送信済' : 'エラー';
			String bikou = sendSmsStatus ? null : '送信エラー';
			Opportunity opp = oppMap.get(task.OpportunityRef__c);
			Obosanbin__c obo =  new Obosanbin__c(Id = opp.ObosanbinRef__c);
			if(task.JizenKakuninKbn__c == '7日前') {
				obo.JizenSmsBf7Status__c = result;
				obo.JizenSmsBf7SoushinDate__c = Date.today();
				obo.JzenSmsBf7StatusDescr__c = bikou;
			}else if(task.JizenKakuninKbn__c == '1日前') {
				obo.JizenSmsBf1Status__c = result;
				obo.JizenSmsBf1SoushinDate__c = Date.today();
				obo.JzenSmsBf1StatusDescr__c = bikou;
			}
			oboList.add(obo);

			if(!sendSmsStatus){
				oppList.add(new Opportunity(Id=opp.Id, SubPhase__c = '事前確認連絡（電話）'));
				keiyakuOboIds.add(opp.ObosanbinRef__c);
			}
		}
		update oboList;
		update oppList;

        if( keiyakuOboIds.size() > 0  ) {
            List<Obosanbin__c> tmpoboList = [Select id, ObosanbinKeiyakuMadoguchi__c FROM Obosanbin__c Where id = :keiyakuOboIds];
            List<Keiyaku__c> keiyakuList = new List<Keiyaku__c>();
        	for( Obosanbin__c tmpObo : tmpoboList){
                Id keiyakuId = tmpObo.ObosanbinKeiyakuMadoguchi__c;
                if(String.isNotBlank(keiyakuId)){
            		keiyakuList.add(new Keiyaku__c(Id = keiyakuId, Jizenkakuninhouhou__c = '電話'));
                }
        	}
        	update keiyakuList;
        }
	}

	private void updateOppStatus(List<JizenKakuninSmsTask__c> tasks){

	}

	private Map<Id, Opportunity> getOpportunityMap(List<JizenKakuninSmsTask__c> tasks){
		Set<Id> oppIds = new Set<Id>();
		for(JizenKakuninSmsTask__c task : tasks){
			if(String.isNotBlank(task.OpportunityRef__c)) oppIds.add(task.OpportunityRef__c);
		}
		List<Opportunity> oppList = [Select id, ObosanbinRef__c FROM Opportunity where id in:oppIds];
		return new Map<Id, Opportunity>(oppList);
	}
	
}