@isTest
public class Ctl_OpportunityToJizenwariBuilderTest {
    @isTest
    static void doTest(){

        //setup
        String theJson = createJsonForMoushikomi();
        Case theCase = Ctl_JizenwariRestResource.createCaseByJsonString( theJson );
        Account theAccounts =  new Account( Name = 'Test-20180314-1428-01' );
        Opportunity theOpp = new Opportunity();
        JizenWariPlan__c thePlan = new JizenWariPlan__c();

        Ctl_OpportunityToJizenwariBuilder theTarget = new Ctl_OpportunityToJizenwariBuilder();

        //test
        Dto_OpportunityServicePair theActual = 
            theTarget.createDto_OpportunityServicePair(theOpp, theCase, thePlan);
        System.Debug(theActual);
    }

    private static String createJsonForMoushikomi(){
        String theJson = '';
        theJson += '{';
        theJson += '"uniq_id":"5aa87991e0692","sid":"test2088",';
        theJson += '"last_name":"梅崎テスト",';
        theJson += '"first_name":"事前割テスト",';
        theJson += '"last_name_kana":"ウメザキテスト",';
        theJson += '"first_name_kana":"ジゼンワリテスト",';
        theJson += '"payment_status":"事前割-申込中",';
        theJson += '"phone":"080-0314-1019","email":"takeharu-umezaki@minrevi.jp",';
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