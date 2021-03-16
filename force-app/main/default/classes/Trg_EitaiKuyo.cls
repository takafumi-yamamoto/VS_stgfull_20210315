public class Trg_EitaiKuyo {
    
	public void OnBeforeInsert(List<EitaiKuyo__c> newList){
	}

	public void OnBeforeUpdate(List<EitaiKuyo__c> newList, Map<ID, EitaiKuyo__c> oldMap){
	}

	public void OnAfterInsert(List<EitaiKuyo__c> newList){
		new Ctl_EitaiKuyo().setSearchTxt(newList, null);
	}

	public void OnAfterUpdate(List<EitaiKuyo__c> newList, Map<ID, EitaiKuyo__c> oldMap){
		new Ctl_EitaiKuyo().setSearchTxt(newList, oldMap);
		new Ctl_EitaiKuyo().setSearchTxtKetteisaki(newList, oldMap);
		new Ctl_EitaiKuyo_SyncToOpp().onEitaiAfterUpdate(newList, oldMap);
		new Ctl_EitaiKuyo_UriageDate().onEitaiKuyoAfterUpdate(newList, oldMap);
	}
}