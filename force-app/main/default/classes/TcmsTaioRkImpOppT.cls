@isTest
public class TcmsTaioRkImpOppT {

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

    @isTest public static void OppCreator_createOpp(){
        beginSetUp();

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

        TcmsTaioRkImpOpp.OppCreator the_OppCreator = 
            new TcmsTaioRkImpOpp.OppCreator( 
                AcntCustRslvr.get_IAccountRelver_instance(), 
                new Todays.Today(),
                new TcmsTaioRkImpOpp.KanryoShubetsuMapper(),
                new TcmsTaioRkImpOpp.KanryoShubetsus()
            ); 
        endSetUp();

        Test.startTest();
        the_OppCreator.createOpp(the_TcmsTaioRkImpData);
        Test.stopTest();
    }
}