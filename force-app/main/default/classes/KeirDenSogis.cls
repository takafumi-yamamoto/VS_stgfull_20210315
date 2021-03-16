public class KeirDenSogis{

	public static KeirDenSogis instance(){
		return new KeirDenSogis( new KeirDenSogiTransSlips(), KeirDenSogiFreees.instance() );
	}

	private KeirDenSogiTransSlips m_KeirDenSogiTransSlips = null;
	private KeirDenSogiFreees m_KeirDenSogiFreees = null;

	private KeirDenSogis(KeirDenSogiTransSlips pKeirDenSogiTransSlips, KeirDenSogiFreees pKeirDenSogiFreees){
		this.m_KeirDenSogiTransSlips = pKeirDenSogiTransSlips;
		this.m_KeirDenSogiFreees = pKeirDenSogiFreees;
	}

	public void renew(String pShodanBango, String pVersionToBeRenewed){

		List<KeirDen__c> theOldDenpyos = [SELECT Id, VersionLastKeiriSync__c FROM KeirDen__c WHERE ShodanBango__c= :pShodanBango];

		//経理が取り込んだVersion
		String  theLastSyncVer = '0';
		if( theOldDenpyos.size() > 0 ) theLastSyncVer = theOldDenpyos.get(0).VersionLastKeiriSync__c;

		Set<Id> theIdsOfOldKeirDen = new Set<Id>();
		for(KeirDen__c aKeirDen : theOldDenpyos){ theIdsOfOldKeirDen.add(aKeirDen.Id); }
		DELETE [ SELECT Id FROM FreDlCsvRow__c WHERE Id IN :theIdsOfOldKeirDen ];
		DELETE theOldDenpyos;

		Opportunity theOpp = this.m_KeirDenSogiTransSlips.getOppData(pShodanBango);

		Boolean toNewKuroden = theOpp != null 
			&& theOpp.RecordType.DeveloperName == 'SimpleYasugo'
			&& theOpp.IsClosed && theOpp.IsWon;

		if(!toNewKuroden) issueTorikeshiDenpyo(pShodanBango, theOpp, pVersionToBeRenewed, theLastSyncVer);

		try{
			if(toNewKuroden) issueNormalDenpyo(theOpp, pVersionToBeRenewed, theLastSyncVer);
		}catch(KeirDenSogis.InvalidDataException ex){
			issueErrDenpyo(pShodanBango, theOpp, pVersionToBeRenewed, theLastSyncVer);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20200130-1508', 'KeirDenSogis.issueNormalDenpyo')
					.putAttr('pShodanBango', pShodanBango)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	private void issueNormalDenpyo(Opportunity pOpp, String pVersionToBeRenewed, String pLastSyncVer){
		Opportunity theOpp = pOpp;

		if( theOpp.SeikyuZandaka__c != 0) throw new InvalidDataException('invalid:お客様への請求残高 != 0');

		String thePartnerId = theOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id;
		if( String.isBlank(thePartnerId) ) throw new InvalidDataException('invalid:送客先葬儀社 == null');


		//create 通常伝票
		KeirDen__c theNewKuroden = 
			new KeirDen__c(
				IssuedDateTime__c = Datetime.now(), VersionLatest__c = pVersionToBeRenewed, VersionLastKeiriSync__c = pLastSyncVer,
				DenpyoShubetsu__c = 'Sogi/Shodan', RenkeiShoriKbn__c = '通常',
				HasseiDate__c = theOpp.Utiagebi__c, 
				ShodanBango__c = theOpp.ShodanBango__c, OppRef__c = theOpp.Id,
				CustomerTorihikisakiBango__c = theOpp.Account.TorihikisakiBango__c, 
				CustomerRef__c = theOpp.AccountId, 
				PartnerTorihikisakiBango__c = theOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c, 
				PartnerRef__c = theOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id
			);
		INSERT theNewKuroden;

		List<FreDlCsvRow__c> theFreDlCsvRows = 
			this.m_KeirDenSogiFreees.toFreDlCsvRows(
				this.m_KeirDenSogiFreees.createDeals(
					this.m_KeirDenSogiTransSlips.createTransSlip(theOpp)
				),
				theOpp.ShodanBango__c
			);
		for(FreDlCsvRow__c aRow : theFreDlCsvRows){ aRow.KeirDenRef__c = theNewKuroden.Id; }
		INSERT theFreDlCsvRows;
	}

	private void issueTorikeshiDenpyo(String pShodanBango, Opportunity pOpp, String pVersionToBeRenewed, String pLastSyncVer){
		KeirDen__c theTorikeshiDen = 
			new KeirDen__c(
				IssuedDateTime__c = Datetime.now(), VersionLatest__c = pVersionToBeRenewed, VersionLastKeiriSync__c = pLastSyncVer,
				DenpyoShubetsu__c = 'Sogi/Shodan', RenkeiShoriKbn__c = '取消',
				HasseiDate__c = null,
				ShodanBango__c = pShodanBango, OppRef__c = pOpp == null ? null : pOpp.Id,
				CustomerTorihikisakiBango__c = null,
				CustomerRef__c = null, 
				PartnerTorihikisakiBango__c = null,
				PartnerRef__c = null
			);
		INSERT theTorikeshiDen;
	}

	private void issueErrDenpyo(String pShodanBango, Opportunity pOpp, String pVersionToBeRenewed, String pLastSyncVer){
		KeirDen__c theErrDen = 
			new KeirDen__c(
				IssuedDateTime__c = Datetime.now(), VersionLatest__c = pVersionToBeRenewed, VersionLastKeiriSync__c = pLastSyncVer,
				DenpyoShubetsu__c = 'Sogi/Shodan', RenkeiShoriKbn__c = 'エラー',
				HasseiDate__c = null,
				ShodanBango__c = pShodanBango, OppRef__c = pOpp == null ? null : pOpp.Id,
				CustomerTorihikisakiBango__c = null,
				CustomerRef__c = null, 
				PartnerTorihikisakiBango__c = null,
				PartnerRef__c = null
			);
		INSERT theErrDen;
	}

	public class InvalidDataException extends Exception {}
}