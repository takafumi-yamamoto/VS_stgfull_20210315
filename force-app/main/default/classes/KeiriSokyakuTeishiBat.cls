global class KeiriSokyakuTeishiBat implements Database.Batchable<sObject>{

	public static void Batstart(){
		if(isBatchActive()) return;
		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT BatchSize__c
											FROM KeiriSokyakuTeishiBat__mdt
											WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
											Limit 1];
		Integer theBatchSize = Integer.valueOf(ACSP.BatchSize__c);
		Database.executeBatch(new KeiriSokyakuTeishiBat(), theBatchSize);
	}

	private static Boolean isBatchActive(){
		//the apex-class-name of AsyncApexJob is not internal class's name but root-class'name
		String theBatchName = KeiriSokyakuTeishiBat.Class.toString();
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

		return Database.getQueryLocator([SELECT Id, AccIdBango__c,KeiriSokyakuTeishiFlag__c
										FROM KeiriSokyakuTeishi__c 
										WHERE ToBeProced__c = True]);

	}

	public void execute(Database.BatchableContext bc, List<KeiriSokyakuTeishi__c> scope){

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
					Loggings.Level.Error, '20200312-1500-01', 'KeiriSokyakuTeishiBat.execute')
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

	private void Batrun(List<KeiriSokyakuTeishi__c> scope){
		SET<String> SETAccIdBango = new SET<String>();
		SET<String> SETAOCRId = new SET<String>();
		MAP<String,Boolean> MapSETA = new MAP<String,Boolean>();
		
		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT 
														StopCustomerMessage__c,
														CancellationMessage__c,
														updateShokaiKa__c,
														updateSimpleHPKeisaiAri__c,
														updateKeiyakuJokyoSTOP__c,
														updateKeiyakuJokyoKaijo__c,
														RecordTypeName__c
													 FROM KeiriSokyakuTeishiBat__mdt
													 WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
													 Limit 1];

		String sRecordTypeName = ACSP.RecordTypeName__c;
		List<String> lRecordTypeName = sRecordTypeName.split(',');
		List<Id> ObjRecordType = new List<Id>();
		for(String Str :lRecordTypeName){
			ObjRecordType.add(Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get(Str).getRecordTypeId());
		}

		for(KeiriSokyakuTeishi__c ascope :scope){
			SETAccIdBango.add(ascope.AccIdBango__c);
			SETAOCRId.add(ascope.Id);
			MapSETA.put(ascope.AccIdBango__c,ascope.KeiriSokyakuTeishiFlag__c);
		}
		
		List<Keiyaku__c> ListKeiyaku = [SELECT 
											Id, 
											Teikeisaki__c,
											KeiriSokyakuTeishiFlag__c, 
											KeiyakuJokyo__c, 
											KeiyakuSikkouKasibi__c, 
											KeiyakuSikkoRiyu__c, 
											KeiyakuSikkouKaijoBi__c, 
											KeiyakuSikkouKaijoRiyu__c, 
											IsYosinOverStop__c, 
											Teikeisaki__r.KeiriSokyakuTeishiFlag__c 
										FROM Keiyaku__c
										WHERE Teikeisaki__c in :SETAccIdBango
										AND RecordTypeId in :ObjRecordType];

		if(ListKeiyaku.size() > 0){
			for(Keiyaku__c aKeiyaku :ListKeiyaku){
				if( aKeiyaku.Teikeisaki__r.KeiriSokyakuTeishiFlag__c ){
					if( aKeiyaku.KeiyakuJokyo__c == '契約中' ){
						aKeiyaku.KeiriSokyakuTeishiFlag__c = TRUE;
						aKeiyaku.KeiyakuJokyo__c = '失効中';
					}
				}else{
					aKeiyaku.KeiriSokyakuTeishiFlag__c = FALSE;
					if( aKeiyaku.KeiyakuJokyo__c == '失効中' ){
						Boolean not_to_Keiyakuchu = KeiyakuSikkoFactors.get_ISikkoFactorReader_instance().is_any_other_sikko_factor(
							KeiyakuSikkoFactors.get_ISikkoFactorReader_instance().select_keiyakus(new List<String>{aKeiyaku.id}).get(0),
							KeiyakuSikkoFactors.Factors.keiri_sokyaku_teishi
						);
						if( !not_to_Keiyakuchu ){
							aKeiyaku.KeiyakuJokyo__c = '契約中';
						} 
					}
				}
			}
			update ListKeiyaku;
		}

		List<Saijo__c> ListSaijo = [SELECT 
										Id, 
										HoyuShutaiSogishaJiinRef__c,
										KeiriSokyakuTeishiFlag__c,
										ShokaiKa__c, 
										BeforeAccountingShokaiKa__c,
										ShokaiKinshiRiyu__c, 
										SimpleHPKeisaiAri__c, 
										BeforeAccountingSimpleHPKeisaiAri__c, 
										SimpleHPKeisaiKinshiRiyu__c 
									FROM Saijo__c
									WHERE HoyuShutaiSogishaJiinRef__c in :SETAccIdBango];

		if(ListSaijo.size() > 0){
			for(Saijo__c aSaijo :ListSaijo){
				Boolean aShokaiKa = false;
				Boolean aSimpleHPKeisaiAri = false;
				if(MapSETA.get(aSaijo.HoyuShutaiSogishaJiinRef__c)){
					aShokaiKa = aSaijo.ShokaiKa__c;
					aSimpleHPKeisaiAri = aSaijo.SimpleHPKeisaiAri__c;
					aSaijo.KeiriSokyakuTeishiFlag__c = TRUE;
					aSaijo.ShokaiKa__c = ACSP.updateShokaiKa__c;
					aSaijo.BeforeAccountingShokaiKa__c = aShokaiKa;
					aSaijo.ShokaiKinshiRiyu__c = ACSP.StopCustomerMessage__c;
					aSaijo.SimpleHPKeisaiAri__c = ACSP.updateSimpleHPKeisaiAri__c;
					aSaijo.BeforeAccountingSimpleHPKeisaiAri__c = aSimpleHPKeisaiAri;
					aSaijo.SimpleHPKeisaiKinshiRiyu__c = ACSP.StopCustomerMessage__c;
				}else{
					if(aSaijo.KeiriSokyakuTeishiFlag__c){
						aShokaiKa = aSaijo.BeforeAccountingShokaiKa__c;
						aSimpleHPKeisaiAri = aSaijo.BeforeAccountingSimpleHPKeisaiAri__c;
						aSaijo.KeiriSokyakuTeishiFlag__c = FALSE;
						aSaijo.ShokaiKa__c = aShokaiKa;
						aSaijo.ShokaiKinshiRiyu__c = '';
						aSaijo.SimpleHPKeisaiAri__c = aSimpleHPKeisaiAri;
						aSaijo.SimpleHPKeisaiKinshiRiyu__c = '';
					}
				}
			}
			update ListSaijo;
		}

		List<KeiriSokyakuTeishi__c> ListAOPCR = [SELECT Id, AccIdBango__c, LastProcVersion__c 
												FROM KeiriSokyakuTeishi__c 
												WHERE Id in :SETAOCRId];
		
		Long NewVerNo = genNewVerNo();
		if(ListAOPCR.size() > 0){
			for(KeiriSokyakuTeishi__c aAOPCR :ListAOPCR){
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