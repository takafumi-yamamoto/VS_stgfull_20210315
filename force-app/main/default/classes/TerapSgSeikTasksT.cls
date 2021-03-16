@isTest
public class TerapSgSeikTasksT {
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
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	private static Map<String, TerapSgSeikTasksDst4Seiks.KakinEntData> theKakinEntDatas = new Map<String, TerapSgSeikTasksDst4Seiks.KakinEntData>{
		'01-01' => new TerapSgSeikTasksDst4Seiks.KakinEntData()
			.setKakinEntId('01-01')
			.setTorihikiSakiBango('TorihikiSakiBango-01').setKeiyakuBango('KeiyakuBango-01').setBeginDate( Date.newInstance(2020,1,1) )
			.setKakinScheme('従量課金').setTeigakuKakinGaku(0).setTesuryoRate(50).setIsFirstMonth(false),
		'01-02' => new TerapSgSeikTasksDst4Seiks.KakinEntData()
			.setTorihikiSakiBango('TorihikiSakiBango-01').setKeiyakuBango('KeiyakuBango-01').setBeginDate( Date.newInstance(2020,2,1) )
			.setKakinEntId('01-02')
			.setKakinScheme('従量課金').setTeigakuKakinGaku(0).setTesuryoRate(50).setIsFirstMonth(false),
			
		'02-01' => new TerapSgSeikTasksDst4Seiks.KakinEntData()
			.setKakinEntId('02-01')
			.setTorihikiSakiBango('TorihikiSakiBang-02').setKeiyakuBango('KeiyakuBango-02').setBeginDate( Date.newInstance(2020,1,1) )
			.setKakinScheme('定額課金').setTeigakuKakinGaku(10000).setTesuryoRate(50).setIsFirstMonth(false),
		'03-01' => new TerapSgSeikTasksDst4Seiks.KakinEntData()
			.setKakinEntId('03-01')
			.setTorihikiSakiBango('TorihikiSakiBang-03').setKeiyakuBango('KeiyakuBango-03').setBeginDate( Date.newInstance(2020,1,1) )
			.setKakinScheme('定額課金').setTeigakuKakinGaku(10000).setTesuryoRate(50).setIsFirstMonth(true)
	};
	private static Map<String,TerapSgSeikTasksDst4Seiks.ToiawaseData> theToiawaseDatas = new Map<String,TerapSgSeikTasksDst4Seiks.ToiawaseData>{
		'01-01' => new TerapSgSeikTasksDst4Seiks.ToiawaseData()
			.setSogishaTorihikiSakiBango('TorihikiSakiBango-01').setToiawaseDate( Date.newInstance(2020,1,1) )
			.setObouPlan('四十九日法要').setSeshuName('施主-01')
	};

