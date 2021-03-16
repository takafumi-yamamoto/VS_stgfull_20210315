public class TeiHehDaiKakins implements Database.Batchable<sObject> {

	//batchable-section begin
	public static void start(Date pRenewTargetYm){
        Boolean isBatchActive = 
			[
				SELECT Id, ApexClass.Name from AsyncApexJob 
				where Status in ('Holding','Queued','Preparing','Processing') 
				and ApexClass.Name = :TeiHehDaiKakins.Class.toString()
				and JobType in ('BatchApex','BatchApexWorker')
				Limit 1
			]
			.size() >= 1;
		if( isBatchActive ) return;

		database.executebatch(
			new TeiHehDaiKakins( pRenewTargetYm.toStartOfMonth() ), 
			1
		);
		TeiHehDaiKakinsExeLogs.getInstance().logStart( 
			pRenewTargetYm.toStartOfMonth(), Todays.now()
		);
	}

	private Date mRenewTargetYm;
	public TeiHehDaiKakins(Date pRenewTargetYm){
		this.mRenewTargetYm = pRenewTargetYm.toStartOfMonth();
	}

	public Database.QueryLocator start(Database.BatchableContext BC) { return getQueryLocator(); }
	
	public static Database.QueryLocator getQueryLocator(){
		return Database.getQueryLocator(
			[
				SELECT Id, KeiyakuBango__c
				FROM Keiyaku__c
				WHERE KeiyakuJokyo__c = '契約中'
				AND KeiyakuType__c IN ('定額僧侶手配代行','てらぱす-従量課金','てらぱす-定額課金')
			]
		);
	}

   	public void execute(Database.BatchableContext BC, List<Keiyaku__c> pRecords) {
   		try{
			for( Keiyaku__c aKeiyaku : pRecords){
				try{
					Date theRenewTargetYm = this.mRenewTargetYm.toStartOfMonth();
					TeiHehDaiKakinsLocks.getInstance().turnOffValidaton();
					TeiHehDaiKakins.renew(aKeiyaku.KeiyakuBango__c, theRenewTargetYm );
					TeiHehDaiKakinsLocks.getInstance().turnOnValidaton();
				}catch(Exception ex){
					Loggings.writeLog(
						Loggings.createLogEntry(
							Loggings.Level.Error, '20191227-1502-01', 'TeiHehDaiKakins.execute')
							.putAttr('aKeiyaku.KeiyakuBango__c', aKeiyaku.KeiyakuBango__c)
							.putAttr('ex.getMessage()', ex.getMessage())
							.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
							.putAttr('ex.getStackTraceString()', ex.getStackTraceString()
						)
					);
				}
			}
   		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20191227-1502-02', 'TeiHehDaiKakins.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
   		}
   	}
	
	public void finish(Database.BatchableContext BC) { 
		TeiHehDaiKakinsExeLogs.getInstance().logFinish( 
			this.mRenewTargetYm.toStartOfMonth(), Todays.now()
		);
	}
	//batchable-section end

	//main-section-begin
	private static IraiCounter m_IraiCounter = new IraiCounter();

	public static void renew(String pKeiyakuBango, Date pRenewTargetYm){
		Date theNewStartDate = pRenewTargetYm.addMonths(1).toStartOfMonth();
		Date theNewEndDate = theNewStartDate.addMonths(1).addDays(-1);
		Date theRenewTargetYmFirstDay = pRenewTargetYm.toStartOfMonth();

		Keiyaku__c theKeiyaku = (Keiyaku__c)SobjectsExtension.firstOrNull(
			[
				SELECT 
				Id, KeiyakuBango__c, Teikeisaki__r.TorihikisakiBango__c,
				(
					SELECT 
					Id, KeiyakuRef__c, RyokinPlan__c, Kingaku__c, SogishaTesuryoToribunRitsu__c,
					BeginDate__c, EndDate__c, KakinScheme__c
					FROM TeiHehDaiKakinSchEnts__r
					WHERE BeginDate__c = :theRenewTargetYmFirstDay
					LIMIT 2
				)
				FROM Keiyaku__c
				WHERE KeiyakuBango__c = :pKeiyakuBango
			]
		);

		Boolean isCreatedAlready = [
			SELECT Id
			FROM TeiHehDaiKakinSchEnt__c
			WHERE KeiyakuRef__c = :theKeiyaku.Id
			AND BeginDate__c = :theNewStartDate
		].size() > 0;
		if( isCreatedAlready ) return;

		if( theKeiyaku.TeiHehDaiKakinSchEnts__r.size() == 0 ){
			throw new LastKakinCanNotBeIdentifiedException('更新対象の課金明細なし');
		}

		if( theKeiyaku.TeiHehDaiKakinSchEnts__r.size() > 1 ){
			throw new LastKakinCanNotBeIdentifiedException('更新対象の課金明細特定不可');
		}

		TeiHehDaiKakinSchEnt__c theOldOne = theKeiyaku.TeiHehDaiKakinSchEnts__r.get(0);

		Integer theSougishaToribunRate = 
			m_IraiCounter.getSougishaToribunRate( m_IraiCounter.getIraiKensu( theKeiyaku.Teikeisaki__r.TorihikisakiBango__c,theNewStartDate ) );

		List<TeiHehDaiKakinSchEnt__c> theUpserts = new List<TeiHehDaiKakinSchEnt__c>();

		TeiHehDaiKakinSchEnt__c theNewOne = new TeiHehDaiKakinSchEnt__c(
			KeiyakuRef__c = theOldOne.KeiyakuRef__c,
			BeginDate__c = theNewStartDate, 
			EndDate__c = theNewEndDate,
			SogishaTesuryoToribunRitsu__c = theSougishaToribunRate,
			RyokinPlan__c = theOldOne.RyokinPlan__c,
			Kingaku__c = theOldOne.Kingaku__c,
			KakinScheme__c = theOldOne.KakinScheme__c
		);
		theUpserts.add(theNewOne);

		UPSERT theUpserts;
	}

	public class IraiCounter{
		public Integer getIraiKensu(String pSogishaTorihikisakiBango, Date pBillingYm){
			Date theFrom = pBillingYm.toStartOfMonth();
			Date theTo = theFrom.addMonths(1).addDays(-1);
			return 
			[
				SELECT COUNT()
				FROM TerapToiRec__c 
				WHERE SogishaTorihikisakiBango__c = :pSogishaTorihikisakiBango
				AND ToribunRateYmApplyingFor__c = :pBillingYm.toStartOfMonth()
			];
		}
		public Integer getSougishaToribunRate(Integer pIraiKensu){
			if( pIraiKensu <= 1) return 50;
			if( pIraiKensu <= 2) return 55;
			return 60;
		}
	}



	public class LastKakinCanNotBeIdentifiedException extends Exception {}
	//main-section-end

	
}