public class QmsEvtPublisher {

	public static void onQmsAfterInserted(List<Qms__c> pNewOnes){
		List<QmsEvt__e> theQmsEvts = new List<QmsEvt__e>();
		theQmsEvts.addAll( QmsDpcr.produceQmsEvts(pNewOnes) );
		publishEvts(theQmsEvts);
	}

    public static void publishEvt(QmsEvt__e pQmsEvt){
		publishEvts( new List<QmsEvt__e>{ pQmsEvt } );
    }

    public static void publishEvts(List<QmsEvt__e> pQmsEvts){

        if( QmsEvtPubLmts.isLimitOvered() ){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190720-0156-02', 'QmsEvtPublisher.PublishCountExceeded', 'event publishing is suspended by publishCountLimit')
            );
            return;
        }
		
		try{
			List<Database.SaveResult> theSaveResults = EventBus.publish(pQmsEvts);
			Boolean isAnyFailed = false;
			for(Database.SaveResult aResult : theSaveResults){
				if( !aResult.isSuccess() ) isAnyFailed = true;
			}
			if( isAnyFailed ){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190720-0115-02', 'QmsEvtPublisher.publish','PublishFaied')
				);
			}
		}catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190720-0120-03', 'QmsEvtPublisher.publish','PublishFaied')
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
            );
		}
    }
}