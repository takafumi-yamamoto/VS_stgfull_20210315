public class KeirDenSyncVerImpTrg {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public KeirDenSyncVerImpTrg(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void onBeforeInsert(List<KeirDenSyncVerImp__c > pNewOnes){

		{ //経理連携伝票
			Set<String> theShodanBangos = new Set<String>();
			for(KeirDenSyncVerImp__c aNewOne : pNewOnes){
				if( String.isBlank(aNewOne.ShodanBango__c) ) continue;
				String aShodanBango = this.omitHeadHash(aNewOne.ShodanBango__c);
				theShodanBangos.add( aShodanBango );
			}
			Map<String, KeirDen__c> theShodanbangoToKeirDenMap = new Map<String, KeirDen__c>();
			for(KeirDen__c  aEntry : [
				SELECT Id, ShodanBango__c  FROM KeirDen__c WHERE ShodanBango__c = :theShodanBangos
			]){
				theShodanbangoToKeirDenMap.put( aEntry.ShodanBango__c, aEntry );
			}

			Map<String,KeirDen__c> theKeirDenToBeUpdated = new Map<String,KeirDen__c>();
			for(KeirDenSyncVerImp__c  aNewOne : pNewOnes){
				String aShodanBango = this.omitHeadHash(aNewOne.ShodanBango__c);
				KeirDen__c theKeirDen = theShodanbangoToKeirDenMap.get( aShodanBango );
				if(theKeirDen == null) continue;
				if( theKeirDenToBeUpdated.containsKey(aShodanBango) ) continue;
				theKeirDenToBeUpdated.put( 
					aShodanBango,
					new KeirDen__c(
						Id = theKeirDen.Id,
						VersionLastKeiriSync__c = this.omitHeadHash(aNewOne.LastVersion__c)
					)
				);
			}
			UPDATE theKeirDenToBeUpdated.values();
		}

		{ //お坊専用伝票
			Set<String> theShodanBangos = new Set<String>();
			for(KeirDenSyncVerImp__c aNewOne : pNewOnes){
				if( String.isBlank(aNewOne.ShodanBango__c) ) continue;
				theShodanBangos.add(aNewOne.ShodanBango__c);
			}
			Map<String, OboKeirDen__c> theShodanbangoToOboKeirDenMap = new Map<String, OboKeirDen__c>();
			for(OboKeirDen__c  aEntry : [
				SELECT Id, ShodanBango__c  FROM OboKeirDen__c WHERE ShodanBango__c = :theShodanBangos
			]){
				theShodanbangoToOboKeirDenMap.put( aEntry.ShodanBango__c, aEntry );
			}

			Map<String,OboKeirDen__c> theOboKeirDenToBeUpdated = new Map<String,OboKeirDen__c>();
			for(KeirDenSyncVerImp__c  aNewOne : pNewOnes){
				OboKeirDen__c theOboKeirDen = theShodanbangoToOboKeirDenMap.get( aNewOne.ShodanBango__c );
				if(theOboKeirDen == null) continue;
				if( theOboKeirDenToBeUpdated.containsKey(aNewOne.ShodanBango__c) ) continue;
				theOboKeirDenToBeUpdated.put( 
					aNewOne.ShodanBango__c,
					new OboKeirDen__c(
						Id = theOboKeirDen.Id,
						LastSyncVersion__c = aNewOne.LastVersion__c
					)
				);
			}

			UPDATE theOboKeirDenToBeUpdated.values();
		}
	}

	private String omitHeadHash(String pValue){
		if( String.isBlank(pValue) ) return pValue;
		return pValue.left(1) == '#'
			? pValue.substring(1, pValue.length() )
			: pValue;
	}

}