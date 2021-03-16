public class KeiriSokyakuTeishi {

	public void OnBeforeUpdate(List<Account> newtList, Map<ID, Account> oldMap) {
		
		ID AccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();

		for (Account neAcc :newtList){
			if(neAcc.RecordTypeId == AccountTypeId){
				if(neAcc.KeiriSokyakuTeishiFlag__c){
					if(neAcc.KeiriSokyakuTeishiFlag__c != oldMap.get(neAcc.ID).KeiriSokyakuTeishiFlag__c){
						if(neAcc.KeiriSokyakuTeishiCount__c == null) {
							neAcc.KeiriSokyakuTeishiCount__c = 1;
						}else{
							neAcc.KeiriSokyakuTeishiCount__c = neAcc.KeiriSokyakuTeishiCount__c + 1;
						}
					}
				}
			}
		}
	}

	public void OnAfterUpdate(List<Account> newList, Map<ID, Account> oldMap){
		
		ID AccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();

		List<Account> ListAcc = new List<Account>();
		
		for (Account neAcc :newList){
			if(neAcc.RecordTypeId == AccountTypeId){
				if(neAcc.KeiriSokyakuTeishiFlag__c != oldMap.get(neAcc.ID).KeiriSokyakuTeishiFlag__c){
					ListAcc.add(neAcc);
				}
			}
		}

		if(ListAcc.size() > 0){
			UpdateVersionToBe(ListAcc);
		}
	}

	public void UpdateVersionToBe(List<Account> pNewAcc){
		Map<String, KeiriSokyakuTeishi__c> theDenVers = new Map<String, KeiriSokyakuTeishi__c>();
		for(Account aAccIdBango : pNewAcc){
			theDenVers.put(
				aAccIdBango.Id,
				new KeiriSokyakuTeishi__c(
					AccIdBango__c = aAccIdBango.Id,
					AccName__c = aAccIdBango.Name,
					URL__c = URL.getOrgDomainUrl().toExternalForm() + '/' + aAccIdBango.Id,
					KeiriSokyakuTeishiFlag__c =  aAccIdBango.KeiriSokyakuTeishiFlag__c,
					OppVersion__c = genNewVerNo(),
					LastProcVersion__c = 0
				)
			);
		}
		UPSERT theDenVers.values() AccIdBango__c;
	}

	public Long GenNewVerNo(){
		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		return LongDate;
	}

}