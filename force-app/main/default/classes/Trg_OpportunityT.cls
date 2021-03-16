@isTest
public class Trg_OpportunityT {

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
	static void OnBeforeInsert(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

		endSetUp();
		Test.startTest();
		INSERT New Opportunity(
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
			Name = '_',
			AccountId = theAccounts.get('客').Id,
			StageName = '_',
			CloseDate = Date.newInstance(2000,1,1),
			SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id,
            TaishoushaJokyo__c = '未聴取により不明'
		);
		Test.stopTest();
	}

	@isTest
	static void OnBeforeUpdate(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
				Name = '_',
				AccountId = theAccounts.get('客').Id,
				StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id,
                TaishoushaJokyo__c = '未聴取により不明'
            )
        };
		INSERT theOpps.values();

		endSetUp();
		Test.startTest();
		UPDATE new Opportunity(Id = theOpps.get('葬儀').Id);
		Test.stopTest();
	}

	@isTest
	static void updateCrossSeliingSakiOpportunity(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Obosanbin__c> theObosanbins = new Map<String, Obosanbin__c>{
            'お坊' => new Obosanbin__c()
        };
        INSERT theObosanbins.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
				Name = '_',
				AccountId = theAccounts.get('客').Id,
				StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				SimpleYasugoRef__c = theSimpleYasugos.get('葬儀').Id
			),
            'お坊' => new Opportunity(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
				Name = '_',
				AccountId = theAccounts.get('客').Id,
				StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
				ObosanbinRef__c = theObosanbins.get('お坊').Id
            )
        };
		INSERT theOpps.values();

		Map<String,CrossSellingTeian__c> theCrossSells = new Map<String,CrossSellingTeian__c>{
			'葬儀toお坊' => new CrossSellingTeian__c(
				OpportunityRef__c = theOpps.get('葬儀').Id,
				CrossSellingSakiOpportunityRef__c = theOpps.get('お坊').Id
			)
		};
		INSERT theCrossSells.values();

		endSetUp();

		Test.startTest();
		List<Opportunity> theNewOnes = new List<Opportunity>{
			new Opportunity( Id = theOpps.get('葬儀').Id, Utiagebi__c = Date.newInstance(2020,1,2) )
		};

		Map<Id, Opportunity> theOldOnes = new Map<Id, Opportunity>{
			theOpps.get('葬儀').Id => 
				new Opportunity( Id = theOpps.get('葬儀').Id, Utiagebi__c = null )
		};

		new Trg_Opportunity(false,0).updateCrossSeliingSakiOpportunity(theNewOnes, theOldOnes);
		Test.stopTest();
	}
}