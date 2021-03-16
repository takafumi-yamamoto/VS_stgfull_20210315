/*
17:30 フォーム送信
17:35 SFでチェック

1. メール処理ID - > nullじゃなければOK
%not null%

2. 問い合わせ日 -> チェックした日付（確認バッチが実行された日付）であればOK
%today%

3．　「お坊さん便法事法要僧侶手配申込Web受付」はまだ確認できません。

*/
global class WebFormDataCheckSchedule implements Schedulable, Database.AllowsCallouts{
    global void execute(SchedulableContext sc) {
        startTestAll();
    }

    @future(callout=true) public static void startTestAll() {


        // [WebToCase]シンプル安豪資料請求Web受付
        WebFormDataCheck checker1 = new WebFormDataCheck();
        RsCoreApi_Util.IHttpRequest client = new RsCoreApi_TestDataClient(checker1, RsCoreApi_TestDataClient.TYPE_SIMPLE_SIRYOUSEIKYU_WEB);
        RsCoreApi_Util.doGet(client);

        // お坊さん便法事法要僧侶手配申込Web受付
        // Api_V1_ObousanbinMoushikomi
        WebFormDataCheck checker2 = new WebFormDataCheck();
        RsCoreApi_Util.IHttpRequest client2 = new RsCoreApi_TestDataClient(checker2, RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SOURYOUTEHAI_WEB);
        RsCoreApi_Util.doGet(client2);

        // お坊さん便資料請求Web受付
        // Api_V1_ObousanbinSiryoSeikyu
        WebFormDataCheck checker3 = new WebFormDataCheck();
        RsCoreApi_Util.IHttpRequest client3 = new RsCoreApi_TestDataClient(checker3, RsCoreApi_TestDataClient.TYPE_OBOSANBIN_SIRYOUSEIKYU_WEB);
        RsCoreApi_Util.doGet(client3);

        // シンプル安豪問合せWeb受付
        // Api_V1_SimpleYasugoToiawase
        WebFormDataCheck checker4 = new WebFormDataCheck();
        RsCoreApi_Util.IHttpRequest client4 = new RsCoreApi_TestDataClient(checker4, RsCoreApi_TestDataClient.TYPE_SIMPLE_TOIAWASE_WEB);
        RsCoreApi_Util.doGet(client4);
        
        // シンプル安豪エンディングノート請求Web受付
        // Api_V1_SimpleYasugoEndingNote
        WebFormDataCheck checker5 = new WebFormDataCheck();
        RsCoreApi_Util.IHttpRequest client5 = new RsCoreApi_TestDataClient(checker5, RsCoreApi_TestDataClient.TYPE_SIMPLE_ENDORINGU_WEB);
        RsCoreApi_Util.doGet(client5);

        checker1.sendMail();
        checker2.sendMail();
        checker3.sendMail();
        checker4.sendMail();
        checker5.sendMail();


        // delete all data
        WebFormDataCheck deleteDataChecker = new WebFormDataCheck();
        deleteDataChecker.deleteAutoCreateData();
        deleteDataChecker.sendMail(WebFormDataCheck.MAIL_TYPE_DELETE_LOG);

    }

}