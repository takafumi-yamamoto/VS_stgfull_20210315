public class OppLineItemJidoToroku
{
	private static String TeigakuTehaiShohinBango = 'SBG-0000291';
	private static Id OppObosanbinRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();

	public void onOppAfterUpdated(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){

		List<Opportunity> theProcTargets = new List<Opportunity>();
		for(Opportunity aNewOne : pNewOnes){
			Opportunity aOldOne = pOldOnes.get(aNewOne.Id);
			if( aNewOne.RecordTypeId != OppObosanbinRecordTypeId ) continue;
			if( aNewOne.RyunyumotoService__c == aOldOne.RyunyumotoService__c) continue;
			if( aNewOne.RyunyumotoService__c == '定額僧侶手配代行' ){
				theProcTargets.add(aNewOne);
			}
		}
		if( theProcTargets.size() <= 0 ) return;

		List<OpportunityLineItem> lineItemsToBeInserted = new List<OpportunityLineItem>();
		NewOppStates theNewOppStates = new NewOppStates().load( SobjectsExtension.collectIds(theProcTargets) );
		for(Opportunity aNewOne : theProcTargets){
			if( theNewOppStates.oppHasShohinByShohinBango( aNewOne.Id, TeigakuTehaiShohinBango ) ) continue;
			Product2 theProduct = new Product2(ShohinBango__c = TeigakuTehaiShohinBango);
			OpportunityLineItem theLineItem = new OpportunityLineItem( OpportunityId = aNewOne.Id, Product2 = theProduct );
			lineItemsToBeInserted.add(theLineItem);
		}
		INSERT lineItemsToBeInserted;

	}

	private class NewOppStates{
		private Map<Id, Opportunity> states = null;

		public NewOppStates load(List<Id> pOppIds){
			this.states = new Map<Id, Opportunity>([
				SELECT Id,
				(
					SELECT Id,
					Product2.ShohinBango__c 
					FROM 
					OpportunityLineItems
				)
				FROM Opportunity
				WHERE Id = :pOppIds
			]);
			return this;
		}
		public Boolean oppHasShohinByShohinBango(Id pOppId, String pShohinBango){
			Opportunity theOpp = states.get(pOppId);
			for(OpportunityLineItem aLineItem : theOpp.OpportunityLineItems){
				if( aLineItem.Product2.ShohinBango__c == pShohinBango ) return true;
			}
			return false;
		}
	}

}