public class CopyIndividualAccounts {

	public List<CopyIndividualAccounts__mdt> CIAmdt; 
    public Id CustomerrecordTypeId;

	public CopyIndividualAccounts(){
		CIAmdt = new List<CopyIndividualAccounts__mdt>();
		CIAmdt = [SELECT 
					Original__c,
					CopyTo__c
				FROM CopyIndividualAccounts__mdt];
		CustomerrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	}

	// 個人取引先（AccountからContactへのコピー処理)
	public void OnBeforeInsert(List<Account> newAccountList){
		
		List<Account> ListAcc = new List<Account>();
		
		for(Account newAcc :newAccountList){
			if(newAcc.recordTypeId == CustomerrecordTypeId){
				ListAcc.add(newAcc);
			}
		}

		if(ListAcc.size() > 0){
			SetIndividualAccounts(ListAcc);
		}
	}

    public void OnBeforeUpdate(List<Account> newAccountList, Map<ID, Account> oldAccountMap){
		
		List<Account> ListAcc = new List<Account>();
		
		for(Account newAcc :newAccountList){
			if(newAcc.recordTypeId == CustomerrecordTypeId){
				Account oldAccount = oldAccountMap.get(newAcc.Id);
				for(CopyIndividualAccounts__mdt sCIAmdt :CIAmdt){
					if(newAcc.get(sCIAmdt.Original__c) != oldAccount.get(sCIAmdt.Original__c)){
						ListAcc.add(newAcc);
						continue; 
					}
				}
			}
		}

		if(ListAcc.size() > 0){
			SetIndividualAccounts(ListAcc);
		}
	}

	public void SetIndividualAccounts(List<Account> pNewAcc){

		SET<String> AccIdBango = New SET<String>();
		
		for(Account aAcc : pNewAcc){
			for(CopyIndividualAccounts__mdt sCIAmdt :CIAmdt){
				aAcc.put(sCIAmdt.CopyTo__c, aAcc.get(sCIAmdt.Original__c));
			}
		}
	}
}