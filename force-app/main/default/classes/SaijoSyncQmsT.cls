@isTest
public class SaijoSyncQmsT {

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
    public static void SaijoSyncQmsUpdateAri(){

    	setUp();

    	Saijo__c s = new Saijo__c();
    	s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = true;
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
        s.OmutsuKokandaiList__c = '有';
        s.SuishoSaijo__c = true;
        insert s;

        Saijo__c sltS = [select Id, SaijoKeisaiJohoId__c from Saijo__c where SaijoKeisaiJohoIdOld__c = '1111111111'];

        Test.startTest();

		List<Saijo__c> sList = new List<Saijo__c>();
		sList.add(sltS);

		List<Qms__c> qmsList = SaijoSyncQms.createPostQmses(sList);
		insert qmsList;

		SaijoSyncQms ssq = new SaijoSyncQms();
		ssq.handleQms(qmsList.get(0));
        
        Test.stopTest();
    }

    @isTest
    public static void SaijoSyncQmsUpdateFumei(){

    	setUp();

    	Saijo__c s = new Saijo__c();
    	s.SaijoKeisaiJohoIdOld__c = '1111111111';
        s.SimpleHPKeisaiAri__c = true;
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
		s.ShisetsuKubun__c = '寺院（本堂のみ）';
		s.KasobaHeisetsuList__c = '有';
		s.UneimotoYago__c = 'よりそう';
		s.TaioShuha__c = '自宗派のみ可(寺院斎場)';
		s.ShiminRyokinKubun__c = '設定あり(3段階)';
		s.Kyukanbi__c = '土日';
		s.AnchiShisetsu__c = '不明';
		s.KaminShisetsuUmuKokubetsushikiZenjitsu__c = '不明';
		s.KaminKanoNinzu__c = 0;
		s.KurumaisuTaio__c = '不明';
		s.ShinzokuHikaeshitsu__c = '不明';
        s.Chushadaisu__c = 0;
		s.ElevatorUmu__c = '不要';
        s.KidsRoomList__c = '有';
        s.JunyushitsuList__c = '有';
        s.KurumaisuKashidashiList__c = '有';
        s.OmutsuKokandaiList__c = '有';
        s.SuishoSaijo__c = false;
        insert s;

		Saijo__c sltS = [select Id, SaijoKeisaiJohoId__c from Saijo__c where SaijoKeisaiJohoIdOld__c = '1111111111'];

        Test.startTest();

		List<Saijo__c> sList = new List<Saijo__c>();
		sList.add(sltS);

		List<Qms__c> qmsList = SaijoSyncQms.createPostQmses(sList);
		insert qmsList;

		SaijoSyncQms ssq = new SaijoSyncQms();
		ssq.handleQms(qmsList.get(0));
        
        Test.stopTest();
    }

    @isTest
    public static void SaijoSyncQmsDelete(){

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
        s.OmutsuKokandaiList__c = '有';
        s.SuishoSaijo__c = true;
        insert s;

		Saijo__c sltS = [select Id, SaijoKeisaiJohoId__c from Saijo__c where SaijoKeisaiJohoIdOld__c = '1111111111'];

        Test.startTest();

		List<Saijo__c> sList = new List<Saijo__c>();
		sList.add(sltS);

		List<Qms__c> qmsList = SaijoSyncQms.createDeleteQmses(sList);
		insert qmsList;

		SaijoSyncQms ssq = new SaijoSyncQms();
		ssq.handleQms(qmsList.get(0));
        
        Test.stopTest();
    }
}