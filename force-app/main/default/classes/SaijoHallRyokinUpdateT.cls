@isTest
public class SaijoHallRyokinUpdateT {

    static testMethod void testMethod_case1(){

        //カスタム設定のTriggerIsActive__cのデータを作成
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        // 都道府県
		TodoufuKen__c todoufuKen = new TodoufuKen__c();
	    // todoufuken36.id = 'a177F000000NnHCQA0';    // カスタムオブジェクト ID
	    todoufuKen.name = '東京都';   // 都道府県
	    todoufuKen.kencode__c = '13';   // 県コード
	    todoufuKen.pkey__c = '東京都';   // PKey
	    insert todoufuKen;

		// 市区郡
	    Shikugun__c shikugun = new Shikugun__c();
	    // shikugun1271.id = 'a0v7F000000aRqIQAU';    // カスタムオブジェクト ID
	    shikugun.name = '東京都品川区';   // 市区郡名称
	    shikugun.areacode__c = '13109';   // エリアコード
	    shikugun.chiriichijouhou__latitude__s = 35.6092261;   // 地理位置情報 (Latitude)
	    shikugun.chiriichijouhou__longitude__s = 139.7301861;   // 地理位置情報 (Longitude)
	    shikugun.shikugunmeifurigana__c = 'しながわく';   // 市区郡名(かな)
	    shikugun.todoufukenref__c = todoufuKen.Id;   // 都道府県
	    shikugun.shikugunmei__c = '品川区';   // 市区郡名
	    //shikugun1271.mukobi__c = DateTime.now();   // 無効日
	    insert shikugun;

        Saijo__c saijo = new Saijo__c();
	    saijo.name = 'テスト五反田斎場';
	    saijo.PostalCode__c = '141-0022';
	    saijo.ShikugunRef__c = shikugun.Id;
	    saijo.Street__c = '東五反田１丁目';
	    insert saijo;

        Test.startTest();

        SaijoHall__c saijoHall = new SaijoHall__c();
	    saijoHall.SaijoRef__c = saijo.Id;
	    saijoHall.Name = 'テストホール';
	    insert saijoHall;

        saijoHall.X2ShiyoRyokinSonota__c = 1;
        update saijoHall;

        Test.stopTest();
    }
}