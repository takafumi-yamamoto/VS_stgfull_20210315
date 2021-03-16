public class KeirSimekiris {
	
	private static Map<String, Date> f_SimekiriDates_Cache = null;

	private static void loadSimekiriDates(){
		Map<String, Date> theSimekiriDates = new Map<String, Date>();

		for(KeirSimekiri__c aKeirSimekiri : 
			[
				SELECT Id, Target__c, SimekiriDate__c
				FROM KeirSimekiri__c
				WHERE SimekiriDate__c != null AND Target__c != null
			]	
		){
			if( String.isBlank(aKeirSimekiri.Target__c) ) continue;
			theSimekiriDates.put( aKeirSimekiri.Target__c, aKeirSimekiri.SimekiriDate__c );
		}
		f_SimekiriDates_Cache = theSimekiriDates;
	}

	public enum Targets {
		NONE,
		OBO_OPPS,
		SOGI_OPPS,
		REVI_OPPS
	}
	public static Boolean isAcceptableDate(Targets pTarget, Date pDate){
		if(pTarget == Targets.NONE) return true;
		String theKey = pTarget.name();
		if( f_SimekiriDates_Cache == null ) loadSimekiriDates();
		if( !f_SimekiriDates_Cache.containsKey(theKey) ) return true;
		return pDate > f_SimekiriDates_Cache.get(theKey);
	}
	public static KeirSimekiris.Targets resolveKeirSimekiriTargetByOppRecTypeId(Id pRecordTypeId){
		
		KeirSimekiris.Targets theSimekiriTarget = KeirSimekiris.Targets.NONE;
		if(pRecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId() ){
			theSimekiriTarget = KeirSimekiris.Targets.OBO_OPPS;
		}
		if(pRecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() ){
			theSimekiriTarget = KeirSimekiris.Targets.SOGI_OPPS;
		}
		if(pRecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SougiRev').getRecordTypeId() ){
			theSimekiriTarget = KeirSimekiris.Targets.REVI_OPPS;
		}
		return theSimekiriTarget;
	}
}