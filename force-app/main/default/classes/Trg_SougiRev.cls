public class Trg_SougiRev {
    
	public void OnBeforeInsert(List<SougiRev__c> newList){
	}

	public void OnBeforeUpdate(List<SougiRev__c> newList, Map<ID, SougiRev__c> oldMap){
	}

	public void OnAfterInsert(List<SougiRev__c> newList){
		new Ctl_SougiRev().setSearchTxt(newList, null);
	}

	public void OnAfterUpdate(List<SougiRev__c> newList, Map<ID, SougiRev__c> oldMap){
		new KeirSimeLocksRevi.OnSougiRevi(new KeirSimeLocksChgNotAllows())
			.onSougiReviBeforeUpdate(newList, oldMap);
			
		new Ctl_SougiRev().setSearchTxt(newList, oldMap);
		new Ctl_SougiRev().setSearchTxtKetteisaki(newList, oldMap);
		new Ctl_SougiRev_SyncToOpp().onReviAfterUpdate(newList, oldMap);
		new Ctl_SougiRev_UriageDate().onReviAfterUpdate(newList, oldMap);
	}
}