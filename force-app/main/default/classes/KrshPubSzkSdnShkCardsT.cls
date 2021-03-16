@isTest
public class KrshPubSzkSdnShkCardsT {
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
	private class setUpOboOpportunity_result{
		Map<String, Account> theAccounts;
		Map<String, Opportunity> theOpps;
		Map<String, SimpleYasugo__c> theSimpleYasugos;
	}
	private static setUpOboOpportunity_result setUpOboOpportunity(){


        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'FirstName', LastName = 'LastName',
				Phone = '000-0000-0000'
            ),
           'Taishosha' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
				FirstName = 'FirstName', LastName = 'LastName',
				PersonDeathDate__pc = Date.today()
            )
        };
		INSERT theAccounts.values();

        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            '1' => new SimpleYasugo__c(
				SonotaSaijoShisetsu__c = 'SaijoName',
				TaishoshaRef__c = theAccounts.get('Taishosha').Id,
				ZokugaraSodanshaNitottenoTaishosha__c = '本人'
            )
        };
        Insert theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('Customer').Id,
                StageName = '施行待ち',
				CloseDate = Date.newInstance(2000,1,1),
				Utiagebi__c = Date.today(),
                SimpleYasugoRef__c = theSimpleYasugos.get('1').Id
            )
        };
        Insert theOpps.values();

		setUpOboOpportunity_result theResult = new setUpOboOpportunity_result();
		theResult.theAccounts = theAccounts;
		theResult.theOpps = theOpps;
		theResult.theSimpleYasugos = theSimpleYasugos;
		return theResult;
	}

	@isTest static void procceedOpp(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;

		Case aCase = new Case(RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','surveyVisca'));
		INSERT aCase;
		SogiSurveyAfterSell__c aAftersell = new SogiSurveyAfterSell__c(CaseRef__c = aCase.Id, OpportunityRef__c = theOppId, SozokuSodanFlg__c = true);
		INSERT aAftersell;

		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        endSetUp();

		Test.startTest();
		KrshPubSzkSdnShkCards.f_TestDataFilter = new KrshPubSzkSdnShkCards.TestDataFilter();
		KrshPubSzkSdnShkCards.procceedOpp(theShodanBango, true);
		Test.stopTest();
	}

	@isTest static void start(){
		beginSetUp();
		setUpOboOpportunity_result the_setUpOboOpportunity_result = setUpOboOpportunity();
		Id theOppId = the_setUpOboOpportunity_result.theOpps.get('1').Id;
		String theShodanBango = [SELECT Id, ShodanBango__c FROM Opportunity WHERE Id = :theOppId].get(0).ShodanBango__c;
        endSetUp();

		Test.startTest();
		KrshPubSzkSdnShkCards.start();
		Test.stopTest();
	}
}