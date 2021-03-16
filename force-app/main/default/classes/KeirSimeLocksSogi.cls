public class KeirSimeLocksSogi {

	private static String SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED = '売上日が経理締切済みのため、経理計上に影響する変更はできません;';
	private static String OPP_CLOSED_SO_CHANGES_ARE_DENIED = 'フェーズが商談クローズ中のため変更できません。フェーズを戻してから変更してください。;';

	public Boolean inClosedOpp_anyChgNotAcceptable(Opportunity pOldOne, Opportunity pNewOne){
		if(
			pOldOne.Req_Day__c != pNewOne.Req_Day__c//問合せ日
			|| pOldOne.CloseDate != pNewOne.CloseDate
			|| pOldOne.KakuteibiSyodan__c != pNewOne.KakuteibiSyodan__c
			|| pOldOne.TesuryoPartner__c != pNewOne.TesuryoPartner__c
			|| pOldOne.JimuTesuryo__c != pNewOne.JimuTesuryo__c
			|| pOldOne.TokuyakutenTesuryoKihonbun__c != pNewOne.TokuyakutenTesuryoKihonbun__c
			|| pOldOne.TokuyakutenTesuryoUwanosebun__c != pNewOne.TokuyakutenTesuryoUwanosebun__c
			|| pOldOne.TesuryoPartnerForPlan__c != pNewOne.TesuryoPartnerForPlan__c
			|| pOldOne.TesuryoPartnerForOption__c != pNewOne.TesuryoPartnerForOption__c
			|| pOldOne.NyukinSimekiriBiPartner__c != pNewOne.NyukinSimekiriBiPartner__c
			|| pOldOne.ShiharaiKijitsuPartner__c != pNewOne.ShiharaiKijitsuPartner__c
			
		){
			return true;
		}
		return false;
	}

	public class OnSimpleYasugo{
		private KeirSimeLocksChgNotAllows mKeirSimeLocksChgNotAllows = new KeirSimeLocksChgNotAllows();
		public OnSimpleYasugo(KeirSimeLocksChgNotAllows pKeirSimeLocksChgNotAllows){
			this.mKeirSimeLocksChgNotAllows = pKeirSimeLocksChgNotAllows;
		}

		public void onSimpleYasugoBeforeUpdate(List<SimpleYasugo__c> pNewOnes, Map<Id, SimpleYasugo__c> pOldOnes){
			if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
			Set<Id> theSimpleYasugoIdsToBeProcessed = new Set<Id>();
			for(SimpleYasugo__c aNewOne : pNewOnes){
				SimpleYasugo__c aOldOne = pOldOnes.get(aNewOne.Id);
				if(aNewOne.SimpleYasugoKeiyakuRef__c != aOldOne.SimpleYasugoKeiyakuRef__c || 	//決定葬儀社名
					aNewOne.TaishoshaRef__c != aOldOne.TaishoshaRef__c){						//対象者
					theSimpleYasugoIdsToBeProcessed.add(aNewOne.Id);
				}
			}
			Set<Id> theSimpleIdToBeDeniedForSimekiri = new Set<Id>();
			Set<Id> theSimpleIdToBeDeniedForClosedOpp = new Set<Id>();

			if( theSimpleYasugoIdsToBeProcessed.size() > 0 ){
				for(Opportunity aOpp : [
					SELECT Id, RecordTypeId, isWon, Utiagebi__c, SimpleYasugoRef__c
					FROM Opportunity 
					WHERE SimpleYasugoRef__c = :theSimpleYasugoIdsToBeProcessed
				]){
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForSimekiri(aOpp.RecordTypeId, aOpp.Utiagebi__c, aOpp.isWon) )
					{ theSimpleIdToBeDeniedForSimekiri.add( aOpp.SimpleYasugoRef__c); }
					if( this.mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForClosedOpp(aOpp.RecordTypeId, aOpp.isWon) )
					{ theSimpleIdToBeDeniedForClosedOpp.add( aOpp.SimpleYasugoRef__c); }
				}
			}
			for(SimpleYasugo__c aNewOne : pNewOnes){
				if( theSimpleIdToBeDeniedForSimekiri.contains(aNewOne.Id) ){
					aNewOne.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
				}
				if( theSimpleIdToBeDeniedForClosedOpp.contains(aNewOne.Id) ){
					aNewOne.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
				}
			}
		}

	}


}