	private static Map<String,TerapSgSeikTasksDst4Seiks.SekoData> theSekoDatas = new Map<String,TerapSgSeikTasksDst4Seiks.SekoData>{
		'01-01' => new TerapSgSeikTasksDst4Seiks.SekoData()
			.setSogishaTorihikiSakiBango('TorihikiSakiBango-01').setSekoDate( Date.newInstance(2020,1,1) )
			.setObouPlan('四十九日法要'),
		'01-02' => new TerapSgSeikTasksDst4Seiks.SekoData()
			.setSogishaTorihikiSakiBango('TorihikiSakiBango-01').setSekoDate( Date.newInstance(2020,1,1) )
			.setObouPlan('火葬式'),
		'03-01' => new TerapSgSeikTasksDst4Seiks.SekoData()
			.setSogishaTorihikiSakiBango('TorihikiSakiBango-03').setSekoDate( Date.newInstance(2020,1,1) )
			.setObouPlan('四十九日法要')
	};
	public class KakinEntDataPvrStub implements TerapSgSeikTasksDst4Seiks.IKakinEntDataPvr{
		public List<TerapSgSeikTasksDst4Seiks.KakinEntData> selectByIds(List<String> pIds){
			List<TerapSgSeikTasksDst4Seiks.KakinEntData> theEntries = new List<TerapSgSeikTasksDst4Seiks.KakinEntData>();
			for(TerapSgSeikTasksDst4Seiks.KakinEntData aKakinEntData : theKakinEntDatas.values() ){
				if( aKakinEntData.BeginDate == Date.newInstance(2020,1,1) ) theEntries.add(aKakinEntData);
			}
			return theEntries;
		}
		public List<TerapSgSeikTasksDst4Seiks.KakinEntData> selectForKakinByTargetYm(Date pTargetYearMonth, List<String> pKeiyakuBangos){
			List<TerapSgSeikTasksDst4Seiks.KakinEntData> theEntries = new List<TerapSgSeikTasksDst4Seiks.KakinEntData>();
			for(TerapSgSeikTasksDst4Seiks.KakinEntData aKakinEntData : theKakinEntDatas.values() ){
				if( !pKeiyakuBangos.contains(aKakinEntData.KeiyakuBango) ) continue;
				if( aKakinEntData.BeginDate != pTargetYearMonth ) continue;
				theEntries.add(aKakinEntData);
			}
			return theEntries;
		}
	}
	public class KeiyakuDataPvrStub implements TerapSgSeikTasksDst4Seiks.IKeiyakuDataPvr{
		public List<TerapSgSeikTasksDst4Seiks.KeiyakuData> selectByKeiyakuBangos(List<String> pKeiyakuBangos){

		return new List<TerapSgSeikTasksDst4Seiks.KeiyakuData>{
			new TerapSgSeikTasksDst4Seiks.KeiyakuData().setKeiyakuBango('KeiyakuBango-01')
				.setTorihikiSakiBango('TorihikiSakiBango-01').setTorihikiSakiName('TorihikiSakiName-01')
				.setToAddrZipCode('001-0001').setToAddrState('ToAddrState-01')
				.setToAddrCity('ToAddrCity-01').setToAddrStreet('ToAddrStreet-01'),
			new TerapSgSeikTasksDst4Seiks.KeiyakuData().setKeiyakuBango('KeiyakuBango-02')
				.setTorihikiSakiBango('TorihikiSakiBango-02').setTorihikiSakiName('TorihikiSakiName-02')
				.setToAddrZipCode('002-0002').setToAddrState('ToAddrState-02')
				.setToAddrCity('ToAddrCity-02').setToAddrStreet('ToAddrStreet-02'),
			new TerapSgSeikTasksDst4Seiks.KeiyakuData().setKeiyakuBango('KeiyakuBango-03')
				.setTorihikiSakiBango('TorihikiSakiBango-03').setTorihikiSakiName('TorihikiSakiName-03')
				.setToAddrZipCode('003-0003').setToAddrState('ToAddrState-03')
				.setToAddrCity('ToAddrCity-03').setToAddrStreet('ToAddrStreet-03')
		};
		}
	}
	public class ToiawaseDataPvrStub implements TerapSgSeikTasksDst4Seiks.IToiawaseDataPvr{
		 public List<TerapSgSeikTasksDst4Seiks.ToiawaseData> selectForToiawaseByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos){
			List<TerapSgSeikTasksDst4Seiks.ToiawaseData> theEntries = new List<TerapSgSeikTasksDst4Seiks.ToiawaseData>();
			for(TerapSgSeikTasksDst4Seiks.ToiawaseData aToiawaseData : theToiawaseDatas.values() ){
				if( !pSogishaTorihikisakiBangos.contains(aToiawaseData.SogishaTorihikiSakiBango) ) continue;
				if( aToiawaseData.ToiawaseDate != pTargetYearMonth ) continue;
				theEntries.add(aToiawaseData);
			}
			return theEntries;
		 }
	}
	public class SekoDataPvrStub implements TerapSgSeikTasksDst4Seiks.ISekoDataPvr{
		 public List<TerapSgSeikTasksDst4Seiks.SekoData> selectByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos){
			List<TerapSgSeikTasksDst4Seiks.SekoData> theEntries = new List<TerapSgSeikTasksDst4Seiks.SekoData>();
			for(TerapSgSeikTasksDst4Seiks.SekoData aSekoData : theSekoDatas.values() ){
				if( !pSogishaTorihikisakiBangos.contains(aSekoData.SogishaTorihikiSakiBango) ) continue;
				if( aSekoData.SekoDate != pTargetYearMonth ) continue;
				theEntries.add(aSekoData);
			}
			return theEntries;
		 }
	}

	@isTest
	public static void doTest(){

		Date theBillingYm = Date.newInstance(2020,1,1);
		List<String> theKakinEntIds = new List<String>();
		for(TerapSgSeikTasksDst4Seiks.KakinEntData aKakinEntData : theKakinEntDatas.values() ){
			if( aKakinEntData.BeginDate == theBillingYm ) theKakinEntIds.add(aKakinEntData.KakinEntId);
		}

		TerapSgSeikTasks theTerapSgSeikTasks = 
			new TerapSgSeikTasks(
				new TerapSgSeikTasksDst4Seiks(
					new KakinEntDataPvrStub(), new KeiyakuDataPvrStub(),
					new ToiawaseDataPvrStub(), new SekoDataPvrStub()
				),
				theBillingYm
			);

		List<TerapSgSeikTasks.SeikyuData> theSeikyuDatas = theTerapSgSeikTasks.createSeikyus( theKakinEntIds, theBillingYm );

		theTerapSgSeikTasks.saveSeikyuDatas(theSeikyuDatas);
	}

	@isTest
	public static void startBatch(){
		beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Sogisya' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
		INSERT theAccounts.values();
		Map<String, Keiyaku__c> theKeiyakus = new Map<String, Keiyaku__c>{
			'SouryoTehaiDaiko' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SouryoTehaiDaiko'),
				Teikeisaki__c = theAccounts.get('Sogisya').Id
			)
		};
		INSERT theKeiyakus.values();
		String theKeiyakuBango = [ SELECT KeiyakuBango__c FROM Keiyaku__c WHERE Id = :theKeiyakus.get('SouryoTehaiDaiko').Id ].get(0).KeiyakuBango__c;
		TeiHehDaiKakinSchEnt__c theKakinEntData = 
			new TeiHehDaiKakinSchEnt__c( 
				KeiyakuRef__c = theKeiyakus.get('SouryoTehaiDaiko').Id, BeginDate__c = Date.newInstance(2020,2,1), KakinScheme__c = '従量課金'
			);
		INSERT theKakinEntData;
		endSetUp();
		Test.startTest();
			TerapSgSeikTasks.start( Date.newInstance(2020,2,1) );
		Test.stopTest();
	}
	
}