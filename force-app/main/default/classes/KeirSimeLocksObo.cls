public class KeirSimeLocksObo {

	private static String SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED = '売上日が経理締切済みのため、経理計上に影響する変更はできません;';
	private static String OPP_CLOSED_SO_CHANGES_ARE_DENIED = 'フェーズが商談クローズ中のため変更できません。フェーズを戻してから変更してください。;';

	public Boolean inClosedOpp_anyChgNotAcceptable(Opportunity pOldOne, Opportunity pNewOne){
		if( pOldOne.Utiagebi__c != pNewOne.Utiagebi__c ) return true;
		if( pOldOne.NyukinSimekiriBiPartner__c != pNewOne.NyukinSimekiriBiPartner__c ) return true;
		if( pOldOne.ShiharaiKijitsuPartner__c != pNewOne.ShiharaiKijitsuPartner__c ) return true;
		return false;
	}

	public class OnObosanbin{
		private KeirSimeLocksChgNotAllows mKeirSimeLocksChgNotAllows = new KeirSimeLocksChgNotAllows();
		public OnObosanbin(KeirSimeLocksChgNotAllows pKeirSimeLocksChgNotAllows){
			this.mKeirSimeLocksChgNotAllows = pKeirSimeLocksChgNotAllows;
		}

		public void onObosanbinBeforeUpdate(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){
			if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
			Set<Id> theObosanbinIdsToBeProcessed = new Set<Id>();
			for(Obosanbin__c aNewOne : pNewOnes){
				Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);
				if(aNewOne.ObosanbinKeiyakuMadoguchi__c != aOldOne.ObosanbinKeiyakuMadoguchi__c){
					theObosanbinIdsToBeProcessed.add(aNewOne.Id);
				}
			}
			Set<Id> theOboIdToBeDeniedForSimekiri = new Set<Id>();
			Set<Id> theOboIdToBeDeniedForClosedOpp = new Set<Id>();

			//Set<Id> theObosanbinIdsToBeDenied = new Set<Id>();
			if( theObosanbinIdsToBeProcessed.size() > 0 ){
				for(Opportunity aOpp : [
					SELECT Id, RecordTypeId, isWon, Utiagebi__c, ObosanbinRef__c
					FROM Opportunity 
					WHERE ObosanbinRef__c = :theObosanbinIdsToBeProcessed
				]){
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForSimekiri(aOpp.RecordTypeId, aOpp.Utiagebi__c, aOpp.isWon) )
					{ theOboIdToBeDeniedForSimekiri.add( aOpp.ObosanbinRef__c); }
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForClosedOpp(aOpp.RecordTypeId, aOpp.isWon) )
					{ theOboIdToBeDeniedForClosedOpp.add( aOpp.ObosanbinRef__c); }
				}
			}
			for(Obosanbin__c aNewOne : pNewOnes){
				if( theOboIdToBeDeniedForSimekiri.contains(aNewOne.Id) ){
					aNewOne.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
				}
				if( theOboIdToBeDeniedForClosedOpp.contains(aNewOne.Id) ){
					aNewOne.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
				}
			}
		}
	}
}