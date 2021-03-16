public class KeirDenVers {
	private static String OPP_RECORDTYPE_ID_OBOSANBIN = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
	private static String OPP_RECORDTYPE_ID_SIMPLEYASUGO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
	
	public class ShodanChgEntry{
		public String KeirSimekiriTarget = '';
		public String ShodanBango = '';
		public ShodanChgEntry(String pKeirSimekiriTarget, String pShodanBango){
			this.KeirSimekiriTarget = pKeirSimekiriTarget; this.ShodanBango = pShodanBango;
		}
	}
	public static void onOppAfterUpdated(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){

		List<ShodanChgEntry> theShodanChgEntrys = new List<ShodanChgEntry>();
		
		for(Opportunity aNewOne : pNewOnes){
			Opportunity aOldOne = pOldOnes.get(aNewOne.Id);

			if(aNewOne.IsWon != aOldOne.IsWon){
				if( aNewOne.RecordTypeId == OPP_RECORDTYPE_ID_OBOSANBIN ) {
					theShodanChgEntrys.add( new ShodanChgEntry('OBO_OPPS', aNewOne.ShodanBango__c ) );
				}
				if( aNewOne.RecordTypeId == OPP_RECORDTYPE_ID_SIMPLEYASUGO ){
					theShodanChgEntrys.add( new ShodanChgEntry('SOGI_OPPS', aNewOne.ShodanBango__c ) );
				}
			}
			
		}
		updateVersionToBe(theShodanChgEntrys);
	}

	public static void updateVersionToBe(List<ShodanChgEntry> pShodanChgEntrys){
		Map<String, KeirDenVer__c> theDenVers = new Map<String, KeirDenVer__c>();
		for(ShodanChgEntry aShodanChgEntry : pShodanChgEntrys){
			theDenVers.put(
				aShodanChgEntry.ShodanBango,
				new KeirDenVer__c(
					ShodanBango__c = aShodanChgEntry.ShodanBango,
					KeirSimekiri_Target__c = aShodanChgEntry.KeirSimekiriTarget, 
					VersionToBeRenewed__c = genNewVerNo() 
				)
			);
		}
		UPSERT theDenVers.values() ShodanBango__c;
	}
	public static String genNewVerNo(){
		return Datetime.now().format('yyyyMMddHHmmssSSS');
	}

	public static void renew(String pShodanBango, String pVersionToBeRenewed){
		Boolean isError = false;
		Opportunity theOpp = null;

		try{
			theOpp = [SELECT Id, RecordTypeId FROM Opportunity WHERE ShodanBango__c = :pShodanBango].get(0);
		}catch(Exception ex){
			isError = true;
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20191115-1819-01', 'KeirDenVers.renew', 'opp not found;')
                	.putAttr('pShodanBango', pShodanBango)
                	.putAttr('pVersionToBeRenewed', pVersionToBeRenewed)
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );	
		}
		
		if(!isError){
			try{
				if(theOpp.RecordTypeId == OPP_RECORDTYPE_ID_OBOSANBIN) OboKeirDenRenews.renew(pShodanBango);
				if(theOpp.RecordTypeId == OPP_RECORDTYPE_ID_SIMPLEYASUGO) KeirDenSogis.instance().renew(pShodanBango, pVersionToBeRenewed);
			}catch(Exception ex){
				isError = true;
				Loggings.writeLog(
					Loggings.createLogEntry(
						Loggings.Level.Error, '20191115-1826-01', 'KeirDenVers.renew')
						.putAttr('pShodanBango', pShodanBango)
						.putAttr('pVersionToBeRenewed', pVersionToBeRenewed)
						.putAttr('ex.getMessage()', ex.getMessage())
						.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
						.putAttr('ex.getStackTraceString()', ex.getStackTraceString()
					)
				);
			}
		}

		if(!isError){
			KeirDenVer__c theDenVerToBeUpdated =
				New KeirDenVer__c( 
					ShodanBango__c = pShodanBango, 
					OppRef__c = theOpp == null ? null : theOpp.Id,
					VersionLastRenewed__c = pVersionToBeRenewed, 
					LastRenewProcResult__c = 'Success' 
				);
			UPSERT theDenVerToBeUpdated ShodanBango__c;
		}
		if(isError){
			KeirDenVer__c theDenVerToBeUpdated =
				New KeirDenVer__c( 
					ShodanBango__c = pShodanBango, 
					OppRef__c = theOpp == null ? null : theOpp.Id,
					LastRenewProcResult__c = 'Error' 
				);
			UPSERT theDenVerToBeUpdated ShodanBango__c;
		}

	}
}