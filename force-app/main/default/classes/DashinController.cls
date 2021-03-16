public class DashinController {
    private static final String DASHIN_HOYO = 'DashinHoyo';
    private static final String DASHIN_KAIMYO = 'DashinKaimyo';
    private static final String DASHIN_SOGI = 'DashinSogi';
    private static final List<String> SOGI_PLAN = new List<String>{'火葬式', '一日葬', '一般葬'};

//打診先案件検索Begin

    // 案件内容
    public class AnkenNaiyo {
        @AuraEnabled public String Id {get; set;}    // 商談 ID
        @AuraEnabled public String shuha {get; set;}    // 宗派
        @AuraEnabled public String ShodanBango {get; set;}    // 商談番号
        @AuraEnabled public String BodaijiUmu {get; set;}    // 菩提寺の有無
        @AuraEnabled public String MemorialServicePlan {get; set;}    // お坊さん便-プラン
        @AuraEnabled public String Kaimyojuyo {get; set;}    // 戒名の授与
        @AuraEnabled public String Kaimyo {get; set;}    // 戒名・法名
        @AuraEnabled public Datetime HoyoKohoDateTime1 {get; set;}    // 告別式・法要日時（第1希望）
        @AuraEnabled public Datetime HoyoKohoDateTime2 {get; set;}    // 告別式・法要日時（第2希望）
        @AuraEnabled public Datetime HoyoKohoDateTime3 {get; set;}    // 告別式・法要日時（第3希望）
        @AuraEnabled public String MemorialContent {get; set;}    // 法要内容
        @AuraEnabled public String HoyoBashoMei {get; set;}    // 法要場所名
        @AuraEnabled public String hoyo_postcode {get; set;}    // 法要郵便番号
        @AuraEnabled public String hoyo_todofuken {get; set;}    // 法要都道府県
        @AuraEnabled public String hoyo_shikugun {get; set;}    // 法要市区郡
        @AuraEnabled public String hoyo_tyoumei {get; set;}    // 法要町名
        @AuraEnabled public String hoyo_banchi {get; set;}    // 法要番地以降
        @AuraEnabled public String TsuikahoyobashoMei {get; set;}    // 追加法要場所名
        @AuraEnabled public String tuika_banchi {get; set;}    // 追加法要番地以降
        @AuraEnabled public String tuika_postcode {get; set;}    // 追加法要郵便番号
        @AuraEnabled public String tuika_shikugun {get; set;}    // 追加法要市区郡
        @AuraEnabled public String tuika_todofuken {get; set;}    // 追加法要都道府県
        @AuraEnabled public String tuika_tyoumei {get; set;}    // 追加法要町名
        @AuraEnabled public Decimal HoyoKingaku {get; set;}    // 金額
        @AuraEnabled public Decimal TesuryoKingaku {get; set;}    // 手数料計
        @AuraEnabled public Datetime MakurakyoDateTime {get; set;}    // 枕経
        @AuraEnabled public Datetime TsuyaDateTime {get; set;}    // 通夜日時
        @AuraEnabled public Datetime KokubetsuDateTime {get; set;}    // 告別式日時
        @AuraEnabled public Datetime KasoDateTime {get; set;}    // 火葬日時
        @AuraEnabled public String Shonanoka {get; set;}    // 初七日
        @AuraEnabled public String Saijo {get; set;}    // 式場名
        @AuraEnabled public String Kasoba {get; set;}    // 別途火葬場名
        @AuraEnabled public String sogi_postcode {get; set;}    // 葬儀郵便番号
        @AuraEnabled public String sogi_todofuken {get; set;}    // 葬儀都道府県
        @AuraEnabled public String sogi_shikugun {get; set;}    // 葬儀市区郡
        @AuraEnabled public String sogi_tyoumei {get; set;}    // 葬儀町名
        @AuraEnabled public String sogi_banchi {get; set;}    // 葬儀番地以降
        @AuraEnabled public String IraishoKisaiJiko {get; set;}    // 備考
        @AuraEnabled public List<String> TaioufukaPlan {get; set;}    // 対応不可プラン
        @AuraEnabled public Decimal hoyo_location_Longitude {get; set;}
        @AuraEnabled public Decimal hoyo_location_Latitude {get; set;}
        @AuraEnabled public Decimal sogi_location_Longitude {get; set;}
        @AuraEnabled public Decimal sogi_location_Latitude {get; set;}
        @AuraEnabled public Decimal tuika_location_Longitude {get; set;}
        @AuraEnabled public Decimal tuika_location_Latitude {get; set;}
        @AuraEnabled public String ZenkaiSoryoKibo {get; set;}
        @AuraEnabled public String anken_type {
            get {
                if(HouyoPlans.isHoyoPlan(MemorialServicePlan)){
                    return DASHIN_HOYO;
                } else if(SOGI_PLAN.contains(MemorialServicePlan)){
                    return DASHIN_SOGI;
                } else if(MemorialServicePlan == '戒名・法名のみ'){
                    return DASHIN_KAIMYO;
                }
                return '';
            }
        }

        @AuraEnabled public Boolean isError {get; set;}
        @AuraEnabled public Map<String, String> messages {get; set;}
        @AuraEnabled public Boolean is_urgent {get; set;}
        @AuraEnabled public Boolean isTeigaku {get; set;}
        @AuraEnabled public Decimal TeiHehTesuryoSogisha {get; set;}
        @AuraEnabled public Decimal TeiHehTesuryoSoryo {get; set;}

        @AuraEnabled public String iraisha_postcode {get; set;}    // 依頼者郵便番号
        @AuraEnabled public String iraisha_todofuken {get; set;}    // 依頼者都道府県
        @AuraEnabled public String iraisha_shikugun {get; set;}    // 依頼者市区郡
        @AuraEnabled public String iraisha_street {get; set;}    // 依頼者町名番地以降
        @AuraEnabled public Decimal iraisha_location_Longitude {get; set;}
        @AuraEnabled public Decimal iraisha_location_Latitude {get; set;}
    }

    /**
    * 案件内容
    */
    @AuraEnabled
    public static AnkenNaiyo searchAnkenNaiyo(String recordId) {
        List<Opportunity> sobjList = [SELECT
                                            Id,
                                            ShodanBango__c,
                                            Amount,
                                            RyunyumotoService__c, Iriguchi__c,
                                            Profit__c,
                                            Account.BillingPostalCode,
                                            Account.BillingState,
                                            Account.BillingCity,
                                            Account.BillingStreet,
                                            Account.BillingLatitude,
                                            Account.BillingLongitude,
                                            ObosanbinRef__r.GoshusiIraiKisaijiko__c,
                                            ObosanbinRef__r.BodaijinoUmu__c,
                                            ObosanbinRef__r.Taishosha1Shuha__c,
                                            ObosanbinRef__r.MemorialServicePlan__c,
                                            ObosanbinRef__r.Kaimyojuyo__c,
                                            ObosanbinRef__r.Kaimyo__c,
                                            ObosanbinRef__r.KokubetsuDateTime_Inp__c,
                                            ObosanbinRef__r.KokubetsuDateTime_Inp1__c,
                                            ObosanbinRef__r.KokubetsuDateTime_Inp2__c,
                                            ObosanbinRef__r.KokubetsuDateTime_Inp3__c,
                                            ObosanbinRef__r.MemorialContent__c,
                                            ObosanbinRef__r.HoyoBashoMei__c,
                                            ObosanbinRef__r.hoyo_postcode__c,
                                            ObosanbinRef__r.hoyo_todofuken__c,
                                            ObosanbinRef__r.hoyo_shikugun__c,
                                            ObosanbinRef__r.hoyo_tyoumei__c,
                                            ObosanbinRef__r.hoyo_banchi__c,
                                            ObosanbinRef__r.TsuikahoyobashoMei__c,
                                            ObosanbinRef__r.tuika_banchi__c,
                                            ObosanbinRef__r.tuika_postcode__c,
                                            ObosanbinRef__r.tuika_shikugun__c,
                                            ObosanbinRef__r.tuika_todofuken__c,
                                            ObosanbinRef__r.tuika_tyoumei__c,
                                            ObosanbinRef__r.Makurakyo__c,
                                            ObosanbinRef__r.TsuyaDateTime_Inp__c,
                                            ObosanbinRef__r.KokubetsushikiNichiji__c,
                                            ObosanbinRef__r.KasoDateTime_Inp__c,
                                            ObosanbinRef__r.Shonanoka__c,
                                            ObosanbinRef__r.Saijo__c,
                                            ObosanbinRef__r.Kasoba__c,
                                            ObosanbinRef__r.sogi_postcode__c,
                                            ObosanbinRef__r.sogi_todofuken__c,
                                            ObosanbinRef__r.sogi_shikugun__c,
                                            ObosanbinRef__r.sogi_tyoumei__c,
                                            ObosanbinRef__r.sogi_banchi__c,
                                            ObosanbinRef__r.SonotaSogisha__c,
                                            ObosanbinRef__r.HohoKingaku__c,
                                            ObosanbinRef__r.hoyo_location__Longitude__s,
                                            ObosanbinRef__r.hoyo_location__Latitude__s,
                                            ObosanbinRef__r.sogi_location__Longitude__s,
                                            ObosanbinRef__r.sogi_location__Latitude__s,
                                            ObosanbinRef__r.tuika_location__Longitude__s,
                                            ObosanbinRef__r.tuika_location__Latitude__s,
                                            ObosanbinRef__r.ZenkaiSoryoKibo__c,
                                            ObosanbinRef__r.TeiHehTesuryoSogisha__c,
                                            ObosanbinRef__r.TeiHehTesuryoSoryo__c,
                                            ObosanbinRef__r.TeiHehOfuseKingaku__c,
                                            DashIraiRef__c,
                                            DashIraiRef__r.Status__c
                                        FROM Opportunity WHERE ID =: recordId];
        if(sobjList.size() == 0) return null;
        AnkenNaiyo ankenNaiyo = toAnkenNaiyo(sobjList[0]);
        checkAnkenNaiyo(ankenNaiyo, sobjList[0]);
        return ankenNaiyo;
    }

    private static AnkenNaiyo toAnkenNaiyo(Opportunity sobj) {
        AnkenNaiyo ankenNaiyo = new AnkenNaiyo();
        ankenNaiyo.Id = sobj.Id;    // 商談 ID
        ankenNaiyo.shuha = sobj.ObosanbinRef__r.Taishosha1Shuha__c;    // 相談者宗派
        ankenNaiyo.ShodanBango = sobj.ShodanBango__c;    // 商談番号
        ankenNaiyo.BodaijiUmu = sobj.ObosanbinRef__r.BodaijinoUmu__c;    // 菩提寺の有無
        ankenNaiyo.MemorialServicePlan = sobj.ObosanbinRef__r.MemorialServicePlan__c;    // お坊さん便-プラン
        ankenNaiyo.Kaimyojuyo = sobj.ObosanbinRef__r.Kaimyojuyo__c;    // 戒名の授与
        ankenNaiyo.Kaimyo = sobj.ObosanbinRef__r.Kaimyo__c;    // 戒名・法名

        List<DateTime> hoyoKohoDateTimes = new HoyoKohoDateTimeCal()
                                                    .addHoyoKohoDate(sobj.ObosanbinRef__r.KokubetsuDateTime_Inp__c)
                                                    .addHoyoKohoDate(sobj.ObosanbinRef__r.KokubetsuDateTime_Inp1__c)
                                                    .addHoyoKohoDate(sobj.ObosanbinRef__r.KokubetsuDateTime_Inp2__c)
                                                    .addHoyoKohoDate(sobj.ObosanbinRef__r.KokubetsuDateTime_Inp3__c)
                                                    .getHoyoKohoDateTimes();
        ankenNaiyo.HoyoKohoDateTime1 = hoyoKohoDateTimes[0];    // 告別式・法要日時（第1希望）
        ankenNaiyo.HoyoKohoDateTime2 = hoyoKohoDateTimes[1];    // 告別式・法要日時（第2希望）
        ankenNaiyo.HoyoKohoDateTime3 = hoyoKohoDateTimes[2];    // 告別式・法要日時（第3希望）
        ankenNaiyo.MemorialContent = sobj.ObosanbinRef__r.MemorialContent__c;    // 法要内容
        ankenNaiyo.TsuikahoyobashoMei = sobj.ObosanbinRef__r.TsuikahoyobashoMei__c;    // 追加法要場所名
        ankenNaiyo.tuika_banchi = sobj.ObosanbinRef__r.tuika_banchi__c;    // 追加法要番地以降
        ankenNaiyo.tuika_postcode = sobj.ObosanbinRef__r.tuika_postcode__c;    // 追加法要郵便番号
        ankenNaiyo.tuika_shikugun = sobj.ObosanbinRef__r.tuika_shikugun__c;    // 追加法要市区郡
        ankenNaiyo.tuika_todofuken = sobj.ObosanbinRef__r.tuika_todofuken__c;    // 追加法要都道府県
        ankenNaiyo.tuika_tyoumei = sobj.ObosanbinRef__r.tuika_tyoumei__c;    // 追加法要町名
        ankenNaiyo.HoyoBashoMei = sobj.ObosanbinRef__r.HoyoBashoMei__c;    // 法要場所名
        ankenNaiyo.hoyo_postcode = sobj.ObosanbinRef__r.hoyo_postcode__c;    // 法要郵便番号
        ankenNaiyo.hoyo_todofuken = sobj.ObosanbinRef__r.hoyo_todofuken__c;    // 法要都道府県
        ankenNaiyo.hoyo_shikugun = sobj.ObosanbinRef__r.hoyo_shikugun__c;    // 法要市区郡
        ankenNaiyo.hoyo_tyoumei = sobj.ObosanbinRef__r.hoyo_tyoumei__c;    // 法要町名
        ankenNaiyo.hoyo_banchi = sobj.ObosanbinRef__r.hoyo_banchi__c;    // 法要番地以降
        ankenNaiyo.MakurakyoDateTime = sobj.ObosanbinRef__r.Makurakyo__c;    // 枕経
        ankenNaiyo.TsuyaDateTime = sobj.ObosanbinRef__r.TsuyaDateTime_Inp__c;    // 通夜日時
        ankenNaiyo.KokubetsuDateTime = sobj.ObosanbinRef__r.KokubetsushikiNichiji__c;    // 告別式日時
        ankenNaiyo.KasoDateTime = sobj.ObosanbinRef__r.KasoDateTime_Inp__c;    // 火葬日時
        ankenNaiyo.Shonanoka = sobj.ObosanbinRef__r.Shonanoka__c;    // 初七日
        ankenNaiyo.Saijo = sobj.ObosanbinRef__r.Saijo__c;    // 式場名
        ankenNaiyo.Kasoba = sobj.ObosanbinRef__r.Kasoba__c;    // 別途火葬場名
        ankenNaiyo.sogi_postcode = sobj.ObosanbinRef__r.sogi_postcode__c;    // 葬儀郵便番号
        ankenNaiyo.sogi_todofuken = sobj.ObosanbinRef__r.sogi_todofuken__c;    // 葬儀都道府県
        ankenNaiyo.sogi_shikugun = sobj.ObosanbinRef__r.sogi_shikugun__c;    // 葬儀市区郡
        ankenNaiyo.sogi_tyoumei = sobj.ObosanbinRef__r.sogi_tyoumei__c;    // 葬儀町名
        ankenNaiyo.sogi_banchi = sobj.ObosanbinRef__r.sogi_banchi__c;    // 葬儀番地以降
        ankenNaiyo.isTeigaku = sobj.RyunyumotoService__c == '定額僧侶手配代行';
        ankenNaiyo.TeiHehTesuryoSogisha = ankenNaiyo.isTeigaku ? sobj.ObosanbinRef__r.TeiHehTesuryoSogisha__c : null;
        ankenNaiyo.TeiHehTesuryoSoryo = ankenNaiyo.isTeigaku ? sobj.ObosanbinRef__r.TeiHehTesuryoSoryo__c : null;
        ankenNaiyo.HoyoKingaku = ankenNaiyo.isTeigaku ? sobj.ObosanbinRef__r.TeiHehOfuseKingaku__c : sobj.Amount;    // 金額
        ankenNaiyo.TesuryoKingaku = sobj.Profit__c;    // 手数料計
        ankenNaiyo.IraishoKisaiJiko = sobj.ObosanbinRef__r.GoshusiIraiKisaijiko__c;    // 備考
        ankenNaiyo.ZenkaiSoryoKibo = sobj.ObosanbinRef__r.ZenkaiSoryoKibo__c;    // 前回と同じ僧侶の希望

        List<String> theServiceFeatureTags = new List<String>();
        if(sobj.ObosanbinRef__r.MemorialServicePlan__c == '戒名・法名のみ') theServiceFeatureTags.add( OboStApi_SoryoPut.ServiceFeatureTags_KaimyoOnly );
        if(sobj.Iriguchi__c == 'Amazon'|| sobj.Iriguchi__c == 'Yahoo') theServiceFeatureTags.add( OboStApi_SoryoPut.ServiceFeatureTags_AmazonYahoo );
        if(sobj.RyunyumotoService__c == '定額僧侶手配代行') theServiceFeatureTags.add( OboStApi_SoryoPut.ServiceFeatureTags_TeigakuTehaiDaiko );
        ankenNaiyo.TaioufukaPlan = theServiceFeatureTags;

        ankenNaiyo.hoyo_location_Longitude = sobj.ObosanbinRef__r.hoyo_location__Longitude__s;
        ankenNaiyo.hoyo_location_Latitude = sobj.ObosanbinRef__r.hoyo_location__Latitude__s;
        ankenNaiyo.sogi_location_Longitude = sobj.ObosanbinRef__r.sogi_location__Longitude__s;
        ankenNaiyo.sogi_location_Latitude = sobj.ObosanbinRef__r.sogi_location__Latitude__s;
        ankenNaiyo.tuika_location_Longitude = sobj.ObosanbinRef__r.tuika_location__Longitude__s;
        ankenNaiyo.tuika_location_Latitude = sobj.ObosanbinRef__r.tuika_location__Latitude__s;

        OboStSelProf oboStSelProf = new OboStSelProf();
        if(ankenNaiyo.anken_type == DASHIN_HOYO ) {
            DateTime serviceTime = new ServiceTimeCal()
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime1)
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime2)
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime3)
                                        .getServiceTime();
            if(serviceTime != null)
                ankenNaiyo.is_urgent = oboStSelProf.isUrgent(serviceTime, DateTime.now());
        }
        if(ankenNaiyo.anken_type == DASHIN_SOGI) {
            DateTime serviceTime = new ServiceTimeCal()
                                        .addServiceTime(ankenNaiyo.MakurakyoDateTime)
                                        .addServiceTime(ankenNaiyo.TsuyaDateTime)
                                        .addServiceTime(ankenNaiyo.KokubetsuDateTime)
                                        .addServiceTime(ankenNaiyo.KasoDateTime)
                                        .getServiceTime();
            if(serviceTime != null)
                ankenNaiyo.is_urgent = oboStSelProf.isUrgent(serviceTime, DateTime.now());
        }
        if(ankenNaiyo.anken_type == DASHIN_KAIMYO) {
            ankenNaiyo.is_urgent = false;
            ankenNaiyo.iraisha_postcode = sobj.Account.BillingPostalCode;
            ankenNaiyo.iraisha_todofuken = sobj.Account.BillingState;
            ankenNaiyo.iraisha_shikugun = sobj.Account.BillingCity;
            ankenNaiyo.iraisha_street = sobj.Account.BillingStreet;
            if(String.isNotBlank(ankenNaiyo.iraisha_postcode)
                 && String.isNotBlank(ankenNaiyo.iraisha_todofuken)
                 && String.isNotBlank(ankenNaiyo.iraisha_shikugun)
                 && String.isNotBlank(ankenNaiyo.iraisha_street)
                ) {
                List<String> addressList = new List<String>();
                if(String.isNotBlank(ankenNaiyo.iraisha_todofuken)) addressList.add(ankenNaiyo.iraisha_todofuken);
                if(String.isNotBlank(ankenNaiyo.iraisha_shikugun)) addressList.add(ankenNaiyo.iraisha_shikugun);
                if(String.isNotBlank(ankenNaiyo.iraisha_street)) addressList.add(ankenNaiyo.iraisha_street);
                String address = String.join(addressList, '');
                GeoLocs.Result res = new GeoLocs().getGeoLocation(ankenNaiyo.iraisha_postcode, address, true);
                if(res.isSuccess){
                    ankenNaiyo.iraisha_location_Latitude = res.geoLocation.lat;
                    ankenNaiyo.iraisha_location_Longitude = res.geoLocation.lng;
                }
            }
        }

        return ankenNaiyo;
    }

    private static void checkAnkenNaiyo(AnkenNaiyo ankenNaiyo, Opportunity opp){
        ankenNaiyo.messages = new Map<String, String>();
        if(String.isBlank(ankenNaiyo.anken_type)){
            ankenNaiyo.messages.put('ANKEN_TYPE_ERROR', 'お坊さん便プラン不正');
        }

        if(ankenNaiyo.isTeigaku){
            if( ankenNaiyo.TeiHehTesuryoSogisha == null || ankenNaiyo.TeiHehTesuryoSogisha <= 0 ) {
                ankenNaiyo.messages.put('TEIHEHTESURYOSOGISHA_ERROR', '金額不正');
            }
            if( ankenNaiyo.TeiHehTesuryoSoryo == null || ankenNaiyo.TeiHehTesuryoSoryo <= 0 ) {
                ankenNaiyo.messages.put('TEIHEHTESURYOSORYO_ERROR', '金額不正');
            }
        }
        if(ankenNaiyo.anken_type == DASHIN_HOYO) {
            if(String.isBlank(ankenNaiyo.shuha)) {
                ankenNaiyo.messages.put('SHUHA_ERROR', '宗派未入力');
            }
            if(ankenNaiyo.BodaijiUmu != '有' && ankenNaiyo.BodaijiUmu != '無' ) {
                ankenNaiyo.messages.put('BODAIJIUMU_ERROR', '菩提寺の有無不正; 「有」か「無」か');
            }
            if(String.isBlank(ankenNaiyo.Kaimyojuyo)) {
                ankenNaiyo.messages.put('KAIMYOJUYO_ERROR', '戒名の授与未入力');
            }
            if(ankenNaiyo.Kaimyojuyo == '戒名の授与を希望する' && String.isBlank(ankenNaiyo.Kaimyo)) {
                ankenNaiyo.messages.put('KAIMYO_ERROR', '戒名・法名未入力');
            }
            if(ankenNaiyo.Kaimyojuyo == '戒名の授与を希望しない' && String.isNotBlank(ankenNaiyo.Kaimyo)) {
                ankenNaiyo.messages.put('KAIMYO_ERROR', '戒名・法名不正');
            }
            if(String.isBlank(ankenNaiyo.MemorialContent)) {
                ankenNaiyo.messages.put('MEMORIALCONTENT_ERROR', '法要内容未入力');
            }
            if( ankenNaiyo.HoyoKohoDateTime1 == null &&
                ankenNaiyo.HoyoKohoDateTime2 == null &&
                ankenNaiyo.HoyoKohoDateTime3 == null
                ) {
                ankenNaiyo.messages.put('HOYODATETIME_ERROR', '法要日時・候補日時未入力');
            }
            if(String.isBlank(ankenNaiyo.HoyoBashoMei)) {
                ankenNaiyo.messages.put('HOYOBASHOMEI_ERROR', '法要場所名未入力');
            }
            if(String.isBlank(ankenNaiyo.hoyo_postcode)) {
                ankenNaiyo.messages.put('HOYO_POSTCODE_ERROR', '法要郵便番号未入力');
            }
            if(String.isBlank(ankenNaiyo.hoyo_todofuken)) {
                ankenNaiyo.messages.put('HOYO_TODOFUKEN_ERROR', '法要都道府県未入力');
            }
            if(String.isBlank(ankenNaiyo.hoyo_shikugun)) {
                ankenNaiyo.messages.put('HOYO_SHIKUGUN_ERROR', '法要市区郡未入力');
            }
            if(String.isBlank(ankenNaiyo.hoyo_tyoumei)) {
                ankenNaiyo.messages.put('HOYO_TYOUMEI_ERROR', '法要町名未入力');
            }
            if(ankenNaiyo.hoyo_location_Latitude == null) {
                ankenNaiyo.messages.put('HOYO_LOCATION_LATITUDE_ERROR', '法要場所座標緯度エラー');
            }
            if(ankenNaiyo.hoyo_location_Longitude == null) {
                ankenNaiyo.messages.put('HOYO_LOCATION_LONGITUDE_ERROR', '法要場所座標経度エラー');
            }
            if( String.isNotBlank(ankenNaiyo.TsuikahoyobashoMei) ||
                String.isNotBlank(ankenNaiyo.tuika_postcode) ||
                String.isNotBlank(ankenNaiyo.tuika_shikugun) ||
                String.isNotBlank(ankenNaiyo.tuika_todofuken) ||
                String.isNotBlank(ankenNaiyo.tuika_tyoumei) ||
                ankenNaiyo.tuika_location_Latitude != null ||
                ankenNaiyo.tuika_location_Longitude != null
                ) {
                if(String.isBlank(ankenNaiyo.TsuikahoyobashoMei)) {
                    ankenNaiyo.messages.put('TSUIKAHOYOBASHOMEI_ERROR', '追加法要場所名未入力');
                }
                if(String.isBlank(ankenNaiyo.tuika_postcode)) {
                    ankenNaiyo.messages.put('TUIKA_POSTCODE_ERROR', '追加法要郵便番号未入力');
                }
                if(String.isBlank(ankenNaiyo.tuika_shikugun)) {
                    ankenNaiyo.messages.put('TUIKA_SHIKUGUN_ERROR', '追加法要市区郡未入力');
                }
                if(String.isBlank(ankenNaiyo.tuika_todofuken)) {
                    ankenNaiyo.messages.put('TUIKA_TODOFUKEN_ERROR', '追加法要都道府県未入力');
                }
                if(String.isBlank(ankenNaiyo.tuika_tyoumei)) {
                    ankenNaiyo.messages.put('TUIKA_TYOUMEI_ERROR', '追加法要町名未入力');
                }
                if(ankenNaiyo.tuika_location_Latitude == null) {
                    ankenNaiyo.messages.put('TUIKA_LOCATION_LATITUDE_ERROR', '追加法要場所座標緯度エラー');
                }
                if(ankenNaiyo.tuika_location_Longitude == null) {
                    ankenNaiyo.messages.put('TUIKA_LOCATION_LONGITUDE_ERROR', '追加法要場所座標経度エラー');
                }
            }
            if( ankenNaiyo.HoyoKingaku == null || ankenNaiyo.HoyoKingaku <= 0 ) {
                ankenNaiyo.messages.put('HOYOKINGAKU_ERROR', '金額不正');
            }
            if( ankenNaiyo.TesuryoKingaku == null || ankenNaiyo.TesuryoKingaku <= 0 ) {
                ankenNaiyo.messages.put('TESURYOKINGAKU_ERROR', '手数料不正');
            }
        }
        if(ankenNaiyo.anken_type == DASHIN_SOGI) {
            if(String.isBlank(ankenNaiyo.shuha)) {
                ankenNaiyo.messages.put('SHUHA_ERROR', '宗派未入力');
            }
            if(ankenNaiyo.BodaijiUmu != '有' && ankenNaiyo.BodaijiUmu != '無' ) {
                ankenNaiyo.messages.put('BODAIJIUMU_ERROR', '菩提寺の有無不正; 「有」か「無」か');
            }
            if(String.isBlank(ankenNaiyo.Kaimyojuyo)) {
                ankenNaiyo.messages.put('KAIMYOJUYO_ERROR', '戒名の授与未入力');
            }
            if(ankenNaiyo.Kaimyojuyo == '戒名の授与を希望する' && String.isBlank(ankenNaiyo.Kaimyo)) {
                ankenNaiyo.messages.put('KAIMYO_ERROR', '戒名・法名未入力');
            }
            if(ankenNaiyo.Kaimyojuyo == '戒名の授与を希望しない' && String.isNotBlank(ankenNaiyo.Kaimyo)) {
                ankenNaiyo.messages.put('KAIMYO_ERROR', '戒名・法名不正');
            }
            if(ankenNaiyo.MemorialServicePlan == '一般葬' && ankenNaiyo.TsuyaDateTime == null){
                ankenNaiyo.messages.put('TSUYADATETIME_ERROR', '通夜日時未入力');
            }
            if( (ankenNaiyo.MemorialServicePlan == '一般葬' || ankenNaiyo.MemorialServicePlan == '一日葬' )
                 && ankenNaiyo.KokubetsuDateTime == null){
                ankenNaiyo.messages.put('KOKUBETSUDATETIME_ERROR', '告別式日時未入力');
            }
            if(String.isBlank(ankenNaiyo.MemorialContent)) {
                ankenNaiyo.messages.put('MEMORIALCONTENT_ERROR', '法要内容未入力');
            }
            if(ankenNaiyo.KasoDateTime == null){
                ankenNaiyo.messages.put('KASODATETIME_ERROR', '火葬日時未入力');
            }
            if( (ankenNaiyo.MemorialServicePlan == '一般葬' || ankenNaiyo.MemorialServicePlan == '一日葬' )
                 && ankenNaiyo.Shonanoka == null){
                ankenNaiyo.messages.put('SHONANOKA_ERROR', '初七日未入力');
            }
            if(ankenNaiyo.Saijo == null){
                ankenNaiyo.messages.put('SAIJO_ERROR', '式場名未入力');
            }
            if((ankenNaiyo.MemorialServicePlan == '一般葬' || ankenNaiyo.MemorialServicePlan == '一日葬' )
                 && String.isBlank(ankenNaiyo.Kasoba)){
                ankenNaiyo.messages.put('KASOBA_ERROR', '火葬場名未入力');
            }
            if(String.isBlank(ankenNaiyo.sogi_postcode)) {
                ankenNaiyo.messages.put('SOGI_POSTCODE_ERROR', '葬儀郵便番号未入力');
            }
            if(String.isBlank(ankenNaiyo.sogi_todofuken)) {
                ankenNaiyo.messages.put('SOGI_TODOFUKEN_ERROR', '葬儀都道府県未入力');
            }
            if(String.isBlank(ankenNaiyo.sogi_shikugun)) {
                ankenNaiyo.messages.put('SOGI_SHIKUGUN_ERROR', '葬儀市区郡未入力');
            }
            if(String.isBlank(ankenNaiyo.sogi_tyoumei)) {
                ankenNaiyo.messages.put('SOGI_TYOUMEI_ERROR', '葬儀町名未入力');
            }
            if( ankenNaiyo.HoyoKingaku == null || ankenNaiyo.HoyoKingaku <= 0 ) {
                ankenNaiyo.messages.put('HOYOKINGAKU_ERROR', '金額不正');
            }
            if( ankenNaiyo.TesuryoKingaku == null || ankenNaiyo.TesuryoKingaku <= 0 ) {
                ankenNaiyo.messages.put('TESURYOKINGAKU_ERROR', '手数料不正');
            }
            if(ankenNaiyo.sogi_location_Latitude == null) {
                ankenNaiyo.messages.put('SOGI_LOCATION_LATITUDE_ERROR', '葬儀場所座標緯度エラー');
            }
            if(ankenNaiyo.sogi_location_Longitude == null) {
                ankenNaiyo.messages.put('SOGI_LOCATION_LONGITUDE_ERROR', '葬儀場所座標経度エラー');
            }
        }
        if(ankenNaiyo.anken_type == DASHIN_KAIMYO) {
            if(String.isBlank(ankenNaiyo.shuha)) {
                ankenNaiyo.messages.put('SHUHA_ERROR', '宗派未入力');
            }
            if(ankenNaiyo.BodaijiUmu != '有' && ankenNaiyo.BodaijiUmu != '無' ) {
                ankenNaiyo.messages.put('BODAIJIUMU_ERROR', '菩提寺の有無不正; 「有」か「無」か');
            }
            if(String.isBlank(ankenNaiyo.Kaimyo)) {
                ankenNaiyo.messages.put('KAIMYO_ERROR', '戒名・法名未入力');
            }
            if( ankenNaiyo.HoyoKingaku == null || ankenNaiyo.HoyoKingaku <= 0 ) {
                ankenNaiyo.messages.put('HOYOKINGAKU_ERROR', '金額不正');
            }
            if( ankenNaiyo.TesuryoKingaku == null || ankenNaiyo.TesuryoKingaku <= 0 ) {
                ankenNaiyo.messages.put('TESURYOKINGAKU_ERROR', '手数料不正');
            }
            if(String.isBlank(ankenNaiyo.iraisha_postcode)) {
                ankenNaiyo.messages.put('IRAISHA_POSTCODE_ERROR', '郵便番号未入力');
            }
            if(String.isBlank(ankenNaiyo.iraisha_todofuken)) {
                ankenNaiyo.messages.put('IRAISHA_TODOFUKEN_ERROR', '都道府県未入力');
            }
            if(String.isBlank(ankenNaiyo.iraisha_shikugun)) {
                ankenNaiyo.messages.put('IRAISHA_SHIKUGUN_ERROR', '市区郡未入力');
            }
            if(String.isBlank(ankenNaiyo.iraisha_street)) {
                ankenNaiyo.messages.put('IRAISHA_STREET_ERROR', '町名以降未入力');
            }
            if(ankenNaiyo.iraisha_location_Latitude == null) {
                ankenNaiyo.messages.put('IRAISHA_LOCATION_LATITUDE_ERROR', '座標緯度エラー');
            }
            if(ankenNaiyo.iraisha_location_Longitude == null) {
                ankenNaiyo.messages.put('IRAISHA_LOCATION_LONGITUDE_ERROR', '座標経度エラー');
            }
        }

        if(opp.DashIraiRef__r.Status__c == 'Opened') {
           ankenNaiyo.messages.put('DASHIN_STATUS_ERROR', '打診中の案件には新規打診操作ができません。');
        }

        ankenNaiyo.isError = ankenNaiyo.messages.size() > 0;
    }

