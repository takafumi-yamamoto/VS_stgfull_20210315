@isTest
public class Tes_TesuryoNebikiEntrTrigger{
    //提携先Core連携のテスト
    static testMethod void testCase1(){
		TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
		TriggerIsActive.name='default';
		TriggerIsActive.isActive__c=true;
		insert TriggerIsActive;
		JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;
		//====================カスタム設定データ準備===================
		KaiinkibanSetting__c KaiinkibanSetting1=new KaiinkibanSetting__c();
		KaiinkibanSetting1.name='dev';
		KaiinkibanSetting1.client_id__c='5';
		KaiinkibanSetting1.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting1.grant_type__c='client_credentials';
		KaiinkibanSetting1.timeOutPeriod__c=60000;
		KaiinkibanSetting1.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting1.isActive__c=True;
        KaiinkibanSetting1.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting1;
		KaiinkibanSetting__c KaiinkibanSetting2=new KaiinkibanSetting__c();
		KaiinkibanSetting2.name='prod';
		KaiinkibanSetting2.client_id__c='5';
		KaiinkibanSetting2.client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh';
		KaiinkibanSetting2.grant_type__c='client_credentials';
		KaiinkibanSetting2.timeOutPeriod__c=60000;
		KaiinkibanSetting2.Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/';
		KaiinkibanSetting2.isActive__c=True;
        KaiinkibanSetting2.KeiyakuCoreFlag__c=true;
		insert KaiinkibanSetting2;
        //====================取引先データ準備======================	
		id redtpId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();
		Account acc=new Account();
		acc.name='新規';
		//取引先.郵便番号（請求先）
		acc.SeikyuSakiAddrPostalCode__c='335-0017';
		//取引先.住所(請求先)
		acc.billingstate='東京';
		//取引先.経理担当者名
		acc.SeikyuSakiTantoName__c='田中太郎';
		//取引先.銀行名
		acc.BankName__c='みずほ';
		//取引先.銀行支店名
		acc.BankBranchName__c='芝';
		//取引先.口座種別
		acc.BankAccountType__c='普通預金';
		//取引先.口座番号
		acc.BankAccountNo__c='12345678';
		//取引先.口座名義
		acc.BankAccountMeigi__c='田中太郎';
		acc.recordtypeid=redtpId;
		insert acc;	
		
		//====================契約データ準備======================	
		Keiyaku__c Keiyaku=new Keiyaku__c();
		Keiyaku.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SougiRevi');
		//取引先
		Keiyaku.Teikeisaki__c=acc.id;
		//契約.入金締切条件
		Keiyaku.NyukinSimekiriJouken__c='DUMMY';
		//契約.契約開始日
		Keiyaku.Keiyakukaishibi__c=system.today();	
		//契約.契約終了日
		Keiyaku.KeiyakuSyuryoBi__c=system.today();
		//連携試行回数
		Keiyaku.TryCount__c=0;
		//連携試行最大回数
		Keiyaku.TryLimit__c=3;	
		//処理ステータス
		Keiyaku.ShoriStatus__c='未連携';					
		insert Keiyaku;

        TesuryoTekiyo__c TesuryoTekiyo=new TesuryoTekiyo__c();
        TesuryoTekiyo.ShoninStatus__c='ドラフト';
        TesuryoTekiyo.KeiyakuRef__c=Keiyaku.id;
        TesuryoTekiyo.TekiyoKaishiBi__c=system.today();
        insert TesuryoTekiyo;

        TesuryoNebikiEntry__c  TesuryoNebikiEntry=new TesuryoNebikiEntry__c();
        TesuryoNebikiEntry.Sanshutsuhoho__c='固定';
        TesuryoNebikiEntry.TesuryoTekiyoRef__c=TesuryoTekiyo.id;
        insert TesuryoNebikiEntry;

    }
}