@RestResource(urlMapping='/api/v1/partnercontract_simplenaososhiki/*')
global with sharing class Api_V1_PartnerContract_Simple {
    
    @HttpPost
    global static void doPost() {
        System.debug('/api/v1/partnercontract_simplenaososhiki/* doPost() start');
        //System.debug('RestContext.request.requestBody.toString():' + RestContext.request.requestBody.toString());

        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        System.Savepoint sp = Database.setSavepoint();
        
        Api_V1_PartnerContract_Simple.Data theData = null;
        try {
            theData = (Api_V1_PartnerContract_Simple.Data)JSON.deserialize(RestContext.request.requestBody.toString(), Api_V1_PartnerContract_Simple.Data.class);
            DataSogisha theDataSogisha = theData.sogisha;
            list<DataSaijo> theDataSaijoLst = theData.saijo;
            DataInterview theDataInterview = theData.interview;
            // 【パートナー申込】葬儀社作成
            PartnerMoshikomi_Sogisha__c newObj = new PartnerMoshikomi_Sogisha__c();
            //申込サービス
            newObj.MoshikomiService__c = theDataSogisha.sogisha_moshikomiservice;
            //商号（カナ）
            newObj.NameShogoFurigana__c= theDataSogisha.sogisha_kaishamei_kana;
            //商号            
            newObj.NameShogo__c= theDataSogisha.sogisha_kaishamei;
            //屋号（カナ）           
            newObj.NameYagouFurigana__c= theDataSogisha.sogisha_yago_kana;
            //お客様・提携先名          
            newObj.TeikeisakiName__c= theDataSogisha.sogisha_yago;
            //運営形態
            newObj.UneiKeitai__c= theDataSogisha.sogisha_uneikeitai;
            //運営形態(その他)
            newObj.UneiKeitaiSonota__c= theDataSogisha.sogisha_uneikeitai_sonota;
            //住所(請求先)(郵便番号)
            newObj.BillingPostalCode__c= theDataSogisha.sogisha_shozaichi_postalcode;
            //住所(請求先)(都道府県)
            newObj.BillingState__c= theDataSogisha.sogisha_shozaichi_state;
            //住所(請求先)(市区郡)
            newObj.BillingCity__c= theDataSogisha.sogisha_shozaichi_city;            
            //住所(請求先)(町名・番地)
            newObj.BillingStreet__c= theDataSogisha.sogisha_shozaichi_street;
            //電話1
            newObj.Phone__c= theDataSogisha.sogisha_tel;
            //Fax
            newObj.Fax__c= theDataSogisha.sogisha_fax;
            //メールアドレス1
            newObj.MailAddress__c= theDataSogisha.sogisha_email;    
            //Web サイト
            newObj.Website__c= theDataSogisha.sogisha_hpurl;
            //代表者姓(カナ)
            newObj.DaihyoshaseiKana__c= theDataSogisha.sogisha_daihyoshasei_kana;
            //代表者名(カナ)
            newObj.DaihyoshameiKana__c= theDataSogisha.sogisha_daihyoshamei_kana;
            //代表者姓
            newObj.Daihyoshasei__c= theDataSogisha.sogisha_daihyoshasei;
            //代表者名
            newObj.DaihyoShamei__c= theDataSogisha.sogisha_daihyoshamei;
            //経理担当者姓(カナ)
            newObj.KeiriTantoshaseiKana__c= theDataSogisha.sogisha_keiritantoshasei_kana;
            //経理担当者名(カナ)
            newObj.KeiriTantoshameiKana__c= theDataSogisha.sogisha_keiritantoshamei_kana;           
            //経理担当者姓
            newObj.KeiriTantoshasei__c= theDataSogisha.sogisha_keiritantoshasei;
            //経理担当者名
            newObj.KeiriTantoshamei__c= theDataSogisha.sogisha_keiritantoshamei;
            //経理担当者TEL
            newObj.KeiriTantoshaTel__c= theDataSogisha.sogisha_keiritantosha_tel;
            //担当者姓（カナ）
            newObj.KeiyakuTantoshaseiKana__c= theDataSogisha.sogisha_teikeitantoshasei_kana;
            //担当者名（カナ）
            newObj.KeiyakuTantoshameiKana__c= theDataSogisha.sogisha_teikeitantoshamei_kana;
            //担当者姓
            newObj.KeiyakuTantoshasei__c= theDataSogisha.sogisha_teikeitantoshasei;
            //担当者名
            newObj.KeiyakuTantoshamei__c= theDataSogisha.sogisha_teikeitantoshamei;
            //担当者役職
            newObj.KeiyakuTantoYakuShoku__c= theDataSogisha.sogisha_teikeitantosha_yakushoku;
            //担当者TelNo
            newObj.KeiyakuTantoTelNo__c= theDataSogisha.sogisha_teikeitantosha_tel;
            //担当者E-Mail
            newObj.KeiyakuTantoEmail__c= theDataSogisha.sogisha_teikeitantosha_email;
            //主要連絡先
            newObj.ShuyoRenrakusaki__c= theDataSogisha.sogisha_shuyorenrakusaki;            
            //寝台車所有数
            newObj.ShindaishaShoyusu__c= theDataSogisha.sogisha_sindaishashoyusu;
            //自社斎場所有数   
            newObj.JisyaSaijoSyoyuSu__c= theDataSogisha.sogisha_saijoshoyusu;
            //一般貨物自動車運送許可書区分
            newObj.UnsoKyokasyoKubun__c= theDataSogisha.sogisha_ippankamotsujidosha;
            //特記事項(パートナー記入)
            newObj.TokkijikoPartnerKinyu__c= theDataSogisha.sogisha_tokkijiko;    
            //請求先商号(カナ)
            newObj.SeikyusakiShogoKana__c= theDataSogisha.sogisha_seikyusaki_shogo_kana;
            //請求先商号
            newObj.SeikyusakiShogo__c= theDataSogisha.sogisha_seikyusaki_shogo;
            //請求先屋号(カナ) 
            newObj.SeikyusakiYagokana__c= theDataSogisha.sogisha_seikyusaki_yago_kana;
            //請求先屋号
            newObj.SeikyusakiYago__c= theDataSogisha.sogisha_seikyusaki_yago;            
            //郵便番号（請求先）
            newObj.SeikyuSakiAddrPostalCode__c= theDataSogisha.sogisha_seikyusaki_shozaichi_postalcode;
            //都道府県（請求先）
            newObj.SeikyuSakiAddrState__c= theDataSogisha.sogisha_seikyusaki_shozaichi_state;
            //市区郡（請求先）
            newObj.SeikyuSakiAddrCity__c= theDataSogisha.sogisha_seikyusaki_shozaichi_city;
            //町名・番地（請求先）
            newObj.SeikyuSakiAddrStreet__c= theDataSogisha.sogisha_seikyusaki_shozaichi_street; 
            //請求先TEL
            newObj.SeikyusakiTel__c= theDataSogisha.sogisha_seikyusaki_tel; 
            //請求先FAX
            newObj.SeikyusakiFax__c= theDataSogisha.sogisha_seikyusaki_fax; 
            //請求先担当者(カナ)
            newObj.SeikyusakiTantoshaseiKana__c= theDataSogisha.sogisha_seikyusaki_tantoshasei_kana;
            //請求先担当者(カナ)
            newObj.SeikyusakiTantoshameiKana__c= theDataSogisha.sogisha_seikyusaki_tantoshamei_kana;
            //請求先担当者
            newObj.SeikyusakiTantoshasei__c= theDataSogisha.sogisha_seikyusaki_tantoshasei;
            //請求先担当者
            newObj.SeikyusakiTantoshamei__c= theDataSogisha.sogisha_seikyusaki_tantoshamei;
            //銀行名
            newObj.BankName__c= theDataSogisha.sogisha_ginkomei; 
            //銀行支店名
            newObj.BankBranchName__c= theDataSogisha.sogisha_shitenmei; 
            //口座種別
            newObj.BankAccountType__c= theDataSogisha.sogisha_shurui; 
            //口座番号
            newObj.BankAccountNo__c= theDataSogisha.sogisha_kozabango; 
            //口座名義
            newObj.BankAccountMeigi__c= theDataSogisha.sogisha_kozameigi; 
            //平均施行件数( 年)
            newObj.HekinSekoKensuNen__c= theDataInterview.interview_hekinsekokensunen; 
            //施行スタッフ人数
            newObj.SekoStaffNinzu__c= theDataInterview.interview_sekostaff; 
            //施行可能件数(月)
            newObj.SekoKanoKensuTsuki__c= theDataInterview.interview_sekokanokensutsuki; 
            //葬祭プランナー人数
            newObj.SosaiPlannerNinzu__c= theDataInterview.interview_sosaiplannerninzu; 
            //葬祭ディレクター人数
            newObj.SosaiDirectorNinzu__c= theDataInterview.interview_sosaidirectorninzu; 
            //対応可能エリア
            newObj.TaiouKanouArea__c= theDataInterview.interview_taiokanoarea;
            //自社集客時対応可能内容
            newObj.JishaSyukyakujiTaiokanoNaiyo__c= theDataInterview.interview_jishashukakutaiokanonaiyo;
            //支払方法
            newObj.ShiharaiHoho__c= theDataInterview.interview_shiharaihoho;
            //支払方法(その他)
            newObj.ShiharaiHohoSonota__c= theDataInterview.interview_shiharaihoho_sonota;
            //自社集客
            newObj.SekoRyunyuHiritsuJishaShukaku__c= theDataInterview.interview_sekoryunyuhiritsu_jishasyukyaku;
            //病院・警察・介護施設・他
            newObj.SekorRyunyuHiritsuByoinKesatsuKaigo__c= theDataInterview.interview_sekoryunyuhiritsu_byoinkesatsukaigo;
            //インターネット
            newObj.SekoRyunyuHiritsuInternet__c= theDataInterview.interview_sekoryunyuhiritsu_internet;
            //その他
            newObj.SekoRyunyuHiritsuSonota__c= theDataInterview.interview_sekoryunyuhiritsu_sonota;
            //直葬
            newObj.SekoHiritsuChokuso__c= theDataInterview.interview_sekohiritsu_chokuso;
            //一日葬
            newObj.SekoHiritsuIchinichiso__c= theDataInterview.interview_sekohiritsu_ichinichiso;
            //家族葬
            newObj.SekoHiritsuKazokuso__c= theDataInterview.interview_sekohiritsu_kazokuso;
            //一般葬
            newObj.SekoHiritsuIppanso__c= theDataInterview.interview_sekohiritsu_ippanso;
            //搬送案件
            newObj.SekoHiritsuHansoAnken__c= theDataInterview.interview_sekohiritsu_hansoanken;
            //その他
            newObj.SekoHiritsuSonota__c= theDataInterview.interview_sekohiritsu_sonota;
            //施行平均単価
            newObj.SekoHekinTanka__c= theDataInterview.interview_sekohekintanka;
            //葬儀ブランド対応可能内容
            newObj.SogiBrandTaioKanoNaiyo__c= theDataInterview.interview_sogibrandtaiokanonaiyo;
            //最大延期日数(火葬式)
            newObj.SaidaiEnkiNissuKasoshiki__c= theDataInterview.interview_saidaienkinissu_kasoshiki;
            //最大分割回数(火葬式)
            newObj.SaidaiBunkatuKaisuKasoshiki__c= theDataInterview.interview_saidaibunkatsukaisu_kasoshiki;
            //最大延期日数(式有)
            newObj.SaidaiEnkiNissuShikiari__c= theDataInterview.interview_saidaienkinissu_shikiari;                        
            //最大分割回数(式有)
            newObj.SaidaiBunkatsuKaisuShikiari__c= theDataInterview.interview_saidaibunkatsukaisu_shikiari;
            insert newObj;
           
            list<PartnerMoshikomi_Saijo__c> PartnerMoshikomi_SaijoLst =new list<PartnerMoshikomi_Saijo__c>();
            for (DataSaijo theDataSaijo:theDataSaijoLst){
                    PartnerMoshikomi_Saijo__c newSaijoObj = new PartnerMoshikomi_Saijo__c();
                    newSaijoObj.Sogisha__c=newObj.id;

                    //施設名(かな)
                    newSaijoObj.ShisetsumeiFurigana__c= theDataSaijo.saijo_saijomei_kana;  
                    //施設名
                    newSaijoObj.Saijomei__c= theDataSaijo.saijo_saijomei;                      
                    //公営民営
                    newSaijoObj.KoeiMinei__c= theDataSaijo.saijo_uneikeitai; 
                    //運営元(屋号)
                    newSaijoObj.Organiser__c= theDataSaijo.saijo_uneimoto; 
                    //郵便番号
                    newSaijoObj.PostalCode__c= theDataSaijo.saijo_shozaichi_postalcode; 
                    //都道府県
                    newSaijoObj.State__c= theDataSaijo.saijo_shozaichi_state; 
                    //市区郡
                    newSaijoObj.City__c= theDataSaijo.saijo_shozaichi_city;  
                    //町名・番地
                    newSaijoObj.Street__c= theDataSaijo.saijo_shozaichi_street;                      
                    //電話番号1
                    newSaijoObj.Phone1__c= theDataSaijo.saijo_tel; 
                    //FAX
                    newSaijoObj.Fax__c= theDataSaijo.saijo_fax; 
                    //HP URL
                    newSaijoObj.HpUrl__c= theDataSaijo.saijo_saijourl; 
                    //休館日
                    newSaijoObj.CloseDay__c= theDataSaijo.saijo_kyukanbi;
                    //ホール説明文
                    newSaijoObj.HoleSetsumeibun__c= theDataSaijo.saijo_holesetsumeibun;
                    //アクセス方法(電車)
                    newSaijoObj.AccessHouhouDensha__c= theDataSaijo.saijo_accsess_densha;
                    //アクセス方法(バス)
                    newSaijoObj.AccessHohoBasu__c= theDataSaijo.saijo_accsess_basu;
                    //アクセス方法(車)
                    newSaijoObj.AccessHohoKuruma__c= theDataSaijo.saijo_accsess_kuruma;
                    //バリアフリー
                    newSaijoObj.Bariafuri__c= theDataSaijo.saijo_barrierfreetaio;
                    //付添安置可
                    newSaijoObj.TsukisoiAnchiKa__c= theDataSaijo.saijo_saijotenpu;
                    //対応可能人数
                    newSaijoObj.TaioKanoNinzu__c= theDataSaijo.saijo_taiokanoninzu;
                    //宿泊可
                    newSaijoObj.ShukuhakuKa__c= theDataSaijo.saijo_shukuhakushisetsu;
                    //宿泊施設料金
                    newSaijoObj.ShukuhakuShisetsuRyokin__c= theDataSaijo.saijo_shukuhakushisetsu_ryokin;
                    //宿泊施設備考
                    newSaijoObj.ShukuhakuShisetsuBiko__c= theDataSaijo.saijo_shukuhakushisetsu_biko;
                    //親族控室有
                    newSaijoObj.ShinzokuHikaeshitsuAri__c= theDataSaijo.saijo_shinzokuhikaeshitsu;
                    //安置面会可
                    newSaijoObj.AnchiMenkaiKa__c= theDataSaijo.saijo_anchinogoizokunomenkai;
                    //シャワールーム有
                    newSaijoObj.ShawaRoomAri__c= theDataSaijo.saijo_nyuyokushowersetsubi;
                    //駐車場有
                    newSaijoObj.ChushajoAri__c= theDataSaijo.saijo_chushajo;
                    //駐車台数
                    newSaijoObj.Chushadaisu__c= theDataSaijo.saijo_chushadaisu;
                    //キッズルーム有
                    newSaijoObj.KizzuRoomAri__c= theDataSaijo.saijo_kidsroom;
                    //法要可
                    newSaijoObj.HoyoKa__c= theDataSaijo.saijo_hoyodenoshiyo;
                    //全宗派対応可
                    newSaijoObj.ZenShuhaTaioKa__c= theDataSaijo.saijo_zenshushisuhataio;
                    //ベビールーム有
                    newSaijoObj.BebiRoomAri__c= theDataSaijo.saijo_bebyroom;
                    //授乳室有
                    newSaijoObj.JunyushitsuAri__c= theDataSaijo.saijo_junyushitsu;
                    //おむつ交換台有
                    newSaijoObj.OmutsuKokandaiAri__c= theDataSaijo.saijo_omutsukokandai;
                    //安置可
                    newSaijoObj.AnchiKa__c= theDataSaijo.saijo_goitaianchishisetsu;
                    //霊安室(安置)料金(市内)
                    newSaijoObj.AnchiResidentPrice__c= theDataSaijo.saijo_goitaianchishisetsu_ryokin;
                    //安置対応人数
                    newSaijoObj.AnchiTaioNinzu__c= theDataSaijo.saijo_anchitaioninzu;
                    //保冷庫数
                    newSaijoObj.Horeikosu__c= theDataSaijo.saijo_horeikosu;
                    //直葬可
                    newSaijoObj.ChokusoKa__c= theDataSaijo.saijo_sekokanoplan_chokuso;
                    //火葬式可
                    newSaijoObj.KasoshikiKa__c= theDataSaijo.saijo_sekokanoplan_kaso;
                    //一日葬可
                    newSaijoObj.IchinichisoKa__c= theDataSaijo.saijo_sekokanoplan_ichinichiso;
                    //家族葬可
                    newSaijoObj.KazokusoKa__c= theDataSaijo.saijo_sekokanoplan_kazokuso;
                    //一般葬可
                    newSaijoObj.IppansoKa__c= theDataSaijo.saijo_sekokanoplan_ippanso;
                    PartnerMoshikomi_SaijoLst.add(newSaijoObj);
            }
            insert PartnerMoshikomi_SaijoLst;

            list<PartnerMoshikomi_SaijoHeya__c> PartnerMoshikomi_SaijoHeyaLst=new list<PartnerMoshikomi_SaijoHeya__c>();
            integer index=0;            
            for (DataSaijo theDataSaijo:theDataSaijoLst){
                list<DataHeya> theDataHeyaLst=theDataSaijo.heya;
                id SaijoId=PartnerMoshikomi_SaijoLst[index].id;
                for (DataHeya theDataHeya:theDataHeyaLst){
                    PartnerMoshikomi_SaijoHeya__c newSaijoHeyaObj=new PartnerMoshikomi_SaijoHeya__c();
                    newSaijoHeyaObj.PartnerMoshikomi_SaijoRef__c=SaijoId;
                    //部屋名
                    newSaijoHeyaObj.heyamei__c= theDataHeya.saijo_heyamei;
                    //最大収容人数
                    newSaijoHeyaObj.SaidaiShuyoNinzu__c= theDataHeya.saijo_saidaishuyoninzu;
                    //着席数
                    newSaijoHeyaObj.Chakusekisu__c= theDataHeya.saijo_chakusekisu;
                    //会葬者数
                    newSaijoHeyaObj.Kaisoshasu__c= theDataHeya.saijo_kaisoshasu;
                    //利用料金
                    newSaijoHeyaObj.RiyoRyokin__c= theDataHeya.saijo_riyoryokin;
                    //みんれび葬儀ブランドでのプラン内利用可否
                    newSaijoHeyaObj.SogiBrandPlannaiRiyoKahi__c= theDataHeya.saijo_plannairiyokahi;    
                    PartnerMoshikomi_SaijoHeyaLst.add(newSaijoHeyaObj); 
                }
                index++;              
            }
            insert PartnerMoshikomi_SaijoHeyaLst;

            res.responseBody = Blob.valueOf(JSON.serialize(newObj));
            res.statusCode = 200;

        } catch(Exception e) {
            String err = '[エラーメッセージ]\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString();
            System.debug('err:' + err);
            Database.rollback(sp);
            res.responseBody = Blob.valueOf(err);
            res.statusCode = 500;

            String strText = '【パートナー申込】葬儀社の作成が失敗しました。\r\n\r\n' + err + '\r\n\r\n' + '[問合せ内容]\r\n' + theData;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【パートナー申込】葬儀社', strText);
        }

        System.debug('/api/v1/partnercontract_simplenaososhiki/* doPost() end');
    }
    public class Data{
        public DataSogisha sogisha { get; set; }
        public list<DataSaijo> saijo { get; set; }
        public DataInterview interview { get; set; }
    }

    public class DataSogisha{
        //申込サービス
        public String sogisha_moshikomiservice { get; set; }
        //商号（カナ）
        public String sogisha_kaishamei_kana { get; set; }
        //商号
        public String sogisha_kaishamei { get; set; }
        //屋号（カナ）
        public String sogisha_yago_kana { get; set; }
        //お客様・提携先名
        public String sogisha_yago { get; set; }
        //運営形態
        public String sogisha_uneikeitai { get; set; }
        //運営形態(その他)
        public String sogisha_uneikeitai_sonota { get; set; }
        //住所(請求先)(郵便番号)
        public String sogisha_shozaichi_postalcode { get; set; }
        //住所(請求先)(都道府県)
        public String sogisha_shozaichi_state { get; set; }     
        //住所(請求先)(市区郡)
        public String sogisha_shozaichi_city { get; set; }
        //住所(請求先)(町名・番地)
        public String sogisha_shozaichi_street { get; set; }
        //電話1
        public String sogisha_tel { get; set; }
        //Fax
        public String sogisha_fax { get; set; }
        //メールアドレス1
        public String sogisha_email { get; set; }
        //Web サイト
        public String sogisha_hpurl { get; set; }
        //代表姓(カナ)
        public String sogisha_daihyoshasei_kana { get; set; }
        //代表名(カナ)
        public String sogisha_daihyoshamei_kana { get; set; }
        //代表姓
        public String sogisha_daihyoshasei { get; set; }
        //代表名
        public String sogisha_daihyoshamei { get; set; }
        //経理担当者姓(カナ)
        public String sogisha_keiritantoshasei_kana { get; set; }
        //経理担当者名(カナ)
        public String sogisha_keiritantoshamei_kana { get; set; }
        //経理担当者姓
        public String sogisha_keiritantoshasei { get; set; }
        //経理担当者名
        public String sogisha_keiritantoshamei { get; set; }
        //経理担当者TEL
        public String sogisha_keiritantosha_tel { get; set; }
        //担当者姓（カナ）
        public String sogisha_teikeitantoshasei_kana { get; set; }
        //担当者名（カナ）
        public String sogisha_teikeitantoshamei_kana { get; set; }
        //担当者姓
        public String sogisha_teikeitantoshasei { get; set; }
        //担当者名
        public String sogisha_teikeitantoshamei { get; set; }
        //担当者役職
        public String sogisha_teikeitantosha_yakushoku { get; set; }
        //担当者TelNo
        public String sogisha_teikeitantosha_tel { get; set; }
        //担当者E-Mail
        public String sogisha_teikeitantosha_email { get; set; }     
        //主要連絡先
        public String sogisha_shuyorenrakusaki { get; set; }
        //寝台車所有数
        public String sogisha_sindaishashoyusu { get; set; }
        //自社斎場所有数
        public String sogisha_saijoshoyusu { get; set; }
        //一般貨物自動車運送許可書区分    
        public String sogisha_ippankamotsujidosha { get; set; }
        //特記事項(パートナー記入)
        public String sogisha_tokkijiko { get; set; }
        //請求先商号(カナ)
        public String sogisha_seikyusaki_shogo_kana { get; set; }
        //請求先商号
        public String sogisha_seikyusaki_shogo { get; set; }
        //請求先屋号(カナ) 
        public String sogisha_seikyusaki_yago_kana { get; set; }                  
        //請求先屋号
        public String sogisha_seikyusaki_yago { get; set; }
        //郵便番号（請求先）
        public String sogisha_seikyusaki_shozaichi_postalcode { get; set; }
        //都道府県（請求先）
        public String sogisha_seikyusaki_shozaichi_state { get; set; }
        //市区郡（請求先）
        public String sogisha_seikyusaki_shozaichi_city { get; set; }
        //町名・番地（請求先）
        public String sogisha_seikyusaki_shozaichi_street { get; set; }
        //請求先TEL
        public String sogisha_seikyusaki_tel { get; set; }
        //請求先FAX
        public String sogisha_seikyusaki_fax { get; set; }
        //請求先担当者姓(カナ)
        public String sogisha_seikyusaki_tantoshasei_kana { get; set; }
        //請求先担当者名(カナ)
        public String sogisha_seikyusaki_tantoshamei_kana { get; set; }
        //請求先担当者姓
        public String sogisha_seikyusaki_tantoshasei { get; set; }
        //請求先担当者名
        public String sogisha_seikyusaki_tantoshamei { get; set; }
        //銀行名
        public String sogisha_ginkomei { get; set; }
        //銀行支店名
        public String sogisha_shitenmei { get; set; }
        //口座種別
        public String sogisha_shurui { get; set; }
        //口座番号
        public String sogisha_kozabango { get; set; }
        //口座名義
        public String sogisha_kozameigi { get; set; }
    }

    public class DataSaijo{
        //施設名(かな)
        public String saijo_saijomei_kana { get; set; }   
        //施設名
        public String saijo_saijomei { get; set; }
        //公営民営
        public String saijo_uneikeitai { get; set; }
        //斎場写真(外観)
        public String saijo_saijoshashin_gaikan { get; set; }
        //斎場写真(内観)
        public String saijo_saijoshashin_naikan { get; set; }
        //運営元(屋号)
        public String saijo_uneimoto { get; set; }
        //郵便番号
        public String saijo_shozaichi_postalcode { get; set; }        
        //都道府県
        public String saijo_shozaichi_state { get; set; }
        //市区郡
        public String saijo_shozaichi_city { get; set; }
        //町名・番地
        public String saijo_shozaichi_street { get; set; }
        //電話番号1
        public String saijo_tel { get; set; } 
        //FAX
        public String saijo_fax { get; set; }
        //HP URL
        public String saijo_saijourl { get; set; }
        //休館日
        public String saijo_kyukanbi { get; set; }
        //ホール説明文
        public String saijo_holesetsumeibun { get; set; }        
        //アクセス方法(電車)
        public String saijo_accsess_densha { get; set; }
        //アクセス方法(バス)
        public String saijo_accsess_basu { get; set; }
        //アクセス方法(車)
        public String saijo_accsess_kuruma { get; set; }
        //バリアフリー
        public String saijo_barrierfreetaio { get; set; }
        //付添安置可
        public String saijo_saijotenpu { get; set; }
        //対応可能人数
        public String saijo_taiokanoninzu { get; set; }
        //宿泊可
        public String saijo_shukuhakushisetsu { get; set; }
        //宿泊施設料金
        public String saijo_shukuhakushisetsu_ryokin { get; set; }        
        //宿泊施設備考
        public String saijo_shukuhakushisetsu_biko { get; set; }
        //親族控室有
        public String saijo_shinzokuhikaeshitsu { get; set; }
        //安置面会可
        public String saijo_anchinogoizokunomenkai { get; set; }
        //シャワールーム有
        public String saijo_nyuyokushowersetsubi { get; set; } 
        //駐車場有
        public String saijo_chushajo { get; set; }
        //駐車台数
        public String saijo_chushadaisu { get; set; }
        //キッズルーム有
        public String saijo_kidsroom { get; set; }        
        //法要可
        public String saijo_hoyodenoshiyo { get; set; }
        //全宗派対応可
        public String saijo_zenshushisuhataio { get; set; }
        //ベビールーム有
        public String saijo_bebyroom { get; set; }
        //授乳室有
        public String saijo_junyushitsu { get; set; }
        //おむつ交換台有
        public String saijo_omutsukokandai { get; set; }
        //安置可
        public String saijo_goitaianchishisetsu { get; set; }
        //霊安室(安置)料金(市内)
        public String saijo_goitaianchishisetsu_ryokin { get; set; }
        //安置対応人数
        public String saijo_anchitaioninzu { get; set; }
        //保冷庫数
        public String saijo_horeikosu { get; set; }
        //直葬可
        public String saijo_sekokanoplan_chokuso { get; set; }
        //火葬式可
        public String saijo_sekokanoplan_kaso { get; set; }
        //一日葬可
        public String saijo_sekokanoplan_ichinichiso { get; set; }                    
        //家族葬可
        public String saijo_sekokanoplan_kazokuso { get; set; }
        //一般葬可
        public String saijo_sekokanoplan_ippanso { get; set; }
        public list<DataHeya> heya { get; set; }        
    }
    public class DataHeya{
        //部屋名
        public String saijo_heyamei { get; set; }
        //最大収容人数
        public String saijo_saidaishuyoninzu { get; set; }
        //着席数
        public String saijo_chakusekisu { get; set; }                  
        //会葬者数
        public String saijo_kaisoshasu { get; set; }
        //利用料金
        public String saijo_riyoryokin { get; set; }
        //みんれび葬儀ブランドでのプラン内利用可否
        public String saijo_plannairiyokahi { get; set; }   
    }
    public class DataInterview{
        //平均施行件数(年) 
        public String interview_hekinsekokensunen { get; set; }
        //施行スタッフ人数
        public String interview_sekostaff { get; set; }     
        //施行可能件数(月)
        public String interview_sekokanokensutsuki { get; set; }
        //葬祭プランナー人数
        public String interview_sosaiplannerninzu { get; set; }
        //葬祭ディレクター人数
        public String interview_sosaidirectorninzu { get; set; }
        //対応可能エリア
        public String interview_taiokanoarea { get; set; }
        //自社集客時対応可能内容
        public String interview_jishashukakutaiokanonaiyo { get; set; }
        //支払方法
        public String interview_shiharaihoho { get; set; }
        //支払方法(その他)
        public String interview_shiharaihoho_sonota { get; set; }
        //自社集客
        public String interview_sekoryunyuhiritsu_jishasyukyaku { get; set; }
        //病院・警察・介護施設・他
        public String interview_sekoryunyuhiritsu_byoinkesatsukaigo { get; set; }              
        //インターネット
        public String interview_sekoryunyuhiritsu_internet { get; set; } 
        //その他
        public String interview_sekoryunyuhiritsu_sonota { get; set; }
        //直葬
        public String interview_sekohiritsu_chokuso { get; set; }              
        //一日葬
        public String interview_sekohiritsu_ichinichiso { get; set; }  
        //家族葬
        public String interview_sekohiritsu_kazokuso { get; set; }
        //一般葬
        public String interview_sekohiritsu_ippanso { get; set; }              
        //搬送案件
        public String interview_sekohiritsu_hansoanken { get; set; } 
        //その他
        public String interview_sekohiritsu_sonota { get; set; }
        //施行平均単価
        public String interview_sekohekintanka { get; set; }              
        //葬儀ブランド対応可能内容
        public String interview_sogibrandtaiokanonaiyo { get; set; }  
        //最大延期日数(火葬式)
        public String interview_saidaienkinissu_kasoshiki { get; set; }        
        //最大分割回数(火葬式)
        public String interview_saidaibunkatsukaisu_kasoshiki { get; set; }  
        //最大延期日数(式有)
        public String interview_saidaienkinissu_shikiari { get; set; } 
        //  最大分割回数(式有)
        public String interview_saidaibunkatsukaisu_shikiari { get; set; }                

    }
}