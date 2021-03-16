@isTest
public class Tes_JizenwariNyukinKakuninTsuchi {

	@isTest(SeeAllData=true)
	static void testCase(){

        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト',RecordTypeId = accRecordTypeId,MailAddress__c = 'test@minrevi.jp');
        insert sodansha;

        Jizenwari__c service = new Jizenwari__c(KeiyakuSha__c = sodansha.Id,MoushikomiKanryoBi__c = date.Today());
        insert service;
        List<Jizenwari__c> jizenwaris = new List<Jizenwari__c>();
        jizenwaris.add(service);

		// サービス商談作成
		Id oppRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari');
		Opportunity opp = new Opportunity(
											Name = 'テスト商談',
											AccountId = sodansha.Id,
											StageName = '問合せ受付',
											CloseDate = date.Today(),
											RecordTypeId = oppRecordTypeId,
											JizenwariRef__c = service.Id
										);
	    insert opp;

	    OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(SeikyuKingaku__c = 5000,OpportunityRef__c = opp.Id,Kessaibi__c = date.Today(),SeikyuHouhou__c='furikomi');
	    insert okyakusamaSeikyuMeisai;


	    Ctl_JizenwariNyukinKakuninTsuchi nyukinKakunin = new Ctl_JizenwariNyukinKakuninTsuchi();
	    nyukinKakunin.processingOfNyukinKakuninTsuchi(jizenwaris,Date.today());


	}
}