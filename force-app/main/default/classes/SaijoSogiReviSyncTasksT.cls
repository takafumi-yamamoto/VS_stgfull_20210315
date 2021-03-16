@isTest
private class SaijoSogiReviSyncTasksT {

    @testSetup
    static void setup() {
        
        Insert new TriggerIsActive__c( name='default', isActive__c=true );

        Saijo__c s = new Saijo__c();
    	s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = false;
		s.Name = 'test';
		s.KeisaiSaijoMeiKana__c = 'テスト';
		s.TokuchoSaijo__c = '特徴';
		s.PostalCode__c = '141-0031';
		s.Street__c = '西五反田2-11-17　HI五反田ビル 4F';
        s.JushoKana__c = 'にしごたんだ';
        s.IdoKedo__Latitude__s = 35.626471;
        s.IdoKedo__longitude__s = 139.722161;
        s.AccessHohoKuruma__c = 'アクセス車';
        s.AccessHohoBasu__c = 'アクセスバス';
        s.AccessHouhouDensha__c = 'アクセス電車';
        s.AccessHohoBiko__c = 'アクセス備考';
		s.ShisetsuKubun__c = '自社';
		s.KasobaHeisetsuList__c = '有';
		s.UneimotoYago__c = 'よりそう';
		s.TaioShuha__c = '全宗派可';
		s.ShiminRyokinKubun__c = '設定なし(一律同額)';
		s.Kyukanbi__c = '土日';
		s.AnchiShisetsu__c = '有';
		s.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '有';
		s.KaminKanoNinzu__c = 1;
		s.KurumaisuTaio__c = '有';
		s.ShinzokuHikaeshitsu__c = '有';
        s.Chushadaisu__c = 1;
		s.ElevatorUmu__c = '有';
        s.KidsRoomList__c = '有';
        s.JunyushitsuList__c = '有';
        s.KurumaisuKashidashiList__c = '有';
        insert s;
    }

    @isTest
    public static void saijoUpdate(){

        Saijo__c s = [select Id from Saijo__c where Name = 'test'];

        Test.startTest();

        s.Name = 'test2';
		update s;
        
        Test.stopTest();
    }

    @isTest
    public static void saijoDelete(){

        Saijo__c s = [select Id from Saijo__c where Name = 'test'];

        Test.startTest();

		delete s;
        
        Test.stopTest();
    }
}