public class Ctl_OpportunityTransferJob implements Queueable,Database.AllowsCallouts{
   Opportunity Opp;
	public Ctl_OpportunityTransferJob(Opportunity syori){
		this.Opp = syori;
	}	
	
	public void execute(QueueableContext context) {
		system.debug('***Ctl_OpportunityTransferJob.execute.begin***');
		RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService service = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService();      
		service.runProc(Opp);
		system.debug('***Ctl_OpportunityTransferJob.execute.end***');	 
	}

}