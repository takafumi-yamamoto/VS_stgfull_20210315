@isTest
public class DashinTestData {
    public static Map<String, Opportunity> dashin_test_data_init() {
        Insert new TriggerIsActive__c( name='default', isActive__c=true );

        OboStApi_Auth.ResBody theOboStApi_AuthRes = new OboStApi_Auth.ResBody();
        theOboStApi_AuthRes.token_type = ''; theOboStApi_AuthRes.expires_in = 0; theOboStApi_AuthRes.access_token = '';
        // OboStApi_Offer.ResBody theOboStApi_OfferRes = new OboStApi_Offer.ResBody();
        // theOboStApi_OfferRes.Id = 1234;
        Test.setMock( HttpCalloutMock.class,
            new Testing_HttpResMock()
                .addResponder(
                    new Testing_HttpResponders.UrlContains()
                        .setStrUrlContains( new OboStConfig().getBaseEndPoint() + '/api/oauth/token' )
                        .setStatusCode(200)
                        .setBody( JSON.serialize(theOboStApi_AuthRes) )
                )
                .addResponder(
                    new Testing_HttpResponders.CatchAll()
                        .setStatusCode(200)
                        // .setBody( JSON.serialize(theOboStApi_OfferRes) )
                        .setBody( '{\"id\": 1234}' )
                )
        );

        OboStSelProf__c oboStSelProf0 = new OboStSelProf__c();
        oboStSelProf0.HourFindBeginInNoTimeSepc__c = 3;
        oboStSelProf0.HourFindEndInNoTimeSepc__c = 3;
        oboStSelProf0.LeftHoursToBeUrgent__c = 3;
        oboStSelProf0.LeftHoursToGiveUp__c = 3;
        oboStSelProf0.MeasureDateTimeFrom__c = Datetime.now().addDays(3);
        oboStSelProf0.MeasureDateTimeTo__c = Datetime.now().addDays(4);
        oboStSelProf0.MeasureExecDatetime__c = Datetime.now().addDays(1);
        oboStSelProf0.MeasuredAvgTesuryoGapRate__c = 3;
        oboStSelProf0.MeasuredAvgTesuryo__c = 3;
        oboStSelProf0.MeasuredCount__c = 3;
        oboStSelProf0.SvcRankOrder__c = 'D-C-E-B-A';
        oboStSelProf0.TargetAvgTesuryo__c = 25000;
        oboStSelProf0.SenteiSize__c = 3;
        oboStSelProf0.DoziDashinSize__c = 3;
        oboStSelProf0.HoursAllowedForReplyInUrgent__c = 1;
        oboStSelProf0.HoursAllowedForReply__c = 3;
        insert oboStSelProf0;

        Id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null');
        Account acc1=new Account();
        acc1.lastname='新規';
        acc1.LastNameFurigana__pc ='defualt';
        acc1.FirstNameFurigana__pc ='defualt';
        acc1.Phone='080-0000-0001';
        acc1.MobilePhone__c='080-0000-0001';
        acc1.recordtypeid=redtpId;
        insert acc1;

        Id accRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
        Account sodansha = new Account(LastName = '相談者',FirstName = 'テスト', BodaijinoUmu__c = '無', RecordTypeId = accRecordTypeId);
        insert sodansha;

        Account moshu = new Account(LastName = '喪主',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert moshu;

        Account taishosha = new Account(LastName = '対象者',FirstName = 'テスト',RecordTypeId = accRecordTypeId);
        insert taishosha;
        Account obosan = new Account(Name = 'お坊田中対象者',RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'));
        insert obosan;

        Keiyaku__c keiyaku = new Keiyaku__c();
        keiyaku.Teikeisaki__c = obosan.Id;
        keiyaku.KeiyakuJokyo__c = '契約中';
        keiyaku.RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId();
        insert keiyaku;


        Map<String, Account> theAccounts = new Map<String, Account>{
            '1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        Insert theAccounts.values();

        Map<String, Product2> theProds = new Map<String, Product2>{
            '1' => new Product2(
                Name = '_',
                IsActive = true
            )
        };
        Insert theProds.values();
        PriceBookEntry pbe = new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
            );
        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => pbe
        };
        Insert theProdEntries.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            '1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '葬儀_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            ),
            '2' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '法要_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            ),
            '3' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '戒名のみ_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            ),
            '4' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = 'NULL葬儀_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            ),
            '5' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = 'NULL法要_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            ),
            '6' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = 'NULL戒名のみ_',
                AccountId = theAccounts.get('1').Id,
                StageName = '予約',
                CloseDate = system.today(),
                Req_Day__c = Date.today(),
                Iriguchi__c = 'Amazon'
            )
        };

        Insert theOpps.values();

        Map<String, Opportunity> opps = new Map<String, Opportunity>();
        for(Opportunity opp: [Select id, Name,RecordTypeId, Req_Day__c, AccountId, ObosanbinRef__c FROM Opportunity ]){
            String key = opp.Name.contains('NULL葬儀_') ? 'NULL葬儀' :
                         opp.Name.contains('NULL法要_') ? 'NULL法要' :
                         opp.Name.contains('NULL戒名のみ_') ? 'NULL戒名のみ' :
                         opp.Name.contains('葬儀_') ? '葬儀' :
                         opp.Name.contains('法要_') ? '法要' :
                         opp.Name.contains('戒名のみ_') ? '戒名のみ' : 'other';
            opps.put(key, opp);
        }


        Obosanbin__c obosanbin0 = new Obosanbin__c(Id = opps.get('葬儀').ObosanbinRef__c);
        obosanbin0.Taishosha1Ref__c = taishosha.Id;   // 菩提寺の有無
        obosanbin0.memorialserviceplan__c = '火葬式';   // お坊さん便-プラン
        obosanbin0.kaimyojuyo__c = '戒名の授与を希望する';   // 戒名の授与
        obosanbin0.kaimyo__c = '釋尼';   // 戒名・法名
        obosanbin0.kokubetsudatetime_inp__c = Datetime.newInstance(2019, 08, 23, 03, 00, 00);   // 法要日時
        obosanbin0.kokubetsudatetime_inp1__c = DateTime.now();   // 法要日時（第1希望）
        obosanbin0.kokubetsudatetime_inp2__c = DateTime.now();   // 法要日時（第2希望）
        obosanbin0.kokubetsudatetime_inp3__c = DateTime.now();   // 法要日時（第3希望）
        obosanbin0.memorialcontent__c = '法要内容テスト';   // 法要内容
        obosanbin0.hoyobashomei__c = 'テスト法要場所';   // 法要場所名
        obosanbin0.hoyo_postcode__c = '1500001';   // 法要場所/郵便番号
        obosanbin0.hoyo_todofuken__c = '東京都';   // 法要場所/都道府県
        obosanbin0.hoyo_shikugun__c = '渋谷区';   // 法要場所/市区郡
        obosanbin0.hoyo_tyoumei__c = '神宮前';   // 法要場所/町名
        // obosanbin0.hoyo_banchi__c = '';    // 法要場所/番地以降
        obosanbin0.tsuikahoyobashomei__c = '追加法要１－１';   // 追加法要場所名
        // obosanbin0.tuika_banchi__c = '';    // 追加法要場所/番地以降
        obosanbin0.tuika_postcode__c = '311-4141';   // 追加法要場所/郵便番号
        obosanbin0.tuika_shikugun__c = '水戸市';   // 追加法要場所/市区郡
        obosanbin0.tuika_todofuken__c = '茨城県';   // 追加法要場所/都道府県
        obosanbin0.tuika_tyoumei__c = '赤塚';   // 追加法要場所/町名
        obosanbin0.makurakyo__c = Datetime.newInstance(2019, 08, 15, 03, 00, 00);   // 枕経
        obosanbin0.tsuyadatetime_inp__c = Datetime.newInstance(2019, 08, 17, 03, 00, 00);   // 通夜日時
        obosanbin0.kokubetsushikinichiji__c = Datetime.newInstance(2019, 08, 18, 03, 00, 00);   // 告別式日時
        obosanbin0.kasodatetime_inp__c = Datetime.newInstance(2019, 08, 19, 03, 00, 00);   // 火葬日時
        obosanbin0.shonanoka__c = '式中';   // 初七日
        obosanbin0.saijo__c = 'タロウ斎場';   // 斎場
        obosanbin0.kasoba__c = '五反田火葬場';   // 火葬場
        obosanbin0.sogi_postcode__c = '1500001';   // 葬儀場所/郵便番号
        obosanbin0.sogi_todofuken__c = '東京都';   // 葬儀場所/都道府県
        obosanbin0.sogi_shikugun__c = '渋谷区';   // 葬儀場所/市区郡
        obosanbin0.sogi_tyoumei__c = '神宮前';   // 葬儀場所/町名
        // obosanbin0.sogi_banchi__c = '';    // 葬儀場所/番地以降
        // obosanbin0.sonotasogisha__c = '';    // その他葬儀社
        // obosanbin0.hohokingaku__c = 0.0;   // 法要金額
        obosanbin0.hoyo_location__longitude__s = 139.709008;   // 法要場所/座標 (Longitude)
        obosanbin0.hoyo_location__latitude__s = 35.6699682;   // 法要場所/座標 (Latitude)
        obosanbin0.sogi_location__longitude__s = 139.709008;   // 葬儀場所/座標 (Longitude)
        obosanbin0.sogi_location__latitude__s = 35.6699682;   // 葬儀場所/座標 (Latitude)
        obosanbin0.tuika_location__longitude__s = 140.4140222;   // 追加法要場所/座標 (Longitude)
        obosanbin0.tuika_location__latitude__s = 36.3852056;   // 追加法要場所/座標 (Latitude)
        // obosanbin0.zenkaisoryokibo__c = '';    // 前回と同じ僧侶の希望
        update obosanbin0;

        Obosanbin__c obosanbin1 = obosanbin0.clone(false, true, false, false);
        obosanbin1.Id = opps.get('法要').ObosanbinRef__c;
        obosanbin1.memorialserviceplan__c = '三七日法要';
        Obosanbin__c obosanbin2 = obosanbin0.clone(false, true, false, false);
        obosanbin2.Id = opps.get('戒名のみ').ObosanbinRef__c;
        obosanbin2.memorialserviceplan__c = '戒名・法名のみ';   // お坊さん便-プラン


        Obosanbin__c obosanbin3 = new Obosanbin__c(Id = opps.get('NULL法要').ObosanbinRef__c);
        obosanbin3.Taishosha1Ref__c = taishosha.Id;   // 菩提寺の有無
        obosanbin3.memorialserviceplan__c = '三七日法要';   // お坊さん便-プラン
        Obosanbin__c obosanbin4 = new Obosanbin__c(Id = opps.get('NULL戒名のみ').ObosanbinRef__c);
        obosanbin4.Taishosha1Ref__c = taishosha.Id;   // 菩提寺の有無
        obosanbin4.memorialserviceplan__c = '戒名・法名のみ';   // お坊さん便-プラン
        Obosanbin__c obosanbin5 = new Obosanbin__c(Id = opps.get('NULL葬儀').ObosanbinRef__c);
        obosanbin5.Taishosha1Ref__c = taishosha.Id;   // 菩提寺の有無
        obosanbin5.memorialserviceplan__c = '火葬式';   // お坊さん便-プラン


        update new List<Sobject>{obosanbin0, obosanbin1, obosanbin2, obosanbin3, obosanbin4, obosanbin5};

        return opps;
    }

    public static DashIrai__c getDataIrai(){
        DashIrai__c dashirai0 = new DashIrai__c();
        dashirai0.dashinirainichiji__c = Datetime.newInstance(2019, 07, 23, 04, 33, 33);   // 打診依頼日時
        // dashirai0.kaimyo__c = '';    // 戒名
        dashirai0.kekkajushinnichiji__c = Datetime.newInstance(2019, 07, 23, 08, 01, 58);   // 結果受信日時
        // dashirai0.kekkasekotantoref__c = '';    // 施行担当
        // dashirai0.kekkasokyakusakiref__c = '';    // 送客先
        dashirai0.result__c = 'NG';   // 結果区分
        // dashirai0.statusdescr__c = '';    // ステータス備考
        dashirai0.status__c = 'Opened';   // ステータス
        dashirai0.bodaiji__c = '有';   // 菩提寺
        dashirai0.caption__c = 'これはテストデータです。';   // 備考
        dashirai0.content_type__c = 'hoyo';   // content_type
        dashirai0.expiry_datetime__c = Datetime.newInstance(2019, 08, 04, 15, 00, 00);   // expiry_datetime
        dashirai0.hours_allowed_for_a_person__c = 3.0;   // hours_allowed_for_a_person
        dashirai0.hoyo_place2_banchi__c = '１－１';   // 追加法要場所/番地
        dashirai0.hoyo_place2_chomei__c = '藤が丘';   // 追加法要場所/町名
        dashirai0.hoyo_place2_city__c = '横浜市青葉区';   // 追加法要場所/市区郡
        dashirai0.hoyo_place2_name__c = 'よりそう霊園';   // 追加法要場所名
        dashirai0.hoyo_place2_postal_code__c = '2270043';   // 追加法要場所/郵便番号
        dashirai0.hoyo_place2_state__c = '神奈川県';   // 追加法要場所/都道府県
        dashirai0.hoyo_place__c = '1-1';   // 法要場所/番地
        dashirai0.hoyo_place_chomei__c = '西五反田';   // 法要場所/町名
        dashirai0.hoyo_place_city__c = '品川区';   // 法要場所/市区郡
        dashirai0.hoyo_place_name__c = '自宅';   // 法要場所名
        dashirai0.hoyo_place_postal_code__c = '1410031';   // 法要場所/郵便番号
        dashirai0.hoyo_place_state__c = '東京都';   // 法要場所/都道府県
        dashirai0.is_repeat__c = False;   // リピート依頼
        dashirai0.is_urgent__c = False;   // 緊急依頼
        dashirai0.kaimyo_juyo__c = '戒名の授与を希望しない';   // 戒名の授与
        dashirai0.kaso_datetime__c = DateTime.now();   // 火葬日時
        // dashirai0.kasoba_name__c = '';    // 火葬場名
        dashirai0.kekka_kettei_datetime__c = DateTime.now();   // 僧侶様が選択した候補日時
        dashirai0.koho_datetime1__c = Datetime.newInstance(2019, 08, 05, 03, 00, 00);   // 候補日時１
        dashirai0.koho_datetime2__c = DateTime.now();   // 候補日時2
        dashirai0.koho_datetime3__c = DateTime.now();   // 候補日時3
        dashirai0.kokubetsu_datetime__c = DateTime.now();   // 告別式日時
        dashirai0.makurakyo_datetime__c = DateTime.now();   // 枕経日時
        dashirai0.offer_id__c = 259.0;   // 打診依頼Id
        dashirai0.plan__c = '四十九日法要';   // プラン
        dashirai0.service_content__c = '読経・法話、御膳料、御車代、心づけ';   // 法要内容
        dashirai0.service_kingaku__c = 45000.0;   // 法要金額
        // dashirai0.shikijo_banchi__c = '';    // 葬儀場所/番地
        // dashirai0.shikijo_city__c = '';    // 葬儀場所/市区郡
        // dashirai0.shikijo_name__c = '';    // 葬儀場所名
        // dashirai0.shikijo_postal_code__c = '';    // 葬儀場所/郵便番号
        // dashirai0.shikijo_state__c = '';    // 葬儀場所/都道府県
        // dashirai0.shonanoka__c = '';    // 初七日
        dashirai0.shuha__c = '浄土真宗本願寺派';   // 希望宗派
        // dashirai0.sogisha_name__c = '';    // 葬儀社名
        // dashirai0.sogisha_tanto_name__c = '';    // 葬儀社担当名
        // dashirai0.sogisha_tanto_tel__c = '';    // 葬儀社担当電話番号
        dashirai0.tesuryo_kingaku__c = 25000.0;   // 手数料
        dashirai0.tsuya_datetime__c = DateTime.now();   // 通夜日時

        return dashirai0;
    }

    public static void init_DashIraiHist(){

        DashIrai__c dashiIrai = DashinTestData.getDataIrai();
        insert dashiIrai;

        Keiyaku__c keiyaku = [Select Id, KeiyakuBango__c from Keiyaku__c Limit 1];

        DashSaki__c dashsaki0 = new DashSaki__c();
        dashsaki0.answer__c = 'reject';   // 回答
        dashsaki0.dashirairef__c = dashiIrai.Id;   // 打診依頼
        dashsaki0.dashinsakiref__c = keiyaku.Id;   // 打診先
        dashsaki0.keiyakubango__c = keiyaku.KeiyakuBango__c;   // 契約番号
        insert dashsaki0;

        List<Opportunity> opps = [Select Id, DashIraiRef__c, ObosanbinRef__c,  ObosanbinRef__r.MemorialServicePlan__c From Opportunity
                                     Where Name like '法要_%'];
        update new Opportunity(id=opps[0].Id, DashIraiRef__c=dashiIrai.Id);

        insert new DashIraiHist__c(DashIraiRef__c=dashiIrai.Id, OppRef__c=opps[0].Id);
    }


}