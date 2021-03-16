@isTest
public class Api_V1_ObthHistByAcntDtT {

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

	public class OboTehaiValidatorStub implements Api_V1_ObthHistByAcntRes.IOboTehaiValidator{
		public Boolean isValid(Api_V1_ObthHistByAcntRes.OboTehai pOboTehai){ return true; }
	}

	@isTest
	public static void DataProvider_getResponse(){

		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '対象者' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_',
				Syuha__c = '浄土真宗本願寺派'
            )
        };
		INSERT theAccounts.values();

		Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => 
				new Obosanbin__c(
					Taishosha1Ref__c = theAccounts.get('対象者').Id,
					MemorialServicePlan__c = '戒名・法名のみ'
				)
		};
		INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '商談クローズ',
				CloseDate = Date.newInstance(2000,1,1),
                ObosanbinRef__c = theObos.get('お坊').Id,
				Utiagebi__c = Date.newInstance(2020,1,1)
            )
        };
        INSERT theOpps.values();

		Api_V1_ObthHistByAcntReq.Req theReq = new Api_V1_ObthHistByAcntReq.Req();
		theReq.torihikisaki_bango = 
			[SELECT Id, TorihikisakiBango__c FROM Account WHERE Id = :theAccounts.get('客').Id ]
			.get(0)
			.TorihikisakiBango__c;

		endSetUp();

		Test.startTest();
			Api_V1_ObthHistByAcntRes.Response theRes =
				new Api_V1_ObthHistByAcntDt.DataProvider( 
					new OboTehaiValidatorStub() 
				)
				.getResponse(theReq);
		Test.stopTest();
	}
}