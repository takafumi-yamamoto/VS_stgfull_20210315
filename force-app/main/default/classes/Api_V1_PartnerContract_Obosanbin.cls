@RestResource(urlMapping='/api/v1/partnercontract_obosanbin/*')
global with sharing class Api_V1_PartnerContract_Obosanbin {
    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/partnercontract_obosanbin/* doPost() start');
        System.debug('RestContext.request.requestBody.toString():' + RestContext.request.requestBody.toString());

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
		System.Savepoint sp = Database.setSavepoint();	
        Api_V1_PartnerContract_Obosanbin.DataObosanbin theDataObosanbin = null;
        try {
            theDataObosanbin = (Api_V1_PartnerContract_Obosanbin.DataObosanbin)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_PartnerContract_Obosanbin.DataObosanbin.class);
            System.debug(theDataObosanbin);

            list<DataJohosha> theDataJohoshaLst=theDataObosanbin.johosha;
            PartnerMoshikomi_Obosanbin__c newObosanbinObj = new PartnerMoshikomi_Obosanbin__c();
            //姓（カナ）           
            newObosanbinObj.LastNameFurigana__c= theDataObosanbin.moshikomisha_moshikomishasei_kana;
            //名（カナ）           
            newObosanbinObj.FirstNameFurigana__c= theDataObosanbin.moshikomisha_moshikomishamei_kana;
            //姓          
            newObosanbinObj.LastName__c= theDataObosanbin.moshikomisha_moshikomishasei;
            //名   
            newObosanbinObj.FirstName__c= theDataObosanbin.moshikomisha_moshikomishamei;
            //性別          
            newObosanbinObj.Gender__c= theDataObosanbin.moshikomisha_seibetsu;
            //宗派  
            newObosanbinObj.JiinSyuha__c= theDataObosanbin.moshikomisha_sosekishuha;
            //宗派その他(カナ)   
            newObosanbinObj.JiinShuhaSonotaKana__c= theDataObosanbin.moshikomisha_sosekishuha_kana;
            //宗派その他          
            newObosanbinObj.JiinShuhaSonota__c= theDataObosanbin.moshikomisha_sosekishuha_sonota;
            //住所(請求先)(郵便番号)         
            newObosanbinObj.MoshikomishaKyojuchiPostalcode__c= theDataObosanbin.moshikomisha_kyojuchi_postalcode;
            //住所(請求先)(都道府県)           
            newObosanbinObj.MoshikomishaKyojuchiState__c= theDataObosanbin.moshikomisha_kyojuchi_state;
            //住所(請求先)(市区郡)           
            newObosanbinObj.MoshikomishaKyojuchiCity__c= theDataObosanbin.moshikomisha_kyojuchi_city;
            //住所(請求先)(町名・番地)        
            newObosanbinObj.MoshikomishaKyojuchiStreet__c= theDataObosanbin.moshikomisha_kyojuchi_street;
            //電話1          
            newObosanbinObj.Phone__c= theDataObosanbin.moshikomisha_tel;
            //Fax       
            newObosanbinObj.Fax__c= theDataObosanbin.moshikomisha_fax;
            //携帯1          
            newObosanbinObj.MobilePhone__c= theDataObosanbin.moshikomisha_mobile;
            //法務対応可能エリア           
            newObosanbinObj.HomutaiokanoArea__c= theDataObosanbin.moshikomisha_taiokanoarea;
            //生年月日
            newObosanbinObj.PersonBirthdate__c= theDataObosanbin.moshikomisha_seinengappi;
            //本人確認書類種別        
            newObosanbinObj.HoninKakuninSyoruiSyubetsu__c= theDataObosanbin.moshikomisha_honninkakuninshorui;
            //メールアドレス1
            newObosanbinObj.MailAddress__c= theDataObosanbin.moshikomisha_email;
            //所属寺院宗派系統
            newObosanbinObj.ShozokuJiinShuhaKeito__c= theDataObosanbin.katudojiin_jiinshuhakeito;
            //宗派
            newObosanbinObj.JiinJiinshuha__c= theDataObosanbin.katudojiin_jiinshuha;
            //宗派その他(カナ)
            newObosanbinObj.JiinJiinshuhaSonotaKana__c= theDataObosanbin.katudojiin_jiinshuha_sonota_kana;
            //宗派その他
            newObosanbinObj.JiinJiinshuhaSonota__c= theDataObosanbin.katudojiin_jiinshuha_sonota;
            //山号寺院名（カナ）
            newObosanbinObj.SangoJiinMeiFurigana__c= theDataObosanbin.katudojiin_jiinmei_kana;
            //お客様・提携先名
            newObosanbinObj.KatudojiinJiinName__c= theDataObosanbin.katudojiin_jiinmei;
            //住所(請求先)(郵便番号)
            newObosanbinObj.KatudojiinJiinjushoPostalcode__c= theDataObosanbin.katudojiin_jiinjusho_postalcode;
            //住所(請求先)(都道府県)
            newObosanbinObj.KatudojiinJiinjushoState__c= theDataObosanbin.katudojiin_jiinjusho_state;
            //住所(請求先)(市区郡)           
            newObosanbinObj.KatudojiinJiinjushoCity__c= theDataObosanbin.katudojiin_jiinjusho_city;
            //住所(請求先)(町名・番地)
            newObosanbinObj.KatudojiinJiinjushoStreet__c= theDataObosanbin.katudojiin_jiinjusho_street;
            //電話1
            newObosanbinObj.JiinTel__c= theDataObosanbin.katudojiin_jiintel;
            //Fax
            newObosanbinObj.JiinFax__c= theDataObosanbin.katudojiin_jiinfax;
            //姓（カナ）
            newObosanbinObj.JiinsekininshaseiKana__c= theDataObosanbin.katudojiin_jiinsekininshasei_kana;
            //名（カナ）
            newObosanbinObj.JiinsekininshameiKana__c= theDataObosanbin.katudojiin_jiinsekininshamei_kana;            
            //姓
            newObosanbinObj.Jiinsekininshasei__c= theDataObosanbin.katudojiin_jiinsekininshasei; 
            //名
            newObosanbinObj.Jiinsekininshamei__c= theDataObosanbin.katudojiin_jiinsekininshamei;            
            //Web サイト
            newObosanbinObj.JiinHpurl__c= theDataObosanbin.katudojiin_hpurl; 
            //宗教法人単位種別
            newObosanbinObj.JiinTanisyubetsu__c= theDataObosanbin.katudojiin_tanisyubetsu;            
            //宗教法人格有
            newObosanbinObj.JiinHojintoki__c= theDataObosanbin.katudojiin_hojintoki; 
            //住所(請求先)(郵便番号)
            newObosanbinObj.JiinjohoBetsuinjushoPostalcode__c= theDataObosanbin.katudojiinjoho_betsuinjusho_postalcode;            
            //住所(請求先)(都道府県)
            newObosanbinObj.JiinjohoBetsuinjushoState__c= theDataObosanbin.katudojiinjoho_betsuinjusho_state; 
            //住所(請求先)(市区郡)
            newObosanbinObj.JiinjohoBetsuinjushoCity__c= theDataObosanbin.katudojiinjoho_betsuinjusho_city;            
            //住所(請求先)(町名・番地)
            newObosanbinObj.JiinjohoBetsuinjushoStreet__c= theDataObosanbin.katudojiinjoho_betsuinjusho_street; 
            //別院での活動を希望
            newObosanbinObj.JiinjohoBetsuindenokatsudo__c= theDataObosanbin.katudojiinjoho_betsuindenokatsudo;            
            //電話1
            newObosanbinObj.JiinjohoBetsuintel__c= theDataObosanbin.katudojiinjoho_betsuintel; 
            //Fax
            newObosanbinObj.JiinjohoBetsuinfax__c= theDataObosanbin.katudojiinjoho_betsuinfax;            
            //山号寺院名（カナ）
            newObosanbinObj.JiinjohoZaisekijiinmeiKana__c= theDataObosanbin.katudojiinjoho_zaisekijiinmei_kana; 
            //お客様・提携先名
            newObosanbinObj.JiinjohoZaisekijiinmei__c= theDataObosanbin.katudojiinjoho_zaisekijiinmei;            
            //住所(請求先)(郵便番号)
            newObosanbinObj.JiinjohoZaisekijiinjushoPostalcode__c= theDataObosanbin.katudojiinjoho_zaisekijiinjusho_postalcode; 
            //住所(請求先)(都道府県)
            newObosanbinObj.JiinjohoZaisekijiinjushoState__c= theDataObosanbin.katudojiinjoho_zaisekijiinjusho_state; 
            //住所(請求先)(市区郡)
            newObosanbinObj.JiinjohoZaisekijiinjushoCity__c= theDataObosanbin.katudojiinjoho_zaisekijiinjusho_city; 
            //住所(請求先)(町名・番地)
            newObosanbinObj.JiinjohoZaisekijiinjushoStreet__c= theDataObosanbin.katudojiinjoho_zaisekijiinjusho_street; 
            //電話1
            newObosanbinObj.JiinjohoZaisekijiintel__c= theDataObosanbin.katudojiinjoho_zaisekijiintel; 
            //Fax
            newObosanbinObj.JiinjohoZaisekijiinfax__c= theDataObosanbin.katudojiinjoho_zaisekijiinfax; 
            //銀行名
            newObosanbinObj.BankName__c= theDataObosanbin.kozajoho_kinkomei; 
            //銀行支店名
            newObosanbinObj.BankBranchName__c= theDataObosanbin.kozajoho_shitenmei;
            //口座種別
            newObosanbinObj.BankAccountType__c= theDataObosanbin.kozajoho_shubetsu; 
            //口座番号
            newObosanbinObj.BankAccountNo__c= theDataObosanbin.kozajoho_kozabango; 
            //口座名義
            newObosanbinObj.BankAccountMeigi__c= theDataObosanbin.kozajoho_kozameigi; 
            //戒名授与のみ依頼
            newObosanbinObj.Kaimyojuyonomiirai__c= theDataObosanbin.jizenanketo_kaimyojuyonomiirai; 
            //戒名授与のみ依頼要相談
            newObosanbinObj.KaimyojuyoIraiYosodan__c= theDataObosanbin.jizenanketo_kaimyojuyonomiirai_yosodan; 
            //移動手段
            newObosanbinObj.IdoSyudan__c= theDataObosanbin.jizenanketo_idoshudan; 
            //移動手段その他
            newObosanbinObj.JizenanketoIdoshudanSonota__c= theDataObosanbin.jizenanketo_idoshudan_sonota; 
            //依頼書送付方法
            newObosanbinObj.Iraisyosofuhouhou__c= theDataObosanbin.jizenanketo_iraishosofuhoho;
            //塔婆対応可否区分
            newObosanbinObj.ToubaTaioKahiKubun__c= theDataObosanbin.jizenanketo_tobataio; 
            //	塔婆対応要相談
            newObosanbinObj.TobaTaioYosodan__c= theDataObosanbin.jizenanketo_tobataio_yosodan;
            //塔婆対応金額(From)
            newObosanbinObj.TobaTaioKingakuFrom__c= theDataObosanbin.jizenanketo_tobataio_kingaku_from; 
            //塔婆対応金額(To)
            newObosanbinObj.TobaTaioKingakuTo__c= theDataObosanbin.jizenanketo_tobataio_kingaku_to; 
            //過去帳記入対応可否区分
            newObosanbinObj.KakoTyoKinyuTaiouKahiKubun__c= theDataObosanbin.jizenanketo_kakochohenokinyu;
            //過去帳記入要相談
            newObosanbinObj.KakochoKinyuYosodan__c= theDataObosanbin.jizenanketo_kakochohenokinyu_yosodan; 
            //過去帳記入金額(From)
            newObosanbinObj.KakochoKinyuKingakuFrom__c= theDataObosanbin.jizenanketo_kakochohenokinyu_kingaku_from;
            //過去帳記入金額(To)
            newObosanbinObj.KakochoKinyuKingakuTo__c= theDataObosanbin.jizenanketo_kakochohenokinyu_kingaku_to;
            //取材対応区分
            newObosanbinObj.SyuzaiTaiouKahiKubun__c= theDataObosanbin.jizenanketo_shuzaitaio; 
            //取材要相談
            newObosanbinObj.ShuzaiYosodan__c= theDataObosanbin.jizenanketo_shuzaitaio_yosodan;
            //寺院での撮影
            newObosanbinObj.Jiindenosatsuei__c= theDataObosanbin.jizenanketo_jiindenosatsuei; 
            //寺院での撮影要相談
            newObosanbinObj.JiindenosatsueiYosodan__c= theDataObosanbin.jizenanketo_jiindenosatsuei_yosodan;
            //寺院での法要可
            newObosanbinObj.JiinDenoHoyoKa__c= theDataObosanbin.jizenanketo_jiindenohoyo; 
            //寺院での法要要相談
            newObosanbinObj.JiindenohoyoYosodan__c= theDataObosanbin.jizenanketo_jiindenohoyo_yosodan;
            //寺院使用料
            newObosanbinObj.JiinSiyoRyo__c= theDataObosanbin.jizenanketo_shiyoryo; 
            //収容人数
            newObosanbinObj.SyuyoNinzu__c= theDataObosanbin.jizenanketo_shuyoninzu;            
            //駐車場有無
            newObosanbinObj.CyusyaJoUmu__c= theDataObosanbin.jizenanketo_chushajo;  
            //駐車可能台数
            newObosanbinObj.CyusyaKanouDaisu__c= theDataObosanbin.jizenanketo_chushakanodaisu;            
            //僧名
            newObosanbinObj.Somei__c= theDataObosanbin.jizenanketo_somei;      
            //僧名での登録を希望
            newObosanbinObj.JizenanketoSomeidenotorokuwokibo__c= theDataObosanbin.jizenanketo_someidenotorokuwokibo;            
            //他社サービス登録
            newObosanbinObj.JizenanketoTashaservicetoroku__c= theDataObosanbin.jizenanketo_tashaservicetoroku;  
            //他社サービス登録名
            newObosanbinObj.JizenanketoTashaservicetorokumei__c= theDataObosanbin.jizenanketo_tashaservicetorokumei;
            //僧籍宗派系統
            newObosanbinObj.moshikomisha_sosekishuhakeito__c= theDataObosanbin.moshikomisha_sosekishuhakeito; 
            insert newObosanbinObj;

            list<PartnerMoshikomi_Johosha__c> PartnerMoshikomi_JohoshaLst=new list<PartnerMoshikomi_Johosha__c>();
            for (DataJohosha theDataJohosha:theDataJohoshaLst){
                PartnerMoshikomi_Johosha__c newJohoshaObj=new PartnerMoshikomi_Johosha__c();
                newJohoshaObj.Obousanbin__c=newObosanbinObj.id;
                //姓（カナ）
                newJohoshaObj.LastNameFurigana__c= theDataJohosha.johosha_johoshasei_kana;
                //名(カナ)
                newJohoshaObj.FirstNameFurigana__c= theDataJohosha.johosha_johoshamei_kana;
                //姓
                newJohoshaObj.LastName__c= theDataJohosha.johosha_johoshasei;
                //名
                newJohoshaObj.FirstName__c= theDataJohosha.johosha_johoshamei;
                //性別
                newJohoshaObj.Gender__c= theDataJohosha.johosha_seibetsu;
                //住所(請求先)(郵便番号)
                newJohoshaObj.JohoshaKyojuchiPostalcode__c= theDataJohosha.johosha_kyojuchi_postalcode;
                //住所(請求先)(都道府県)
                newJohoshaObj.JohoshaKyojuchiState__c= theDataJohosha.johosha_kyojuchi_state;
                //住所(請求先)(市区郡)
                newJohoshaObj.JohoshaKyojuchiCity__c= theDataJohosha.johosha_kyojuchi_city;            
                //住所(請求先)(町名・番地)
                newJohoshaObj.JohoshaKyojuchiStreet__c= theDataJohosha.johosha_kyojuchi_street;
                //電話1
                newJohoshaObj.JohoshaTel__c= theDataJohosha.johosha_tel;
                //Fax
                newJohoshaObj.Fax__c= theDataJohosha.johosha_fax;
                //携帯1
                newJohoshaObj.MobilePhone__c= theDataJohosha.johosha_mobile;
                //法務対応可能エリア
                newJohoshaObj.HomutaiokanoArea__c= theDataJohosha.johosha_taiokanoarea;
                //生年月日
                newJohoshaObj.PersonBirthdate__c= theDataJohosha.johosha_seinengappi;
                //本人確認書類種別
                newJohoshaObj.HoninKakuninSyoruiSyubetsu__c= theDataJohosha.johosha_honninkakuninshorui;
                //メールアドレス1
                newJohoshaObj.MailAddress__c= theDataJohosha.johosha_email;
                //	宗派
                newJohoshaObj.Syuha__c= theDataJohosha.johoshajiin_sosekishuha;
                //宗派その他(カナ)
                newJohoshaObj.JiinShuhaSonotaKana__c= theDataJohosha.johoshajiin_sosekishuha_kana;
                //宗派その他
                newJohoshaObj.JiinShushaSonota__c= theDataJohosha.johoshajiin_sosekishuha_sonota;
                //山号寺院名（カナ）
                newJohoshaObj.SangoJiinMeiFurigana__c= theDataJohosha.johoshajiin_zaisekijiinmei_kana;
                //お客様・提携先名
                newJohoshaObj.TeikeisakiName__c= theDataJohosha.johoshajiin_zaisekijiinmei;
                //住所(請求先)(郵便番号)
                newJohoshaObj.JiinZaisekijiinjushoPostalcode__c= theDataJohosha.johoshajiin_zaisekijiinjusho_postalcode;
                //	住所(請求先)(都道府県)
                newJohoshaObj.JiinZaisekijiinjushoState__c= theDataJohosha.johoshajiin_zaisekijiinjusho_state;
                //住所(請求先)(市区郡)
                newJohoshaObj.JiinZaisekijiinjushoCity__c= theDataJohosha.johoshajiin_zaisekijiinjusho_city;
                //住所(請求先)(町名・番地)
                newJohoshaObj.JiinZaisekijiinjushoStreet__c= theDataJohosha.johoshajiin_zaisekijiinjusho_street;
                //電話1
                newJohoshaObj.JohoshajiinTel__c= theDataJohosha.johoshajiin_tel;
                //	Fax
                newJohoshaObj.JohoshajiinFax__c= theDataJohosha.johoshajiin_fax;
                //Web サイト
                newJohoshaObj.JohoshajiinHpurl__c= theDataJohosha.johoshajiin_hpurl;
                //宗教法人単位種別
                newJohoshaObj.JohoshajiinTanishubetsu__c= theDataJohosha.johoshajiin_tanishubetsu;
                //宗教法人格有
                newJohoshaObj.JohoshajiinHojintoki__c= theDataJohosha.johoshajiin_hojintoki;
                //僧籍宗派系統
                newJohoshaObj.johoshajiin_sosekishuhakeito__c= theDataJohosha.johoshajiin_sosekishuhakeito; 
                PartnerMoshikomi_JohoshaLst.add(newJohoshaObj);
            }
            insert PartnerMoshikomi_JohoshaLst;
        } catch(Exception e) {
            String err = '[エラーメッセージ]\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString();
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;

            String strText = '【パートナー申込】お坊さん便の作成が失敗しました。\r\n\r\n' + err + '\r\n\r\n' + '[問合せ内容]\r\n' + theDataObosanbin;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【パートナー申込】お坊さん便', strText);
        }

        System.debug('/api/v1/partnercontract_obosanbin/* doPost() end');
	}
	public class DataObosanbin{
        //姓（カナ）
        public String moshikomisha_moshikomishasei_kana { get; set; }
        //名（カナ）
        public String moshikomisha_moshikomishamei_kana { get; set; }                      
        //姓
        public String moshikomisha_moshikomishasei { get; set; }
        //名
        public String moshikomisha_moshikomishamei { get; set; }
        //性別
        public String moshikomisha_seibetsu { get; set; }
        //僧籍宗派系統
        public String moshikomisha_sosekishuhakeito { get; set; }
        //宗派
        public String moshikomisha_sosekishuha { get; set; }                      
        //宗派その他(カナ)
        public String moshikomisha_sosekishuha_kana { get; set; }
        //宗派その他
        public String moshikomisha_sosekishuha_sonota { get; set; }
        //住所(請求先)(郵便番号)
        public String moshikomisha_kyojuchi_postalcode { get; set; }
        //住所(請求先)(都道府県)
        public String moshikomisha_kyojuchi_state { get; set; }                      
        //住所(請求先)(市区郡)
        public String moshikomisha_kyojuchi_city { get; set; }
        //住所(請求先)(町名・番地)
        public String moshikomisha_kyojuchi_street { get; set; }
        //電話1
        public String moshikomisha_tel { get; set; }
        //Fax
        public String moshikomisha_fax { get; set; }                      
        //携帯1
        public String moshikomisha_mobile { get; set; }
        //法務対応可能エリア
        public String moshikomisha_taiokanoarea { get; set; } 
        //生年月日
        public String moshikomisha_seinengappi { get; set; }
        //本人確認書類種別
        public String moshikomisha_honninkakuninshorui { get; set; }                      
        //メールアドレス1
        public String moshikomisha_email { get; set; }
        //所属寺院宗派系統
        public String katudojiin_jiinshuhakeito { get; set; }
        //	宗派
        public String katudojiin_jiinshuha { get; set; }
        //宗派その他(カナ)
        public String katudojiin_jiinshuha_sonota_kana { get; set; }
        //宗派その他
        public String katudojiin_jiinshuha_sonota { get; set; }                      
        //山号寺院名（カナ）
        public String katudojiin_jiinmei_kana { get; set; }
        //お客様・提携先名
        public String katudojiin_jiinmei { get; set; }
        //住所(請求先)(郵便番号)
        public String katudojiin_jiinjusho_postalcode { get; set; }
        //住所(請求先)(都道府県)
        public String katudojiin_jiinjusho_state { get; set; }                      
        //住所(請求先)(市区郡)
        public String katudojiin_jiinjusho_city { get; set; }
        //	住所(請求先)(町名・番地)
        public String katudojiin_jiinjusho_street { get; set; }
        //電話1
        public String katudojiin_jiintel { get; set; }
        //Fax
        public String katudojiin_jiinfax { get; set; }                      
        //姓（カナ）
        public String katudojiin_jiinsekininshasei_kana { get; set; }
        //名（カナ）
        public String katudojiin_jiinsekininshamei_kana { get; set; } 
         //姓
        public String katudojiin_jiinsekininshasei { get; set; }           
        //名
        public String katudojiin_jiinsekininshamei { get; set; } 
         //Web サイト
        public String katudojiin_hpurl { get; set; }
        //宗教法人単位種別
        public String katudojiin_tanisyubetsu { get; set; } 
         //	宗教法人格有
        public String katudojiin_hojintoki { get; set; }           
        //住所(請求先)(郵便番号)
        public String katudojiinjoho_betsuinjusho_postalcode { get; set; } 
         //住所(請求先)(都道府県)
        public String katudojiinjoho_betsuinjusho_state { get; set; }
        //住所(請求先)(市区郡)
        public String katudojiinjoho_betsuinjusho_city { get; set; } 
         //住所(請求先)(町名・番地)
        public String katudojiinjoho_betsuinjusho_street { get; set; }           
        //別院での活動を希望
        public String katudojiinjoho_betsuindenokatsudo { get; set; } 
         //電話1
        public String katudojiinjoho_betsuintel { get; set; }
        //Fax
        public String katudojiinjoho_betsuinfax { get; set; } 
         //	山号寺院名（カナ）
        public String katudojiinjoho_zaisekijiinmei_kana { get; set; }           
        //お客様・提携先名
        public String katudojiinjoho_zaisekijiinmei { get; set; } 
         //住所(請求先)(郵便番号)
        public String katudojiinjoho_zaisekijiinjusho_postalcode { get; set; }
         //住所(請求先)(都道府県)
        public String katudojiinjoho_zaisekijiinjusho_state { get; set; }
         //住所(請求先)(市区郡)
        public String katudojiinjoho_zaisekijiinjusho_city { get; set; }
         //住所(請求先)(町名・番地)
        public String katudojiinjoho_zaisekijiinjusho_street { get; set; }
         //電話1
        public String katudojiinjoho_zaisekijiintel { get; set; }
         //Fax
        public String katudojiinjoho_zaisekijiinfax { get; set; }
         //銀行名
        public String kozajoho_kinkomei { get; set; }
         //銀行支店名
        public String kozajoho_shitenmei { get; set; }
         //口座種別
        public String kozajoho_shubetsu { get; set; }
         //	口座番号
        public String kozajoho_kozabango { get; set; }
         //口座名義
        public String kozajoho_kozameigi { get; set; }
         //戒名授与のみ依頼
        public String jizenanketo_kaimyojuyonomiirai { get; set; }
         //戒名授与のみ依頼要相談
        public String jizenanketo_kaimyojuyonomiirai_yosodan { get; set; }
         //移動手段
        public String jizenanketo_idoshudan { get; set; }
         //移動手段その他
        public String jizenanketo_idoshudan_sonota { get; set; }
         //依頼書送付方法
        public String jizenanketo_iraishosofuhoho { get; set; }
         //塔婆対応可否区分
        public String jizenanketo_tobataio { get; set; }
         //塔婆対応要相談
        public String jizenanketo_tobataio_yosodan { get; set; }
         //塔婆対応金額
        public String jizenanketo_tobataio_kingaku_from { get; set; }
         //塔婆対応金額
        public String jizenanketo_tobataio_kingaku_to { get; set; }
         //過去帳記入対応可否区分
        public String jizenanketo_kakochohenokinyu { get; set; }
         //過去帳記入要相談
        public String jizenanketo_kakochohenokinyu_yosodan { get; set; }
         //過去帳記入金額  
        public String jizenanketo_kakochohenokinyu_kingaku_from { get; set; }
         //過去帳記入金額	
        public String jizenanketo_kakochohenokinyu_kingaku_to { get; set; }
         //取材対応区分
        public String jizenanketo_shuzaitaio { get; set; }
         //取材要相談
        public String jizenanketo_shuzaitaio_yosodan { get; set; }
         //寺院での撮影
        public String jizenanketo_jiindenosatsuei { get; set; }
         //寺院での撮影要相談
        public String jizenanketo_jiindenosatsuei_yosodan { get; set; }
         //寺院での法要可
        public String jizenanketo_jiindenohoyo { get; set; }
         //寺院での法要要相談
        public String jizenanketo_jiindenohoyo_yosodan { get; set; }
         //寺院使用料
        public String jizenanketo_shiyoryo { get; set; }
         //収容人数
        public String jizenanketo_shuyoninzu { get; set; }
         //駐車場有無
        public String jizenanketo_chushajo { get; set; }
         //駐車可能台数
        public String jizenanketo_chushakanodaisu { get; set; }
         //僧名
        public String jizenanketo_somei { get; set; }
         //僧名での登録を希望
        public String jizenanketo_someidenotorokuwokibo { get; set; }
         //他社サービス登録
        public String jizenanketo_tashaservicetoroku { get; set; }
         //	他社サービス登録名
        public String jizenanketo_tashaservicetorokumei { get; set; }

        public list<DataJohosha> johosha { get; set; }

	}
    public class DataJohosha{
         //姓（カナ）
        public String johosha_johoshasei_kana { get; set; }        
         //名(カナ)
        public String johosha_johoshamei_kana { get; set; }
         //姓
        public String johosha_johoshasei { get; set; }        
         //名
        public String johosha_johoshamei { get; set; }
         //性別
        public String johosha_seibetsu { get; set; }        
         //住所(請求先)(郵便番号)
        public String johosha_kyojuchi_postalcode { get; set; }
         //住所(請求先)(都道府県)
        public String johosha_kyojuchi_state { get; set; }        
         //住所(請求先)(市区郡)
        public String johosha_kyojuchi_city { get; set; }
         //住所(請求先)(町名・番地)
        public String johosha_kyojuchi_street { get; set; }        
         //電話1
        public String johosha_tel { get; set; }
         //Fax
        public String johosha_fax { get; set; }        
         //携帯1
        public String johosha_mobile { get; set; }
         //法務対応可能エリア
        public String johosha_taiokanoarea { get; set; }        
         //生年月日
        public String johosha_seinengappi { get; set; }
         //本人確認書類種別
        public String johosha_honninkakuninshorui { get; set; }        
         //メールアドレス1
        public String johosha_email { get; set; }        
         //宗派
        public String johoshajiin_sosekishuha { get; set; } 
         //宗派その他(カナ)
        public String johoshajiin_sosekishuha_kana { get; set; } 
         //宗派その他
        public String johoshajiin_sosekishuha_sonota { get; set; }        
         //山号寺院名（カナ）
        public String johoshajiin_zaisekijiinmei_kana { get; set; } 
         //	お客様・提携先名
        public String johoshajiin_zaisekijiinmei { get; set; }                
         //住所(請求先)(郵便番号)
        public String johoshajiin_zaisekijiinjusho_postalcode { get; set; }        
         //住所(請求先)(都道府県)
        public String johoshajiin_zaisekijiinjusho_state { get; set; } 
         //住所(請求先)(市区郡)
        public String johoshajiin_zaisekijiinjusho_city { get; set; } 
         //住所(請求先)(町名・番地)
        public String johoshajiin_zaisekijiinjusho_street { get; set; }        
         //電話1
        public String johoshajiin_tel { get; set; } 
         //Fax
        public String johoshajiin_fax { get; set; } 
         //Web サイト
        public String johoshajiin_hpurl { get; set; } 
         //宗教法人単位種別
        public String johoshajiin_tanishubetsu { get; set; } 
         //宗教法人格有
        public String johoshajiin_hojintoki { get; set; }
         //僧籍宗派系統
        public String johoshajiin_sosekishuhakeito { get; set; }

    }
}