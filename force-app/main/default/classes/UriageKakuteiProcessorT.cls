@isTest
public class UriageKakuteiProcessorT {

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
		INSERT new List<KaiinkibanSetting__c>{
			new KaiinkibanSetting__c(
				name='dev',
				client_id__c='',
				client_secret__c='',
				grant_type__c='',
				timeOutPeriod__c=60000,
				Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com',
				KeiyakuCoreFlag__c=true,
				isActive__c=true
			),
			new KaiinkibanSetting__c(
				name='prod',
				client_id__c='',
				client_secret__c='',
				grant_type__c='',
				timeOutPeriod__c=60000,
				Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com',
				KeiyakuCoreFlag__c=true,
				isActive__c=true
            )
        };
		Utility_Common.isMimicExecAsDataIkouProfile = false;
    }

    private class RsCoreApi_Util_IRequester_Stub implements RsCoreApi_Util.IRequester{
        public void doAction(RsCoreApi_Util.IHttpRequest action, String method, Boolean isUsePatch){

            UriageKakuteiProcessor.UriagekakuteiResult a_result = new UriageKakuteiProcessor.UriagekakuteiResult();
            a_result.salesResults = new List<UriageKakuteiProcessor.SalesResult>();
            UriageKakuteiProcessor.SalesResult a_sales_result = new UriageKakuteiProcessor.SalesResult();
            a_sales_result.salesDate = '20200101';
            a_result.salesResults.add(a_sales_result);

            HttpResponse a_HttpResponse = new HttpResponse();
            a_HttpResponse.setStatusCode(200);
            a_HttpResponse.setBody( JSON.serialize(a_result) );
            action.doOnSuccess(a_HttpResponse);
        }
    }
	@isTest static void execute(){
		beginSetUp();
		Map<String, Account> the_accounts = new Map<String, Account>{
			'客-1' => new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '_', LastName = '_'
			)
		};
		INSERT the_accounts.values();

		Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
			'葬儀商談-1' => new Opportunity(
				RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
				AccountId = the_accounts.get('客-1').Id,
				Name = '_',
				StageName = '_',
				Utiagebi__c = Date.newInstance(2020, 1, 1),
				CloseDate = Date.newInstance(2020, 1, 1)
			)
		};
		INSERT the_opps.values();

		Map<String, OkyakusamaSeikyuMeisai__c> the_seikyu_lines = new Map<String, OkyakusamaSeikyuMeisai__c>{
			'GMOクレカ' => new OkyakusamaSeikyuMeisai__c(
				OpportunityRef__c = the_opps.get('葬儀商談-1').Id,
				ServiceSyubetsu__c = 'シンプル安豪',
				SeikyuHouhou__c = 'gmo_credit',
				RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId(),
				SeikyuKingaku__c = 1000,
				Kessaibi__c = Date.newInstance(2020, 1, 1),
				SeikyuStatus__c = '決済済',
				SeikyuOya__c = null,
				SeikyuHohoCode__c = '1',
				SeikyuBango__c = 'SKBG-0000010221'	
			)
		};
		INSERT the_seikyu_lines.values();
		endSetUp();

		Test.startTest();
        RsCoreApi_Util.m_IRequester_instance = new RsCoreApi_Util_IRequester_Stub();

        new UriageKakuteiProcessor(
            new OkyakusamaSeikyuMeisai__c(Id = the_seikyu_lines.get('GMOクレカ').Id )
        )
        .execute(null);
		Test.stopTest();
	}
}