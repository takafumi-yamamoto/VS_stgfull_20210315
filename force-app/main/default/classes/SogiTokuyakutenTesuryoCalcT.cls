@isTest
public class SogiTokuyakutenTesuryoCalcT {

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

    @isTest static void TokuyakutenTesuryoCalc_ichinichi (){
        beginSetUp();

        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            ),
            '葬儀社-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Sogisya'),
                Name = '_'
            )
        };
        INSERT the_accounts.values();
        Map<String, Keiyaku__c> the_sogi_keiyakus = new Map<String, Keiyaku__c>{
			'葬儀契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
        INSERT the_sogi_keiyakus.values();

		Map<String, Keiyaku__c> the_tokuyakuten_keiyakus = new Map<String, Keiyaku__c>{
			'特約店契約-1' => new Keiyaku__c(
				RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),
				Teikeisaki__c = the_accounts.get('葬儀社-1').Id,
                SyuKeiyakuRef__c = the_sogi_keiyakus.get('葬儀契約-1').Id,
                KeiyakuJokyo__c = '契約中'
			)
		};
		INSERT the_tokuyakuten_keiyakus.values();

        Map<String , SogiShaTokuyakutenTesuryo__c > the_sogishatokuyakuten_tesuryo = new Map<String,SogiShaTokuyakutenTesuryo__c>{
            '特約店手数料-1' => new SogiShaTokuyakutenTesuryo__c (
                KeiyakuRef__c = the_tokuyakuten_keiyakus.get('特約店契約-1').Id,
                Tekiyokaishi__c = Date.newInstance(2000,1,1)
            )
        };
        INSERT the_sogishatokuyakuten_tesuryo.values();
        Map<String, SimpleYasugo__c> the_simple_yasugos = new Map<String, SimpleYasugo__c>{
            '葬儀-1' => new SimpleYasugo__c( 
                SimpleYasugoKeiyakuRef__c = the_sogi_keiyakus.get('葬儀契約-1').Id ,
                TokuyakutenKeiyakuRef__c = the_tokuyakuten_keiyakus.get('特約店契約-1').Id,
                TaiouKanouRiyu__c  ='対応可能（斎場優先）'
            )
        };
        INSERT the_simple_yasugos.values();

        Map<String , k_ShohinSyubetsu__c> the_shubetsu =  new Map<String , k_ShohinSyubetsu__c>{
            '商品種別' => new k_ShohinSyubetsu__c(
                Name = '本体（委託）',
                ID__c = '1'
            )
        };
        INSERT the_shubetsu.values();
        Map<String , k_Service__c> the_service =  new Map<String , k_Service__c>{
            'サービス名' => new k_Service__c(
                Name = 'シンプルなお葬式',
                ID__c = '1'
            )
        };
        INSERT the_service.values();

        Map<String, k_ShohinCategory__c> the_oppItems_category = new Map<String, k_ShohinCategory__c>{
            '商品カテゴリ-1' => new k_ShohinCategory__c(
                Name = '直葬',
                ID__c = 'chokusou'
            ),
            '商品カテゴリ-2' => new k_ShohinCategory__c(
                Name = '火葬式',	
                ID__c = 'kasou' 
            ),
            '商品カテゴリ-3' => new k_ShohinCategory__c(
                Name = '一日葬',	
                ID__c = 'ichinichi'
            ),
            '商品カテゴリ-4' => new k_ShohinCategory__c(
                Name = '家族葬',	
                ID__c = 'kazokusou' 
            ),
            '商品カテゴリ-5' => new k_ShohinCategory__c(
                Name = 'お花いっぱいのお葬式',	
                ID__c = 'yasugou-kazoku' 
            ),
            '商品カテゴリ-6' => new k_ShohinCategory__c(
                Name = '安豪一日',	
                ID__c = 'yasugou-ichinichi'
            ),
            '商品カテゴリ-7' => new k_ShohinCategory__c(
                Name = '一般葬',	
                ID__c = 'ippansou'
            )
        };
        INSERT the_oppItems_category.values();
        Map<String, Product2> theProds = new Map<String, Product2>{
            '葬儀プラン-1' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-1',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-1').Id
            ),
            '葬儀プラン-2' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-2',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-2').Id
            ),
            '葬儀プラン-3' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-3',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-3').Id
            ),
            '葬儀プラン-4' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-4',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-4').Id
            ),
            '葬儀プラン-5' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-5',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-5').Id
            ),
            '葬儀プラン-6' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-6',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-6').Id
            ),
            '葬儀プラン-7' => new Product2(
                Name = '_',
                IsActive = true,
                ShohinBango__c = '葬儀プラン-7',
                SougiPlan__c = true,
                k_ShohinSyubetsuRef__c = the_shubetsu.get('商品種別').Id,
                k_ServiceRef__c = the_service.get('サービス名').Id,
                k_ShohinCategoryRef__c = the_oppItems_category.get('商品カテゴリ-7').Id
            )
        };
        INSERT theProds.values();
        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '葬儀プラン価格-1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-1'),
                UnitPrice = 1000,
                IsActive = true
           ),
           '葬儀プラン価格-2' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-2'),
                UnitPrice = 2000,
                IsActive = true
           ),
           '葬儀プラン価格-3' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-3'),
                UnitPrice = 3000,
                IsActive = true
           ),
           '葬儀プラン価格-4' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-4'),
                UnitPrice = 4000,
                IsActive = true
           ),
           '葬儀プラン価格-5' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-5'),
                UnitPrice = 5000,
                IsActive = true
           ),
           '葬儀プラン価格-6' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-6'),
                UnitPrice = 6000,
                IsActive = true
           ),
           '葬儀プラン価格-7' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2 = new Product2(ShohinBango__c = '葬儀プラン-7'),
                UnitPrice = 6000,
                IsActive = true
           )
        };
        INSERT theProdEntries.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '2' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '3' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '4' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '5' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '6' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            ),
            '7' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = the_simple_yasugos.get('葬儀-1').Id,
                KakuteibiSyodan__c = Date.newInstance(2000,1,1),
                Pricebook2Id = Test.getStandardPricebookId()
            )
        };
        INSERT the_opps.values();
        Map<String, OpportunityLineItem> the_Opp_Items = new Map<String, OpportunityLineItem>{
            '商談商品-1' => new OpportunityLineItem(
                OpportunityId = the_opps.get('1').Id,
                Product2Id = theProds.get('葬儀プラン-1').Id
            ),
            '商談商品-2' => new OpportunityLineItem(
                OpportunityId = the_opps.get('2').Id,
                Product2Id = theProds.get('葬儀プラン-2').Id
            ),
            '商談商品-3' => new OpportunityLineItem(
                OpportunityId = the_opps.get('3').Id,
                Product2Id = theProds.get('葬儀プラン-3').Id
            ),
            '商談商品-4' => new OpportunityLineItem(
                OpportunityId = the_opps.get('4').Id,
                Product2Id = theProds.get('葬儀プラン-4').Id
            ),
            '商談商品-5' => new OpportunityLineItem(
                OpportunityId = the_opps.get('5').Id,
                Product2Id = theProds.get('葬儀プラン-5').Id
            ),
            '商談商品-6' => new OpportunityLineItem(
                OpportunityId = the_opps.get('6').Id,
                Product2Id = theProds.get('葬儀プラン-6').Id
            ),
            '商談商品-7' => new OpportunityLineItem(
                OpportunityId = the_opps.get('7').Id,
                Product2Id = theProds.get('葬儀プラン-7').Id
            )
        };
        INSERT the_Opp_Items.values();
        endSetUp();
        Test.startTest();
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('1').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('2').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('3').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('4').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('5').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('6').Id);
        SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(the_opps.get('7').Id);
        Test.stopTest();
    }

}