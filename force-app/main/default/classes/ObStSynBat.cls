public class ObStSynBat implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

	private static Date startDateForSchedule = Date.today();
	private static Date endDateForSchedule = startDateForSchedule.addMonths(6);
	private static String defaultServiceRank = 'C';

	private class ProcEntry{
		public OboStSynVersion__c oboStSynVersion;
		public Keiyaku__c keiyaku;
		public List<Event> events = new List<Event>();
	}
	private List<ProcEntry> createProcEntries(List<OboStSynVersion__c> pOboStSynVersions){

		List<String> theKeiyakuBangos = new List<String>();
		for(OboStSynVersion__c aOboStSynVersion : pOboStSynVersions){
			if(aOboStSynVersion.KeiyakuBango__c != null) theKeiyakuBangos.add(aOboStSynVersion.KeiyakuBango__c);
		}

		Map<String, Keiyaku__c> theKeiyakusByKeiyakuBango = new Map<String, Keiyaku__c>();
		Set<Id> theAccountIds = new Set<Id>();
		for( Keiyaku__c akeiyaku :
			[
			SELECT Id,
			KeiyakuBango__c,KeiyakuJokyo__c,
			Syozokusangojiinme__c,
			Teikeisaki__r.YosinRef__c,
			Teikeisaki__r.YosinRef__r.NpTorihikiTorokuKahi__c,
			Teikeisaki__r.YosinRef__r.NpSaikenHoshoStatus__c,
			Teikeisaki__c,Teikeisaki__r.TorihikisakiBango__c,Teikeisaki__r.Name,
			Teikeisaki__r.Seinengappi__c,
			Teikeisaki__r.MobilePhone__c,
			Teikeisaki__r.ShozokuSangouSangoJiin__c, Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyusi__c, Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c,
			Teikeisaki__r.BillingPostalCode, Teikeisaki__r.BillingState, Teikeisaki__r.BillingCity, Teikeisaki__r.BillingStreet,
			Teikeisaki__r.BillingLatitude, Teikeisaki__r.BillingLongitude,
			Teikeisaki__r.PartnerHyokaRef__r.ServiceRank__c,
			ObousanBinTehaiKubun__c, AmazonTaioka__c, Kaimyojuyonomiirai__c, TeigakuTehaiTaioKahi__c, TaioufukaDay__c,
			KyuTesuryoTaioFlag__c,
			(
				SELECT Id, KeiyakuBango__c,
				Teikeisaki__r.TorihikisakiBango__c,
				Teikeisaki__r.Name
				FROM KeiyakusSyuKeiyaku__r
				WHERE RecordType.DeveloperName = 'ObousanBinJohouSya'
				AND KeiyakuJokyo__c = '契約中'
			),
			(
				SELECT Id
				FROM Keiyaku_TesuryoTekiyos__r
				WHERE ShoninStatus__c = '承認済'
				AND TekiyoKaishiBi__c <= :Date.today() AND TekiyoSyuryoBi__c >= :Date.today()
				AND isKyuTesuryoTaioExp__c = true
			)
			FROM Keiyaku__c
			WHERE KeiyakuBango__c =:theKeiyakuBangos
			]
		){
			theKeiyakusByKeiyakuBango.put( akeiyaku.KeiyakuBango__c, akeiyaku );
			theAccountIds.add(akeiyaku.Teikeisaki__c);
		}

		Map<Id, List<Contact>> theContacsPerAccountId = new Map<Id, List<Contact>>();
		Set<Id> theContactIds = new Set<Id>();
		for(Contact aContact :
			[select Id, AccountId from Contact WHERE AccountId = :theAccountIds]
		){
			if( !theContacsPerAccountId.containsKey( aContact.AccountId ) ) theContacsPerAccountId.put(aContact.AccountId, new List<Contact>());
			theContacsPerAccountId.get(aContact.AccountId).add(aContact);
			theContactIds.add(aContact.Id);
		}

		Map<Id, List<Event>> theEventsPerContactId = new Map<Id, List<Event>>();
		Datetime StartDateTime = Datetime.newInstance(startDateForSchedule.year(), startDateForSchedule.month(), startDateForSchedule.day());
		Datetime EndDateTime = Datetime.newInstance(endDateForSchedule.year(), endDateForSchedule.month(), endDateForSchedule.day(), 23, 59, 59);
		for( Event aEvent :
			[SELECT Id, whoId, StartDateTime, EndDateTime FROM Event WHERE whoId = :theContactIds AND StartDateTime >= :StartDateTime AND EndDateTime <= :EndDateTime ]
		){
			if( !theEventsPerContactId.containsKey( aEvent.whoId ) ) theEventsPerContactId.put(aEvent.whoId, new List<Event>());
			theEventsPerContactId.get(aEvent.whoId).add(aEvent);
		}

		List<ProcEntry> theProcEntries = new List<ProcEntry>();
		for(OboStSynVersion__c aOboStSynVersion : pOboStSynVersions){
			ProcEntry theProcEntry = new ProcEntry();
			theProcEntry.oboStSynVersion = aOboStSynVersion;
			Keiyaku__c theKeiyaku = theKeiyakusByKeiyakuBango.get(aOboStSynVersion.KeiyakuBango__c);

			if(theKeiyaku != null){
				theProcEntry.keiyaku = theKeiyaku;
			}

			if(theKeiyaku != null){
				List<Contact> theContacts = theContacsPerAccountId.get( theKeiyaku.Teikeisaki__c );
				for(Contact aContact : theContacts){
					List<Event> aEvents = theEventsPerContactId.get(aContact.Id);
					if(aEvents != null) theProcEntry.events.addAll(aEvents);
				}
			}
			theProcEntries.add(theProcEntry);
		}
		return theProcEntries;
	}

	private static String cmdType_Ignore_isNotYet = 'Ignore-isNotYet';
	private static String cmdType_Ignore_isDeleted = 'Ignore-isDeleted';
	private static String cmdType_Sync_Inactivate = 'Sync-Inactivate';
	private static String cmdType_Ignore_isInvalid = 'Ignore-invalid';
	private static String cmdType_Sync_Updated = 'Sync-Update';
	private String resolveCmdType(ProcEntry pProcEntry){

		if( this.isInactive(pProcEntry) && this.isExistInZaikoSys(pProcEntry) ) return cmdType_Sync_Inactivate;
		if( this.isInactive(pProcEntry) && !this.isExistInZaikoSys(pProcEntry) ) {
			return pProcEntry.keiyaku == null ? cmdType_Ignore_isDeleted : cmdType_Ignore_isNotYet;
		}
		if( !this.isValid(pProcEntry) ) return cmdType_Ignore_isInvalid;
		return cmdType_Sync_Updated;
	}
	private Boolean isInactive(ProcEntry pProcEntry){
		if(pProcEntry.keiyaku == null) return true;
		if(pProcEntry.keiyaku.ObousanBinTehaiKubun__c != '自社手配') return true;
		if(pProcEntry.keiyaku.KyuTesuryoTaioFlag__c) return true;
		if(pProcEntry.keiyaku.KeiyakuJokyo__c != '契約中') return true;
		if(pProcEntry.keiyaku.Teikeisaki__r.YosinRef__r.NpTorihikiTorokuKahi__c == '不可') return true;
		if(pProcEntry.keiyaku.Teikeisaki__r.YosinRef__r.NpSaikenHoshoStatus__c == 'NG') return true;
		Boolean isKyuTesuryo = pProcEntry.keiyaku.Keiyaku_TesuryoTekiyos__r.size() > 0;
		if(isKyuTesuryo) return true;
		if( new OboStConfig().isServiceRankToBeInactivated(pProcEntry.keiyaku.Teikeisaki__r.PartnerHyokaRef__r.ServiceRank__c) ) return true;
		return false;
	}
	private Boolean isExistInZaikoSys(ProcEntry pProcEntry){
		if(pProcEntry.oboStSynVersion.isExistInZaikoSys__c) return true;
		return false;
	}
	private Boolean isValid(ProcEntry pProcEntry) {
		Keiyaku__c keiyaku = pProcEntry.keiyaku;
		if( keiyaku == null ) return false;
		if( String.isBlank(keiyaku.Teikeisaki__r.BillingState) ) return false;
		if( String.isBlank(keiyaku.Teikeisaki__r.BillingCity) ) return false;
		if( String.isBlank(keiyaku.Teikeisaki__r.BillingStreet) ) return false;
		if( keiyaku.Teikeisaki__r.BillingLatitude == null ) return false;
		if( keiyaku.Teikeisaki__r.BillingLongitude == null ) return false;
		if( keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__c == null ) return false;
		if( keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c == null ) return false;
		return true;
	}

	private void proccedAnProcEntry(ProcEntry pProcEntry){

		try{
			String theCmdType = pProcEntry.oboStSynVersion.LastCmdType__c;
			if(theCmdType == cmdType_Ignore_isNotYet || theCmdType == cmdType_Ignore_isDeleted || theCmdType == cmdType_Ignore_isInvalid){
				pProcEntry.oboStSynVersion.LastProcVersion__c = pProcEntry.oboStSynVersion.LastVersion__c;
				pProcEntry.oboStSynVersion.isFailed__c = false;
			}
			if(theCmdType == cmdType_Sync_Inactivate){
				this.proceedSyncInactivate(pProcEntry);
			}
			if(theCmdType == cmdType_Sync_Updated){
				this.proceedSyncUpdate(pProcEntry);
			}

			if( pProcEntry.oboStSynVersion.isFailed__c ){
		        Loggings.writeLog(
		            Loggings.createLogEntry(Loggings.Level.Error, '20190416-1530-01', 'ObStSynBat.proccedAnProcEntry')
		            	.setSubjectRecordId(pProcEntry.oboStSynVersion.Id)
		        );
			}
		}catch(Exception e){
			pProcEntry.oboStSynVersion.isFailed__c = true;
			System.Debug(e);
	        Loggings.writeLog(
	            Loggings.createLogEntry(Loggings.Level.Error, '20190410-1924-02', 'ObStSynBat.proccedAnProcEntry')
	            	.setSubjectRecordId(pProcEntry.oboStSynVersion.Id)
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}
	private void proceedSyncInactivate(ProcEntry pProcEntry){
		OboStApi_InactivateSoryoCmdPost.Result theRes = new OboStApi_InactivateSoryoCmdPost().sendRequest(pProcEntry.keiyaku.KeiyakuBango__c);
		if(!theRes.isSuccess){
			pProcEntry.oboStSynVersion.isFailed__c = true;
			return;
		}

        Loggings.writeLog(
            Loggings.createLogEntry(
                Loggings.Level.Info, '20190426-1212-01', 'OboStApi_InactivateSoryoCmdPost.sendRequest')
                .putAttr('theResult.endPoint', theRes.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theRes.statusCode))
                .putAttr('theResult.reqBodyRaw',theRes.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theRes.resBodyRaw)
                .putAttr('theResult.descr',theRes.descr)
        );

		pProcEntry.oboStSynVersion.LastProcVersion__c = pProcEntry.oboStSynVersion.LastVersion__c;
		pProcEntry.oboStSynVersion.LastSyncVersion__c = pProcEntry.oboStSynVersion.LastVersion__c;
		pProcEntry.oboStSynVersion.isFailed__c = false;
		
	}
	private void proceedSyncUpdate(ProcEntry pProcEntry){

		OboStApi_SoryoPut.ReqBody theReqForSoryo = this.createOboStApi_SoryoPutReqBody(pProcEntry);
		OboStApi_SoryoPut.Result theResForSoryo = new OboStApi_SoryoPut().sendRequest(pProcEntry.keiyaku.KeiyakuBango__c, theReqForSoryo);
		if(!theResForSoryo.isSuccess){
			pProcEntry.oboStSynVersion.isFailed__c = true;
			return;
		}
		pProcEntry.oboStSynVersion.isExistInZaikoSys__c = true;

		OboStApi_SoryoSchedPut.ReqBody theReqForSchedule = this.createOboStApi_SoryoSchedPutReqBody(pProcEntry);
		OboStApi_SoryoSchedPut.Result theResForSchedule =
			new OboStApi_SoryoSchedPut().sendRequest(pProcEntry.keiyaku.Teikeisaki__r.TorihikisakiBango__c,theReqForSchedule);
		if(!theResForSchedule.isSuccess){
			pProcEntry.oboStSynVersion.isFailed__c = true;
			return;
		}

        Loggings.writeLog(
            Loggings.createLogEntry(
                Loggings.Level.Info, '20190416-1610-01', 'OboStApi_SoryoPut.sendRequest')
                .putAttr('theResult.endPoint', theResForSoryo.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResForSoryo.statusCode))
                .putAttr('theResult.reqBodyRaw',theResForSoryo.reqBodyRaw)
                .putAttr('theResult.resBodyRaw',theResForSoryo.resBodyRaw)
                .putAttr('theResult.descr',theResForSoryo.descr)
        );
       Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20190416-1610-02', 'OboStApi_SoryoSchedPut.sendRequest')
                    .putAttr('theResult.endPoint', theResForSchedule.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResForSchedule.statusCode))
                    .putAttr('theResult.reqBodyRaw',theResForSchedule.reqBodyRaw)
                    .putAttr('theResult.resBodyRaw',theResForSchedule.resBodyRaw)
                    .putAttr('theResult.descr',theResForSchedule.descr)
            );

		pProcEntry.oboStSynVersion.LastProcVersion__c = pProcEntry.oboStSynVersion.LastVersion__c;
		pProcEntry.oboStSynVersion.LastSyncVersion__c = pProcEntry.oboStSynVersion.LastVersion__c;
		pProcEntry.oboStSynVersion.isFailed__c = false;

	}
	private OboStApi_SoryoPut.ReqBody createOboStApi_SoryoPutReqBody(ProcEntry pProcEntry){

		Keiyaku__c keiyaku = pProcEntry.keiyaku;
		OboStApi_SoryoPut.ReqBody theReq = new OboStApi_SoryoPut.ReqBody();

		theReq.partner_id = keiyaku.Teikeisaki__r.TorihikisakiBango__c;
		theReq.partner_name = keiyaku.Teikeisaki__r.Name;
		theReq.shuha = String.isBlank(keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c) ? null : keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c;
		theReq.shushi = String.isBlank(keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyusi__c) ? null : keiyaku.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyusi__c;

		theReq.place.postal_code = String.isBlank(keiyaku.Teikeisaki__r.BillingPostalCode) ? null : keiyaku.Teikeisaki__r.BillingPostalCode;
		theReq.place.address = '';
		theReq.place.address += keiyaku.Teikeisaki__r.BillingState == null ? '' : keiyaku.Teikeisaki__r.BillingState;
		theReq.place.address += keiyaku.Teikeisaki__r.BillingCity == null ? '' : keiyaku.Teikeisaki__r.BillingCity;
		theReq.place.address += keiyaku.Teikeisaki__r.BillingStreet == null ? '' : keiyaku.Teikeisaki__r.BillingStreet;
		if(String.isBlank(theReq.place.address)) theReq.place.address = null;

		theReq.place.latitude = keiyaku.Teikeisaki__r.BillingLatitude;
		theReq.place.longitude = keiyaku.Teikeisaki__r.BillingLongitude;

		theReq.rank =
				String.isBlank(keiyaku.Teikeisaki__r.PartnerHyokaRef__r.ServiceRank__c)
				? defaultServiceRank
				: keiyaku.Teikeisaki__r.PartnerHyokaRef__r.ServiceRank__c;
		theReq.is_active = true;

		if(keiyaku.Kaimyojuyonomiirai__c == '不可能') theReq.unavailable_services.add( OboStApi_SoryoPut.ServiceFeatureTags_KaimyoOnly );
		if(!keiyaku.AmazonTaioka__c) theReq.unavailable_services.add( OboStApi_SoryoPut.ServiceFeatureTags_AmazonYahoo );
		if(keiyaku.TeigakuTehaiTaioKahi__c == '不可') theReq.unavailable_services.add( OboStApi_SoryoPut.ServiceFeatureTags_TeigakuTehaiDaiko );

		for(Keiyaku__c sekoshakeiyaku : keiyaku.KeiyakusSyuKeiyaku__r){
			OboStApi_SoryoPut.Sekosha sekosha = new OboStApi_SoryoPut.Sekosha();
			sekosha.contract_id = sekoshakeiyaku.KeiyakuBango__c;
			sekosha.partner_id = sekoshakeiyaku.Teikeisaki__r.TorihikisakiBango__c;
			sekosha.partner_name = sekoshakeiyaku.Teikeisaki__r.Name;
			theReq.contractors.add(sekosha);
		}

		theReq.temple = keiyaku.Syozokusangojiinme__c;

		return theReq;
	}
	private OboStApi_SoryoSchedPut.ReqBody createOboStApi_SoryoSchedPutReqBody(ProcEntry pProcEntry){
		OboStApi_SoryoSchedPut.ReqBody theReq = new OboStApi_SoryoSchedPut.ReqBody();
		Set<String> startAndEndSet = new Set<String>();
		for(Event aEnvet : pProcEntry.events){
			OboStApi_SoryoSchedPut.Event theEventData = new OboStApi_SoryoSchedPut.Event();
			theEventData.start_datetime = aEnvet.StartDateTime.format('yyyy-MM-dd HH:mm:00');
			theEventData.end_datetime = aEnvet.EndDateTime.format('yyyy-MM-dd HH:mm:00');
			if(startAndEndSet.contains( theEventData.start_datetime + theEventData.end_datetime )) continue;
			startAndEndSet.add( theEventData.start_datetime + theEventData.end_datetime );
			theReq.schedules.add(theEventData);
		}
		List<ObStWeekDuations.Duration> theAnAvailableDurations = new List<ObStWeekDuations.Duration>();
		if( pProcEntry.keiyaku.TaioufukaDay__c == '土日不可'){
			theAnAvailableDurations.addAll(
				ObStWeekDuations.getWeekEndDaysDurations(startDateForSchedule, endDateForSchedule)
			);
		}
		if( pProcEntry.keiyaku.TaioufukaDay__c == '平日不可'){
			theAnAvailableDurations.addAll(
				ObStWeekDuations.getWeekDaysDurations(startDateForSchedule, endDateForSchedule)
			);
		}
		for(ObStWeekDuations.Duration aDuration : theAnAvailableDurations){
			OboStApi_SoryoSchedPut.Event theEventData = new OboStApi_SoryoSchedPut.Event();
			theEventData.start_datetime = aDuration.fromDateTime.format('yyyy-MM-dd HH:mm:00');
			theEventData.end_datetime = aDuration.toDateTime.format('yyyy-MM-dd HH:mm:00');
			theReq.schedules.add(theEventData);
		}

		return theReq;
	}

	public void run(List<OboStSynVersion__c> pOboStSynVersion){
		List<ProcEntry> theProcEntries = this.createProcEntries(pOboStSynVersion);

		for(ProcEntry aProcEntry:theProcEntries){
			aProcEntry.oboStSynVersion.LastCmdType__c = this.resolveCmdType(aProcEntry);
		}

		for(ProcEntry aProcEntry:theProcEntries){
			this.proccedAnProcEntry(aProcEntry);
		}

		Map<Id, OboStSynVersion__c> theOboStSynVersionToBeUpd = new Map<Id,OboStSynVersion__c>();
		for(ProcEntry aProcEntry:theProcEntries){
			OboStSynVersion__c theOboStSynVersion =
				new OboStSynVersion__c(
					Id = aProcEntry.oboStSynVersion.Id,
					LastCmdType__c = aProcEntry.oboStSynVersion.LastCmdType__c,
					isExistInZaikoSys__c = aProcEntry.oboStSynVersion.isExistInZaikoSys__c,
					LastProcVersion__c = aProcEntry.oboStSynVersion.LastProcVersion__c,
					LastSyncVersion__c = aProcEntry.oboStSynVersion.LastSyncVersion__c,
					isFailed__c =  aProcEntry.oboStSynVersion.isFailed__c,
					KeiyakuRef__c = aProcEntry.keiyaku == null ? null : aProcEntry.keiyaku.Id
				);
			theOboStSynVersionToBeUpd.put(theOboStSynVersion.Id, theOboStSynVersion);
		}

		UPDATE theOboStSynVersionToBeUpd.values();

	}

	public static String getQuery(){
		String theQuery = 'SELECT id, ';
		theQuery += 'KeiyakuBango__c, ';
		theQuery += 'LastCmdType__c, isFailed__c, ';
		theQuery += 'LastVersion__c, LastProcVersion__c, LastSyncVersion__c, isExistInZaikoSys__c ';
		theQuery += 'FROM OboStSynVersion__c ';
		theQuery += 'WHERE IsProcessed__c = False ';
		theQuery += 'ORDER by LastVersion__c ';
		return theQuery;
	}

	public Database.QueryLocator start(Database.BatchableContext BC) { return Database.getQueryLocator( getQuery() ); }
   	public void execute(Database.BatchableContext BC, List<OboStSynVersion__c> oboStSynVersionList) {
   		try{
   			this.run(oboStSynVersionList);
   		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(Loggings.Level.Error, '20190410-1924-01', 'ObStSynBat.execute')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
   		}

   	}
	public void finish(Database.BatchableContext BC) { }

}