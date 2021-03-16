public class KeiriTorihikiSakiNameImpTrg {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public KeiriTorihikiSakiNameImpTrg(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
	}

	public void onBeforeInsert(List<KeiriTorihikiSakiNameImp__c > pNewOnes){

        Set<String> theTorihikiSakiBangos = new Set<String>();
        for(KeiriTorihikiSakiNameImp__c aNewOne : pNewOnes){
            if( String.isBlank(aNewOne.TorihikiSakiBango__c) ) continue;
            theTorihikiSakiBangos.add(aNewOne.TorihikiSakiBango__c);
        }
        Map<String, Account> theTorihikiSakiBangoToAccountMap = new Map<String, Account>();
        for(Account aEntry : [
            SELECT Id, TorihikiSakiBango__c  FROM Account WHERE TorihikiSakiBango__c = :theTorihikiSakiBangos
        ]){
            theTorihikiSakiBangoToAccountMap.put( aEntry.TorihikiSakiBango__c, aEntry );
        }

        List<Account> theAccountToBeUpdated = new List<Account>();
        for(KeiriTorihikiSakiNameImp__c  aNewOne : pNewOnes){
            Account theAccount = theTorihikiSakiBangoToAccountMap.get( aNewOne.TorihikiSakiBango__c );
            if(theAccount == null) continue;
            theAccountToBeUpdated.add( 
                new Account(
                    Id = theAccount.Id,
                    KeiriTorihikiSakiName__c = aNewOne.KeiriTorihikiSakiName__c
                )
            );
        }
        UPDATE theAccountToBeUpdated;
	}
}