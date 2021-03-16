public class TerapSgSeikTasks implements Database.Batchable<sObject>{
	private static String m_BatchName = TerapSgSeikTasks.Class.toString();
	private Date m_BillingYm;
	private TerapSgSeikTasksDst4Seiks m_TerapSgSeikTasksDst4Seiks;
	public TerapSgSeikTasks(
		TerapSgSeikTasksDst4Seiks pTerapSgSeikTasksDst4Seiks,
		Date pBillingYm
	){
		this.m_TerapSgSeikTasksDst4Seiks = pTerapSgSeikTasksDst4Seiks;
		this.m_BillingYm = pBillingYm;
	}
	public static TerapSgSeikTasks instance(Date pBillingYm){
		return new TerapSgSeikTasks( TerapSgSeikTasksDst4Seiks.instance(), pBillingYm.toStartOfMonth() );
	}

	//batchable-section begin
	public static void start(Date pBillingYm){
		if( isBatchActive() ) return;
		Integer theBatchSize = 10;
		database.executebatch( TerapSgSeikTasks.instance(pBillingYm) , theBatchSize );
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = :m_BatchName
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }
	public Database.QueryLocator start(Database.BatchableContext BC) { 
		Date theFromDate = this.m_BillingYm.toStartOfMonth();
		Date theToDate = theFromDate.addMonths(1).addDays(-1);
		return Database.getQueryLocator(
			[
				SELECT Id
				FROM TeiHehDaiKakinSchEnt__c
				WHERE BeginDate__c >= :theFromDate AND BeginDate__c <= :theToDate
			]
		);
		//return Database.getQueryLocator( this.getQuery() ); 
	}
   	public void execute(Database.BatchableContext BC, List<TeiHehDaiKakinSchEnt__c> pRecords) {
   		try{
   			this.exec( pRecords, this.m_BillingYm.toStartOfMonth() );
   		}catch(Exception ex){
	        this.reportBatchError( pRecords, ex );
   		}
   	}
	private void reportBatchError(List<TeiHehDaiKakinSchEnt__c> pRecords, Exception ex){
		Set<String> theIds = new Set<String>();
		for(TeiHehDaiKakinSchEnt__c aRecord : pRecords){ theIds.add(aRecord.Id); }
		Loggings.writeLog(
			Loggings.createLogEntry(Loggings.Level.Error, '20200221-1700', 'TerapSgSeikTasks.BatchError')
				.putAttr('theFailedRecordIds_TeiHehDaiKakinSchEnt.Id', JSON.serializePretty(theIds) )
				.putAttr('Exception', ex.getMessage())
				.putAttr('LineNumber', '' + ex.getLineNumber())
				.putAttr('getStackTraceString', ex.getStackTraceString())
		);
	}
	public void finish(Database.BatchableContext BC) { }
	//main-section begin


	public class SeikyuData{
		TerapSgSeik__c TerapSgSeik;
		List<TerapSgSeikLine__c> TerapSgSeikLines = new List<TerapSgSeikLine__c>();
		List<TerapSgSeikSekoLine__c> TerapSgSeikSekoLines = new List<TerapSgSeikSekoLine__c>();
		List<TerapSgSeikCallLine__c> TerapSgSeikCallLines = new List<TerapSgSeikCallLine__c>();
	}

	public void exec(List<TeiHehDaiKakinSchEnt__c> pRecords, Date pBillTargetYm){
		this.exec( SobjectsExtension.collectIds(pRecords), pBillTargetYm);
	}
	private void exec(List<String> pRecordIds, Date pBillTargetYm){

		List<SeikyuData> theSeikyuDatas = this.createSeikyus( pRecordIds, pBillTargetYm );

		this.saveSeikyuDatas(theSeikyuDatas);
	}
	public List<SeikyuData> createSeikyus(List<String> pRecordIds, Date pBillTargetYm){
		List<SeikyuData> theSeikyuDatas = new List<SeikyuData>();

		List<TerapSgSeikTasksDst4Seiks.DataForSeikyu> theDataForSeikyus = 
			this.m_TerapSgSeikTasksDst4Seiks.getDataSet( pRecordIds, pBillTargetYm ).getDataForSeikyus();

		for(TerapSgSeikTasksDst4Seiks.DataForSeikyu aDataForSeikyu : theDataForSeikyus ){

			SeikyuData aSeikyuData = null;
			try{
				aSeikyuData = this.createSeikyu( aDataForSeikyu, pBillTargetYm);
			}catch(Exception ex){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20200221-1819', 'TerapSgSeikTasks.createSeikyu')
						.putAttr('aDataForSeikyu.KakinEntData.KakinEntId', aDataForSeikyu.KakinEntData == null ? '' : aDataForSeikyu.KakinEntData.KakinEntId )
						.putAttr('Exception', ex.getMessage())
						.putAttr('LineNumber', '' + ex.getLineNumber())
						.putAttr('getStackTraceString', ex.getStackTraceString())
				);
				throw ex;
			}
			if( aSeikyuData != null ) theSeikyuDatas.add(aSeikyuData);
		}
		return theSeikyuDatas;
	}

	private SeikyuData createSeikyu(TerapSgSeikTasksDst4Seiks.DataForSeikyu pDataForSeikyu, Date pBillTargetYm){
		
		Date theBillingYm = pBillTargetYm.toStartOfMonth();
		Date theShiharaiKijitsu = theBillingYm.addMonths(2).addDays(-1);

		List<TerapSgSeikLine__c> theTerapSgSeikLines = new List<TerapSgSeikLine__c>();
		{ //請求明細
			TerapSgSeikTasksDst4Seiks.KakinEntData theKakinEntData = pDataForSeikyu.KakinEntData;
			List<TerapSgSeikTasksDst4Seiks.SekoData> theSekoDataList = pDataForSeikyu.SekoDataList;
			
			Boolean isNoKakinMonth = theKakinEntData.IsFirstMonth;

			if(theKakinEntData.KakinScheme == '定額課金' && !isNoKakinMonth){

				if(!isNoKakinMonth){

					String theDescr = String.format(
						'{0}月度　僧侶手配代行サービス',
						new List<String>{
							String.valueOf( theBillingYm.month() )
						}
					);
					theTerapSgSeikLines.add(
						new TerapSgSeikLine__c(
							Descr__c = theDescr,
							UnitPrice__c = theKakinEntData.TeigakuKakinGaku,
							Quantity__c = 1,
							Price__c = theKakinEntData.TeigakuKakinGaku
						)
					);
				}
			}

			if(theKakinEntData.KakinScheme == '従量課金' && !isNoKakinMonth){
				Map<String, TerapSgSeikLine__c> theHoyoOrSogiToSeikLine = new Map<String, TerapSgSeikLine__c>();
				for( TerapSgSeikTasksDst4Seiks.SekoData aSekoData : theSekoDataList ){

					String theHoyoOrSogi = OboPlanKeitais.isSogi( aSekoData.ObouPlan) ? 'Sogi' : 'Hoyo';
					if( !theHoyoOrSogiToSeikLine.containsKey(theHoyoOrSogi) ){

						String theDescr = String.format(
							'{0}月度　僧侶手配代行サービス {1}',
							new List<String>{
								String.valueOf( theBillingYm.month() ),
								theHoyoOrSogi == 'Sogi' ? '葬儀読経' : '法要'
							}
						);
						Decimal theTaxRate = TaxRates.instance().getRate(theBillingYm);
						Decimal theUnitPrice = theHoyoOrSogi == 'Sogi' ? 5000 * (1 + theTaxRate) : 3000 * (1 + theTaxRate);
						TerapSgSeikLine__c theInitial = 
							new TerapSgSeikLine__c(
								Descr__c = theDescr,
								UnitPrice__c = theUnitPrice,
								Quantity__c = 0, Price__c = 0
							);
						theHoyoOrSogiToSeikLine.put( theHoyoOrSogi, theInitial );
					}
					TerapSgSeikLine__c theTerapSgSeikLine = theHoyoOrSogiToSeikLine.get(theHoyoOrSogi);
					theTerapSgSeikLine.Quantity__c ++;
					theTerapSgSeikLine.Price__c += theTerapSgSeikLine.UnitPrice__c;
				}
				theTerapSgSeikLines.addAll( theHoyoOrSogiToSeikLine.values() );
			}
		}

		Decimal theSeikyuKingaku = 0; Decimal theZeinukiKingaku = 0; Decimal theTax = 0;
		{ //請求金額
			for(TerapSgSeikLine__c aSeikLine : theTerapSgSeikLines){ theSeikyuKingaku += aSeikLine.Price__c; }
			Decimal theTaxRate = TaxRates.instance().getRate(theBillingYm);
			theZeinukiKingaku = theSeikyuKingaku == 0 ? 0 : ( theSeikyuKingaku / (1 + theTaxRate) ).round(System.RoundingMode.HALF_EVEN);
			theTax = theSeikyuKingaku - theZeinukiKingaku;
		}

		List<TerapSgSeikSekoLine__c> theTerapSgSeikSekoLines = new List<TerapSgSeikSekoLine__c>();
		{ //施行明細
			for( TerapSgSeikTasksDst4Seiks.SekoData aSekoData : pDataForSeikyu.SekoDataList ){
				theTerapSgSeikSekoLines.add(
					new TerapSgSeikSekoLine__c(
						ShodanBango__c = aSekoData.ShodanBango, OppRef__c = aSekoData.ShodanId,
						SekoDate__c = aSekoData.SekoDate,
						Seshu__c = aSekoData.SeshuName,
						HoyoShubetsu__c = aSekoData.ObouPlan
					)
				);
			}
		}

		List<TerapSgSeikCallLine__c> theTerapSgSeikCallLines = new List<TerapSgSeikCallLine__c>();
		{ //お問合せ明細
			for( TerapSgSeikTasksDst4Seiks.ToiawaseData aToiawaseData : pDataForSeikyu.ToiawaseDataList ){
				theTerapSgSeikCallLines.add(
					new TerapSgSeikCallLine__c(
						ShodanBango__c = aToiawaseData.ShodanBango, OppRef__c = aToiawaseData.ShodanId,
						ToiawaseDate__c = aToiawaseData.ToiawaseDate,
						Seshu__c = aToiawaseData.SeshuName,
						HoyoShubetsu__c = aToiawaseData.ObouPlan
					)
				);
			}
		}

		if(theSeikyuKingaku <= 0 && theTerapSgSeikCallLines.size() == 0){
			return null;
		}

		TerapSgSeik__c theTerapSgSeik = new TerapSgSeik__c(
			DocStatus__c = 'Draft', IssueDate__c = Todays.date(),
			BillingTargetYearMonth__c = theBillingYm,
			ShiharaiKijitsu__c = theShiharaiKijitsu,
			ZeikomiKingaku__c = theSeikyuKingaku,
			ZeinukiKingaku__c = theZeinukiKingaku,
			Tax__c = theTax,
			ToTorihikiSakiBango__c = pDataForSeikyu.KeiyakuData.TorihikiSakiBango, 
			PartnerRef__c = pDataForSeikyu.KeiyakuData.TorihikiSakiId,
			KeiyakuRef__c = pDataForSeikyu.KeiyakuData.KeiyakuId,
			ToName__c = pDataForSeikyu.KeiyakuData.TorihikiSakiName,
			ToAddrZipCode__c = pDataForSeikyu.KeiyakuData.ToAddrZipCode,
			ToAddrState__c = pDataForSeikyu.KeiyakuData.ToAddrState,
			City__c = pDataForSeikyu.KeiyakuData.ToAddrCity,
			Street__c = pDataForSeikyu.KeiyakuData.ToAddrStreet,
			FriKzGinkoCode__c = pDataForSeikyu.KeiyakuData.FrikzBankCode,
			FriKzGinkoName__c  = pDataForSeikyu.KeiyakuData.FrikzBankName,
			FriKzShitenCode__c = pDataForSeikyu.KeiyakuData.FrikzShitenCode,
			FriKzShitenName__c = pDataForSeikyu.KeiyakuData.FrikzShitenName,
			FriKzKouzaType__c = pDataForSeikyu.KeiyakuData.FrikzKouzaType,
			FriKzKouzaBango__c = pDataForSeikyu.KeiyakuData.FrikzKouzaBango,
			FriKzMeigiName__c = pDataForSeikyu.KeiyakuData.FrikzKouzaMeigi,
			TesuryoRate__c = pDataForSeikyu.KakinEntData.TesuryoRate,
			TesuryoRateNextMonth__c = pDataForSeikyu.NextYmKakinEntData == null ? 0 : pDataForSeikyu.NextYmKakinEntData.TesuryoRate
		);

		SeikyuData theSeikyuData = new SeikyuData();
		theSeikyuData.TerapSgSeik = theTerapSgSeik;
		theSeikyuData.TerapSgSeikLines.addAll(theTerapSgSeikLines);
		theSeikyuData.TerapSgSeikSekoLines.addAll(theTerapSgSeikSekoLines);
		theSeikyuData.TerapSgSeikCallLines.addAll(theTerapSgSeikCallLines);

		return theSeikyuData;
	}

	public void saveSeikyuDatas(List<SeikyuData> pSeikyuDatas){

		List<TerapSgSeik__c> theTerapSgSeiks = new List<TerapSgSeik__c>();

		for(SeikyuData aSeikyuData : pSeikyuDatas){ 
			theTerapSgSeiks.add( aSeikyuData.TerapSgSeik ); 
		}
		INSERT theTerapSgSeiks;

		List<TerapSgSeikLine__c> theTerapSgSeikLines = new List<TerapSgSeikLine__c>();
		List<TerapSgSeikSekoLine__c> theTerapSgSeikSekoLines = new List<TerapSgSeikSekoLine__c>();
		List<TerapSgSeikCallLine__c> theTerapSgSeikCallLines = new List<TerapSgSeikCallLine__c>();
		for(SeikyuData aSeikyuData : pSeikyuDatas){ 
			TerapSgSeik__c aTerapSgSeik = aSeikyuData.TerapSgSeik;
			
			for(TerapSgSeikLine__c aTerapSgSeikLine : aSeikyuData.TerapSgSeikLines ){
				aTerapSgSeikLine.TerapSgSeikRef__c = aTerapSgSeik.Id;
				theTerapSgSeikLines.add(aTerapSgSeikLine);
			}
			for(TerapSgSeikSekoLine__c aTerapSgSeikSekoLine : aSeikyuData.TerapSgSeikSekoLines){
				aTerapSgSeikSekoLine.TerapSgSeikRef__c = aTerapSgSeik.Id;
				theTerapSgSeikSekoLines.add(aTerapSgSeikSekoLine);
			}
			for(TerapSgSeikCallLine__c aTerapSgSeikCallLine : aSeikyuData.TerapSgSeikCallLines){
				aTerapSgSeikCallLine.TerapSgSeikRef__c = aTerapSgSeik.Id;
				theTerapSgSeikCallLines.add(aTerapSgSeikCallLine);
			}
		}
		INSERT theTerapSgSeikLines;
		INSERT theTerapSgSeikSekoLines;
		INSERT theTerapSgSeikCallLines;
	}


}