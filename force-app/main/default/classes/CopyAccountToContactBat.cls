public class CopyAccountToContactBat{
    public void ATC(){}

/*
global class CopyAccountToContactBat implements Database.Batchable<sObject>{

	public static void Batstart(){
		if(isBatchActive()) return;
		Integer theBatchSize = Integer.valueOf(System.Label.BatchSizeCopyAccountToContact);
		Database.executeBatch(new CopyAccountToContactBat(), theBatchSize);
	}

	private static Boolean isBatchActive(){
		//the apex-class-name of AsyncApexJob is not internal class's name but root-class'name
		String theBatchName = CopyAccountToContactBat.Class.toString();
		List<AsyncApexJob> theJobs = [
			SELECT Id, ApexClass.Name from AsyncApexJob 
			where Status in ('Holding','Queued','Preparing','Processing') 
			and ApexClass.Name = :theBatchName
			and JobType in ('BatchApex','BatchApexWorker')
			Limit 1
		];
		return theJobs.size() >= 1;
	}


	public Database.QueryLocator start(Database.BatchableContext bc) {

		return Database.getQueryLocator([SELECT Id, AccIdBango__c
									FROM CopyAccountToContact__c 
									WHERE ToBeProced__c = True]);

	}

	public void execute(Database.BatchableContext bc, List<CopyAccountToContact__c> scope){

		try{
			this.Batrun(scope);

			if(Test.isRunningTest()){
				CalloutException e = new CalloutException();
				e.setMessage('This is a constructed exception!');
				throw e;
			}
		
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20200217-1500-01', 'CopyAccountToContactBat.execute')
					.putAttr('ex.getMessage()', ex.getMessage())
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
					.putAttr('ex.getStackTraceString()', ex.getStackTraceString()
				)
			);
		}

	}

	public void finish(Database.BatchableContext bc){
		//特に処理はしない
	}


	private void Batrun(List<CopyAccountToContact__c> scope){
		SET<String> SETAccIdBango = new SET<String>();
		SET<String> SETAOCRId = new SET<String>();
		
		for(CopyAccountToContact__c ascope :scope){
			SETAccIdBango.add(ascope.AccIdBango__c);
			SETAOCRId.add(ascope.Id);
		}
		
		List<Account> ListAcc = [SELECT 
									Id, 
									PersonContactId, 
									KoukokuDmNg__c, 
									KoukokuSmsNg__c, 
									KaihoshiNG__c, 
									ClaimAllNum__c, 
									MobilePhone__c, 
									YusenMailAddressFormula__c, 
									TorihikisakiBango__c, 
									Syushi__c, 
									Syuha__c, 
									HakaUmuKubun__c, 
									SonotanoSyukyoSyuha__c, 
									BodaijinoUmu__c, 
									MemberTokutenKubun__c, 
									BillingCountry, 
									BillingState, 
									BillingCity, 
									BillingStreet, 
									BillingPostalCode
								FROM Account
								Where Id in :SETAccIdBango];

		if(ListAcc.size() > 0){
			LIST<Contact> ListCon = new LIST<Contact>();
			for(Account aAcc :ListAcc){
				Contact aCon = new Contact(
					Id = aAcc.PersonContactId,
					mkto71_KoukokuDmNg__c = aAcc.KoukokuDmNg__c,
					mkto71_KoukokuSmsNg__c = aAcc.KoukokuSmsNg__c,
					mkto71_KaihoshiNG__c = aAcc.KaihoshiNG__c,
					mkto71_ClaimAllNum__c = aAcc.ClaimAllNum__c,
					MobilePhone = aAcc.MobilePhone__c,
					Email = aAcc.YusenMailAddressFormula__c,
					mkto71_TorihikisakiBango__c = aAcc.TorihikisakiBango__c,
					mkto71_Syushi__c = aAcc.Syushi__c,
					mkto71_JiinSyuha__c = aAcc.Syuha__c,
					mkto71_HakaUmuKubun__c = aAcc.HakaUmuKubun__c,
					mkto71_SonotanoSyukyoSyuha__c = aAcc.SonotanoSyukyoSyuha__c,
					mkto71_BodaijinoUmu__c = aAcc.BodaijinoUmu__c,
					mkto71_MemberTokutenKubun__c = aAcc.MemberTokutenKubun__c,
					MailingCountry = aAcc.BillingCountry,
					MailingState = aAcc.BillingState,
					MailingCity = aAcc.BillingCity,
					MailingStreet = aAcc.BillingStreet,
					MailingPostalCode = aAcc.BillingPostalCode
				);
				ListCon.add(aCon);
			}
			if(ListCon.size() > 0){
				update ListCon;
			}
		}

		List<CopyAccountToContact__c> ListAOPCR = [SELECT Id, AccIdBango__c, LastProcVersion__c 
														FROM CopyAccountToContact__c 
														WHERE Id in :SETAOCRId];
		
		Long NewVerNo = genNewVerNo();
		if(ListAOPCR.size() > 0){
			for(CopyAccountToContact__c aAOPCR :ListAOPCR){
				aAOPCR.LastProcVersion__c = NewVerNo;
			}
			update ListAOPCR;
		}
		
	}

	public static Long genNewVerNo(){
		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		return LongDate;
	}
}
*/
}