//打診先案件検索End

//打診先検索Begin

    // 打診先
    public class DashinSaki {
        @AuraEnabled public String Id {get; set;}    // カスタムオブジェクト ID
        @AuraEnabled public String KeiyakuBango {get; set;}    // 契約番号
        @AuraEnabled public String Syozokusangojiinme {get; set;}    // 所属山号寺院名
        @AuraEnabled public String TeikeisakiName {get; set;}    // 僧侶名
        @AuraEnabled public String SyussiRank {get; set;}    // 出仕ランク
        @AuraEnabled public String Sokyakujicyuiten {get; set;}    // 送客時注意点
        @AuraEnabled public String Syuha {get; set;}    // 宗派
    }

    // 打診先検索用パラメータ
    public class DashinSakiSearchCondition {
        public String simei_soryo {get; set;}    // 指名僧侶
    }

    public class DashinSakiSearchResult{
        @AuraEnabled public List<DashinSaki> dashinSakiList = new List<DashinSaki>();
        @AuraEnabled public List<String> message = new List<String>();
        @AuraEnabled public Integer code = 1;
    }

    /**
    * 打診先検索
    */
    @AuraEnabled
    public static DashinSakiSearchResult doSearchDashinSaki(String dashinSakiSearchCondition, String ankenNaiyo) {
        DashinSakiSearchResult dashinSakiSearchResult = new DashinSakiSearchResult();
        try{
            DashinSakiSearchCondition theDashinSakiSearchCondition = (DashinSakiSearchCondition)JSON.deserialize(dashinSakiSearchCondition, DashinSakiSearchCondition.class);
            DashinController.AnkenNaiyo theAnkenNaiyo = (DashinController.AnkenNaiyo)JSON.deserialize(ankenNaiyo, DashinController.AnkenNaiyo.class);
            dashinSakiSearchResult.dashinSakiList = new DashinSakiDataProvider().getDashinSakiList(theDashinSakiSearchCondition, theAnkenNaiyo);

            dashinSakiSearchResult.message.add('打診debug log');
            dashinSakiSearchResult.message.add(ankenNaiyo);
            dashinSakiSearchResult.message.add(dashinSakiSearchCondition);
        } catch(Exception ex){
            dashinSakiSearchResult.code = -1;
            dashinSakiSearchResult.message.add(ex + '');
            dashinSakiSearchResult.message.add('Exception type caught: ' + ex.getTypeName());
            dashinSakiSearchResult.message.add('Message: ' + ex.getMessage());
            dashinSakiSearchResult.message.add('Cause: ' + ex.getCause());    // returns null
            dashinSakiSearchResult.message.add('Line number: ' + ex.getLineNumber());
            dashinSakiSearchResult.message.add('Stack trace: ' + ex.getStackTraceString());
        }
        return dashinSakiSearchResult;
    }

    private class DashinSakiDataProvider {

        private OboStSelProf oboStSelProf = new OboStSelProf();

        private Boolean isHoyoJikanMitei(DateTime dt) {
            return dt.format('HH:mm') == '00:00';
        }

        private void addCandidatePeriod(OboStApi_Search.ReqBody reqBody, DateTime candidatePeriod){
            Date today = Date.toDay();
            Time hourFindBeginInNoTimeSepc = Time.newInstance(oboStSelProf.getHourFindBeginInNoTimeSepc(), 0, 0, 0);
            Time hourFindEndInNoTimeSepc = Time.newInstance(oboStSelProf.getHourFindEndInNoTimeSepc(), 0, 0, 0);
            String eigyoJikanFrom = DateTime.newInstance(today, hourFindBeginInNoTimeSepc).format('HH:mm');
            String eigyoJiaknTo = DateTime.newInstance(today, hourFindEndInNoTimeSepc).format('HH:mm');
            Integer siteiAkiJikan = 1;
            if(candidatePeriod != null){
                if( isHoyoJikanMitei(candidatePeriod) ){
                    reqBody.fuzzy_candidate_dates.add(
                            new OboStApi_Search.FuzzyCandidateDate(eigyoJikanFrom, eigyoJiaknTo, siteiAkiJikan,
                                    date.newinstance(candidatePeriod.year(), candidatePeriod.month(), candidatePeriod.day())
                                )
                        );
                } else {
                    reqBody.candidate_periods.add(
                            new OboStApi_Search.CandidatePeriod()
                                .addDuration(new OboStApi_Search.Duration(candidatePeriod, candidatePeriod.addHours(1)))
                        );
                }
            }
        }

        public List<DashinSaki> getDashinSakiList(DashinSakiSearchCondition dashinSakiSearchCondition, DashinController.AnkenNaiyo ankenNaiyo) {
            // Call OboStApi_Search To get Data
            // お坊自動手配.選定.Api.Draft
            OboStApi_Search.ReqBody reqBody = new OboStApi_Search.ReqBody();
            reqBody.offset = 0;
            reqBody.limit_size = oboStSelProf.getSenteiSize();
            reqBody.exclude_negotiation_id = ankenNaiyo.ShodanBango; // 商談番号
            reqBody.contract_id = dashinSakiSearchCondition.simei_soryo;
            reqBody.kibo_shuha = ankenNaiyo.shuha;
            reqBody.rank_ordering = [SELECT SvcRankOrder__c FROM OboStSelProf__c LIMIT 1].SvcRankOrder__c.split('-');
            reqBody.exclude_unavailable_services = ankenNaiyo.TaioufukaPlan;

            String ankenType = ankenNaiyo.anken_type;

            // 法要
            if(ankenType == DASHIN_HOYO) {
                if(ankenNaiyo.HoyoKohoDateTime1!= null) this.addCandidatePeriod(reqBody, ankenNaiyo.HoyoKohoDateTime1);
                if(ankenNaiyo.HoyoKohoDateTime2!= null) this.addCandidatePeriod(reqBody, ankenNaiyo.HoyoKohoDateTime2);
                if(ankenNaiyo.HoyoKohoDateTime3!= null) this.addCandidatePeriod(reqBody, ankenNaiyo.HoyoKohoDateTime3);
                if(String.isBlank(dashinSakiSearchCondition.simei_soryo)){
                    reqBody.place = new OboStApi_Search.place(ankenNaiyo.hoyo_location_Latitude, ankenNaiyo.hoyo_location_Longitude, oboStSelProf.getMaxDistance());
                } else {
                    // 指名僧侶の時、距離制限を外す
                    reqBody.place = null;
                }
            }

            // 葬儀
            if(ankenType == DASHIN_SOGI) {

                OboStApi_Search.CandidatePeriod theSogi = new OboStApi_Search.CandidatePeriod();

                if(ankenNaiyo.MakurakyoDateTime != null){
                    theSogi.addDuration(
                        new OboStApi_Search.Duration(ankenNaiyo.MakurakyoDateTime, ankenNaiyo.MakurakyoDateTime.addHours(1))
                    );
                }
                if(ankenNaiyo.TsuyaDateTime != null){
                    theSogi.addDuration(
                        new OboStApi_Search.Duration(ankenNaiyo.TsuyaDateTime, ankenNaiyo.TsuyaDateTime.addHours(1))
                    );
                }
                if(ankenNaiyo.KokubetsuDateTime != null){
                    theSogi.addDuration(
                        new OboStApi_Search.Duration(ankenNaiyo.KokubetsuDateTime, ankenNaiyo.KokubetsuDateTime.addHours(1))
                    );
                }
                if(ankenNaiyo.KasoDateTime != null){
                    theSogi.addDuration(
                        new OboStApi_Search.Duration(ankenNaiyo.KasoDateTime, ankenNaiyo.KasoDateTime.addHours(1))
                    );
                }
                reqBody.candidate_periods.add(theSogi);

                if(String.isBlank(dashinSakiSearchCondition.simei_soryo)){
                    reqBody.place = new OboStApi_Search.place(ankenNaiyo.sogi_location_Latitude, ankenNaiyo.sogi_location_Longitude, oboStSelProf.getMaxDistance());
                } else {
                    // 指名僧侶の時、距離制限を外す
                    reqBody.place = null;
                }
            }

            // 戒名の場合
            if(ankenType == DASHIN_KAIMYO) {
                if(String.isBlank(dashinSakiSearchCondition.simei_soryo)){
                    Integer KAIMYO_MAX_DISTANCE = 50;
                    reqBody.place = new OboStApi_Search.place(ankenNaiyo.iraisha_location_Latitude, ankenNaiyo.iraisha_location_Longitude, KAIMYO_MAX_DISTANCE);
                } else {
                    // 指名僧侶の時、距離制限を外す
                    reqBody.place = null;
                }
            }

            List<DashinSaki> theDashinSakis = new List<DashinSaki>();
            Set<String> keiyakubangos = new Set<String>();
            for(OboStApi_Search.Senteisaki senteisaki : new OboStApi_Search().doSearch(reqBody)) {
                DashinSaki aDashinSaki = new DashinSaki();
                aDashinSaki.Id = senteisaki.id;    //
                aDashinSaki.KeiyakuBango = senteisaki.id;    // 契約番号
                aDashinSaki.Syozokusangojiinme = senteisaki.temple;    // 所属山号寺院名
                aDashinSaki.TeikeisakiName = senteisaki.partner_name;    // 僧侶名
                aDashinSaki.SyussiRank = senteisaki.rank;    // 出仕ランク
                theDashinSakis.add(aDashinSaki);
                keiyakubangos.add(senteisaki.id);
            }

            // 送客時注意点
            Map<String, Keiyaku__c> keiyakuMap = new Map<String, Keiyaku__c>();
            for(Keiyaku__c k : [SELECT Id, KeiyakuBango__c, Sokyakujicyuiten__c, Syuha__c FROM Keiyaku__c WHERE KeiyakuBango__c = :keiyakubangos]){
                keiyakuMap.put(k.KeiyakuBango__c, k);
            }
            for(DashinSaki aDashinSaki : theDashinSakis){
                if(!keiyakuMap.containsKey(aDashinSaki.KeiyakuBango)) continue;
                Keiyaku__c k = keiyakuMap.get(aDashinSaki.KeiyakuBango);
                aDashinSaki.Sokyakujicyuiten = k.Sokyakujicyuiten__c;
                aDashinSaki.Syuha = k.Syuha__c;
            }

            return theDashinSakis;
        }
    }

