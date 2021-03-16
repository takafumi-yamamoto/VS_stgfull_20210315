@isTest
public class Tes_ShodanShohinNavigaterController {
	// @isTest(SeeAllData=true)
	// static void JizenwariTest(){

	// 	Account Acc=new Account();
	// 	Acc.name='テスト';
	// 	insert Acc;
		
	// 	Case c=new Case();
	// 	c.accountid=Acc.id;
	// 	c.description='';
	// 	insert c;
	//     // 商談
	// 	String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
	// 	Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
	// 	insert opp;	

	// 	Jizenwari__c Jizenwari=new Jizenwari__c(CaseRef__c = c.Id);
	// 	insert Jizenwari;
	//     String oppJizenwariRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari');
	// 	Opportunity oppJizenwari = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppJizenwariRdId, JizenwariRef__c=Jizenwari.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
	// 	insert oppJizenwari;
	// }

	@isTest
	static void simpleYasugoTest(){
		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;
	
	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

        //==============SimpleYasugo__c===============
        SimpleYasugo__c simpleYasugo = new SimpleYasugo__c(CaseRef__c = c.Id);
		insert simpleYasugo;			
	    String oppSimpleYasugoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppSimpleYasugo = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSimpleYasugoRdId, SimpleYasugoRef__c=simpleYasugo.id, 
			TorihikiShodanRef__c=opp.id,StageName = 'フォロー',CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);	
		insert oppSimpleYasugo;	
	}

	@isTest
	static void obouTest(){
		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;

	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

		Obosanbin__c Obosanbin=new Obosanbin__c(CaseRef__c = c.Id);
		insert Obosanbin;		
	    String oppObosanbinRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');
		Opportunity oppObosanbin = new Opportunity(
			Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppObosanbinRdId, 
			ObosanbinRef__c=Obosanbin.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,
			CloseDate = system.today(), TaishoushaJokyo__c = '_'
			);	
		insert oppObosanbin;
	}

	@isTest
	static void obouSeizen(){
		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;

	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	

		SeizenKeiyaku__c SeizenKeiyaku=new SeizenKeiyaku__c(CaseRef__c = c.Id);
		insert SeizenKeiyaku;
	    String oppSeizenKeiyakuRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
		Opportunity oppSeizenKeiyaku = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppSeizenKeiyakuRdId, SeizenKeiyakuRef__c=SeizenKeiyaku.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppSeizenKeiyaku;
	}

	@isTest
	static void testCase1(){
		Account Acc=new Account();
		Acc.name='テスト';
		insert Acc;
		
		Case c=new Case();
		c.accountid=Acc.id;
		c.description='テスト';
		insert c;

	    // 商談
		String oppTorihikiShodanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
		Opportunity opp = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppTorihikiShodanRdId, StageName = 'フォロー',CloseDate = system.today());	
		insert opp;	
		
		EitaiKuyo__c EitaiKuyo=new EitaiKuyo__c(CaseRef__c = c.Id);
		insert EitaiKuyo;
	    String oppEitaiKuyoRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','PerpetualMemorial');
		Opportunity oppEitaiKuyo = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppEitaiKuyoRdId, EitaiKuyoRef__c=EitaiKuyo.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppEitaiKuyo;

		BestButsudan__c BestButsudan=new BestButsudan__c(CaseRef__c = c.Id);
		insert BestButsudan;
	    String oppBestButsudanRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan');
		Opportunity oppBestButsudan = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppBestButsudanRdId, BestButsudanRef__c=BestButsudan.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppBestButsudan;
			
		KyokaHaitatsuRev__c KyokaHaitatsuRev=new KyokaHaitatsuRev__c(CaseRef__c = c.Id);
		insert KyokaHaitatsuRev;
	    String oppKyokaHaitatsuRevRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Kyouka');
		Opportunity oppKyokaHaitatsuRev = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppKyokaHaitatsuRevRdId, KyokaHaitatsuRevRef__c=KyokaHaitatsuRev.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppKyokaHaitatsuRev;
		
		Hakapita__c Hakapita=new Hakapita__c(CaseRef__c = c.Id);
		insert Hakapita;
	    String oppHakapitaRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Hakapita');
		Opportunity oppHakapita = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppHakapitaRdId, HakaPitaRef__c=Hakapita.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppHakapita;

		UchusoSorae__c UchusoSorae=new UchusoSorae__c(CaseRef__c = c.Id);
		insert UchusoSorae;
	    String oppUchusoSoraeRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SpaceFuneral');
		Opportunity oppUchusoSorae = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppUchusoSoraeRdId, UchusoSoraeRef__c=UchusoSorae.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppUchusoSorae;

		KakuyasuBoseki__c KakuyasuBoseki=new KakuyasuBoseki__c(CaseRef__c = c.Id);
		insert KakuyasuBoseki;
	    String oppKakuyasuBosekiRdId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuBoseki');
		Opportunity oppKakuyasuBoseki = new Opportunity(Name = 'テスト商談', AccountId = acc.Id, CaseRef__c=c.id,RecordTypeId = oppKakuyasuBosekiRdId, KakuyasuBosekiRef__c=KakuyasuBoseki.id, StageName = 'フォロー',TorihikiShodanRef__c=opp.id,CloseDate = system.today());	
		insert oppKakuyasuBoseki;
				
		Test.startTest();
		ShodanShohinNavigaterController.getDataContext(Acc.id);
		ShodanShohinNavigaterController.getDataContext(c.id);
		ShodanShohinNavigaterController.getDataContext(opp.id);
		
				
		Test.stopTest();
	}
}