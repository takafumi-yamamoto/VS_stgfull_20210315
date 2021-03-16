@isTest
public class Opportunity_SimeSiharaiDateTest {

    public static Map<String,Keiyaku__c> keiyakuMap = new Map<String,Keiyaku__c>();

    @isTest(seeAllData=true)
    public static void onOppAfterUpdate_ObouNyukinShimeDate(){
    // static testMethod void onOppAfterUpdate_ObouNyukinShimeDate(){
        Account theAccount = new Account(
            Name = '_', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId()
        );
        Insert theAccount;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
            TaishoushaJokyo__c = '_'
        );
        Insert theOpp;

        Keiyaku__c theKeiyaku = new Keiyaku__c(
            Teikeisaki__c = theAccount.Id,
            NyukinSimekiriJouken__c = '３日後',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId()
        );
        insert theKeiyaku;

        Opportunity theOppAfter = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0);
        theOppAfter.TesuryoPartner__c = -10000;
        theOppAfter.KetteiSakiRef__c = theKeiyaku.Id;
        theOppAfter.Utiagebi__c = Date.valueOf('2000-01-01');
        update theOppAfter;

        Opportunity theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOppAfter.Id } ).get(0);

        System.Debug(theActual);
        System.Debug('theActual.ShiharaiKijitsuPartner__c;' + theActual.ShiharaiKijitsuPartner__c);
        System.Debug('theActual.NyukinSimekiriBiPartner__c;' + theActual.NyukinSimekiriBiPartner__c);
    }
    @isTest
    public static void onOppBeforeUpdate1(){

        //入金締切条件が「請求書発送日から7日後」
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('請求書発送日から7日後').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.StageName = '施行完了';
        theOpp.SeikyushoHassoubiPartner__c = date.newinstance(2019, 10, 23);
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate2(){

        //当月20日締めの場合
        //**売上日が2019/10/20の場合**
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('当月20日締め当月末').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.StageName = '施行完了';
        theOpp.SeikyushoHassoubiPartner__c = date.newinstance(2019, 10, 23);
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }

    @isTest
    public static void onOppBeforeUpdate3(){

        //当月1-20日締め翌月20日、当月21日-月末締め翌月末の場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('当月1-20日締め翌月20日、当月21日-月末締め翌月末').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.StageName = '施行完了';
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate4(){
        //月末締め翌月10日の場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('月末締め翌月10日').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.StageName = '施行完了';
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate5(){
        //月末締め翌々月末の場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('月末締め翌々月末').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.StageName = '施行完了';
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate6(){
        //**売上日が2019/10/21の場合**
        //当月20日締めの場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('当月20日締め翌月10日').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.Utiagebi__c = Date.valueOf('2019-10-21');
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate7(){
        //**売上日が2019/10/21の場合**
        //当月1-20日締め翌月20日、当月21日-月末締め翌月末の場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('当月1-20日締め翌月20日、当月21日-月末締め翌月末').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.Utiagebi__c = Date.valueOf('2019-10-21');
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate8(){
        //**売上日が2019/10/20の場合**
        //請求書発送日（パートナー）が変更された場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('請求書発送日から7日後').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.SeikyushoHassoubiPartner__c = date.newinstance(2019, 10, 27);
        theOpp.NyukinSimekiriBiPartner__c = null;
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate9(){
        //**売上日が2019/10/20の場合**
        //売上日が変更された場合 (2019/11/21に変更)
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('月末締め翌月10日').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.Utiagebi__c = Date.valueOf('2019-11-21');
        theOpp.StageName = '施行完了';
        theOpp.NyukinSimekiriBiPartner__c = null;
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    @isTest
    public static void onOppBeforeUpdate10(){
        //**売上日が2019/10/20の場合**
        //入金締切日(パートナー）がクリアされた場合
        createTestData();

        Opportunity theOpp = [
            SELECT 
                Id, 
                IsWon, 
                ShodanBangoF__c, 
                SeikyuYoteiGakuPartnerExp__c, 
                SeikyushoHassoubiPartner__c, 
                Utiagebi__c, 
                SimpleYasugoRef__c, 
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                NyukinSimekiriBiPartner__c 
            FROM Opportunity 
            WHERE Name = '_'
        ];

        Id keiyaku = keiyakuMap.get('月末締め翌月10日').Id;
        SimpleYasugo__c theSimple = new SimpleYasugo__c(Id = theOpp.SimpleYasugoRef__c, SimpleYasugoKeiyakuRef__c = keiyaku, TaiouKanouRiyu__c = '対応可能（斎場優先）');
        update theSimple;

        theOpp.KetteiSakiRef__c = keiyaku;
        theOpp.NyukinSimekiriBiPartner__c = null;
        update theOpp;

        Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(theOpp.Id);
    }
    private static void createTestData(){
        //取引先のデータ作成
        RecordType defualtAccountRT = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		Account dacc=new Account();
		dacc.LastName='xxxdefualt';
		dacc.Phone='088-0000-0001';
		dacc.MobilePhone__c='888-0000-0001';
		dacc.recordTypeId = defualtAccountRT.Id;
		insert dacc;

        Account sogishaAccount = new Account(
            Name = '_', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId()
        );
        Insert sogishaAccount;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        Id pricebookId = Test.getStandardPricebookId();
		// k_ShohinSyubetsu__c k_ShohinSyubetsu=[SELECT ID FROM k_ShohinSyubetsu__c WHERE ID__c = '1'];

        Product2 prod = new Product2(
		     Name = 'Product X',
		     ProductCode = 'Pro-X',
		     DataKubun__c='1:通常商品',  		
		    //  k_ShohinSyubetsuRef__c=k_ShohinSyubetsu.id,
		     isActive = true
		);
		
		insert prod;

		PricebookEntry pbEntry = new PricebookEntry(
		     Pricebook2Id = pricebookId,
		     Product2Id = prod.Id,
		     UnitPrice = 100.00,
		     IsActive = true
		);
		insert pbEntry;
        Opportunity theOpp = new Opportunity(
            AccountId = dacc.Id
            ,Name = '_'
            ,StageName = '_'
            ,CloseDate = Date.valueOf('1900-01-01')
            ,RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')
            ,TaishoushaJokyo__c = '_'
        );
        Insert theOpp;
        //商談商品の追加
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = theOpp.Id,
            Quantity = 1,
            PricebookEntryId = pbEntry.Id,
            SireKingaku__c = 6000,
            TotalPrice =10000
		);
		insert oli;
		// 商談クローズするために「請求方法」「請求金額」「決済日」を設定
		OkyakusamaSeikyuMeisai__c oOkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		oOkyakusamaSeikyuMeisai.OpportunityRef__c = theOpp.id;
		oOkyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_credit';
		oOkyakusamaSeikyuMeisai.SeikyuKingaku__c = 10000;
		oOkyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
		insert oOkyakusamaSeikyuMeisai;
        //パートナー売上
        PatnerUriage__c oPatnerUriage=new PatnerUriage__c();
		oPatnerUriage.Kingaku__c=20000;
		oPatnerUriage.Syodan__c  =theOpp.id;
		oPatnerUriage.Syohin__c=prod.id;
		insert oPatnerUriage;

        //シンプル安豪のアップデート
        Opportunity yasugoOppResult = [
            SELECT 
                Id
                ,SimpleYasugoRef__c
            FROM Opportunity
            WHERE Id = :theOpp.Id
        ];
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
        simpleYasugo.ID = yasugoOppResult.SimpleYasugoRef__c;
        simpleYasugo.SeikyushojuryoDay__c = Date.valueOf('1900-01-01');
        update  simpleYasugo;        

        keiyakuMap.put('請求書発送日から7日後',createKeiyaku(sogishaAccount.Id,'請求書発送日から7日後'));
        keiyakuMap.put('当月20日締め当月末',createKeiyaku(sogishaAccount.Id,'当月20日締め当月末'));
        keiyakuMap.put('当月1-20日締め翌月20日、当月21日-月末締め翌月末',createKeiyaku(sogishaAccount.Id,'当月1-20日締め翌月20日、当月21日-月末締め翌月末'));
        keiyakuMap.put('月末締め翌月10日',createKeiyaku(sogishaAccount.Id,'月末締め翌月10日'));
        keiyakuMap.put('月末締め翌々月末',createKeiyaku(sogishaAccount.Id,'月末締め翌々月末'));
        keiyakuMap.put('当月20日締め翌月10日',createKeiyaku(sogishaAccount.Id,'当月20日締め翌月10日'));
        keiyakuMap.put('当月1-20日締め翌月20日、当月21日-月末締め翌月末',createKeiyaku(sogishaAccount.Id,'当月1-20日締め翌月20日、当月21日-月末締め翌月末'));
        insert keiyakuMap.values();

        //商談をクローズ前までの状態にする
        Opportunity theOppAfter = new Opportunity();
        theOppAfter.Id = theOpp.Id;
        theOppAfter.TesuryoPartner__c = -10000;
        // theOppAfter.KetteiSakiRef__c = theKeiyaku.Id;
        theOppAfter.Utiagebi__c = Date.valueOf('2019-10-20');
        theOppAfter.Req_Day__c = Date.valueOf('1900-01-01');
        theOppAfter.KakuteibiSyodan__c = DateTime.valueOf('1900-01-01 00:00:00');
        update theOppAfter;
    }
    private static Keiyaku__c createKeiyaku(Id accId,String simejoken){
        return new Keiyaku__c(
            Teikeisaki__c = accId
            ,NyukinSimekiriJouken__c = simejoken
            ,RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId()
        );
    }

}