@isTest
public class Tes_ObouSekouKakuninBatch {

	static testMethod void testCase(){

		Test.startTest();

        OboSekoKakuninSetting__c oboSekoKakuninSetting=new OboSekoKakuninSetting__c();
        oboSekoKakuninSetting.name='default';
        oboSekoKakuninSetting.Kaimyo_tel__c='03-5348-6766';
        oboSekoKakuninSetting.SogiHoyo_tel__c='03-5348-6766';
        insert oboSekoKakuninSetting;



        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert sodansha;

        Account moshu = new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert moshu;

        Account taishosha = new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert taishosha;


        Id soryoRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount');
        Account soryo = new Account(Name = '対象者 テスト',RecordTypeId = soryoRecordTypeId, MobilePhone__c = '0311111111');
        insert soryo;


		// 契約
		Id keiyakuRecordtype = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin');
		Keiyaku__c keiyaku = new Keiyaku__c( Name = 'テスト提携',
											 Teikeisaki__c = soryo.Id,
											 KeiyakuJokyo__c = '契約中',
											 RecordTypeId = keiyakuRecordtype,
											 Madoguchisoryo__c = soryo.Id,
											 HomutaiokanoArea__c = '東京都',
											 ObousanBinTehaiKubun__c = '自社手配'
											 );
		insert keiyaku;

        Obosanbin__c service = new Obosanbin__c(Taishosha1Ref__c = taishosha.Id,
        									    MoshuRef__c = moshu.Id,
        									    ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
        									    KokubetsuDateTime_Inp__c = DateTime.now()
        									    );
        insert service;


		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = sodansha.Id,
											StageName = '施行待ち',
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											ObosanbinRef__c = service.Id,
											KakuteibiSyodan__c = Date.today()
										);
	    insert opp;

	    Bat_ObouSekouKakuninBatch testBatch = new Bat_ObouSekouKakuninBatch();
	    //Database.executeBatch(testBatch,200);

	    Test.stopTest();
	}


}