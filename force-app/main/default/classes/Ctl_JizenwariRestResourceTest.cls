@isTest
public class Ctl_JizenwariRestResourceTest {

    @isTest
    static void createCaseByJsonStringTest(){

        String theJson = createJsonForMoushikomi();
        Case theCase = Ctl_JizenwariRestResource.createCaseByJsonString( theJson );
        System.Debug(theCase);
    }

    @isTest(SeeAllData=true)
    static void doTest(){
        
        
        String theJson = createJsonForMoushikomi();
        Case theCase = Ctl_JizenwariRestResource.createCaseByJsonString( theJson );
        Insert theCase;
        System.Debug('Limits.getQueries();' + Limits.getQueries());
        System.Debug(theCase);
        List<Opportunity> theActual = Dao_Opportunity.getInstance().selectByCaseRefIds( new List<Id>{ theCase.Id } );
        System.Debug('Limits.getQueries()x01;' + Limits.getQueries());
        System.Debug(theActual);

    }

    private static String createJsonForMoushikomi(){
        String theJson = '';
        theJson += '{';
        theJson += '"uniq_id":"5aa87991e0692","sid":"test2088",';
        theJson += '"last_name":"よりそう",';
        theJson += '"first_name":"てすと",';
        theJson += '"last_name_kana":"ヨリソウ",';
        theJson += '"first_name_kana":"テスト",';
        theJson += '"payment_status":"事前割-申込中",';
        theJson += '"phone":"090-5989-9446","email":"takeharu-umezaki@minrevi.jp",';
        theJson += '"address_post":"169-0075",';
        theJson += '"address_state":"東京都",';
        theJson += '"address_city":"品川区",';
        theJson += '"address_street":"テスト町１－１",';
        theJson += '"taisyosya_jokyo":"健在",';
        theJson += '"AreaState":"東京都",';
        theJson += '"AreaCity":"品川区",';
        theJson += '"SimpleJizenwariOwns_material":"持っている",';
        theJson += '"Plan":"",';
        theJson += '"Sogi_planHope":"決まっていない",';
        theJson += '"payment_type":"コンビニ払い（伝票払い）",';
        theJson += '"req_Day":"2018-03-14 10:23:30",';
        theJson += '"mauticAccountId":null,"customer_bango":"",';
        theJson += '"member_touroku_kibo":"希望する",';
        theJson += '"web_account_kibo":"希望する"';
        theJson += '}';
        return theJson;
    }

}