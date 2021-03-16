public class QmsEvts {

    public static void onQmsEvtAfterInserted(List<QmsEvt__e> pNewOnes){
        try{
            hdlQmsEvts(pNewOnes);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190720-2031', 'QmsEvts.onQmsEvtAfterInserted')
                        .putAttr('Exception', ex.getMessage())
                        .putAttr('LineNumber', '' + ex.getLineNumber())
                        .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private static void hdlQmsEvts(List<QmsEvt__e> pNewOnes){
    	QmsEvt__e toBeRelayed = null;
    	List<QmsEvt__e> toBeCarryOvered = new List<QmsEvt__e>();
    	Long theCount = 0;
    	for(QmsEvt__e aQmsEvt : pNewOnes){
    		theCount ++;
            if( theCount == 1){
                toBeRelayed = aQmsEvt;
            }else{
                toBeCarryOvered.add(aQmsEvt);
            }
    	}

        if( toBeRelayed != null ){
            relayEvt(toBeRelayed);
            carryOverEvts(toBeCarryOvered);
            logPublish(toBeRelayed, toBeCarryOvered);
        }
    }

    private static void relayEvt(QmsEvt__e pQmsEvt){
        if( QmsDpcr.isQmsEvtToBeHandled(pQmsEvt.MsgType__c) ){ QmsDpcr.onQmsEvtRelayed(pQmsEvt); }
    }

    private static void carryOverEvts(List<QmsEvt__e> pQmsEvts){
    	for(QmsEvt__e aNewOne : cloneEvts(pQmsEvts) ){ QmsEvtPublisher.publishEvt(aNewOne); }
    }

    private static List<QmsEvt__e> cloneEvts(List<QmsEvt__e> pQmsEvts){
		List<QmsEvt__e> theNewOnes = new List<QmsEvt__e>();
    	for(QmsEvt__e aQmsEvt : pQmsEvts){
			theNewOnes.add(
				new QmsEvt__e(MsgType__c = aQmsEvt.MsgType__c, Data__c = aQmsEvt.Data__c)
			);
    	}
		return theNewOnes;
    }

    private static void logPublish(QmsEvt__e pToBeRelayed, List<QmsEvt__e> pToBeCarryOvered){
        QmsEvtPubLmts.writeTmpLog(pToBeRelayed, pToBeCarryOvered);
    }
}