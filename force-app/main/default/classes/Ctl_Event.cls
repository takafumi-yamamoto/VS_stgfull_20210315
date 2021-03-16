public with sharing class Ctl_Event {

	public void initialProcessing(List<Event> newList, Map<ID, Event> oldMap){

		Set<ID> accountIdSet = new Set<Id>();
		for(Event event : newList){
			if(String.valueOf(event.WhatId).startswith('001')){
				accountIdSet.add(event.WhatId);
			}
		}

		Map<ID, Account> sltAccountMap = Dao_Account.getAccountContactKeiyakuMapByAccountSet(accountIdSet);
		Set<ID> johoshaAccountIdSet = new Set<ID>();
		for(Account sltAccount : sltAccountMap.values()){
			if(sltAccount.KeiyakusTeikeisaki__r.size() > 0){
				Keiyaku__c tempKeiyaku = sltAccount.KeiyakusTeikeisaki__r.get(0);
				johoshaAccountIdSet.add(tempKeiyaku.SyuKeiyakuRef__r.Teikeisaki__c);
			}
		}

		Map<ID, Account> sltJohoshaAccountMap = Dao_Account.getAccountContactMapByAccountSet(johoshaAccountIdSet);
		for(Event event : newList){
			if(sltAccountMap.containskey(event.WhatId)){
				event.AtesakiRef__c = event.WhatId;
				Account tempAccount = sltAccountMap.get(event.WhatId);
				if(tempAccount.KeiyakusTeikeisaki__r.size() > 0){
					Keiyaku__c tempKeiyaku = tempAccount.KeiyakusTeikeisaki__r.get(0);
					if(sltJohoshaAccountMap.containsKey(tempKeiyaku.SyuKeiyakuRef__r.Teikeisaki__c)){
						Account tempJohoshaAccount = sltJohoshaAccountMap.get(tempKeiyaku.SyuKeiyakuRef__r.Teikeisaki__c);
						if(tempJohoshaAccount.Contacts.size() > 0){
							event.WhoId = tempJohoshaAccount.Contacts.get(0).Id;
						}
					}
				}
				else{
					if(tempAccount.Contacts.size() > 0){
						event.WhoId = tempAccount.Contacts.get(0).Id;
					}
				}
			}
		}
	}
}