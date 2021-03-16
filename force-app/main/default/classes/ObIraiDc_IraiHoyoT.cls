@isTest
public class ObIraiDc_IraiHoyoT {
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
    @isTest public static void getOpFcTemplateData_EmptyData(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c()
		};
        INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                ObosanbinRef__c = theObos.get('お坊').Id
            )
        };
        INSERT theOpps.values();
        endSetUp();
        Test.startTest();
        new ObIraiDc_IraiHoyo().getOpFcTemplateData( theOpps.get('お坊').Id,'','' );
        Test.stopTest();
    }

    @isTest public static void getOpFcTemplateData(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '助法者' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'),
                Name = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'助法者' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','ObousanBinJohouSya'),
				Teikeisaki__c = theAccounts.get('助法者').Id
			)
		};
        INSERT theKeiyakus.values();
        
        Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c(
                HoyoBashoMei__c = '_',
                TsuikahoyobashoMei__c = '_',
                KokubetsuDateTime_Inp__c = Datetime.newInstance(2020,1,1),
                ObosanbinKeiyakuSekotanto__c = theKeiyakus.get('助法者').Id
            )
		};
        INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                ObosanbinRef__c = theObos.get('お坊').Id
            )
        };
        INSERT theOpps.values();
        endSetUp();
        Test.startTest();
        new ObIraiDc_IraiHoyo().getOpFcTemplateData( theOpps.get('お坊').Id,'fax','999-9999-9999' );
        Test.stopTest();
    }
}