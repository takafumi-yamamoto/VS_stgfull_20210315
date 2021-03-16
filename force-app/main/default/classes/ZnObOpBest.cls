public class ZnObOpBest {

	public class ZenkaiOboOppBest{

		public void onOppBeforeUpdate(List<Opportunity> pNewOnes, Map<ID, Opportunity> pOldOnes){
			UPDATE this.getUpdates(pNewOnes, pOldOnes);
		}

		public List<BestButsudan__c> getUpdates(List<Opportunity> pNewOnes, Map<ID, Opportunity> pOldOnes){

			List<Opportunity> theNewOnes_ToBeProcessed = new List<Opportunity>();
			{
				String theBestRecTypeId = 
					RecordTypeCachedDaos.getInstance()
					.SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan');

				for( Opportunity aNewOne : pNewOnes){
					Opportunity aOldOne = pOldOnes.get(aNewOne.Id);

					Boolean toProcess =
						aNewOne.RecordTypeId == theBestRecTypeId &&
						aNewOne.ZennkaiOboOppRef__c != aOldOne.ZennkaiOboOppRef__c &&
						aNewOne.ZennkaiOboOppRef__c != null;

					if( toProcess ) theNewOnes_ToBeProcessed.add(aNewOne);
				}
			}

			Map<String,Opportunity> theZenkaiOboOpps_ByOppId = new Map<String,Opportunity>();
			{
				Set<String> theZenkaiOboOppIds = new Set<String>();
				for(Opportunity aNewOne : theNewOnes_ToBeProcessed){
					theZenkaiOboOppIds.add( aNewOne.ZennkaiOboOppRef__c );
				}
				for(Opportunity aZenkaiOboOpp : [
					SELECT Id, ObosanbinRef__r.Taishosha1Ref__c
					FROM Opportunity
					WHERE Id IN :theZenkaiOboOppIds
				]){
					theZenkaiOboOpps_ByOppId.put( aZenkaiOboOpp.Id, aZenkaiOboOpp );
				}
			}

			Map<String, BestButsudan__c> theBest_ToBeUpdated = new Map<String, BestButsudan__c>();
			for(Opportunity aNewOne : theNewOnes_ToBeProcessed){
				Opportunity aZenkaiOboOpp = 
					theZenkaiOboOpps_ByOppId.get( aNewOne.ZennkaiOboOppRef__c );
				
				String theBestId = aNewOne.BestButsudanRef__c;

				theBest_ToBeUpdated.put(
					theBestId,
					new BestButsudan__c( 
						Id = theBestId, 
						TaishoshaRef__c =  aZenkaiOboOpp.ObosanbinRef__r.Taishosha1Ref__c
					)
				);
			}

			return theBest_ToBeUpdated.values();
		}

	}
	


}