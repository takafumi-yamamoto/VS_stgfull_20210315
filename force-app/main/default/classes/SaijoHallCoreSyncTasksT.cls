@isTest
public class SaijoHallCoreSyncTasksT {

	private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );

        Insert new List<KaiinkibanSetting__c>{
            new KaiinkibanSetting__c(
                name='dev', 
                client_id__c='5', 
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true,
                IsShisetsuRenkeiYuko__c=true
            ),
            new KaiinkibanSetting__c(
                name='prod',
                client_id__c='5',
                client_secret__c='EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
                grant_type__c='client_credentials',
                timeOutPeriod__c=60000,
                Endpoint__c='http://dev2-rakuso-coreapi-external-alb-767861573.ap-northeast-1.elb.amazonaws.com/',
                KeiyakuCoreFlag__c=true,
                isActive__c=true,
                IsShisetsuRenkeiYuko__c=true
            )
        };

        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void saijoHallUpdate(){

    	setUp();

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

        SaijoHall__c sh = new SaijoHall__c();
        sh.SaijoRef__c = s.Id;
		sh.Name = 'テスト斎場ホール';
		sh.SaijoHallKana__c = 'テストサイジョウホール';
		sh.TaioShikishubetsu__c = '一日葬;家族葬;一般葬';
		sh.Sekisu__c = 10;
        sh.JogenKaisoshasu__c = 10;
        sh.X1ShiyoRyokinIppan__c = 1;
        sh.X1ShiyoRyokinShimin__c = 2;
        sh.X1ShiyoRyokinSonota__c = 3;
        sh.X2ShiyoRyokinIppan__c = 4;
		sh.X2ShiyoRyokinShimin__c = 5;
		sh.X2ShiyoRyokinSonota__c = 6;
		sh.ShiyoRyokinBiko__c = '備考';
		insert sh;

        Test.startTest();

		update sh;
        
        Test.stopTest();
    }

    @isTest
    public static void saijoDelete(){

    	setUp();

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

        SaijoHall__c sh = new SaijoHall__c();
        sh.SaijoRef__c = s.Id;
		sh.Name = 'テスト斎場ホール';
		sh.SaijoHallKana__c = 'テストサイジョウホール';
		sh.TaioShikishubetsu__c = '一日葬;家族葬;一般葬';
		sh.Sekisu__c = 10;
        sh.JogenKaisoshasu__c = 10;
        sh.X1ShiyoRyokinIppan__c = 1;
        sh.X1ShiyoRyokinShimin__c = 2;
        sh.X1ShiyoRyokinSonota__c = 3;
        sh.X2ShiyoRyokinIppan__c = 4;
		sh.X2ShiyoRyokinShimin__c = 5;
		sh.X2ShiyoRyokinSonota__c = 6;
		sh.ShiyoRyokinBiko__c = '備考';
		insert sh;

        Test.startTest();

		delete sh;
        
        Test.stopTest();
    }

}