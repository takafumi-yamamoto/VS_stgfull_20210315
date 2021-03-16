public class QmsEvtPubLmts {

    private static Long getCurDurationKey(){
        return Long.valueOf( DateTime.now().format('yyyyMMddHH') );
    }

	public static void writeTmpLog(QmsEvt__e pQmsEvtRelayed, List<QmsEvt__e> pQmsEvtsCarryOvered ){
		Long theDurationKey = getCurDurationKey();
		INSERT new QmsEvtPubLmtTmpLog__c(
			LoggedDtm__c = DateTime.now(),
			RelayedEvtMsgType__c = pQmsEvtRelayed.MsgType__c,
			RelayedEvtData__c = pQmsEvtRelayed.Data__c,
			CarriedOveredEvtCnt__c = pQmsEvtsCarryOvered.size(),
			DurationKey__c = theDurationKey,
			PubCnt__c = 1,
			IsCollected__c = false
		);
        QmsEvtPubLmtLogColt.requestStart(theDurationKey);
	}

    public static Boolean isLimitOvered(){
        Long theDurationKey = getCurDurationKey();
        Long thePubCount = 0;
        for(QmsEvtPubLmtLog__c aQmsEvtPubLmtLog : [
            SELECT Id, PubCnt__c
            FROM QmsEvtPubLmtLog__c 
            WHERE DurationKey__c = :theDurationKey
            ORDER BY Name DESC
            LIMIT 1000
        ]){
            thePubCount += (Long)aQmsEvtPubLmtLog.PubCnt__c;
        }
        return thePubCount > 10000;
    }
}