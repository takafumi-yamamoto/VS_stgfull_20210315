@isTest
public class TcmsTaioRkImpSogiShiryoT {

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
    
    private class IShikugunResolver_Stub implements TcmsTaioRkImpSogiShiryo.IShikugunResolver{
        private Shikugun__c m_Shikugun;
        public IShikugunResolver_Stub(Shikugun__c p_Shikugun){
            this.m_Shikugun = p_Shikugun;
        }
        public Shikugun__c resolveShikugun(String pSogiKiboAreaCode, String pSodanshaZipCode){
            return this.m_Shikugun;
        }
    }
    private class ITeianShisetsuResolver_Stub implements TcmsTaioRkImpSogiShiryo.ITeianShisetsuResolver{
        private Saijo__c m_saijo;
        private Shisetsu__c m_kasoba;
        public ITeianShisetsuResolver_Stub( Saijo__c p_saijo, Shisetsu__c p_kasoba){
            this.m_saijo = p_saijo;
            this.m_kasoba = p_kasoba;
        }
        public TcmsTaioRkImpSogiShiryo.TeianShisetsuSet resolve(String pShikugunId){
            TcmsTaioRkImpSogiShiryo.TeianShisetsuSet the_result = new TcmsTaioRkImpSogiShiryo.TeianShisetsuSet();

            ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap aKasoba = new ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap();
            aKasoba.shisetsuId = this.m_kasoba.Id;
            aKasoba.shisetsuName = m_kasoba.Name;
            the_result.kasobas.add(aKasoba);

            ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap aSaijo = new ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap();
            aSaijo.shisetsuId = this.m_saijo.Id;
            aSaijo.shisetsuName = m_saijo.Name;
            the_result.saijos.add(aSaijo);

            the_result.isShutoken = true;

            return the_result;
        }
    }
    @isTest public static void SogiShiryoSofuCreator_createSogiShiryoSofu(){
        beginSetUp();

        Map<String, Shikugun__c> the_Shikuguns = new Map<String, Shikugun__c>{
            'テスト市区郡' => new Shikugun__c( AreaCode__c = '1')
        };
        INSERT the_Shikuguns.values();

        Map<String, Saijo__c> the_Saijos = new Map<String, Saijo__c>{
            '斎場' => new Saijo__c(
                Name = 'テスト斎場'
            )
        };
        INSERT the_Saijos.values();

        Map<String, Shisetsu__c> the_Kasobas = new Map<String, Shisetsu__c>{
            '火葬場' => new Shisetsu__c(
                Name = 'テスト火葬場',
                ShisetsuShubetsu__c = '火葬場',
                IsShutokenRyokin__c = true
            )
        };
        INSERT the_Kasobas.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル安豪' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
            )
        };
        INSERT theOpps.values();

        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(
            TcmsSeqNo__c = '1',
            ToiawaseDt__c = '#2020-09-01 12:00',
            Sodansha_Sei_Kana__c = '_',
            Sodansha_Mei_Kana__c = '_',
            Sodansha_Sei__c = '_',
            Sodansha_Mobile__c = '#09099999999',
            Sodansha_Phone__c = '#039999999',
            Sodansha_Addr_ZipCode__c = '#1410031',
            Sodansha_Addr_State__c = '東京都',
            Sodansha_Addr_City__c = '品川区',
            Sodansha_Addr_Street__c = 'テスト町１－１',
            Sodansha_Addr_Room__c = 'テストビル　１０１',
            Sofusaki_Atena__c = 'テスト宛名',
            Sofusaki_ZipCode__c = '#1410031',
            Sofusaki_State__c = 'テスト送付先県',
            Sofusaki_City__c = 'テスト送付先市',
            Sofusaki_Street__c = 'テスト送付先町１－１',
            Sofusaki_Room__c = 'テスト送付先ビル',
            SiryoKibo__c = 'はい',
            SmsPermission__c = 'OK',
            TaishoshaUmu__c = '有',
            Taishosha_Joutai__c = '健在',
            SogiKiboAreaCode__c = '1',
            SogiType1__c = '一般葬',
            SogiType2__c = '仏式',
            SoryoTehaiUmu__c = 'ご検討中',
            BodaijiUmu__c = '無',
            AnchiSaki__c = 'その他',
            Taishosha_Zokugara_From_Sodansha__c = 'いとこ',
            Taishosha_Yomei__c = '5年以内',
            Taishosha_KyojuKeitai__c = '自宅',
            Taishosha_Jumin_State__c = 'テスト住民票県',
            Taishosha_Jumin_City__c = 'テスト住民票市',
            Comment__c = 'this is test',
            HikitsugiJiko__c = 'this is test',
            Kanryo_Shubetsu__c = '完了/資料送付1',
            ShiryoHassoDate__c = '#2020-09-01'
        );
        INSERT the_TcmsTaioRkImpData;
        endSetUp();

        Test.startTest();
        new TcmsTaioRkImpSogiShiryo.SogiShiryoSofuCreator(
            new IShikugunResolver_Stub( the_Shikuguns.get('テスト市区郡') ),
            new ITeianShisetsuResolver_Stub(
                the_Saijos.get('斎場'),
                the_Kasobas.get('火葬場')
            )
        ).createSogiShiryoSofu(
            theOpps.get('葬儀').Id,
            the_TcmsTaioRkImpData
        );
        Test.stopTest();
    }

    @isTest public static void insert_SogiShiryoSofu_for_yoriso_sofu_panflet_only(){
        beginSetUp();

        Map<String, Shikugun__c> the_Shikuguns = new Map<String, Shikugun__c>{
            'テスト市区郡' => new Shikugun__c( AreaCode__c = '1')
        };
        INSERT the_Shikuguns.values();
        
        Map<String, Saijo__c> the_Saijos = new Map<String, Saijo__c>{
            '斎場' => new Saijo__c(
                Name = 'テスト斎場'
            )
        };
        INSERT the_Saijos.values();

        Map<String, Shisetsu__c> the_Kasobas = new Map<String, Shisetsu__c>{
            '火葬場' => new Shisetsu__c(
                Name = 'テスト火葬場',
                ShisetsuShubetsu__c = '火葬場',
                IsShutokenRyokin__c = true
            )
        };
        INSERT the_Kasobas.values();

        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();
        
        Map<String, SimpleYasugo__c> theSimpleYasugos = new Map<String, SimpleYasugo__c>{
            'シンプル安豪' => new SimpleYasugo__c()
        };
        INSERT theSimpleYasugos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '葬儀' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
				Req_Day__c = Datetime.newInstance(2000,1,1,0,0,0),
				CloseDate = Date.newInstance(2000,1,1),
                SimpleYasugoRef__c = theSimpleYasugos.get('シンプル安豪').Id
            )
        };
        INSERT theOpps.values();

        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(
            TcmsSeqNo__c = '1',
            ToiawaseDt__c = '#2020-09-01 12:00',
            Sodansha_Sei_Kana__c = '_',
            Sodansha_Mei_Kana__c = '_',
            Sodansha_Sei__c = '_',
            Sodansha_Mobile__c = '#09099999999',
            Sodansha_Phone__c = '#039999999',
            Sodansha_Addr_ZipCode__c = '#1410031',
            Sodansha_Addr_State__c = '東京都',
            Sodansha_Addr_City__c = '品川区',
            Sodansha_Addr_Street__c = 'テスト町１－１',
            Sodansha_Addr_Room__c = 'テストビル　１０１',
            Sofusaki_Atena__c = 'テスト宛名',
            Sofusaki_ZipCode__c = '#1410031',
            Sofusaki_State__c = 'テスト送付先県',
            Sofusaki_City__c = 'テスト送付先市',
            Sofusaki_Street__c = 'テスト送付先町１－１',
            Sofusaki_Room__c = 'テスト送付先ビル',
            SiryoKibo__c = 'はい',
            SmsPermission__c = 'OK',
            TaishoshaUmu__c = '有',
            Taishosha_Joutai__c = '健在',
            SogiKiboAreaCode__c = null,
            SogiType1__c = '一般葬',
            SogiType2__c = '仏式',
            SoryoTehaiUmu__c = 'ご検討中',
            BodaijiUmu__c = '無',
            AnchiSaki__c = 'その他',
            Taishosha_Zokugara_From_Sodansha__c = 'いとこ',
            Taishosha_Yomei__c = '5年以内',
            Taishosha_KyojuKeitai__c = '自宅',
            Taishosha_Jumin_State__c = 'テスト住民票県',
            Taishosha_Jumin_City__c = 'テスト住民票市',
            Comment__c = 'this is test',
            HikitsugiJiko__c = 'this is test',
            Kanryo_Shubetsu__c = '完了/資料送付1',
            ShiryoHassoDate__c = '#2020-09-01'
        );
        INSERT the_TcmsTaioRkImpData;
        endSetUp();

        Test.startTest();
        new TcmsTaioRkImpSogiShiryo.SogiShiryoSofuCreator(
            new IShikugunResolver_Stub( the_Shikuguns.get('テスト市区郡') ),
            new ITeianShisetsuResolver_Stub(
                the_Saijos.get('斎場'),
                the_Kasobas.get('火葬場')
            )
        ).createSogiShiryoSofu(
            theOpps.get('葬儀').Id,
            the_TcmsTaioRkImpData
        );
        Test.stopTest();
    }

    @isTest public static void ShikugunResolver_resolveShikugun(){
        Test.startTest();
        new TcmsTaioRkImpSogiShiryo.ShikugunResolver().resolveShikugun(null, '#141-0031');
        Test.stopTest();
    }
    @isTest public static void TeianShisetsuResolver_resolve(){
        beginSetUp();
        Shikugun__c the_Shikugun = new Shikugun__c( 
            AreaCode__c = '1',
            Chiriichijouhou__latitude__s = 43.6989744,
            Chiriichijouhou__longitude__s = 142.5103168
        );
        INSERT the_Shikugun;
        endSetUp();
        Test.startTest();
        new TcmsTaioRkImpSogiShiryo.TeianShisetsuResolver().resolve(the_Shikugun.Id);
        Test.stopTest();
    }
}