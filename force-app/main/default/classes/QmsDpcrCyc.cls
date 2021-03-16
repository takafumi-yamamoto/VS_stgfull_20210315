public class QmsDpcrCyc implements Queueable{
	private static Integer getDispatchSize(){ return 20; }
	private static Integer getBottomDateOffset(){ return -30; }

	private String f_ProcId;
	private String f_MsgType;
	public QmsDpcrCyc(String pProcId, String pMsgType) {
		this.f_ProcId = pProcId;
		this.f_MsgType = pMsgType;
	}

    public void execute(QueueableContext context) {
		this.run();
    }

	public void run(){
		this.garbageCollect();
		if( this.toContinue() ){ tryContinue(); }
	}

	private Boolean toContinue(){ 
		Datetime theNow = Datetime.now();
		return
			[
				SELECT Id
				FROM Qms__c 
				WHERE ScheduledAt__c <= :theNow
				AND DispatchStatus__c = 'Created'
				AND ScheduledAt__c >= :theNow.addDays( QmsDpcrCyc.getBottomDateOffset() ) 
				LIMIT 1
			]
			.size() > 0;
	}

	private void tryContinue(){
		String theNewProcId = QmsDpcrProcs.requestNewProc();
		if( String.isBlank(theNewProcId) ) return;
		QmsEvtPublisher.publishEvt( new QmsEvt__e(MsgType__c = f_MsgType, Data__c = theNewProcId) );
	}

	private void garbageCollect(){
		Datetime theNow = Datetime.now();
		Datetime theDateTimeBottom = theNow.addDays( QmsDpcrCyc.getBottomDateOffset() );
		Datetime theDateTimeDelete = 
			Datetime.newInstance(
				theDateTimeBottom.year(),
				theDateTimeBottom.month(),
				theDateTimeBottom.day(),
				0, 0, 0
			);
		try{ 
			DELETE [ SELECT Id FROM Qms__c  WHERE ScheduledAt__c < :theDateTimeDelete LIMIT 1000 ];
		}catch(Exception ex){} //ignore delete exception.
		try{ 
			DELETE [ SELECT Id FROM QmsDpcrProc__c WHERE ExpireAt__c < :theDateTimeDelete LIMIT 1000 ];
		}catch(Exception ex){} //ignore delete exception.
	}

	public static List<Qms__c> getNextQmses(){
		Datetime theNow = Datetime.now();
		Integer theDispatchSize = getDispatchSize();
        return 
        	new List<Qms__c>(
	            [
	                SELECT Id, MsgType__c, Data__c,
					ChainNodeType__c, ChainNodeId__c, ChainRootId__c, ChainParentId__c, ChainDepth__c
	                FROM Qms__c 
	                WHERE ScheduledAt__c <= :theNow
					AND DispatchStatus__c = 'Created'
	                AND ScheduledAt__c >= :theNow.addDays( QmsDpcrCyc.getBottomDateOffset() )
	                LIMIT :theDispatchSize
	                FOR UPDATE //caution=should be with Lock!;
	            ]
        	);
	}
	public static void requestStart(String pProcId, String pMsgType){
		System.enqueueJob( new QmsDpcrCyc( pProcId, pMsgType ) ); 
	}
}