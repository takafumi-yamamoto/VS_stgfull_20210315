public class KeirSimeLocksRevi {

	private static String SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED = '売上日が経理締切済みのため、経理計上に影響する変更はできません;';
	private static String OPP_CLOSED_SO_CHANGES_ARE_DENIED = 'フェーズが商談クローズ中のため変更できません。フェーズを戻してから変更してください。;';

	public Boolean inClosedOpp_anyChgNotAcceptable(Opportunity pOldOne, Opportunity pNewOne){
		if( pOldOne.Utiagebi__c != pNewOne.Utiagebi__c ) return true;
		if( pOldOne.NyukinSimekiriBiPartner__c != pNewOne.NyukinSimekiriBiPartner__c ) return true;
		if( pOldOne.ShiharaiKijitsuPartner__c != pNewOne.ShiharaiKijitsuPartner__c ) return true;
		return false;
	}

	public class OnSougiRevi{
		private KeirSimeLocksChgNotAllows mKeirSimeLocksChgNotAllows = new KeirSimeLocksChgNotAllows();
		public OnSougiRevi(KeirSimeLocksChgNotAllows pKeirSimeLocksChgNotAllows){
			this.mKeirSimeLocksChgNotAllows = pKeirSimeLocksChgNotAllows;
		}

		public void onSougiReviBeforeUpdate(List<SougiRev__c> pNewOnes, Map<Id, SougiRev__c> pOldOnes){
			if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
			Set<Id> theReviIdsToBeProcessed = new Set<Id>();
			for(SougiRev__c aNewOne : pNewOnes){
				SougiRev__c aOldOne = pOldOnes.get(aNewOne.Id);
				if(aNewOne.KetteiSogisya__c != aOldOne.KetteiSogisya__c){
					theReviIdsToBeProcessed.add(aNewOne.Id);
				}
			}
			Set<Id> theReviIdToBeDeniedForSimekiri = new Set<Id>();
			Set<Id> theReviIdToBeDeniedForClosedOpp = new Set<Id>();
			if( theReviIdsToBeProcessed.size() > 0 ){
				for(Opportunity aOpp : [
					SELECT Id, RecordTypeId, isWon, Utiagebi__c, SogiReviRef__c
					FROM Opportunity 
					WHERE SogiReviRef__c = :theReviIdsToBeProcessed
				]){
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForSimekiri(aOpp.RecordTypeId, aOpp.Utiagebi__c, aOpp.isWon) )
					{ theReviIdToBeDeniedForSimekiri.add( aOpp.SogiReviRef__c); }
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForClosedOpp(aOpp.RecordTypeId, aOpp.isWon) )
					{ theReviIdToBeDeniedForClosedOpp.add( aOpp.SogiReviRef__c); }
				}
			}
			for(SougiRev__c aNewOne : pNewOnes){
				if( theReviIdToBeDeniedForSimekiri.contains(aNewOne.Id) ){
					aNewOne.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
				}
				if( theReviIdToBeDeniedForClosedOpp.contains(aNewOne.Id) ){
					aNewOne.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
				}
			}
		}
	}

}