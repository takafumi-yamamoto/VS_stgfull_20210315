@isTest
private class Tes_FuneralCompany
{

    /**
    * testMethodSearchData
    * 検索アクションテスト
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    static testMethod void testMethodSearchData(){
        Ctrl_FuneralCompany cls = new Ctrl_FuneralCompany();
        cls.searchWrapper.radioLookup = true;
        cls.searchWrapper.account.ShikugunRef__c = shikugun.Id;
        // テスト実行
        Test.startTest();
        // 顧客基本情報 のリスト
        cls.searchData();
        // テスト終了
        Test.stopTest();
        // 結果比較
        //System.assertEquals(1, cls.listFuneralCompanyWrapper.size());
        //System.assertEquals(5, cls.listShisetuWrapper.size());
    }

    /**
    * testMethodClearData
    * データをクリアするテスト
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    static testMethod void testMethodClearData(){
        Ctrl_FuneralCompany cls = new Ctrl_FuneralCompany();
        // テスト実行
        Test.startTest();
        // 顧客基本情報 のリスト
        cls.clearData();
        // テスト終了
        Test.stopTest();
        // 結果比較
        System.assertEquals(0, cls.listFuneralCompanyWrapper.size());
        System.assertEquals(0, cls.listShisetuWrapper.size());
    }

    private static List<Keiyaku__c> lstKeiyaku;
    private static List<Account> lstAccount;
    private static List<Shisetsu__c> lstShisetu;
    private static Shikugun__c shikugun;
    static {
        shikugun = createShikugun();
        lstAccount = new List<Account>();
        for(Integer i=0; i<5; i++){
            Account account = new Account();
            account.Name = 'Account' + i;
            account.BillingState = '東京都';
            account.Syushi__c = '仏教';
            account.Syuha__c = '真言宗';
            account.BillingLatitude = 35.689488;
            account.BillingLongitude = 139.691706;
            account.ShikugunRef__c = shikugun.Id;
            account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
            lstAccount.add(account);
        }
        insert lstAccount;

        lstKeiyaku = new List<Keiyaku__c>();
        for(Integer i=0; i<5; i++){
            Keiyaku__c keiyaku = new Keiyaku__c();
            keiyaku.Teikeisaki__c = lstAccount[0].Id;
            keiyaku.Madoguchisoryo__c = lstAccount[1].Id;
            keiyaku.HomutaiokanoArea__c = '北海道';
            keiyaku.RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
            lstKeiyaku.add(keiyaku);
        }
        insert lstKeiyaku;

        SekouKanouArea__c sekouKanouArea = new SekouKanouArea__c();
        sekouKanouArea.SimpleYasugoKeiyakuRef__c = lstKeiyaku[0].Id;
        sekouKanouArea.ShikugunRef__c = shikugun.Id;
        insert sekouKanouArea;

        lstShisetu = new List<Shisetsu__c>();
        List<Shisetsu__c> lstShisetu = new List<Shisetsu__c>();
        for(Integer i=0; i<5; i++){
            Shisetsu__c shisetu = new Shisetsu__c();
            shisetu.IdoKedo__latitude__s = 35.689488;
            shisetu.IdoKedo__longitude__s = 139.691706;
            shisetu.Shikugun__c = shikugun.Id; 
            lstShisetu.add(shisetu);
        }
        insert lstShisetu;
        

    }

    private static Shikugun__c createShikugun(){
        Shikugun__c shikugun = new Shikugun__c();
        shikugun.Chiriichijouhou__latitude__s = 35.689488;
        shikugun.Chiriichijouhou__longitude__s = 139.691706;
        insert shikugun;
        return shikugun;
    }

}