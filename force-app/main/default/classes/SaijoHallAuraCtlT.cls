@isTest
public class SaijoHallAuraCtlT {

    @isTest
	static void test1() {
		TodoufuKen__c todoufuken36 = new TodoufuKen__c();
	    // todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
	    todoufuken36.name = '東京都';   // 都道府県
	    todoufuken36.kencode__c = '13';   // 県コード
	    todoufuken36.pkey__c = '東京都';   // PKey
	    insert todoufuken36;

	    Shikugun__c shikugun1271 = new Shikugun__c();
	    // shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
	    shikugun1271.name = '東京都品川区';   // 市区郡名称
	    shikugun1271.areacode__c = '13109';   // エリアコード
	    shikugun1271.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
	    shikugun1271.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
	    shikugun1271.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
	    shikugun1271.todoufukenref__c = todoufuken36.Id;   // 都道府県
	    shikugun1271.shikugunmei__c = '品川区';   // 市区郡名
	    //shikugun1271.mukobi__c = DateTime.now();   // 無効日
	    insert shikugun1271;

        Saijo__c saijo0 = new Saijo__c();
	    saijo0.name = 'テスト五反田斎場';
	    saijo0.PostalCode__c = '141-0022';
	    saijo0.ShikugunRef__c = shikugun1271.Id;
	    saijo0.Street__c = '東五反田１丁目';
	    insert saijo0;

	    Test.startTest();
	    SaijoHallAuraCtl.auraGetSaijoHallListBySaijoId(saijo0.Id);
	    Test.stopTest();
    }
}