public class ObOppCloseValids {

	public class ClosingValidation{

		private String oboRecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		public void onOppBeforeUpdate(List<Opportunity> pNewOnes, Map<Id,Opportunity> pOldOnes){
			for( Opportunity aNewOne : pNewOnes){ 
				if( aNewOne.RecordTypeId != this.oboRecTypeId ) continue;
				Opportunity aOldOne = pOldOnes.get(aNewOne.Id);
				this.onOppBeforeUpdate( aNewOne, aOldOne );
			}
		}
		private void onOppBeforeUpdate(Opportunity pNewOne, Opportunity pOldOne){
			if( pNewOne.isWon != pOldOne.isWon && pNewOne.isWon ){
				Decimal theSeikyuZan = 
					pNewOne.SeikyuZandaka__c == null ? 0 : pNewOne.SeikyuZandaka__c;

				if( theSeikyuZan != 0 ) pNewOne.addError('お客様請求残高は0にしてください;');
			}
		}

	}
}