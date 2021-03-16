@isTest
public class SorKetRenBatT {

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

	@isTest static void run(){
		beginSetUp(); 
		endSetUp();
		Test.startTest();
		SorKetRenBat.run('Shodan-Bango', '法要', '現金', 'メール');
		SorKetRenBat.run('Shodan-Bango', '法要', '現金', 'SMS');
		SorKetRenBat.run('Shodan-Bango', '法要', 'カード', 'メール');
		SorKetRenBat.run('Shodan-Bango', '法要', 'カード', 'SMS');
		SorKetRenBat.run('Shodan-Bango', '戒名', '現金', 'メール');
		SorKetRenBat.run('Shodan-Bango', '戒名', '現金', 'SMS');
		SorKetRenBat.run('Shodan-Bango', '戒名', 'カード', 'メール');
		SorKetRenBat.run('Shodan-Bango', '戒名', 'カード', 'SMS');
		Test.stopTest();
	}

	@isTest static void start(){
		beginSetUp(); 
        Map<String, Account> theAccounts01 = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts01.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts01.get('Customer').Id,
                StageName = '決定', SubPhase__c = '僧侶決定連絡',
				CloseDate = Date.newInstance(2000,1,1),
				SoryoKetteiRenrakuHoho__c = 'メール'
            )
        };
        Insert theOpps.values();
		endSetUp();
		Test.startTest();
		SorKetRenBat.start();
		Test.stopTest();
	}
}