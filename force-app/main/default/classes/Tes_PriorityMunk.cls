/**
* クラス名  	:	Tes_PriorityMunk
* クラス概要 	:	僧侶検索画面
* @created  :	2017/11/30 Vinh Hua Quoc
* @modified :	
*/
@isTest
private class Tes_PriorityMunk
{	
	/**
    * testMethodCheckInputValid
    * チェック仕様テスト
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
	static testMethod void testMethodCheckInputValid(){
		Ctrl_PriorityMunk cls = new Ctrl_PriorityMunk();
		cls.searchWrapper.syozokusangojiinmeFurigana = '1';
		cls.searchWrapper.someiFurigana = '2';
		cls.searchWrapper.madoguchiSouryoRenrakuSaki = '3';
		// テスト実行
		Test.startTest();
		// 顧客基本情報 のリスト
		cls.searchData();
		// テスト終了
		Test.stopTest();
		// 結果比較
		System.assertEquals(true, String.isNotBlank(cls.messageInfo));
	}
	
	/**
    * testMethodSearchData
    * 検索アクションテスト
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
	static testMethod void testMethodSearchData(){
		Ctrl_PriorityMunk cls = new Ctrl_PriorityMunk();
		cls.searchWrapper.keiyakuBillingState.HomutaiokanoArea__c = '東京都;東京都';
		cls.searchWrapper.keiyaku.HomutaiokanoArea__c = '北海道;北海道';
		// テスト実行
		Test.startTest();
		// 顧客基本情報 のリスト
		cls.searchData();
		// テスト終了
		Test.stopTest();
		// 結果比較
		System.assertEquals(5, cls.resultWraperList.size());
	}

	/**
    * testMethodClearData
    * データをクリアするテスト
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
	static testMethod void testMethodClearData(){
		Ctrl_PriorityMunk cls = new Ctrl_PriorityMunk();
		// テスト実行
		Test.startTest();
		// 顧客基本情報 のリスト
		cls.clearData();
		// テスト終了
		Test.stopTest();
		// 結果比較
		System.assertEquals(0, cls.resultWraperList.size());
	}

	private static List<Keiyaku__c> lstKeiyaku;
	private static List<Account> lstAccount;
	static {

		lstAccount = new List<Account>();
		for(Integer i=0; i<5; i++){
			Account account = new Account();
			account.Name = 'Account' + i;
			account.BillingState = '東京都';
			account.Syushi__c = '仏教';
			account.Syuha__c = '真言宗';
			account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
			lstAccount.add(account);
		}
		insert lstAccount;

		lstKeiyaku = new List<Keiyaku__c>();
		for(Integer i=0; i<5; i++){
			Keiyaku__c keiyaku = new Keiyaku__c();
			keiyaku.Teikeisaki__c = lstAccount[0].Id;
			keiyaku.Madoguchisoryo__c = lstAccount[1].Id;
			keiyaku.HomutaiokanoArea__c = '北海道';
			lstKeiyaku.add(keiyaku);
		}
		insert lstKeiyaku;
	}
}