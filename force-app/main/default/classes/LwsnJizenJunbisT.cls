@isTest
public class LwsnJizenJunbisT {

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
	private static void start(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		Date theDate = Date.newInstance(2020,1,1);
		LwsnJizenJunbis.start(theDate, theDate);
		Test.stopTest();
	}

	@isTest
	private static void execute(){
		beginSetUp();
		endSetUp();
		Test.startTest();
		Date theDate = Date.newInstance(2020,1,1);
		new LwsnJizenJunbis(theDate,theDate).execute(null, new List<Case>() );
		Test.stopTest();
	}

	@isTest
	private static void Runner_run(){

		beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            'ローソン' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Default'),
                Name = '_'
            )
        };
		INSERT theAccounts.values();

		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'ローソンアライアンス' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Alliance'),
				Teikeisaki__c = theAccounts.get('ローソン').Id
			)
		};
		INSERT theKeiyakus.values();
		String theAllianceKeiyakuBango = [
			SELECT KeiyakuBango__c FROM Keiyaku__c WHERE Id = :theKeiyakus.get('ローソンアライアンス').Id
		].get(0).KeiyakuBango__c;

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '葬儀手配' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('葬儀手配').Id,
				AllianceRef__c = theKeiyakus.get('ローソンアライアンス').Id
            )
        };
        INSERT theOpps.values();

		Map<String, Case> theCases = new Map<String, Case>{
			'Web事前準備' => new Case(
				RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId(),
				AccountId =theAccounts.get('客').Id,
				ToiawaseDate__c = Datetime.newInstance(2000,1,2,0,0,0)
			)
		};
		INSERT theCases.values();
		String theCaseNumber = [
			SELECT CaseNumber FROM Case WHERE Id = :theCases.get('Web事前準備').Id
		].get(0).CaseNumber;

		endSetUp();

		Test.startTest();
		new LwsnJizenJunbis.Runner().run(theAllianceKeiyakuBango, theCaseNumber);
		Test.stopTest();
	}
}