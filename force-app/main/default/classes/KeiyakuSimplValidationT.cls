@isTest
public class KeiyakuSimplValidationT {

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

	@isTest
	public static void chgKeiyakuStatusKeiyakuchuInsertT(){
		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId()
		);
		insert accSogisha;

		endSetUp();

		Test.startTest();
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '契約中',
            Keiyakukaishibi__c = Date.today(),
            SeikyushoHassoCycle__c = '都度',
            NyukinSimekiriJouken__c = '請求書発送日から7日後'
        );

        try{
        	insert keiyaku;
        }
        catch(Exception e){
			System.AssertEquals(e.getMessage().contains('有効な手数料適用がないため【契約状況】を契約中にできません。'), true);
		}

		Test.stopTest();
	}

	@isTest
	public static void chkKeiyakuStatusKeiyakuchuRequiredKeiyakuKaishibiT(){
		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			KinyukikanCodeTosha__c = '_', 
			KinyukikanMeiTosha__c = '_', 
			KozaShubetsuTosha__c = '普通', 
			KozaBangoTosha__c = '_', 
			KozaMeigiKanaTosha__c = '_', 
			KozaMeigiTosha__c = '_', 
			ShitenCodeTosha__c = '_', 
			ShitenMeiTosha__c = '_'
		);
		insert accSogisha;

		endSetUp();

		Test.startTest();
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '未契約',
            SeikyushoHassoCycle__c = '都度',
            NyukinSimekiriJouken__c = '請求書発送日から7日後'
        );
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        try{
        	keiyaku.KeiyakuJokyo__c = '契約中';
        	update keiyaku;
        }
        catch(Exception e){
			System.AssertEquals(e.getMessage().contains('【契約開始日】が未入力です。'), true);
		}

		Test.stopTest();
	}

	@isTest
	public static void chkKeiyakuStatusKeiyakuchuRequiredSeikyushoHassoCycleT(){
		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			KinyukikanCodeTosha__c = '_', 
			KinyukikanMeiTosha__c = '_', 
			KozaShubetsuTosha__c = '普通', 
			KozaBangoTosha__c = '_', 
			KozaMeigiKanaTosha__c = '_', 
			KozaMeigiTosha__c = '_', 
			ShitenCodeTosha__c = '_', 
			ShitenMeiTosha__c = '_'
		);
		insert accSogisha;

		endSetUp();

		Test.startTest();
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '未契約',
            NyukinSimekiriJouken__c = '請求書発送日から7日後'
        );
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        try{
        	keiyaku.KeiyakuJokyo__c = '契約中';
        	keiyaku.Keiyakukaishibi__c = Date.today();
        	update keiyaku;
        }
        catch(Exception e){
			System.AssertEquals(e.getMessage().contains('【請求書発送サイクル】が未入力です。'), true);
		}

		Test.stopTest();
	}

	@isTest
	public static void chkKeiyakuStatusKeiyakuchuRequiredNyukinshimekiriJokenT(){
		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			KinyukikanCodeTosha__c = '_', 
			KinyukikanMeiTosha__c = '_', 
			KozaShubetsuTosha__c = '普通', 
			KozaBangoTosha__c = '_', 
			KozaMeigiKanaTosha__c = '_', 
			KozaMeigiTosha__c = '_', 
			ShitenCodeTosha__c = '_', 
			ShitenMeiTosha__c = '_'
		);
		insert accSogisha;

		endSetUp();

		Test.startTest();
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '未契約',
            SeikyushoHassoCycle__c = '都度'
        );
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        try{
        	keiyaku.KeiyakuJokyo__c = '契約中';
        	keiyaku.Keiyakukaishibi__c = Date.today();
        	update keiyaku;
        }
        catch(Exception e){
			System.AssertEquals(e.getMessage().contains('【入金締切条件】が未入力です。'), true);
		}

		Test.stopTest();
	}

	@isTest
	public static void chgKeiyakuStatusKeiyakuchuToshaFurikomiKozaT(){
		beginSetUp();

		Account accSogisha = new Account(
			Name = '_',										// お客様・提携先名
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId(),
			KinyukikanCodeTosha__c = '_', 
			KinyukikanMeiTosha__c = '_', 
			KozaShubetsuTosha__c = '普通', 
			KozaBangoTosha__c = '_', 
			KozaMeigiKanaTosha__c = '_', 
			KozaMeigiTosha__c = '_', 
			ShitenCodeTosha__c = '_'
		);
		insert accSogisha;

		endSetUp();

		Test.startTest();
		
        Keiyaku__c keiyaku = new Keiyaku__c(
            Name = 'シンプル安豪契約',
            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
            Teikeisaki__c = accSogisha.Id,
            KeiyakuJokyo__c = '未契約',
            SeikyushoHassoCycle__c = '都度',
            NyukinSimekiriJouken__c = '請求書発送日から7日後'
        );
        insert keiyaku;

        k_Service__c kService = new k_Service__c( name='_', ID__c = '1' );
        insert kService;

        TesuryoPlan__c tesuryoPlan = new TesuryoPlan__c( 
            Name = '_',  CoreTesuryoPlanId__c = 1, ServiceRef__c = kService.Id,
            KobetsuPlanFlag__c = false, TesuryoNebikiSetteiKa__c = false );
        insert tesuryoPlan;

        TesuryoTekiyo__c tesuryoTekiyo = new TesuryoTekiyo__c(
            KeiyakuRef__c = keiyaku.Id,  
            ShoninStatus__c = 'ドラフト',
            TekiyoKaishiBi__c = Date.valueOf('1900-01-01'),
            TesuryoPlanRef__c = tesuryoPlan.Id,
            ServiceRef__c = kService.Id);
        insert tesuryoTekiyo;

        tesuryoTekiyo.ShoninStatus__c = '承認済';
        update tesuryoTekiyo;

        try{
        	keiyaku.KeiyakuJokyo__c = '契約中';
        	keiyaku.Keiyakukaishibi__c = Date.today();
        	update keiyaku;
        }
        catch(Exception e){
			System.AssertEquals(e.getMessage().contains('提携先の当社振込用口座情報に不備があります。'), true);
		}

		Test.stopTest();
	}
}