//打診先検索End


//打診依頼Begin
    public class DashIraiRequest {
        @AuraEnabled public AnkenNaiyo ankenNaiyo {get; set;}
        @AuraEnabled public List<DashinSaki> dashinSakiList {get; set;}
        @AuraEnabled public Boolean is_repeat {get; set;}
    }

    // 打診先送信結果
    public class DashinIraiResult {
        @AuraEnabled public String resultCode = 'success';
        @AuraEnabled public List<String> errMsgs = new List<String>();
        public DashinIraiResult setResultCode(String presultCode){ this.resultCode = presultCode; return this; }
        public DashinIraiResult addErrorMsg(String pErrMsg){ this.errMsgs.add(pErrMsg); return this; }
        public DashinIraiResult addErrorMsg( List<String> pErrMsgs ){ this.errMsgs.addAll(pErrMsgs); return this; }
    }

    /**
    * 打診先送信
    */
    @AuraEnabled
    public static DashinIraiResult doSendDashinIrai(String pRequest) {
        try{
            DashIraiRequest theDashIraiRequest = (DashIraiRequest)JSON.deserialize(pRequest, DashIraiRequest.class);
            System.debug(theDashIraiRequest);
            System.debug(theDashIraiRequest.ankenNaiyo);
            return new DashinIraiProcessor().processDashinIraiRequest(theDashIraiRequest);
        }catch(Exception ex){
            System.debug(ex);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190730-1600-02', 'DashinController.doSendDashinIrai')
                    .putAttr( 'ex.getTypeName()', ex.getTypeName() )
                    .putAttr( 'ex.getMessage()', ex.getMessage() )
                    .putAttr( 'ex.getStackTraceString()', ex.getStackTraceString() )
            );
            return new DashinIraiResult().setResultCode('error_unhandled')
                        .addErrorMsg(ex.getMessage())
                        .addErrorMsg(pRequest);
        }
    }

    private class DashinIraiProcessor {

        private IDashinIraiDataBuilder dashinIraiDataBuilder;

        public DashinIraiResult processDashinIraiRequest(DashIraiRequest dashIraiRequest){

            this.dashinIraiDataBuilder = this.getDashinIraiDataBuilder(dashIraiRequest.ankenNaiyo.anken_type);
            OboStApi_Offer.ReqBody oboStApiOfferReqBody = this.dashinIraiDataBuilder.getOboStApiOfferReqBody(dashIraiRequest);
            OboStApi_Offer.Result result = new OboStApi_Offer().sendRequest(oboStApiOfferReqBody);
            if(result.isSuccess){
                this.saveNewDashinIrai(result.offer_id, dashIraiRequest, oboStApiOfferReqBody);
                return new DashinIraiResult().setResultCode('success');
            } else {
                return new DashinIraiResult()
                            .setResultCode('error_unhandled')
                            .addErrorMsg('OboStApi_Offer.Resultエラー')
                            .addErrorMsg(result.descr+ '')
                            .addErrorMsg(result.endPoint+ '')
                            .addErrorMsg(result.statusCode+ '')
                            .addErrorMsg(result.offer_id+ '')
                            .addErrorMsg(result.reqBodyRaw+ '')
                            .addErrorMsg(result.resBodyRaw + '');
            }
        }

        private IDashinIraiDataBuilder getDashinIraiDataBuilder(String ankenType){
            if(ankenType == DASHIN_HOYO){
                return new HoyoDashinIraiDataBuilder();
            }
            if(ankenType == DASHIN_SOGI){
                return new SogiDashinIraiDataBuilder();
            }
            if(ankenType == DASHIN_KAIMYO){
                return new KaimyoDashinIraiDataBuilder();
            }
            return null;
        }

        private void saveNewDashinIrai(Integer offer_id, DashIraiRequest dashIraiRequest, OboStApi_Offer.ReqBody oboStApiOfferReqBody){
            DashIrai__c dashIrai = this.dashinIraiDataBuilder.getDashinIrai(dashIraiRequest.ankenNaiyo);
            dashIrai.offer_id__c = offer_id;
            dashIrai.expiry_datetime__c = Datetime.valueOf(oboStApiOfferReqBody.expiry_datetime);
            dashIrai.hours_allowed_for_a_person__c = oboStApiOfferReqBody.hours_allowed;
            dashIrai.is_repeat__c = dashIraiRequest.is_repeat;
            insert dashIrai;

            List<DashSaki__c> dashSakiList = new List<DashSaki__c>();
            Map<String, Id> keiyakuMap = this.getKeiyakuMap(dashIraiRequest.dashinSakiList) ;
            for(DashinSaki ds : dashIraiRequest.dashinSakiList){
                dashSakiList.add(new DashSaki__c(
                        DashIraiRef__c = dashIrai.Id,
                        KeiyakuBango__c = ds.KeiyakuBango,
                        DashinSakiRef__c = keiyakuMap.get(ds.KeiyakuBango)
                    ));
            }
            insert dashSakiList;
            update new Opportunity(Id=dashIraiRequest.ankenNaiyo.Id, DashIraiRef__c=dashIrai.id, SubPhase__c='スケジュール確認中（自動打診）');

            insert new DashIraiHist__c(OppRef__c=dashIraiRequest.ankenNaiyo.Id, DashIraiRef__c=dashIrai.id);
        }

        private Map<String, Id> getKeiyakuMap(List<DashinSaki> dashinSakiList) {
            Map<String, Id> keiyakuMap = new Map<String, Id>();
            Set<String> keiyakubangos = new Set<String>();
            for(DashinSaki ds : dashinSakiList) {
                keiyakubangos.add(ds.KeiyakuBango);
            }
            for(Keiyaku__c ky : [Select Id, KeiyakuBango__c From Keiyaku__c Where KeiyakuBango__c = :keiyakubangos]){
                keiyakuMap.put(ky.KeiyakuBango__c, ky.Id);
            }
            return keiyakuMap;
        }

    }

    private interface IDashinIraiDataBuilder {
        OboStApi_Offer.ReqBody getOboStApiOfferReqBody(DashIraiRequest dashIraiRequest);
        DashIrai__c getDashinIrai(AnkenNaiyo ankenNaiyo);
    }

    private class HoyoDashinIraiDataBuilder implements IDashinIraiDataBuilder {
        public OboStApi_Offer.ReqBody getOboStApiOfferReqBody(DashIraiRequest dashIraiRequest) {
            AnkenNaiyo ankenNaiyo = dashIraiRequest.ankenNaiyo;
            OboStSelProf oboStSelProf = new OboStSelProf();
            OboStApi_Offer.ReqBody reqBody = new OboStApi_Offer.ReqBody();
            reqBody.negotiation_id = ankenNaiyo.ShodanBango;
            reqBody.service_type = 'hoyo';
            reqBody.is_repeat = dashIraiRequest.is_repeat;
            DateTime serviceTime = new ServiceTimeCal()
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime1)
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime2)
                                        .addServiceTime(ankenNaiyo.HoyoKohoDateTime3)
                                        .getServiceTime();
            reqBody.is_urgent = ankenNaiyo.is_urgent;
            reqBody.send_limit = reqBody.is_urgent ? oboStSelProf.getDoziDashinSize() : 1;
            reqBody.hours_allowed = oboStSelProf.getHoursAllowedForReply(ankenNaiyo.is_urgent);

            reqBody.setExpiryDatetime(oboStSelProf.getTimeLimit(serviceTime));
            for(DashinSaki dashinSaki : dashIraiRequest.dashinSakiList){
                reqBody.offer_contracts.add(new OboStApi_Offer.Offer_contract().setContractId(dashinSaki.KeiyakuBango));
            }
            reqBody.kibo_shuha = ankenNaiyo.shuha;
            reqBody.is_bodaiji = ankenNaiyo.BodaijiUmu == '有';
            reqBody.plan = ankenNaiyo.MemorialServicePlan + (String.isNotBlank(ankenNaiyo.Kaimyo) ? ' + 戒名・法名の授与' : '');
            reqBody.service_fee = (Integer)ankenNaiyo.HoyoKingaku;
            reqBody.commission = (Integer)ankenNaiyo.TesuryoKingaku;
            if(ankenNaiyo.isTeigaku){
                reqBody.subscription = new OboStApi_Offer.Subscription().setProviderRevenue((Integer)ankenNaiyo.TeiHehTesuryoSogisha).setContractRevenue((Integer)ankenNaiyo.TeiHehTesuryoSoryo);
            }
            reqBody.caption = ankenNaiyo.IraishoKisaiJiko;
            reqBody.hoyo_detail = new OboStApi_Offer.Hoyo_detail()
                                        .setKaimyo(ankenNaiyo.Kaimyo)
                                        .setServiceContent(ankenNaiyo.MemorialContent)
                                        .setPlace(  new OboStApi_Offer.Place()
                                                        .setName(ankenNaiyo.HoyoBashoMei)
                                                        .setPostalCode(ankenNaiyo.hoyo_postcode)
                                                        .setState(ankenNaiyo.hoyo_todofuken)
                                                        .setCity(ankenNaiyo.hoyo_shikugun)
                                                        .setStreet(ankenNaiyo.hoyo_tyoumei)
                                                    )
                                        .addCandidateDatetime(ankenNaiyo.HoyoKohoDateTime1)
                                        .addCandidateDatetime(ankenNaiyo.HoyoKohoDateTime2)
                                        .addCandidateDatetime(ankenNaiyo.HoyoKohoDateTime3);

            if( String.isNotBlank(ankenNaiyo.TsuikahoyobashoMei) &&
                String.isNotBlank(ankenNaiyo.tuika_postcode) &&
                String.isNotBlank(ankenNaiyo.tuika_todofuken) &&
                String.isNotBlank(ankenNaiyo.tuika_shikugun) &&
                String.isNotBlank(ankenNaiyo.tuika_tyoumei)
                ){
                reqBody.hoyo_detail.setAdditionalPlace(
                        new OboStApi_Offer.Place()
                            .setName(ankenNaiyo.TsuikahoyobashoMei)
                            .setPostalCode(ankenNaiyo.tuika_postcode)
                            .setState(ankenNaiyo.tuika_todofuken)
                            .setCity(ankenNaiyo.tuika_shikugun)
                            .setStreet(ankenNaiyo.tuika_tyoumei)
                    );
            }

            return reqBody;
        }

        public DashIrai__c getDashinIrai(AnkenNaiyo ankenNaiyo) {
            return new DashIrai__c(
                    DashinIraiNichiji__c = DateTime.now(),
                    Status__c = 'Opened',
                    content_type__c = 'hoyo',
                    shuha__c = ankenNaiyo.shuha,
                    bodaiji__c = ankenNaiyo.BodaijiUmu,
                    plan__c = ankenNaiyo.MemorialServicePlan,
                    kaimyo_juyo__c = ankenNaiyo.Kaimyojuyo,
                    Kaimyo__c = ankenNaiyo.Kaimyo,
                    service_content__c = ankenNaiyo.MemorialContent,
                    koho_datetime1__c = ankenNaiyo.HoyoKohoDateTime1,
                    koho_datetime2__c = ankenNaiyo.HoyoKohoDateTime2,
                    koho_datetime3__c = ankenNaiyo.HoyoKohoDateTime3,
                    hoyo_place_name__c = ankenNaiyo.HoyoBashoMei,
                    hoyo_place_postal_code__c = ankenNaiyo.hoyo_postcode,
                    hoyo_place_state__c = ankenNaiyo.hoyo_todofuken,
                    hoyo_place_city__c = ankenNaiyo.hoyo_shikugun,
                    hoyo_place_chomei__c = ankenNaiyo.hoyo_tyoumei,
                    hoyo_place__c = ankenNaiyo.hoyo_banchi,
                    hoyo_place2_name__c = ankenNaiyo.TsuikahoyobashoMei,
                    hoyo_place2_postal_code__c = ankenNaiyo.tuika_postcode,
                    hoyo_place2_state__c = ankenNaiyo.tuika_todofuken,
                    hoyo_place2_city__c = ankenNaiyo.tuika_shikugun,
                    hoyo_place2_chomei__c = ankenNaiyo.tuika_tyoumei,
                    hoyo_place2_banchi__c = ankenNaiyo.tuika_banchi,
                    caption__c = ankenNaiyo.IraishoKisaiJiko,
                    service_kingaku__c = ankenNaiyo.HoyoKingaku,
                    tesuryo_kingaku__c = ankenNaiyo.TesuryoKingaku,
                    is_urgent__c = ankenNaiyo.is_urgent,
                    TeiHehTesuryoSoryo__c = ankenNaiyo.TeiHehTesuryoSoryo,
                    TeiHehTesuryoSogisha__c = ankenNaiyo.TeiHehTesuryoSogisha,
                    isTeigaku__c = ankenNaiyo.isTeigaku
                );
        }
    }

    private class KaimyoDashinIraiDataBuilder implements IDashinIraiDataBuilder {

        public OboStApi_Offer.ReqBody getOboStApiOfferReqBody(DashIraiRequest dashIraiRequest){

            AnkenNaiyo ankenNaiyo = dashIraiRequest.ankenNaiyo;
            OboStSelProf oboStSelProf = new OboStSelProf();
            OboStApi_Offer.ReqBody reqBody = new OboStApi_Offer.ReqBody();
            reqBody.negotiation_id = ankenNaiyo.ShodanBango;
            reqBody.service_type = 'kaimyo';
            reqBody.is_repeat = dashIraiRequest.is_repeat;
            reqBody.is_urgent = ankenNaiyo.is_urgent;
            reqBody.send_limit = reqBody.is_urgent ? oboStSelProf.getDoziDashinSize() : 1;
            reqBody.hours_allowed = oboStSelProf.getHoursAllowedForReply(ankenNaiyo.is_urgent);
            reqBody.setExpiryDatetime(DateTime.now().addDays(7));

            for(DashinSaki dashinSaki : dashIraiRequest.dashinSakiList){
                reqBody.offer_contracts.add(new OboStApi_Offer.Offer_contract().setContractId(dashinSaki.KeiyakuBango));
            }
            reqBody.kibo_shuha = ankenNaiyo.shuha;
            reqBody.is_bodaiji = ankenNaiyo.BodaijiUmu == '有';
            reqBody.plan = '戒名・法名の授与(' + ankenNaiyo.Kaimyo + ')';
            reqBody.service_fee = (Integer)ankenNaiyo.HoyoKingaku;
            reqBody.commission = (Integer)ankenNaiyo.TesuryoKingaku;
            if(ankenNaiyo.isTeigaku){
                reqBody.subscription = new OboStApi_Offer.Subscription().setProviderRevenue((Integer)ankenNaiyo.TeiHehTesuryoSogisha).setContractRevenue((Integer)ankenNaiyo.TeiHehTesuryoSoryo);
            }
            reqBody.caption = ankenNaiyo.IraishoKisaiJiko;
            reqBody.kaimyo_detail = new OboStApi_Offer.Kaimyo_detail().setKaimyo(ankenNaiyo.Kaimyo);
            return reqBody;
        }

        public DashIrai__c getDashinIrai(AnkenNaiyo ankenNaiyo) {
            return new DashIrai__c(
                    DashinIraiNichiji__c = DateTime.now(),
                    Status__c = 'Opened',
                    content_type__c = 'kaimyo',
                    shuha__c = ankenNaiyo.shuha,
                    bodaiji__c = ankenNaiyo.BodaijiUmu,
                    plan__c = ankenNaiyo.MemorialServicePlan,
                    kaimyo_juyo__c = ankenNaiyo.Kaimyojuyo,
                    caption__c = ankenNaiyo.IraishoKisaiJiko,
                    service_kingaku__c = ankenNaiyo.HoyoKingaku,
                    tesuryo_kingaku__c = ankenNaiyo.TesuryoKingaku,
                    is_urgent__c = ankenNaiyo.is_urgent,
                    TeiHehTesuryoSoryo__c = ankenNaiyo.TeiHehTesuryoSoryo,
                    TeiHehTesuryoSogisha__c = ankenNaiyo.TeiHehTesuryoSogisha,
                    isTeigaku__c = ankenNaiyo.isTeigaku
                );
        }
    }

    private class SogiDashinIraiDataBuilder implements IDashinIraiDataBuilder {

        public OboStApi_Offer.ReqBody getOboStApiOfferReqBody(DashIraiRequest dashIraiRequest){

            AnkenNaiyo ankenNaiyo = dashIraiRequest.ankenNaiyo;
            OboStSelProf oboStSelProf = new OboStSelProf();
            OboStApi_Offer.ReqBody reqBody = new OboStApi_Offer.ReqBody();
            reqBody.negotiation_id = ankenNaiyo.ShodanBango;
            reqBody.service_type = 'sogi';
            reqBody.is_repeat = dashIraiRequest.is_repeat;
            DateTime serviceTime = new ServiceTimeCal()
                                        .addServiceTime(ankenNaiyo.MakurakyoDateTime)
                                        .addServiceTime(ankenNaiyo.TsuyaDateTime)
                                        .addServiceTime(ankenNaiyo.KokubetsuDateTime)
                                        .addServiceTime(ankenNaiyo.KasoDateTime)
                                        .getServiceTime();
            reqBody.is_urgent = ankenNaiyo.is_urgent;
            reqBody.send_limit = reqBody.is_urgent ? oboStSelProf.getDoziDashinSize() : 1;
            reqBody.hours_allowed = oboStSelProf.getHoursAllowedForReply(ankenNaiyo.is_urgent);
            reqBody.setExpiryDatetime(oboStSelProf.getTimeLimit(serviceTime));

            for(DashinSaki dashinSaki : dashIraiRequest.dashinSakiList){
                reqBody.offer_contracts.add(new OboStApi_Offer.Offer_contract().setContractId(dashinSaki.KeiyakuBango));
            }
            reqBody.kibo_shuha = ankenNaiyo.shuha;
            reqBody.is_bodaiji = ankenNaiyo.BodaijiUmu == '有';
            reqBody.plan = ankenNaiyo.MemorialServicePlan + (String.isNotBlank(ankenNaiyo.Kaimyo) ? ' + 戒名・法名の授与' : '');
            reqBody.service_fee = (Integer)ankenNaiyo.HoyoKingaku;
            reqBody.commission = (Integer)ankenNaiyo.TesuryoKingaku;
            if(ankenNaiyo.isTeigaku){
                reqBody.subscription = new OboStApi_Offer.Subscription().setProviderRevenue((Integer)ankenNaiyo.TeiHehTesuryoSogisha).setContractRevenue((Integer)ankenNaiyo.TeiHehTesuryoSoryo);
            }
            reqBody.caption = ankenNaiyo.IraishoKisaiJiko;
            reqBody.sogi_detail = new OboStApi_Offer.Sogi_detail()
                                        .setKaimyo(ankenNaiyo.Kaimyo)
                                        .setServiceContent(ankenNaiyo.MemorialContent)
                                        .setPlace(  new OboStApi_Offer.Place()
                                                        .setName(ankenNaiyo.Saijo)
                                                        .setPostalCode(ankenNaiyo.sogi_postcode)
                                                        .setState(ankenNaiyo.sogi_todofuken)
                                                        .setCity(ankenNaiyo.sogi_shikugun)
                                                        .setStreet(ankenNaiyo.sogi_tyoumei)
                                                    )
                                        .setMakurakyoDatetime(ankenNaiyo.MakurakyoDateTime)
                                        .setTsuyaDatetime(ankenNaiyo.TsuyaDateTime)
                                        .setKokubetsuDatetime(ankenNaiyo.KokubetsuDateTime)
                                        .setKasoDatetime(ankenNaiyo.KasoDateTime)
                                        .setShonanoka(getShonanokaCode(ankenNaiyo.Shonanoka))
                                        .setKasobaName(ankenNaiyo.Kasoba);
            return reqBody;
        }

        private String getShonanokaCode(String shonanoka) {
            if(String.isBlank(shonanoka)) return 'nashi';
            Map<String, String> shonanokaMap = new Map<String, String>{
                '式中' => 'shikichu',
                '収骨後' => 'shukotsugo',
                '無' => 'nashi'
            };
            return shonanokaMap.get(shonanoka);
        }

        public DashIrai__c getDashinIrai(AnkenNaiyo ankenNaiyo) {
            return new DashIrai__c(
                    DashinIraiNichiji__c = DateTime.now(),
                    Status__c = 'Opened',
                    content_type__c = 'sogi',
                    shuha__c = ankenNaiyo.shuha,
                    bodaiji__c = ankenNaiyo.BodaijiUmu,
                    plan__c = ankenNaiyo.MemorialServicePlan,
                    kaimyo_juyo__c = ankenNaiyo.Kaimyojuyo,
                    Kaimyo__c = ankenNaiyo.Kaimyo,
                    service_content__c = ankenNaiyo.MemorialContent,
                    makurakyo_datetime__c = ankenNaiyo.MakurakyoDateTime,
                    tsuya_datetime__c = ankenNaiyo.TsuyaDateTime,
                    kokubetsu_datetime__c = ankenNaiyo.KokubetsuDateTime,
                    kaso_datetime__c = ankenNaiyo.KasoDateTime,
                    shonanoka__c = ankenNaiyo.Shonanoka,
                    shikijo_name__c = ankenNaiyo.Saijo,
                    shikijo_postal_code__c = ankenNaiyo.sogi_postcode,
                    shikijo_state__c = ankenNaiyo.sogi_todofuken,
                    shikijo_city__c = ankenNaiyo.sogi_shikugun,
                    shikijo_chomei__c = ankenNaiyo.sogi_tyoumei,
                    shikijo_banchi__c = ankenNaiyo.sogi_banchi,
                    kasoba_name__c = ankenNaiyo.Kasoba,
                    caption__c = ankenNaiyo.IraishoKisaiJiko,
                    service_kingaku__c = ankenNaiyo.HoyoKingaku,
                    tesuryo_kingaku__c = ankenNaiyo.TesuryoKingaku,
                    is_urgent__c = ankenNaiyo.is_urgent,
                    TeiHehTesuryoSoryo__c = ankenNaiyo.TeiHehTesuryoSoryo,
                    TeiHehTesuryoSogisha__c = ankenNaiyo.TeiHehTesuryoSogisha,
                    isTeigaku__c = ankenNaiyo.isTeigaku
                );
        }


    }

    private class ServiceTimeCal {
        private List<DateTime> serviceTimeList = new List<DateTime>();
        public ServiceTimeCal addServiceTime(DateTime dt){
            if(dt == null) return this;
            this.serviceTimeList.add(dt);
            return this;
        }
        public DateTime getServiceTime(){
            if(serviceTimeList.size() == 0) return null;
            serviceTimeList.sort();
            return serviceTimeList[0];
        }
    }

    private class HoyoKohoDateTimeCal {
        private Map<String, DateTime> hoyoKohoDateTimeMap = new Map<String, DateTime>();
        public HoyoKohoDateTimeCal addHoyoKohoDate(DateTime dt){
            if(dt == null) return this;
            String key = dt.format('yyyyMMdd-HHmm');
            if(!hoyoKohoDateTimeMap.containsKey(key)){
                this.hoyoKohoDateTimeMap.put(key, dt);
            }
            return this;
        }
        public List<DateTime> getHoyoKohoDateTimes(){
            List<DateTime> hoyoKohoDateTimeList = hoyoKohoDateTimeMap.values();
            Integer size = hoyoKohoDateTimeList.size();
            for(Integer i=0; i < 3 - size; i++) {
                hoyoKohoDateTimeList.add(null);
            }
            return hoyoKohoDateTimeList;
        }
    }

//打診依頼End

}