public class NpTorihikiDataImpTask implements Queueable{
	private Id f_TaskId = null;

	public NpTorihikiDataImpTask(Id pTaskId) {
		this.f_TaskId = pTaskId;
	}

    public void execute(QueueableContext context) {
    	try{
    		this.runTask( this.f_TaskId );
    	}catch(Exception ex){
	        Loggings.writeLog(
	            Loggings.createLogEntry(Loggings.Level.Error, '20190104-1418', 'NpTorihikiDataImpTask', 'UnhandledException')
	                .setSubjectRecordId(this.f_TaskId)
	                .putAttr(ex.getMessage(),'ex.getMessage()')
	        );
    	}
    }

    public void runTask(Id pTaskId){

        NpTorihikiDataImpTask__c theTask = 
        	(NpTorihikiDataImpTask__c)SobjectsExtension.firstOrNull(
	        	[
	            SELECT 
	            Id, KameitenTorihikiId__c, NpTorihikiId__c, TorihikiKingaku__c, NpStatus__c
	            FROM NpTorihikiDataImpTask__c 
	            WHERE Id = :pTaskId
	            Limit 1
	        	]
        	);
        if(theTask == null) return;

        Boolean theFinished = false;

        if(!theFinished){
        	if(String.isBlank(theTask.KameitenTorihikiId__c)) { theTask.ShoriStatus__c = 'Faulted'; theTask.ShoriDescr__c = 'invalid data'; theFinished = true; }
        	if(String.isBlank(theTask.NpTorihikiId__c)) { theTask.ShoriStatus__c = 'Faulted'; theTask.ShoriDescr__c = 'invalid data'; theFinished = true; }
        	if(String.isBlank(theTask.NpStatus__c)) { theTask.ShoriStatus__c = 'Faulted'; theTask.ShoriDescr__c = 'invalid data'; theFinished = true; }
        	if( theTask.TorihikiKingaku__c == null ) { theTask.ShoriStatus__c = 'Faulted'; theTask.ShoriDescr__c = 'invalid data'; theFinished = true; }
        }

        if(!theFinished){
        	List<String> theStatusToBeProcessed = new List<String>{
        		'請求書発行待ち',
        		'請求書発行済',
        		'審査OK'
        	};
        	if( !theStatusToBeProcessed.contains(theTask.NpStatus__c) ){
        		theTask.ShoriStatus__c = 'Completed'; theTask.ShoriDescr__c = 'Skipped; 処理対象外ステータス'; theFinished = true;
        	}
        	
        }
        

        if(!theFinished){
			PartnerNyukin__c thePartnerNyukinExist = (PartnerNyukin__c)SobjectsExtension.firstOrNull(
				[
				select Id
				from PartnerNyukin__c
				where NpTorihikiId__c = :theTask.NpTorihikiId__c
				limit 1
				]
			);
			if(thePartnerNyukinExist != null){ theTask.ShoriStatus__c = 'Completed'; theTask.ShoriDescr__c = 'Skipped; 既に取込済み'; theFinished = true; }
        }
        
        Opportunity theOpp = null;
        if(!theFinished){
			theOpp = (Opportunity)SobjectsExtension.firstOrNull(
				[
				select Id
				from Opportunity
				where ShodanBango__c = :theTask.KameitenTorihikiId__c
				limit 1
				]
			);
			if(theOpp == null){ theTask.ShoriStatus__c = 'Faulted'; theTask.ShoriDescr__c = '該当商談なし'; theFinished = true; }
        }

        if(!theFinished){
			Insert new PartnerNyukin__c(
				NpTorihikiId__c = theTask.NpTorihikiId__c,
				NyukinBi__c = System.Date.today(),
				ShodanRef__c = theOpp.Id,
				Kingaku__c = theTask.TorihikiKingaku__c
			);
			theTask.ShoriStatus__c = 'Completed'; theTask.ShoriDescr__c = ''; theFinished = true;
        }

        Update theTask;

    }
}