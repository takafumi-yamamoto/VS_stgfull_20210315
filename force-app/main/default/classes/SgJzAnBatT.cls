@isTest
public class SgJzAnBatT {

	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
	}

	private static void endSetUp(){
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Insert new Account(
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
			FirstName = '_', LastName = '_'
		);
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	private class SogiJizenAncateSelector_Stub implements SgJzAnBat.ISogiJizenAncateSelector{
		public List<SogiJizenAncate__c> get_SogiJizenAncate(){
			new SgJzAnBatT().save_SogiJizenAncate();
			List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
			theRecords = 
				[
					SELECT Id 
					FROM SogiJizenAncate__c
				];
			return theRecords;
		}
	}

	private class CaseSaber_Stub implements SgJzAnBat.ICaseSaber{
		public void save_case( String pSogiJizenAncate_id ){
		}
	}

	private class CaseSaberErr_Stub implements SgJzAnBat.ICaseSaber{
		public void save_case( String pSogiJizenAncate_id ){
			throw new Exceptions.AnException();
		}
	}

	private void save_SogiJizenAncate (){
		Map<String, SogiJizenAncate__c> theSogiJizenAncate = new Map<String, SogiJizenAncate__c>{
			'theSogiJizenAncate1' => new SogiJizenAncate__c(
				Status__c                                   = '未紐付け',
				Torokubi__c                                 = Date.newInstance(2021, 02, 17),
				SogiWebShiryoSeikyuUniqueKey__c             = '0901234123420170410200716',
				Lastname__c                                 = 'TEST',
				Firstname__c                                = 'TEST',
				LastNameKana__c                             = 'ﾃｽﾄ',
				FirstNameKana__c                            = 'ﾃｽﾄ',
				TaishoshaSei__c                             = 'TESTE',
				TaishoshaMei__c                             = 'TESTE',
				TaishoshaSeiFurigana__c                     = 'ﾃｽﾄｴ',
				TaishoshaMeiFurigana__c                     = 'ﾃｽﾄｴ',
				CampaignMoshikomiName__c                    = 'campaign_sougi_bouquet,TEST'
			)
		};
		INSERT theSogiJizenAncate.values();
	}

	@isTest
	public static void TEST_SgJzAnBat(){
		beginSetUp();
		SgJzAnBat.mSogiJizenAncateSelector = new SogiJizenAncateSelector_Stub();
		SgJzAnBat.mCaseSaber = new CaseSaber_Stub();
		endSetUp();
		
		Test.startTest();
		SgJzAnBat.start();
		Test.stopTest();
	}

	@isTest
	public static void TEST_SgJzAnBat_Err(){
		beginSetUp();
		SgJzAnBat.mSogiJizenAncateSelector = new SogiJizenAncateSelector_Stub();
		SgJzAnBat.mCaseSaber = new CaseSaberErr_Stub();
		endSetUp();

		Test.startTest();
		SgJzAnBat.start();
		Test.stopTest();
	}

	@isTest
	public static void get_SogiJizenAncate(){
		beginSetUp();
		new SgJzAnBatT().save_SogiJizenAncate();
		Date theDate = Date.newInstance(2021, 02, 17);
		endSetUp();

		Test.startTest();
		SgJzAnBat.ISogiJizenAncateSelector theISogiJizenAncateSelector = new SgJzAnBat.SogiJizenAncateSelector(theDate);
		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = theISogiJizenAncateSelector.get_SogiJizenAncate();
		Test.stopTest();
	}

	@isTest
	public static void save_case(){
		beginSetUp();
		new SgJzAnBatT().save_SogiJizenAncate();
		Map<String, Case> theCase = new Map<String, Case>{
			'theCase1' => new Case(
				RecordTypeId                    =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),
				ToiawaseDate__c                 = Datetime.valueOf('2019-03-18 17:24:00'), 
				Status                          = '新規',
				Origin                          = 'Web', 
				Lastname__c                     = 'TEST',
				Firstname__c                    = 'TEST',
				LastNameKana__c                 = 'ﾃｽﾄ',
				FirstNameKana__c                = 'ﾃｽﾄ',
				SogiWebShiryoSeikyuUniqueKey__c = '0901234123420170410200716'
			)
		};
		INSERT theCase.values();
		Date theDate = Date.newInstance(2021, 02, 17);
		endSetUp();

		Test.startTest();
		SgJzAnBat.ISogiJizenAncateSelector theISogiJizenAncateSelector = new SgJzAnBat.SogiJizenAncateSelector(theDate);
		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = theISogiJizenAncateSelector.get_SogiJizenAncate();
		SgJzAnBat.ICaseSaber theICaseSaber = new SgJzAnBat.CaseSaber();
		theICaseSaber.save_case(theRecords.get(0).id);
		Test.stopTest();
	}

	@isTest
	public static void save_case_caseDataNashi(){
		beginSetUp();
		new SgJzAnBatT().save_SogiJizenAncate();
		Date theDate = Date.newInstance(2021, 02, 17);
		endSetUp();

		Test.startTest();
		SgJzAnBat.ISogiJizenAncateSelector theISogiJizenAncateSelector = new SgJzAnBat.SogiJizenAncateSelector(theDate);
		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = theISogiJizenAncateSelector.get_SogiJizenAncate();
		SgJzAnBat.ICaseSaber theICaseSaber = new SgJzAnBat.CaseSaber();
		theICaseSaber.save_case(theRecords.get(0).id);
		Test.stopTest();
	}
}