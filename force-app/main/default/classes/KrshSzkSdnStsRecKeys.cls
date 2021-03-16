public class KrshSzkSdnStsRecKeys {
	public static void assignIfNotAssigned(List<KrshSzkSdnStsRec__c> pNewOnes){

		List<KrshSzkSdnStsRecKey__c> theKeyEntries = new List<KrshSzkSdnStsRecKey__c>();
		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){
			theKeyEntries.add( new KrshSzkSdnStsRecKey__c() );
		}
		INSERT theKeyEntries;

		List<String> theKeys = new List<String>();
		for( KrshSzkSdnStsRecKey__c aKeyEntry : [
			SELECT Id, Name
			FROM KrshSzkSdnStsRecKey__c 
			WHERE Id IN :SobjectsExtension.collectIds(theKeyEntries)
		] ){
			theKeys.add( aKeyEntry.Name );
		}

		Integer theIdx = 0;
		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){
			if( String.isBlank(aNewOne.Key__c) ){
				aNewOne.Key__c = theKeys.get(theIdx);
			}
			theIdx ++;
		}
		DELETE theKeyEntries;
	}
}