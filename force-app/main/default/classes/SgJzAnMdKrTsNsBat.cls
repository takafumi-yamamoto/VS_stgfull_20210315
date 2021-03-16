// SogiJizenAncateMihimodukeTaishoNashiKanryoBatch
public class SgJzAnMdKrTsNsBat implements Database.Batchable<sObject> {

	@TestVisible
	private static SgJzAnMdKrTsNsBat.ISogiJizenAncateSelector mSogiJizenAncateSelector = get_ISogiJizenAncateSelector_instance();

	@TestVisible
	private static SgJzAnMdKrTsNsBat.ISogiJizenAncateSaber mSogiJizenAncateSaber= new SgJzAnMdKrTsNsBat.SogiJizenAncateSaber();

	public static ISogiJizenAncateSelector get_ISogiJizenAncateSelector_instance(){
		return new SogiJizenAncateSelector(
			Date.today().addDays(-3)
		);
	}

	public static void start(){
		if( isBatchActive() ) return;
		Integer theBatchSize = 200;
		database.executebatch( new SgJzAnMdKrTsNsBat(),theBatchSize );
	}
	private static Boolean isBatchActive(){
		List<AsyncApexJob> theJobs = [
			SELECT Id, ApexClass.Name from AsyncApexJob 
			where Status in ('Holding','Queued','Preparing','Processing') 
			and ApexClass.Name = 'SgJzAnMdKrTsNsBat'
			and JobType in ('BatchApex','BatchApexWorker')
			Limit 1
		];
		return theJobs.size() >= 1;
	}


	public List<SogiJizenAncate__c> start(Database.BatchableContext BC) { 

		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = mSogiJizenAncateSelector.get_SogiJizenAncate();
		return theRecords;

	}

	public void execute(Database.BatchableContext BC, List<SogiJizenAncate__c> pRecords) {
		if( pRecords.size() <= 0 ) return;

		String theSogiJizenAncateID = '';
		try{
			mSogiJizenAncateSaber.save_SogiJizenAncate(pRecords);
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210203-1600-00', 'SgJzAnMdKrTsNsBat.execute')
					.putAttr('ex.getTypeName()', ex.getTypeName() )
					.putAttr('ex.getMessage()', ex.getMessage() )
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber() )
					.putAttr('ex.getStackTraceString', ex.getStackTraceString() )
					.putAttr('RecordID', theSogiJizenAncateID )
			);
		}

	}

	public void finish(Database.BatchableContext BC){}

	public interface ISogiJizenAncateSelector {
		List<SogiJizenAncate__c>  get_SogiJizenAncate();
	}

	public class SogiJizenAncateSelector implements ISogiJizenAncateSelector {
		private Date m_Torokubi;
		public SogiJizenAncateSelector(Date p_Torokubi){
			this.m_Torokubi = p_Torokubi;
		}
		public List<SogiJizenAncate__c> get_SogiJizenAncate(){
			List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
			theRecords = 
						[ 
							SELECT Id, 
								Status__c, 
								Kanryobi__c 
							FROM SogiJizenAncate__c
							WHERE Torokubi__c < :m_Torokubi
							AND Status__c = '未紐付け'
				];
			return theRecords;
		}
	}

	public interface ISogiJizenAncateSaber {
		void save_SogiJizenAncate( List<SogiJizenAncate__c> pSogiJizenAncate );
	}

	public class SogiJizenAncateSaber implements ISogiJizenAncateSaber {

		public void save_SogiJizenAncate( List<SogiJizenAncate__c> pSogiJizenAncate ){

			List<SogiJizenAncate__c> theSogiJizenAncate = new List<SogiJizenAncate__c>();
            for( SogiJizenAncate__c aSogiJizenAncate :pSogiJizenAncate ){
				aSogiJizenAncate.Status__c = '紐付け対象無のため完了';
				aSogiJizenAncate.Kanryobi__c = Date.today();
				theSogiJizenAncate.add(aSogiJizenAncate);
			}
			update theSogiJizenAncate;
		}

	}

}