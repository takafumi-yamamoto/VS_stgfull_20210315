@RestResource(urlMapping='/api/v1/obousanbin_moushikomi/*')
global with sharing class Api_V1_ObousanbinMoushikomi {

    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
        RestContext.response = res;
        }
        
        System.Savepoint sp = Database.setSavepoint();
        try {
            Insert new ObouYoyakuCaseToShodanTask__c(data__c = RestContext.request.requestBody.toString());
        } catch(Exception ex) {
            String err = '[エラーメッセージ]\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString();
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;

            String title = 'お坊さん便申込Exception';
            Loggings.writeLog(
               Loggings.createLogEntry(Loggings.Level.Error, '20181016-1800-00', 'Api_V1_ObousanbinMoushikomi', title)
                   .putAttr('RequestBody', RestContext.request.requestBody.toString())
                   .putAttr('Description', 'お坊さん便申込')
                   .putAttr('Exception', ex.getMessage())
           );
        }
    }

    public class Data{
        // ga_client_id
        public String gaclient_id { get; set; }
        //メール処理Id
        public String mail_syori_id { get;  set; }
        //問合せ日
        public String toiawase_date { get;  set; }
        //入口
        public String iriguchi_name { get;  set; }       
         
        //申込者姓
        public String customer_sei  { get;  set; }
        //申込者名
        public String customer_mei  { get;  set; }
        //申込者姓(カナ)
        public String customer_sei_kana { get;  set; }
        //申込者名(カナ)
        public String customer_mei_kana { get;  set; }
        //申込者電話番号
        public String customer_tel  { get;  set; }
        //申込者メールアドレス
        public String customer_mail { get;  set; }
        //申込者住所.郵便番号
        public String customer_postal_code  { get;  set; }
        //申込者住所.都道府県
        public String customer_state    { get;  set; }
        //申込者住所.市区郡
        public String customer_city { get;  set; }
        //申込者住所.町名番地
        public String customer_street   { get;  set; }
        //資料送付先住所.郵便番号
        public String siryo_sofu_postal_code    { get;  set; }
        //資料送付先住所.都道府県
        public String siryo_sofu_state  { get;  set; }
        //資料送付先住所.市区郡
        public String siryo_sofu_city   { get;  set; }
        //資料送付先住所.町名番地
        public String siryo_sofu_street { get;  set; }
        //対象者姓
        public String taisyosya_sei { get;  set; }
        //対象者名
        public String taisyosya_mei { get;  set; }
        //対象者姓(カナ)
        public String taisyosya_sei_kana    { get;  set; }
        //対象者名(カナ)
        public String taisyosya_mei_kana    { get;  set; }
        //対象者生年月日
        public String taisyosya_birthday    { get;  set; }
        //対象者逝去日
        public String taisyosya_seikyodate  { get;  set; }
        //対象者続柄
        public String taisyosya_zokugara  { get;  set; }
        //対象者宗派
        public String taisyosya_syuha   { get;  set; }
        //対象者その他宗派
        public String taisyosya_sonotasyuha   { get;  set; }
        //菩提寺有無
        public String taisyosya_bodaiji_umu { get;  set; }
        //法要場所.名称
        public String hoyo_basyo_name   { get;  set; }
        //法要場所.郵便番号
        public String hoyo_basyo_postal_code    { get;  set; }
        //法要場所.都道府県
        public String hoyo_basyo_state  { get;  set; }
        //法要場所.市区郡
        public String hoyo_basyo_city   { get;  set; }
        //法要場所・町名
        public String hoyo_basyo_tyoumei { get;  set; }
        //法要場所.番地
        public String hoyo_basyo_street { get;  set; }
        //法要場所2.名称
        public String hoyo_basyo2_name  { get;  set; }
        //法要場所2.郵便番号
        public String hoyo_basyo2_postal_code   { get;  set; }
        //法要場所2.都道府県
        public String hoyo_basyo2_state { get;  set; }
        //法要場所2.市区郡
        public String hoyo_basyo2_city  { get;  set; }
        //法要場所2.町名番地
        public String hoyo_basyo2_street    { get;  set; }
        //第一希望.日付
        public String hoyo_date1    { get;  set; }
        //第一希望.時間
        public String hoyo_hour1    { get;  set; }
        //第一希望.分
        public String hoyo_minute1    { get;  set; }
        //第二希望.日付
        public String hoyo_date2    { get;  set; }
        //第二希望.時間
        public String hoyo_hour2    { get;  set; }
        //第二希望.分
        public String hoyo_minute2    { get;  set; }
        //第三希望.日付
        public String hoyo_date3    { get;  set; }
        //第三希望.時間
        public String hoyo_hour3    { get;  set; }
        //第三希望.分
        public String hoyo_minute3    { get;  set; }
        //お坊さん便.法事法要
        public String hoyo  { get;  set; }
        //お坊さん便.その他法要
        public String sonota_hoyo  { get;  set; }
        //お坊さん便.追加法要
        public String tsuika_hoyo   { get;  set; }
        //お坊さん便.戒名授与希望
        public String kaimyo_kibo   { get;  set; }
        //お坊さん便.希望戒名
        public String kaimyo_plan   { get;  set; }
        //お客様コメント
        public String customer_comment  { get;  set; }   
        //確認連絡の希望有無     
        public String kakunin_renraku_kibo  { get;  set; }
        //利用回数     
        public String riyokaisu  { get;  set; }
        //お盆セット
        public String obonset  { get;  set; }
        //商品送付先
        public String productPlaceSelect  { get;  set; }
        //追加日程
        public List<Tsuika_nitteis> tsuika_nitteis  { get;  set; }
        //メンバー登録希望
        public String member_touroku_kibo   { get;  set; }
        //支払方法
        public String kibo_shiharai_hoho   { get;  set; }
        //斎場名
        public String saijo   { get;  set; }
        //斎場.郵便番号
        public String saijo_postal_code    { get;  set; }
        //斎場.都道府県
        public String saijo_state  { get;  set; }
        //斎場.市区郡
        public String saijo_city   { get;  set; }
        //斎場.町名
        public String saijo_tyoumei { get;  set; }
        //斎場.番地
        public String saijo_street { get;  set; }
        //火葬日
        public String kaso_date { get;  set; }
        //火葬・時間
        public String kaso_hour { get;  set; }
        //火葬・分
        public String kaso_minute { get;  set; }
        //告別式日
        public String kokubetsu_date { get;  set; }
        //告別式・時間
        public String kokubetsu_hour { get;  set; }
        //告別式・分
        public String kokubetsu_minute { get;  set; }
        //通夜日
        public String tsuya_date { get;  set; }
        //通夜・時間
        public String tsuya_hour { get;  set; }
        //通夜・分
        public String tsuya_minute { get;  set; }
        //初七日
        public String syonanoka_umu { get;  set; }
        //火葬場
        public String kaso_place { get;  set; }

        //メールマガジン
        public String mailmagazine { get; set; }  
        
        public String getFukusuHoyo(){
            List<String> result = new List<String>();
            if(tsuika_nitteis!=null){
                for(Tsuika_nitteis nitei : tsuika_nitteis){
                    result.add(nitei.plan_name);
                }
            }
            return String.join(result, ',');
        }
    }

    public class Tsuika_nitteis {
        public String plan_name;    //プラン名
        public String yotei_date;   //予定日
        public String jizen_tsuchi_kibo; // 事前通知希望
        public String jizen_tsuchi_yotei_date; // 事前通知予定日
    }
}