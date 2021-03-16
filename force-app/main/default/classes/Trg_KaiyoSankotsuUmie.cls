public class Trg_KaiyoSankotsuUmie {
    
	public void OnBeforeInsert(List<KaiyoSankotsuUmie__c> newList){

	}

	public void OnBeforeUpdate(List<KaiyoSankotsuUmie__c> newList, Map<ID, KaiyoSankotsuUmie__c> oldMap){
		new KaiyoSankotsuUmieSetIkotsuSofusaki().setIkotsuSofusakiForUpdate(newList,oldMap);
	}

	public void OnAfterInsert(List<KaiyoSankotsuUmie__c> newList){
		new Ctl_KaiyoSankotsuUmie().setSearchTxt(newList, null);
	}

	public void OnAfterUpdate(List<KaiyoSankotsuUmie__c> newList, Map<ID, KaiyoSankotsuUmie__c> oldMap){
		new Ctl_KaiyoSankotsuUmie().setSearchTxt(newList, oldMap);
		new Ctl_KaiyoSankotsuUmie().setSearchTxtKetteisaki(newList, oldMap);
		new Ctl_KaiyoSankotsuUmie_SyncToOpp().onUmieAfterUpdate(newList, oldMap);
		new Ctl_KaiyoSankotsuUmie_UriageDate().onUmieAfterUpdate(newList, oldMap);
	}
}