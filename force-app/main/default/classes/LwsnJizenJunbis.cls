public class LwsnJizenJunbis implements Database.Batchable<sObject>{

	private static String m_WebJizenJunbiCaseRecordTypeId = 
		Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();

	private Date mFromDate; private Date mToDate;
	public LwsnJizenJunbis(Date pFromDate, Date pToDate){ this.mFromDate = pFromDate; this.mToDate = pToDate; }

	public static void start(Date pFromDate, Date pToDate){

        Boolean isBatchActive = 
			[
				SELECT Id, ApexClass.Name from AsyncApexJob 
				where Status in ('Holding','Queued','Preparing','Processing') 
				and ApexClass.Name = :LwsnJizenJunbis.Class.toString()
				and JobType in ('BatchApex','BatchApexWorker')
				Limit 1
			]
			.size() >= 1;
		if( isBatchActive ) return;

		database.executebatch( new LwsnJizenJunbis(pFromDate, pToDate), 1 );
	}
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
                SELECT Id, CaseNumber
                FROM CASE
                WHERE DAY_ONLY(ToiawaseDate__c) >= : this.mFromDate
                AND DAY_ONLY(ToiawaseDate__c) <= : this.mToDate
                AND RecordTypeId = :m_WebJizenJunbiCaseRecordTypeId
				AND AccountId != null
            ]);
    }
    public void execute(Database.BatchableContext BC, List<Case> pRecords) {
		String theAllianceKeiyakuBango = new LwsnConfig().getAllianceKeiyakuBango();

        for(Case aRecord: pRecords) {
			try{
				new Runner().run( theAllianceKeiyakuBango, aRecord.CaseNumber );
			}catch(Exception ex){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20200331-2106-01', 'LwsnJizenJunbis.execute')
						.putAttr('ex.getMessage()', ex.getMessage())
						.putAttr('ex.getLineNumber()', String.valueOf(ex.getLineNumber()) )
						.putAttr('ex.getStackTraceString()', ex.getStackTraceString())
						.putAttr('aRecord.CaseNumber', aRecord.CaseNumber)
						.setSubjectRecordId(aRecord.Id)
				);
			}
        }
    }
	public void finish(Database.BatchableContext BC) {}

	public class Runner{
		public void run( String pAllianceKeiyakuBango, String pCaseNumber ){

			Case theCase = (Case)SobjectsExtension.firstOrNull(
				[
					SELECT Id, ToiawaseDate__c, AccountId
					FROM Case
					WHERE CaseNumber = :pCaseNumber
					AND RecordTypeId = :m_WebJizenJunbiCaseRecordTypeId
				]
			);
			if(theCase == null) return;

			Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT 
					Id, ShodanBango__c
					FROM Opportunity 
					WHERE AccountId = :theCase.AccountId
					AND RecordTypeId = :Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
					AND IsClosed = false
					AND Req_Day__c <= :theCase.ToiawaseDate__c
					AND AllianceRef__c != null AND AllianceRef__r.KeiyakuBango__c = :pAllianceKeiyakuBango
					ORDER BY Req_Day__c DESC
					LIMIT 1
				]
			);
			if(theOpp == null) return;

			Boolean theOppIsJizenJunbiAlready = [
				SELECT Id
				FROM LwsnJizenJunbi__c
				WHERE ShodanBango__c = :theOpp.ShodanBango__c
				AND JizenJunbiDate__c != NULL
			].size() > 0;
			if(theOppIsJizenJunbiAlready) return;

			UPSERT New LwsnJizenJunbi__c(
				ShodanBango__c = theOpp.ShodanBango__c,
				ShodanRef__c = theOpp.Id,
				JizenJunbiDate__c = 
					Date.newInstance( theCase.ToiawaseDate__c.year(), theCase.ToiawaseDate__c.month(), theCase.ToiawaseDate__c.day() ),
				CaseRef__c = theCase.Id
			) ShodanBango__c;
		}
	}


}