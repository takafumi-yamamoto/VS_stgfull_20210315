public class QmsDpat implements Queueable, Database.AllowsCallouts{
	private Qms__c f_Qms;
	private IHdlQms f_Handler;
	public QmsDpat(Qms__c pQms, IHdlQms pHandler) {
		this.f_Qms = pQms;
		this.f_Handler = pHandler;
	}

	public void dispatch(){
		try{
			this.f_Handler.handleQms(f_Qms);
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190722-1553', 'QmsDpat.handleQms.dispatch','dispatchFailed')
					.setSubjectRecordId(f_Qms.Id)
					.putAttr('f_Qms.MsgType__c', f_Qms.MsgType__c )
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
			try{ UPDATE New Qms__c(Id = f_Qms.Id, ShoriStatus__c = 'Failed'); }catch(Exception e){ }//IgnoreError
		}	
	}

    public void execute(QueueableContext context) {
		this.dispatch();
    }

	public static void startDispatch(Qms__c pQms, IHdlQms pHandler){
		System.enqueueJob( new QmsDpat(pQms, pHandler) ); 
	}
}