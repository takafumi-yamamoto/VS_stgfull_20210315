@isTest
public class Tes_SoryoSearch {

	static testMethod void testMethod_SoryoSearch(){

		Test.startTest();

		// 都道府県
		TodoufuKen__c todoufuKen = new TodoufuKen__c(Name = '東京都');
		insert todoufuKen;

		// 市区郡
		Shikugun__c shikugun = new Shikugun__c(Name = '東京都渋谷区',TodoufuKenRef__c = todoufuKen.Id,Chiriichijouhou__latitude__s = 35.689634, Chiriichijouhou__longitude__s = 139.692101);
		insert shikugun;

		// 僧侶
		Id sogisyaRecordtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
		Account testSoryo  = new Account( Name = 'テスト僧侶 テスト',ShikugunRef__c = shikugun.Id,BillingState = '東京都',RecordTypeId = sogisyaRecordtype );
		insert testSoryo;

		// 契約
		Id keiyakuRecordtype = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin');
		Keiyaku__c keiyaku = new Keiyaku__c( Name = 'テスト提携',
											 Teikeisaki__c = testSoryo.Id,
											 KeiyakuJokyo__c = '契約中',
											 RecordTypeId = keiyakuRecordtype,
											 Madoguchisoryo__c = testSoryo.Id,
											 HomutaiokanoArea__c = '東京都'
											 );
		insert keiyaku;

		Test.stopTest();


		Ctl_SoryoSearch soryoSearch = new Ctl_SoryoSearch();

		// 検索条件(参照)
		soryoSearch.searchWrapper.radioLookup = true;
		soryoSearch.searchJoken.SangoJiinMeiFurigana__c = 'テスト';
    	soryoSearch.searchJoken.HomutaiokanoArea__c = '東京都';
    	soryoSearch.searchJoken.JiinSyusi__c = 'テスト';
    	soryoSearch.searchJoken.JiinSyuha__c = 'テスト';
    	soryoSearch.searchJoken.SeiKana__c = 'テスト';
    	soryoSearch.searchJoken.Kaimyojuyonomiirai__c = '希望';
    	soryoSearch.searchJoken.Phone = '0311112222';
    	soryoSearch.searchJoken.ShikugunRef__c = shikugun.Id;
    	soryoSearch.searchData();

    	soryoSearch.clearData();

		//soryoSearch.searchWrapper.radioText = true;
		//soryoSearch.searchWrapper.address = '東京都渋谷区';

    	//soryoSearch.searchData();

	}
}