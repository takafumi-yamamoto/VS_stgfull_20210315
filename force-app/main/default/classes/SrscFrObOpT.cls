@isTest
public class SrscFrObOpT {

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

	@isTest
	public static void SoryoScheduler_getUnitOfWork(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
			'僧侶' => new Account(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'),
				Name = '_'
			)
        };
		INSERT theAccounts.values();

		Map<String, Contact> theContacts = new Map<String, Contact>{
			'僧侶' => new Contact(
				AccountId = theAccounts.get('僧侶').Id,
				FirstName = '_', LastName = '_'
			)
		};
		INSERT theContacts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'お坊' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
				Teikeisaki__c = theAccounts.get('僧侶').Id
			)
		};
		INSERT theKeiyakus.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c(
				MemorialServicePlan__c = '一般葬',
				TsuyaDateTime_Inp__c = Datetime.newInstance(2020,1,1,12,30,0),
				KokubetsushikiNichiji__c = Datetime.newInstance(2020,1,1,12,30,0),
				KasoDateTime_Inp__c = Datetime.newInstance(2020,1,1,12,30,0),
				ObosanbinKeiyakuMadoguchi__c = theKeiyakus.get('お坊').Id,
				ObosanbinKeiyakuSekotanto__c = theKeiyakus.get('お坊').Id
			)
		};
		INSERT theObos.values();

		Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
			'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '施行待ち',
				CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObos.get('お坊').Id
			)
		};
		INSERT theOpps.values();

		String theShodanBango = 
			[SELECT ShodanBango__c FROM Opportunity WHERE Id = :theOpps.get('お坊').Id]
			.get(0)
			.ShodanBango__c;
		endSetUp();


		Test.startTest();
		SrscFrObOp.SoryoScheduler theSoryoScheduler = 
			new SrscFrObOp.SoryoScheduler(
				new SrscFrObOpPhase.StageToSchedule()
			);

		SrscFrObOp.UnitOfWork theUow =
			theSoryoScheduler.getUnitOfWork(
				theSoryoScheduler.selectOppData(theShodanBango)
			);
		Test.stopTest();

		System.AssertEquals( 0, theUow.events_delete.size() );
		System.AssertEquals( 3, theUow.events_insert.size() );
	}

}