public class Trg_Lead {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Lead(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<Lead> pNewOnes){
		new Ctl_Lead().initialProcessing(pNewOnes, null);
	}

	public void OnAfterUpdated(List<Lead> pNewOnes, Map<Id, Lead> pOldOnes){
		Map<Id, Account> theAccounts = this.selectAccounts(pNewOnes, pOldOnes);
		new Ctl_Lead().startTrading(pNewOnes, pOldOnes);
		new TeikeiProc().onLeadAfterUpdated(pNewOnes, pOldOnes, theAccounts);
	}

	private Map<Id, Account> selectAccounts(List<Lead> pNewOnes, Map<Id, Lead> pOldOnes){
		Set<Id> theIds = new Set<Id>();

		for(Lead aLead : pNewOnes){
			if(aLead.ConvertedAccountId != null) theIds.add(aLead.ConvertedAccountId);
		}

		if(pOldOnes != null){
			for( Lead aLead : pOldOnes.values() ){
				if(aLead.ConvertedAccountId != null) theIds.add(aLead.ConvertedAccountId);
			}		
		}

		if( theIds.size() <= 0 ) return new Map<Id, Account>();
		return new Map<Id, Account>(
			[
				select Id, RecordTypeId
				from Account
				where Id = :theIds
			]
		);
	}
}