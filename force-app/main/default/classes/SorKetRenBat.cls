public class SorKetRenBat implements Schedulable, Database.Batchable<sObject>{

	public void execute(SchedulableContext context) {
		try{
			SorKetRenBat.start();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20191125-1417-01', 'SorKetRenBat.execute','Batch cant start')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}

	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch(new SorKetRenBat(), 5);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        String theBatchName = SorKetRenBat.Class.toString();
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = :theBatchName
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

	public Database.QueryLocator start(Database.BatchableContext BC) { return Database.getQueryLocator( getQuery() ); }
	
	public static String getQuery(){
		String theQuery = 'SELECT ';
		theQuery += 'Id, ShodanBango__c, RecordTypeId, RecordType.DeveloperName, ';
		theQuery += 'StageName, SubPhase__c, ';
		theQuery += 'ObosanbinRef__r.MemorialServicePlan__c, ';
		theQuery += 'ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c, ';
		theQuery += 'SoryoKetteiRenrakuHoho__c, KiboShiharaiHouhou__c ';
		theQuery += 'FROM Opportunity ';
		theQuery += 'WHERE StageName = \'決定\' AND SubPhase__c = \'僧侶決定連絡\' ';
		theQuery += 'AND RecordType.DeveloperName = \'Obosanbin\' ';
		theQuery += 'AND SoryoKetteiRenrakuHoho__c IN (\'メール\',\'SMS\') ';
		theQuery += 'AND (NOT RyunyumotoService__c LIKE \'%手配代行%\') ';
		theQuery += 'AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c = \'自社手配\' ';
		return theQuery;
	}

   	public void execute(Database.BatchableContext BC, List<Opportunity> pRecords) {
   		try{
   			runs( pRecords );
   		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20191125-1411-01', 'SorKetRenBat.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
   		}
   	}
	
	public void finish(Database.BatchableContext BC) { }
	
	private static void runs(List<Opportunity> pOpps){

		for(Opportunity aOpp : pOpps){

			String thePlanKeitai = '';
			if( OboPlanKeitais.isHoyo(aOpp.ObosanbinRef__r.MemorialServicePlan__c) ) thePlanKeitai = '法要';
			if( OboPlanKeitais.isKaimyo(aOpp.ObosanbinRef__r.MemorialServicePlan__c) ) thePlanKeitai = '戒名';
			if( String.isBlank(thePlanKeitai) ) continue;

			run(aOpp.ShodanBango__c, thePlanKeitai, aOpp.KiboShiharaiHouhou__c, aOpp.SoryoKetteiRenrakuHoho__c);
		}
	}

	@TestVisible
	private static void run(String pShodanBango, String pPlanKeitai, String pShiharaiHoho, String pRenrakuHoho){

		String theShodanBango = pShodanBango;
		String thePlanKeitai = pPlanKeitai;
		String theKiboShiharaiHouhou = pShiharaiHoho;
		String theRenRakuHouhou = pRenrakuHoho;

		if( thePlanKeitai == '法要' && theKiboShiharaiHouhou == '現金' && theRenRakuHouhou == 'メール'){
			SorKetRenHoyoCachMailQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '法要' && theKiboShiharaiHouhou == '現金' && theRenRakuHouhou == 'SMS'){
			SorKetRenHoyoCachSdcQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '法要' && theKiboShiharaiHouhou == 'カード' && theRenRakuHouhou == 'メール'){
			SorKetRenHoyoCredMailQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '法要' && theKiboShiharaiHouhou == 'カード' && theRenRakuHouhou == 'SMS'){
			SorKetRenHoyoCredSdcQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '戒名' && theKiboShiharaiHouhou == '現金' && theRenRakuHouhou == 'メール'){
			SorKetRenKaimCachMailQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '戒名' && theKiboShiharaiHouhou == '現金' && theRenRakuHouhou == 'SMS'){
			SorKetRenKaimCachSdcQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '戒名' && theKiboShiharaiHouhou == 'カード' && theRenRakuHouhou == 'メール'){
			SorKetRenKaimCredMailQms.InsertAsRoot(theShodanBango);
		}
		if( thePlanKeitai == '戒名' && theKiboShiharaiHouhou == 'カード' && theRenRakuHouhou == 'SMS'){
			SorKetRenKaimCredSdcQms.InsertAsRoot(theShodanBango);
		}
	}

}