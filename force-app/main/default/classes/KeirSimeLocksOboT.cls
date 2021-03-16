public @isTest class KeirSimeLocksOboT {
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

	@isTest public static void inClosedOpp_anyChgNotAcceptable(){
		Test.startTest();
			new KeirSimeLocksObo().inClosedOpp_anyChgNotAcceptable( new Opportunity(), new Opportunity() );
		Test.stopTest();
	}
	@isTest public static void OnSimpleYasugo_onSimpleYasugoBeforeUpdate(){

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

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'お坊' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),
				Teikeisaki__c = theAccounts.get('僧侶').Id
			)
		};
		INSERT theKeiyakus.values();

        Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
            'お坊' => new Obosanbin__c()
        };
        INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '商談クローズ',
				CloseDate = Date.newInstance(2000,1,1),
                ObosanbinRef__c = theObos.get('お坊').Id
            )
        };
        INSERT theOpps.values();
		endSetUp();

		List<Obosanbin__c> theNewOnes = new List<Obosanbin__c>{
			new Obosanbin__c( 
				Id = theObos.get('お坊').Id,
				ObosanbinKeiyakuMadoguchi__c = theKeiyakus.get('お坊').Id
			)
		};
		Map<Id, Obosanbin__c> theOldOnes = new Map<Id, Obosanbin__c>{
			theObos.get('お坊').Id =>
				new Obosanbin__c(
					Id = theObos.get('お坊').Id,
					ObosanbinKeiyakuMadoguchi__c = null
				)
		};
		Test.startTest();
			new KeirSimeLocksObo.OnObosanbin( new KeirSimeLocksChgNotAllows() )
				.onObosanbinBeforeUpdate( theNewOnes, theOldOnes );
		Test.stopTest();
	}
}