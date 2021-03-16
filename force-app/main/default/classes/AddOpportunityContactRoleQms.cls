global class AddOpportunityContactRoleQms{

	private static String OPP_RECORDTYPE_ID_SIMPLEYASUGO = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

	public static void OnAfterInsert(List<Opportunity> pNewOnes){

		SET<String> oppShodanBango = New SET<String>();
		
		for(Opportunity aNewOne : pNewOnes){
			if(aNewOne.RecordTypeId == OPP_RECORDTYPE_ID_SIMPLEYASUGO){
					oppShodanBango.add(aNewOne.ShodanBango__c);
			}
			
		}
		updateVersionToBe(oppShodanBango);
	}

	public static void OnAfterUpdate(List<Opportunity> pNewOnes, Map<Id, Opportunity> oldMap){

		SET<String> oppShodanBango = New SET<String>();
		
		for(Opportunity aNewOne : pNewOnes){
			if(aNewOne.RecordTypeId == OPP_RECORDTYPE_ID_SIMPLEYASUGO){
				Opportunity chkOpp = oldMap.get(aNewOne.ID);
				if((aNewOne.StageName != chkOpp.StageName)
				|| (aNewOne.SubPhase__c != chkOpp.SubPhase__c)){
					oppShodanBango.add(aNewOne.ShodanBango__c);
				}
			}
			
		}
		updateVersionToBe(oppShodanBango);
	}

	public static void updateVersionToBe(SET<String> oppShodanBango){
		Map<String, AddOpportunityContactRole__c> theDenVers = new Map<String, AddOpportunityContactRole__c>();
		for(String aShodanBango : oppShodanBango){
			theDenVers.put(
				aShodanBango,
				new AddOpportunityContactRole__c(
					ShodanBango__c = aShodanBango,
					OppVersion__c = genNewVerNo(),
					LastProcVersion__c = 0
				)
			);
		}
		UPSERT theDenVers.values() ShodanBango__c;
	}

	public static Long genNewVerNo(){
		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		return LongDate;
	}

}