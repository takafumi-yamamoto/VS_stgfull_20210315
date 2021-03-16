@isTest
public class SgJzAnMdKrTsNsBatT {

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

	private class SogiJizenAncateSelector_Stub implements SgJzAnMdKrTsNsBat.ISogiJizenAncateSelector{
		public List<SogiJizenAncate__c> get_SogiJizenAncate(){
			new SgJzAnMdKrTsNsBatT().save_SogiJizenAncate();
			List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
			theRecords = 
				[
					SELECT Id 
					FROM SogiJizenAncate__c
				];
			return theRecords;
		}
	}

	private class SogiJizenAncateSaber_Stub implements SgJzAnMdKrTsNsBat.ISogiJizenAncateSaber{
		public void save_SogiJizenAncate( List<SogiJizenAncate__c> pSogiJizenAncate ){
		}
	}

	private class SogiJizenAncateSaberErr_Stub implements SgJzAnMdKrTsNsBat.ISogiJizenAncateSaber{
		public void save_SogiJizenAncate( List<SogiJizenAncate__c> pSogiJizenAncate ){
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
	public static void TEST_SgJzAnMdKrTsNsBat(){
		beginSetUp();
		SgJzAnMdKrTsNsBat.mSogiJizenAncateSelector = new SogiJizenAncateSelector_Stub();
		SgJzAnMdKrTsNsBat.mSogiJizenAncateSaber = new SogiJizenAncateSaber_Stub();
		endSetUp();
		
		Test.startTest();
		SgJzAnMdKrTsNsBat.start();
		Test.stopTest();
	}

	@isTest
	public static void TEST_SgJzAnMdKrTsNsBat_Err(){
		beginSetUp();
		SgJzAnMdKrTsNsBat.mSogiJizenAncateSelector = new SogiJizenAncateSelector_Stub();
		SgJzAnMdKrTsNsBat.mSogiJizenAncateSaber = new SogiJizenAncateSaberErr_Stub();
		endSetUp();

		Test.startTest();
		SgJzAnMdKrTsNsBat.start();
		Test.stopTest();
	}

	@isTest
	public static void get_SogiJizenAncate(){
		beginSetUp();
		new SgJzAnMdKrTsNsBatT().save_SogiJizenAncate();
		Date theDate = Date.newInstance(2021, 02, 20);
		endSetUp();

		Test.startTest();
		SgJzAnMdKrTsNsBat.ISogiJizenAncateSelector theISogiJizenAncateSelector = new SgJzAnMdKrTsNsBat.SogiJizenAncateSelector(theDate);
		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = theISogiJizenAncateSelector.get_SogiJizenAncate();
		Test.stopTest();
	}

	@isTest
	public static void SogiJizenAncate_case(){
		beginSetUp();
		new SgJzAnMdKrTsNsBatT().save_SogiJizenAncate();
		Date theDate = Date.newInstance(2021, 02, 20);
		endSetUp();

		Test.startTest();
		SgJzAnMdKrTsNsBat.ISogiJizenAncateSelector theISogiJizenAncateSelector = new SgJzAnMdKrTsNsBat.SogiJizenAncateSelector(theDate);
		List<SogiJizenAncate__c> theRecords = new List<SogiJizenAncate__c>();
		theRecords = theISogiJizenAncateSelector.get_SogiJizenAncate();
		SgJzAnMdKrTsNsBat.ISogiJizenAncateSaber theISogiJizenAncateSaber = new SgJzAnMdKrTsNsBat.SogiJizenAncateSaber();
		theISogiJizenAncateSaber.save_SogiJizenAncate(theRecords);
		Test.stopTest();
	}

}