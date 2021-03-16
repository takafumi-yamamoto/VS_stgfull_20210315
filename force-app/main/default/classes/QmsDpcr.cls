public class QmsDpcr {
	private static String getMsgType(){ return 'QmsDpcr.dispatchQmses'; }

	public static List<QmsEvt__e> produceQmsEvts(List<Qms__c> pNewOnes){
		String theNewProcId = QmsDpcrProcs.requestNewProc();
		if( String.isBlank(theNewProcId) ) return new List<QmsEvt__e>();
		return new List<QmsEvt__e>{ new QmsEvt__e(MsgType__c = getMsgType(), Data__c = theNewProcId) };
	}

	public static Boolean isQmsEvtToBeHandled(String pQmsEvntMsgType){
		return pQmsEvntMsgType == getMsgType();
	}
	public static void onQmsEvtRelayed(QmsEvt__e pQmsEvt){
		String theProcId = pQmsEvt.Data__c;
		dispatchQmses();
		QmsDpcrProcs.endProc(theProcId);
		System.enqueueJob( new QmsDpcrCyc( theProcId, getMsgType() ) ); 
	}

	public static void dispatchQmses(){

        List<Qms__c> theQmses = QmsDpcrCyc.getNextQmses();

		for(Qms__c aQms : theQmses){ 
			try{
				dispatch(aQms);
			}catch(Exception ex){
				aQms.DispatchedHandlerName__c = null;
				aQms.DispatchStatus__c = 'DispatchFailed';
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190722-1146', 'QmsDpcr.DispatchFailed')
						.setSubjectRecordId(aQms.Id)
						.putAttr('aQms.MsgType__c', aQms.MsgType__c )
						.putAttr('Exception', ex.getMessage())
						.putAttr('LineNumber', '' + ex.getLineNumber())
						.putAttr('getStackTraceString', ex.getStackTraceString())
				);
			}
		}
		UPDATE theQmses;
	}

	private static void dispatch(Qms__c pQms){

		QmsHdlPvdr.ResolveHandlerResult theResolveHandlerResult = QmsHdlPvdr.resolveHandler(pQms.MsgType__c);

		if( theResolveHandlerResult.handler != null ){
			QmsDpat.startDispatch(pQms, theResolveHandlerResult.handler);
			pQms.DispatchedHandlerName__c = theResolveHandlerResult.handlerClassName;
			pQms.DispatchStatus__c = 'Dispatched';
		}

		if( theResolveHandlerResult.handler == null ){
			pQms.DispatchedHandlerName__c = null;
			pQms.DispatchStatus__c = 'NoHandler';
			pQms.ShoriStatus__c = 'Completed';
		}
	}

}