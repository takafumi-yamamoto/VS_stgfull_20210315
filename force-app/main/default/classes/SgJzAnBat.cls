public class SgJzAnBat implements Database.Batchable<sObject> {

	@TestVisible
	private static SgJzAnBat.ISogiJizenAncateSelector mSogiJizenAncateSelector = get_ISogiJizenAncateSelector_instance();

	@TestVisible
	private static SgJzAnBat.ICaseSaber mCaseSaber= new SgJzAnBat.CaseSaber();

	public static ISogiJizenAncateSelector get_ISogiJizenAncateSelector_instance(){
		return new SogiJizenAncateSelector(
			Date.today().addDays(-3)
		);
	}

	public static void start(){
		if( isBatchActive() ) return;
		Integer theBatchSize = 1;
		database.executebatch( new SgJzAnBat(),theBatchSize );
	}
	private static Boolean isBatchActive(){
		List<AsyncApexJob> theJobs = [
			SELECT Id, ApexClass.Name from AsyncApexJob 
			where Status in ('Holding','Queued','Preparing','Processing') 
			and ApexClass.Name = 'SgJzAnBat'
			and JobType in ('BatchApex','BatchApexWorker')
			Limit 1
		];
		return theJobs.size() >= 1;
	}


	public List<SogiJizenAncate__c> start(Database.BatchableContext BC) { 

		return mSogiJizenAncateSelector.get_SogiJizenAncate();

	}

	public void execute(Database.BatchableContext BC, List<SogiJizenAncate__c> pRecords) {
		if( pRecords.size() <= 0 ) return;

		String theSogiJizenAncateID = '';
		try{
			for(SogiJizenAncate__c aRecord :pRecords){
				theSogiJizenAncateID = aRecord.id;
				mCaseSaber.save_case(theSogiJizenAncateID);
			}
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210203-1600-00', 'SgJzAnBat.execute')
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
							SELECT Id 
							FROM SogiJizenAncate__c
							WHERE Torokubi__c >= :m_Torokubi
							AND Status__c = '未紐付け'
				];
			return theRecords;
		}
	}

	public interface ICaseSaber {
		void save_case( String pSogiJizenAncate_id  );
	}

	public class CaseSaber implements ICaseSaber {

		public void save_case( String pSogiJizenAncate_id ){

			SogiJizenAncate__c theSogiJizenAncate = (SogiJizenAncate__c)SobjectsExtension.firstOrNull(
				[ 
					SELECT Id, 
						Name, 
						Status__c, 
						Torokubi__c, 
						Kanryobi__c, 
						SogiWebShiryoSeikyuCase__c, 
						PostalCode__c, 
						State__c, 
						City__c, 
						Street__c, 
						Lastname__c, 
						Firstname__c, 
						TaishoshaCity__c, 
						TaishoshaState__c, 
						TaishoshaStreet__c, 
						TaishoshaZipCode__c, 
						AnchiKubun__c, 
						FirstNameKana__c, 
						KiboAreaCity__c, 
						KiboAreaState__c, 
						KiboPlan__c, 
						LastNameKana__c, 
						MailAddress__c, 
						ObosanbinOption__c, 
						OmukaesakiCity__c, 
						OmukaesakiMeisho__c, 
						OmukaesakiState__c, 
						OmukaesakiStreet__c, 
						OmukaesakiZipCode__c, 
						Seinengappi__c, 
						Shuha__c, 
						SonotanoSyukyoSyuha__c, 
						TaishoshaBodaijinoUmu__c, 
						TaishoshaJuminhyoCity__c, 
						TaishoshaJuminhyoState__c, 
						TaishoshaMeiFurigana__c, 
						TaishoshaMei__c, 
						TaishoshaSeiFurigana__c, 
						TaishoshaSei__c, 
						TaishoshaSeinengappi__c, 
						TaishoshaTelNo__c, 
						TaishoushaJokyo__c, 
						TelNo__c, 
						ToiawaseDate__c, 
						ZokugaraSodanshaNitottenoTaishoshaSonota__c, 
						ZokugaraSodanshaNitottenoTaishosha__c, 
						uniq_id__c, 
						GaClientId__c, 
						CampaignMoshikomiName__c, 
						YorisoWoSittaKikkake__c, 
						SogiWebShiryoSeikyuUniqueKey__c, 
						KeitaiDenwa__c, 
						TaishoshaKeitaiDenwa__c 
					FROM SogiJizenAncate__c
					WHERE id >= :pSogiJizenAncate_id
				]
			);

			if( theSogiJizenAncate == null ) return;

			ID theSogiShiryoseikyuRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();

			Case theSogiShiryoseikyuCase = (Case)SobjectsExtension.firstOrNull(
							[
								SELECT id
								FROM Case 
								WHERE SogiWebShiryoSeikyuUniqueKey__c = :theSogiJizenAncate.SogiWebShiryoSeikyuUniqueKey__c 
								AND RecordTypeId = :theSogiShiryoseikyuRecordTypeId
								LIMIT 1
							]
						);

			if( theSogiShiryoseikyuCase == null ) return;

			Case newCase = new Case();
			newCase.RecordTypeId                                = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId();
			newCase.Status                                      = '新規';
			newCase.Origin                                      = 'Web';
			newCase.GaClientId__c                               = theSogiJizenAncate.GaClientId__c;
			newCase.uniq_id__c                                  = theSogiJizenAncate.uniq_id__c;
			newCase.ToiawaseDate__c                             = theSogiJizenAncate.ToiawaseDate__c;
			newCase.SogiWebShiryoSeikyuUniqueKey__c             = theSogiJizenAncate.SogiWebShiryoSeikyuUniqueKey__c;
			newCase.Lastname__c                                 = theSogiJizenAncate.Lastname__c;
			newCase.Firstname__c                                = theSogiJizenAncate.Firstname__c;
			newCase.LastNameKana__c                             = theSogiJizenAncate.LastNameKana__c;
			newCase.FirstNameKana__c                            = theSogiJizenAncate.FirstNameKana__c;
			newCase.Seinengappi__c                              = theSogiJizenAncate.Seinengappi__c;
			newCase.KeitaiDenwa__c                              = theSogiJizenAncate.KeitaiDenwa__c;
			newCase.TelNo__c                                    = theSogiJizenAncate.TelNo__c;
			newCase.MailAddress__c                              = theSogiJizenAncate.MailAddress__c;
			newCase.PostalCode__c                               = theSogiJizenAncate.PostalCode__c;
			newCase.State__c                                    = theSogiJizenAncate.State__c;
			newCase.City__c                                     = theSogiJizenAncate.City__c;
			newCase.Street__c                                   = theSogiJizenAncate.Street__c;
			newCase.TaishoushaJokyo__c                          = theSogiJizenAncate.TaishoushaJokyo__c;
			newCase.TaishoshaSei__c                             = theSogiJizenAncate.TaishoshaSei__c;
			newCase.TaishoshaMei__c                             = theSogiJizenAncate.TaishoshaMei__c;
			newCase.TaishoshaSeiFurigana__c                     = theSogiJizenAncate.TaishoshaSeiFurigana__c;
			newCase.TaishoshaMeiFurigana__c                     = theSogiJizenAncate.TaishoshaMeiFurigana__c;
			newCase.TaishoshaSeinengappi__c                     = theSogiJizenAncate.TaishoshaSeinengappi__c;
			newCase.TaishoshaKeitaiDenwa__c                     = theSogiJizenAncate.TaishoshaKeitaiDenwa__c;
			newCase.TaishoshaTelNo__c                           = theSogiJizenAncate.TaishoshaTelNo__c;
			newCase.TaishoshaZipCode__c                         = theSogiJizenAncate.TaishoshaZipCode__c;
			newCase.TaishoshaState__c                           = theSogiJizenAncate.TaishoshaState__c;
			newCase.TaishoshaCity__c                            = theSogiJizenAncate.TaishoshaCity__c;
			newCase.TaishoshaStreet__c                          = theSogiJizenAncate.TaishoshaStreet__c;
			newCase.TaishoshaJuminhyoState__c                   = theSogiJizenAncate.TaishoshaJuminhyoState__c;
			newCase.TaishoshaJuminhyoCity__c                    = theSogiJizenAncate.TaishoshaJuminhyoCity__c;
			newCase.Shuha__c                                    = theSogiJizenAncate.Shuha__c;
			newCase.SonotanoSyukyoSyuha__c                      = theSogiJizenAncate.SonotanoSyukyoSyuha__c;
			newCase.TaishoshaBodaijinoUmu__c                    = theSogiJizenAncate.TaishoshaBodaijinoUmu__c;
			newCase.ZokugaraSodanshaNitottenoTaishosha__c       = theSogiJizenAncate.ZokugaraSodanshaNitottenoTaishosha__c;
			newCase.ZokugaraSodanshaNitottenoTaishoshaSonota__c = theSogiJizenAncate.ZokugaraSodanshaNitottenoTaishoshaSonota__c;
			newCase.OmukaesakiMeisho__c                         = theSogiJizenAncate.OmukaesakiMeisho__c;
			newCase.OmukaesakiZipCode__c                        = theSogiJizenAncate.OmukaesakiZipCode__c;
			newCase.OmukaesakiState__c                          = theSogiJizenAncate.OmukaesakiState__c;
			newCase.OmukaesakiCity__c                           = theSogiJizenAncate.OmukaesakiCity__c;
			newCase.OmukaesakiStreet__c                         = theSogiJizenAncate.OmukaesakiStreet__c;
			newCase.AnchiKubun__c                               = theSogiJizenAncate.AnchiKubun__c;
			newCase.KiboAreaState__c                            = theSogiJizenAncate.KiboAreaState__c;
			newCase.KiboAreaCity__c                             = theSogiJizenAncate.KiboAreaCity__c;
			newCase.KiboPlan__c                                 = theSogiJizenAncate.KiboPlan__c;
			newCase.ObosanbinOption__c                          = theSogiJizenAncate.ObosanbinOption__c;
			newCase.YorisoWoSittaKikkake__c                     = theSogiJizenAncate.YorisoWoSittaKikkake__c;
			List<String> Listcampaign_id = new List<String>();
			if(String.isNotBlank(theSogiJizenAncate.CampaignMoshikomiName__c)){
				String theCampaignMoshikomiName = theSogiJizenAncate.CampaignMoshikomiName__c;
				Listcampaign_id = theCampaignMoshikomiName.split(',');
				newCase.CampaignMoshikomiName__c = String.join(Listcampaign_id, ';');
			}
			insert newCase;

			theSogiJizenAncate.Status__c = '紐付け完了';
			theSogiJizenAncate.Kanryobi__c = Date.today();
			theSogiJizenAncate.SogiWebShiryoSeikyuCase__c = theSogiShiryoseikyuCase.id;
			update theSogiJizenAncate;

		}

	}

}