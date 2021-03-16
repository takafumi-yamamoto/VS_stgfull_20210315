public class QmsDpcrProcs {
	private static Integer getMaxConcurentProcs(){ return 2; } 
	private static Integer getProcExpirOffset(){ return 5; }

	public static String requestNewProc(){
		if( isConcurentProcsOver() ) return null;
		String theNewProcId = initNewProc();
		return theNewProcId;
	}

	private static Boolean isConcurentProcsOver(){
		Integer theMaxConcurentProcs = getMaxConcurentProcs();
		Integer theRunningProcCnt = 
		[
			SELECT Id FROM QmsDpcrProc__c 
			WHERE expireAt__c >= :Datetime.now() 
			AND isEnded__c = false
			LIMIT :theMaxConcurentProcs
		].size();
		return theRunningProcCnt >= theMaxConcurentProcs;
	}
	private static String initNewProc(){
		QmsDpcrProc__c theNewProc = new QmsDpcrProc__c( initedAt__c = Datetime.now(), expireAt__c = Datetime.now().addMinutes( getProcExpirOffset() ) );
		INSERT theNewProc;
		return theNewProc.Id;
	}
	public static void endProc(String pProcId){
        UPDATE New QmsDpcrProc__c(Id=pProcId, isEnded__c = true);
	}
}