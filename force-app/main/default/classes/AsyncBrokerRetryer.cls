public class AsyncBrokerRetryer implements Schedulable {

	public void run(){
		List<AsyncBrokerReqPended__c> theAsyncBrokerReqPendeds =
		[
			select id, RequestName__c from AsyncBrokerReqPended__c
			where ShoriStatus__c = 'Created'
			limit 100
		];

		Set<String> theRequests = new Set<String>();
		for(AsyncBrokerReqPended__c aEntry : theAsyncBrokerReqPendeds){
			if( !String.isBlank(aEntry.RequestName__c) ){
				theRequests.add(aEntry.RequestName__c);
			}
			aEntry.ShoriStatus__c = 'Completed';
		}

		for(String aRequest : theRequests){
			Asyncs_Broker.requestStart(aRequest);
		}

		Update theAsyncBrokerReqPendeds;

		Delete [
			select Id
			from AsyncBrokerReqPended__c
			where CreatedDate <= :DateTime.now().addMonths(-3)
		];

	}
	public Void execute(SchedulableContext context){
		try{
			//unschedule me.
	        System.abortJob( context.getTriggerId() );

	        this.run();

	        //reschedule new one.
	        Integer theInterval = 5;
			String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
	        System.schedule('AsyncBrokerRetryer' + '(' + theNextTimeCron + ')', theNextTimeCron, new AsyncBrokerRetryer() );
		}catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181207-1703-01', 'AsyncBrokerRetryer.ScheduleRunFailed', 're-shedule needed.')
                	.putAttr('e.getMessage()', e.getMessage())
            );
		}
	}
}