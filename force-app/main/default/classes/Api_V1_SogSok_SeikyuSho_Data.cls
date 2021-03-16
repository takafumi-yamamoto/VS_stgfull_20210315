public class Api_V1_SogSok_SeikyuSho_Data {

    public class SeikyuSho{
        public String soukyaku_bango = '';
        public String shodan_bango = '';
        public SeikyuSho_SoukyakuSaki soukyakusaki = new SeikyuSho_SoukyakuSaki();
        public SeikyuSho_Sodansha sodansha = new SeikyuSho_Sodansha();
        public SeikyuSho_Taishosha taishosha = new SeikyuSho_Taishosha();
        public SeikyuSho_Moshu moshu = new SeikyuSho_Moshu();
        public SeikyuSho_Sogi sogi = new SeikyuSho_Sogi();
        public SeikyuSho_Soryo_tehai soryo_tehai = new SeikyuSho_Soryo_tehai();
        public SeikyuSho_Sogi_plan sogi_plan = new SeikyuSho_Sogi_plan();
        public List<SeikyuSho_Tsuika_hinmokus> tsuika_hinmokus = new List<SeikyuSho_Tsuika_hinmokus>();
        public List<SeikyuSho_Tekiyo_waribikis> tekiyo_waribikis = new List<SeikyuSho_Tekiyo_waribikis>();
        public SeikyuSho_Shiharai shiharai = new SeikyuSho_Shiharai();
        public SeikyuSho_Shiharaisha shiharaisha = new SeikyuSho_Shiharaisha();
        public String lastupdatetime = '';
        public String doc_status = '';
        public String kinyu_date = '';
        public String sign_url = '';
    }
    public class SeikyuSho_SoukyakuSaki{
        public String torihikisaki_bango = '';
        public String torihikisaki_name = '';
        public String tantosha_name = '';
        public String tantosha_tel = '';
        public String tantosha_fax = '';
    }
    public class SeikyuSho_Sodansha{
        public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
    }
    public class SeikyuSho_Taishosha{
        public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
        public String sei_kana = '';
        public String mei_kana = '';
        public String birth_date = '';
        public String death_date = '';
        public Decimal age = 0;
        public String gender = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String jumhyo_postal_code = '';
        public String jumhyo_state = '';
        public String jumhyo_city = '';
        public String jumhyo_street = '';
        public String shushi = '';
        public String shuha = '';
        public String shuha_sonotaShuha = '';
        public String bodaiji_umu = '';
        public String zokugara_from_moshu = '';
    }
    public class SeikyuSho_Moshu{
        //public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
        public String sei_kana = '';
        public String mei_kana = '';
        public String birth_date = '';
        public Decimal age = 0;
        public String gender = '';
        public String phone = '';
        public String mobile = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String zokugara_from_soudansha = '';
    }
    public class SeikyuSho_Sogi{
        public String tsuya_datetime = '';
        public String kokubetsushiki_datetime = '';
        public String shukkan_datetime = '';
        public String kaso_datetime = '';
        public String shikijo_name = '';
        public String kasoba_name = '';
    }
    public class SeikyuSho_Soryo_tehai{
        public String tehai_umu = '';
        public String kaimyo = '';
    }
    public class SeikyuSho_Sogi_plan{
        public String shohin_bango = '';
        public String name = '';
        public Decimal kingaku = 0;
        public String service_id = '';
        public String butsugu_kibo = '';
        public String last_message = '';
        public String ohanaire = '';
        public String memorial_corner = '';
        public String iei_hanakazari = '';
    }
    public class SeikyuSho_Tsuika_hinmokus{
        public List<String> hinmoku_bunrui = new List<String>();
        public String hinmoku_bunrui_name = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
        public String shohin_bango = '';
    }
    public class SeikyuSho_Tekiyo_waribikis{
        public String shohin_bango = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
    }
    public class SeikyuSho_Shiharai{
        public Decimal loan_kingaku = 0;
        public Decimal card_kingaku = 0;
        public Decimal genkin_kingaku = 0;
        public Decimal maeuke_kingaku = 0;
        public Decimal gmo_kingaku = 0;
    }
    public class SeikyuSho_Shiharaisha{
        public String name = '';
        public String email = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String atena = '';
    }

    public SogSok_SeikyuSho__c createSogSokSeikyuSho(SeikyuSho pSource){
        SogSok_SeikyuSho__c theSogSokSeikyuSho = new SogSok_SeikyuSho__c();
        // root
        theSogSokSeikyuSho.SokyakuBango__c = pSource.soukyaku_bango;
        theSogSokSeikyuSho.ShodanBango__c = pSource.shodan_bango;
        // 送客先
        theSogSokSeikyuSho.Soukyakusaki_TorihikisakiBango__c = pSource.soukyakusaki.torihikisaki_bango;
        theSogSokSeikyuSho.SoukyakuSaki_TorihikiSakiName__c = pSource.soukyakusaki.torihikisaki_name;
        theSogSokSeikyuSho.SoukyakuSaki_Tantosha_Name__c = pSource.soukyakusaki.tantosha_name;
        theSogSokSeikyuSho.SoukyakuSaki_Tantosha_Tel__c = pSource.soukyakusaki.tantosha_tel;
        theSogSokSeikyuSho.SoukyakuSaki_Tantosha_Fax__c = pSource.soukyakusaki.tantosha_fax;
        // 相談者
        theSogSokSeikyuSho.SodanSha_TorihikiSakiBango__c = pSource.sodansha.torihikisaki_bango;
        theSogSokSeikyuSho.SodanSha_Sei__c = pSource.sodansha.sei;
        theSogSokSeikyuSho.SodanSha_Mei__c = pSource.sodansha.mei;
        // 対象者
        theSogSokSeikyuSho.TaishoSha_TorihikiSakiBango__c = pSource.taishosha.torihikisaki_bango;
        theSogSokSeikyuSho.TaishoSha_Sei__c = pSource.taishosha.sei;
        theSogSokSeikyuSho.TaishoSha_Mei__c = pSource.taishosha.mei;
        theSogSokSeikyuSho.TaishoSha_SeiKana__c = pSource.taishosha.sei_kana;
        theSogSokSeikyuSho.TaishoSha_MeiKana__c = pSource.taishosha.mei_kana;
        theSogSokSeikyuSho.TaishoSha_BirthDate__c =  toDateStr(pSource.taishosha.birth_date);
        theSogSokSeikyuSho.TaishoSha_DeathDate__c = toDateStr(pSource.taishosha.death_date);
        theSogSokSeikyuSho.TaishoSha_Age__c = pSource.taishosha.age == null ? 0 : pSource.taishosha.age;
        theSogSokSeikyuSho.TaishoSha_Gender__c = pSource.taishosha.gender;
        theSogSokSeikyuSho.Taishosha_Addr_PostalCode__c = pSource.taishosha.addr_postal_code;
        theSogSokSeikyuSho.TaishoSha_Addr_State__c = pSource.taishosha.addr_state;
        theSogSokSeikyuSho.TaishoSha_Addr_City__c = pSource.taishosha.addr_city;
        theSogSokSeikyuSho.TaishoSha_Addr_Street__c = pSource.taishosha.addr_street;
        theSogSokSeikyuSho.TaishoSha_JumHyo_PostalCode__c = pSource.taishosha.jumhyo_postal_code;
        theSogSokSeikyuSho.TaishoSha_JumHyo_State__c = pSource.taishosha.jumhyo_state;
        theSogSokSeikyuSho.TaishoSha_JumHyo_City__c = pSource.taishosha.jumhyo_city;
        theSogSokSeikyuSho.TaishoSha_JumHyo_Street__c = pSource.taishosha.jumhyo_street;
        theSogSokSeikyuSho.TaishoSha_Shushi__c = pSource.taishosha.shushi;
        theSogSokSeikyuSho.TaishoSha_Shuha__c = pSource.taishosha.shuha;
        theSogSokSeikyuSho.TaishoSha_Shuha_Sonota__c = pSource.taishosha.shuha_sonotaShuha;
        theSogSokSeikyuSho.TaishoSha_Bodaiji_Umu__c = pSource.taishosha.bodaiji_umu;
        theSogSokSeikyuSho.TaishoSha_ZokugaraFromMoshu__c = pSource.taishosha.zokugara_from_moshu;
        // 喪主
        //theSogSokSeikyuSho.Moshu_TorihikiSakiBango__c = pSource.moshu.torihikisaki_bango;
        theSogSokSeikyuSho.Moshu_Sei__c = pSource.moshu.sei;
        theSogSokSeikyuSho.Moshu_Mei__c = pSource.moshu.mei;
        theSogSokSeikyuSho.Moshu_SeiKana__c = pSource.moshu.sei_kana;
        theSogSokSeikyuSho.Moshu_MeiKana__c = pSource.moshu.mei_kana;
        theSogSokSeikyuSho.Moshu_BirthDate__c = toDateStr(pSource.moshu.birth_date);
        theSogSokSeikyuSho.Moshu_Gender__c = pSource.moshu.gender;
        theSogSokSeikyuSho.Moshu_Phone__c = pSource.moshu.phone;
        theSogSokSeikyuSho.Moshu_Mobile__c = pSource.moshu.mobile;
        theSogSokSeikyuSho.Moshu_Addr_PostalCode__c = pSource.moshu.addr_postal_code;
        theSogSokSeikyuSho.Moshu_Addr_State__c = pSource.moshu.addr_state;
        theSogSokSeikyuSho.Moshu_Addr_City__c = pSource.moshu.addr_city;
        theSogSokSeikyuSho.Moshu_Addr_Street__c = pSource.moshu.addr_street;
        theSogSokSeikyuSho.Moshu_ZokugaraFromSoudanSha__c = pSource.moshu.zokugara_from_soudansha;
        // 葬儀
        theSogSokSeikyuSho.Sogi_TsuyaDateTime__c = toDatetimeStr(pSource.sogi.tsuya_datetime);
        theSogSokSeikyuSho.Sogi_KokubetsuDateTime__c = toDatetimeStr(pSource.sogi.kokubetsushiki_datetime);
        theSogSokSeikyuSho.Sogi_ShukkanDateTime__c = toDatetimeStr(pSource.sogi.shukkan_datetime);
        theSogSokSeikyuSho.Sogi_KasoDateTime__c = toDatetimeStr(pSource.sogi.kaso_datetime);
        theSogSokSeikyuSho.Sogi_Shikijo_Name__c = pSource.sogi.shikijo_name;
        theSogSokSeikyuSho.Sogi_Kasoba_Name__c = pSource.sogi.kasoba_name;
        // 僧侶手配
        theSogSokSeikyuSho.SoryoTehai__c = pSource.soryo_tehai.tehai_umu;
        theSogSokSeikyuSho.SoryoTehai_Kaimyo__c = pSource.soryo_tehai.kaimyo;
        // 葬儀プラン
        theSogSokSeikyuSho.SogiPlan_ShohinBango__c = pSource.sogi_plan.shohin_bango;
        theSogSokSeikyuSho.SogiPlan_PlanName__c = pSource.sogi_plan.name;
        theSogSokSeikyuSho.SogiPlan_Amount__c = pSource.sogi_plan.kingaku == null ? 0 : pSource.sogi_plan.kingaku;
        theSogSokSeikyuSho.SogiPlan_ServiceId__c = pSource.sogi_plan.service_id;
        theSogSokSeikyuSho.ButsuguNashiKibo__c = pSource.sogi_plan.butsugu_kibo;
        theSogSokSeikyuSho.LastMessage__c = pSource.sogi_plan.last_message;
        theSogSokSeikyuSho.Ohanaire__c = pSource.sogi_plan.ohanaire;
        theSogSokSeikyuSho.MemorialCorner__c = pSource.sogi_plan.memorial_corner;
        theSogSokSeikyuSho.IeiHanakazari__c = pSource.sogi_plan.iei_hanakazari;
        // 支払
        theSogSokSeikyuSho.Shiharai_LoanKingaku__c = pSource.shiharai.loan_kingaku == null ? 0 : pSource.shiharai.loan_kingaku;
        theSogSokSeikyuSho.Shiharai_CreditKingaku__c = pSource.shiharai.card_kingaku == null ? 0 : pSource.shiharai.card_kingaku;
        theSogSokSeikyuSho.Shiharai_GenkinKingaku__c = pSource.shiharai.genkin_kingaku == null ? 0 : pSource.shiharai.genkin_kingaku;
        theSogSokSeikyuSho.Shiharai_MaeukeKingaku__c = pSource.shiharai.maeuke_kingaku == null ? 0 : pSource.shiharai.maeuke_kingaku;
        theSogSokSeikyuSho.Shiharai_AtobaraiGMO__c = pSource.shiharai.gmo_kingaku == null ? 0 : pSource.shiharai.gmo_kingaku;
        // 支払者
        theSogSokSeikyuSho.ShiharaiSha_Name__c = pSource.shiharaisha.name;
        theSogSokSeikyuSho.ShiharaiSha_Mail__c = pSource.shiharaisha.email;
        theSogSokSeikyuSho.ShiharaiSha_Addr_PostalCode__c = pSource.shiharaisha.addr_postal_code;
        theSogSokSeikyuSho.ShiharaiSha_Addr_State__c = pSource.shiharaisha.addr_state;
        theSogSokSeikyuSho.ShiharaiSha_Addr_City__c = pSource.shiharaisha.addr_city;
        theSogSokSeikyuSho.ShiharaiSha_Addr_Street__c = pSource.shiharaisha.addr_street;
        theSogSokSeikyuSho.ShiharaiSha_RyosyuAtena__c = pSource.shiharaisha.atena;

        // root
        theSogSokSeikyuSho.DocStatus__c = pSource.doc_status;
        theSogSokSeikyuSho.KinyuDate__c = toDateStr(pSource.kinyu_date);
        theSogSokSeikyuSho.Sign_Url__c = pSource.sign_url;
        return theSogSokSeikyuSho;
    }
    public List<SogSok_Seikyusho_TsuikaHinLine__c> createSogSokSeikyuShoTsuikaHinLines(SeikyuSho pSource, Id pSogSokSeikyuShoId){
        List<SogSok_Seikyusho_TsuikaHinLine__c> theSogSokSeikyuShoTsuikaHinLines = new List<SogSok_Seikyusho_TsuikaHinLine__c>();
        for(SeikyuSho_Tsuika_hinmokus tsuika_hinmoku : pSource.tsuika_hinmokus){
            theSogSokSeikyuShoTsuikaHinLines.add(new SogSok_Seikyusho_TsuikaHinLine__c(
                                                        SogSok_SeikyuShoRef__c = pSogSokSeikyuShoId,
                                                        HinmokuBunrui__c = tsuika_hinmoku.hinmoku_bunrui.get(0) + ';' + tsuika_hinmoku.hinmoku_bunrui.get(1),
                                                        Hinmei__c = tsuika_hinmoku.name,
                                                        UnitPrice__c = tsuika_hinmoku.unit_price == null ? 0 : tsuika_hinmoku.unit_price,
                                                        Quantity__c = tsuika_hinmoku.quantity == null ? 0 : tsuika_hinmoku.quantity,
                                                        Amount__c = tsuika_hinmoku.amount == null ? 0 : tsuika_hinmoku.amount,
                                                        ShohinBango__c = tsuika_hinmoku.shohin_bango)
                                                );
        }
        return theSogSokSeikyuShoTsuikaHinLines;
    }
    public List<SogSok_Seikyusho_WaribikiLine__c> createSogSokSeikyuShoWaribikiLines(SeikyuSho pSource, Id pSogSokSeikyuShoId){
        List<SogSok_Seikyusho_WaribikiLine__c> theSogSokSeikyuShoWaribikiLines = new List<SogSok_Seikyusho_WaribikiLine__c>();
        for(SeikyuSho_Tekiyo_waribikis tekiyo_waribiki : pSource.tekiyo_waribikis){
            theSogSokSeikyuShoWaribikiLines.add(new SogSok_Seikyusho_WaribikiLine__c(
                                                        SogSok_SeikyuShoRef__c = pSogSokSeikyuShoId,
                                                        ShohinBango__c = tekiyo_waribiki.shohin_bango,
                                                        Hinmei__c = tekiyo_waribiki.name,
                                                        UnitPrice__c = tekiyo_waribiki.unit_price == null ? 0 : tekiyo_waribiki.unit_price,
                                                        Quantity__c = tekiyo_waribiki.quantity == null ? 0 : tekiyo_waribiki.quantity,
                                                        Amount__c = tekiyo_waribiki.amount == null ? 0 : tekiyo_waribiki.amount)
                                                );
        }
        return theSogSokSeikyuShoWaribikiLines;
    }

    public SeikyuSho createSeikyuSho(SogSok_SeikyuSho__c pSource){
        SeikyuSho theSeikyuSho = new SeikyuSho();
        // root
        theSeikyuSho.soukyaku_bango = String.isBlank(pSource.SokyakuBango__c) ? '' : pSource.SokyakuBango__c;
        theSeikyuSho.shodan_bango = String.isBlank(pSource.ShodanBango__c) ? '' : pSource.ShodanBango__c;
        // 送客先
        SeikyuSho_SoukyakuSaki theSoukyakuSaki = new SeikyuSho_SoukyakuSaki();
        theSoukyakuSaki.torihikisaki_bango = String.isBlank(pSource.Soukyakusaki_TorihikisakiBango__c) ? '' : pSource.Soukyakusaki_TorihikisakiBango__c;
        theSoukyakuSaki.torihikisaki_name = String.isBlank(pSource.SoukyakuSaki_TorihikiSakiName__c) ? '' : pSource.SoukyakuSaki_TorihikiSakiName__c;
        theSoukyakuSaki.tantosha_name = String.isBlank(pSource.SoukyakuSaki_Tantosha_Name__c) ? '' : pSource.SoukyakuSaki_Tantosha_Name__c;
        theSoukyakuSaki.tantosha_tel = String.isBlank(pSource.SoukyakuSaki_Tantosha_Tel__c) ? '' : pSource.SoukyakuSaki_Tantosha_Tel__c;
        theSoukyakuSaki.tantosha_fax = String.isBlank(pSource.SoukyakuSaki_Tantosha_Fax__c) ? '' : pSource.SoukyakuSaki_Tantosha_Fax__c;
        theSeikyuSho.soukyakusaki = theSoukyakuSaki;
        // 相談者
        SeikyuSho_Sodansha theSodansha = new SeikyuSho_Sodansha();
        theSodansha.torihikisaki_bango = String.isBlank(pSource.SodanSha_TorihikiSakiBango__c) ? '' : pSource.SodanSha_TorihikiSakiBango__c;
        theSodansha.sei = String.isBlank(pSource.SodanSha_Sei__c) ? '' : pSource.SodanSha_Sei__c;
        theSodansha.mei = String.isBlank(pSource.SodanSha_Mei__c) ? '' : pSource.SodanSha_Mei__c;
        theSeikyuSho.sodansha = theSodansha;
        // 対象者
        SeikyuSho_Taishosha theTaishosha = new SeikyuSho_Taishosha();
        theTaishosha.torihikisaki_bango = String.isBlank(pSource.TaishoSha_TorihikiSakiBango__c) ? '' : pSource.TaishoSha_TorihikiSakiBango__c;
        theTaishosha.sei = String.isBlank(pSource.TaishoSha_Sei__c) ? '' : pSource.TaishoSha_Sei__c;
        theTaishosha.mei = String.isBlank(pSource.TaishoSha_Mei__c) ? '' : pSource.TaishoSha_Mei__c;
        theTaishosha.sei_kana = String.isBlank(pSource.TaishoSha_SeiKana__c) ? '' : pSource.TaishoSha_SeiKana__c;
        theTaishosha.mei_kana = String.isBlank(pSource.TaishoSha_MeiKana__c) ? '' : pSource.TaishoSha_MeiKana__c;
        theTaishosha.birth_date = toStringDate(pSource.TaishoSha_BirthDate__c);
        theTaishosha.death_date = toStringDate(pSource.TaishoSha_DeathDate__c);
        theTaishosha.age = pSource.TaishoSha_Age__c == null ? 0 : pSource.TaishoSha_Age__c;
        theTaishosha.gender = String.isBlank(pSource.TaishoSha_Gender__c) ? '' : pSource.TaishoSha_Gender__c;
        theTaishosha.addr_postal_code = String.isBlank(pSource.Taishosha_Addr_PostalCode__c) ? '' : pSource.Taishosha_Addr_PostalCode__c;
        theTaishosha.addr_state = String.isBlank(pSource.TaishoSha_Addr_State__c) ? '' : pSource.TaishoSha_Addr_State__c;
        theTaishosha.addr_city = String.isBlank(pSource.TaishoSha_Addr_City__c) ? '' : pSource.TaishoSha_Addr_City__c;
        theTaishosha.addr_street = String.isBlank(pSource.TaishoSha_Addr_Street__c) ? '' : pSource.TaishoSha_Addr_Street__c;
        theTaishosha.jumhyo_postal_code = String.isBlank(pSource.TaishoSha_JumHyo_PostalCode__c) ? '' : pSource.TaishoSha_JumHyo_PostalCode__c;
        theTaishosha.jumhyo_state = String.isBlank(pSource.TaishoSha_JumHyo_State__c) ? '' : pSource.TaishoSha_JumHyo_State__c;
        theTaishosha.jumhyo_city = String.isBlank(pSource.TaishoSha_JumHyo_City__c) ? '' : pSource.TaishoSha_JumHyo_City__c;
        theTaishosha.jumhyo_street = String.isBlank(pSource.TaishoSha_JumHyo_Street__c) ? '' : pSource.TaishoSha_JumHyo_Street__c;
        theTaishosha.shushi = String.isBlank(pSource.TaishoSha_Shushi__c) ? '' : pSource.TaishoSha_Shushi__c;
        theTaishosha.shuha = String.isBlank(pSource.TaishoSha_Shuha__c) ? '' : pSource.TaishoSha_Shuha__c;
        theTaishosha.shuha_sonotaShuha = String.isBlank(pSource.TaishoSha_Shuha_Sonota__c) ? '' : pSource.TaishoSha_Shuha_Sonota__c;
        theTaishosha.bodaiji_umu = String.isBlank(pSource.TaishoSha_Bodaiji_Umu__c) ? '' : pSource.TaishoSha_Bodaiji_Umu__c;
        theTaishosha.zokugara_from_moshu = String.isBlank(pSource.TaishoSha_ZokugaraFromMoshu__c) ? '' : pSource.TaishoSha_ZokugaraFromMoshu__c;
        theSeikyuSho.taishosha = theTaishosha;
        // 喪主
        SeikyuSho_Moshu theMoshu = new SeikyuSho_Moshu();
        //theMoshu.torihikisaki_bango = String.isBlank(pSource.Moshu_TorihikiSakiBango__c) ? '' : pSource.Moshu_TorihikiSakiBango__c;
        theMoshu.sei = String.isBlank(pSource.Moshu_Sei__c) ? '' : pSource.Moshu_Sei__c;
        theMoshu.mei = String.isBlank(pSource.Moshu_Mei__c) ? '' : pSource.Moshu_Mei__c;
        theMoshu.sei_kana = String.isBlank(pSource.Moshu_SeiKana__c) ? '' : pSource.Moshu_SeiKana__c;
        theMoshu.mei_kana = String.isBlank(pSource.Moshu_MeiKana__c) ? '' : pSource.Moshu_MeiKana__c;
        theMoshu.birth_date = toStringDate(pSource.Moshu_BirthDate__c);
        theMoshu.gender = String.isBlank(pSource.Moshu_Gender__c) ? '' : pSource.Moshu_Gender__c;
        theMoshu.phone = String.isBlank(pSource.Moshu_Phone__c) ? '' : pSource.Moshu_Phone__c;
        theMoshu.mobile = String.isBlank(pSource.Moshu_Mobile__c) ? '' : pSource.Moshu_Mobile__c;
        theMoshu.addr_postal_code = String.isBlank(pSource.Moshu_Addr_PostalCode__c) ? '' : pSource.Moshu_Addr_PostalCode__c;
        theMoshu.addr_state = String.isBlank(pSource.Moshu_Addr_State__c) ? '' : pSource.Moshu_Addr_State__c;
        theMoshu.addr_city = String.isBlank(pSource.Moshu_Addr_City__c) ? '' : pSource.Moshu_Addr_City__c;
        theMoshu.addr_street = String.isBlank(pSource.Moshu_Addr_Street__c) ? '' : pSource.Moshu_Addr_Street__c;
        theMoshu.zokugara_from_soudansha = String.isBlank(pSource.Moshu_ZokugaraFromSoudanSha__c) ? '' : pSource.Moshu_ZokugaraFromSoudanSha__c;
        theSeikyuSho.moshu = theMoshu;
        // 葬儀
        SeikyuSho_Sogi theSogi = new SeikyuSho_Sogi();
        theSogi.tsuya_datetime = toStringDatetime(pSource.Sogi_TsuyaDateTime__c);
        theSogi.kokubetsushiki_datetime = toStringDatetime(pSource.Sogi_KokubetsuDateTime__c);
        theSogi.shukkan_datetime = toStringDatetime(pSource.Sogi_ShukkanDateTime__c);
        theSogi.kaso_datetime = toStringDatetime(pSource.Sogi_KasoDateTime__c);
        theSogi.shikijo_name = String.isBlank(pSource.Sogi_Shikijo_Name__c) ? '' : pSource.Sogi_Shikijo_Name__c;
        theSogi.kasoba_name = String.isBlank(pSource.Sogi_Kasoba_Name__c) ? '' : pSource.Sogi_Kasoba_Name__c;
        theSeikyuSho.sogi = theSogi;
        // 僧侶手配
        SeikyuSho_Soryo_tehai theSoryo_tehai = new SeikyuSho_Soryo_tehai();
        theSoryo_tehai.tehai_umu = String.isBlank(pSource.SoryoTehai__c) ? '' : pSource.SoryoTehai__c;
        theSoryo_tehai.kaimyo = String.isBlank(pSource.SoryoTehai_Kaimyo__c) ? '' : pSource.SoryoTehai_Kaimyo__c;
        theSeikyuSho.soryo_tehai = theSoryo_tehai;
        // 葬儀プラン
        SeikyuSho_Sogi_plan theSogi_plan = new SeikyuSho_Sogi_plan();
        theSogi_plan.shohin_bango = String.isBlank(pSource.SogiPlan_ShohinBango__c) ? '' : pSource.SogiPlan_ShohinBango__c;
        theSogi_plan.name = String.isBlank(pSource.SogiPlan_PlanName__c) ? '' : pSource.SogiPlan_PlanName__c;
        theSogi_plan.kingaku = pSource.SogiPlan_Amount__c == null ? 0 : pSource.SogiPlan_Amount__c;
        theSogi_plan.service_id = String.isBlank(pSource.SogiPlan_ServiceId__c) ? '' : pSource.SogiPlan_ServiceId__c;
        theSogi_plan.butsugu_kibo = String.isBlank(pSource.ButsuguNashiKibo__c) ? '' : pSource.ButsuguNashiKibo__c;
        theSogi_plan.last_message = String.isBlank(pSource.LastMessage__c) ? '' : pSource.LastMessage__c;
        theSogi_plan.ohanaire = String.isBlank(pSource.Ohanaire__c) ? '' : pSource.Ohanaire__c;
        theSogi_plan.memorial_corner = String.isBlank(pSource.MemorialCorner__c) ? '' : pSource.MemorialCorner__c;
        theSogi_plan.iei_hanakazari = String.isBlank(pSource.IeiHanakazari__c) ? '' : pSource.IeiHanakazari__c;
        theSeikyuSho.sogi_plan = theSogi_plan;
        // 追加品目
        List<SeikyuSho_Tsuika_hinmokus> theTsuika_hinmokus = new List<SeikyuSho_Tsuika_hinmokus>();
        for(SogSok_Seikyusho_TsuikaHinLine__c tempTsuika_hinmoku : pSource.SogSok_Seikyusho_TsuikaHinLines__r){
            SeikyuSho_Tsuika_hinmokus theTsuika_hinmoku = new SeikyuSho_Tsuika_hinmokus();
            theTsuika_hinmoku.hinmoku_bunrui = String.isBlank(tempTsuika_hinmoku.HinmokuBunrui__c) ? null : tempTsuika_hinmoku.HinmokuBunrui__c.split(';');
            theTsuika_hinmoku.hinmoku_bunrui_name = tempTsuika_hinmoku.HinmokuBunrui__c;
            theTsuika_hinmoku.name = String.isBlank(tempTsuika_hinmoku.Hinmei__c) ? '' : tempTsuika_hinmoku.Hinmei__c;
            theTsuika_hinmoku.unit_price = tempTsuika_hinmoku.UnitPrice__c == null ? 0 : tempTsuika_hinmoku.UnitPrice__c;
            theTsuika_hinmoku.quantity = tempTsuika_hinmoku.Quantity__c == null ? 0 : tempTsuika_hinmoku.Quantity__c;
            theTsuika_hinmoku.amount = tempTsuika_hinmoku.Amount__c == null ? 0 : tempTsuika_hinmoku.Amount__c;
            theTsuika_hinmoku.shohin_bango = String.isBlank(tempTsuika_hinmoku.ShohinBango__c) ? '' : tempTsuika_hinmoku.ShohinBango__c;
            theTsuika_hinmokus.add(theTsuika_hinmoku);
        }
        theSeikyuSho.tsuika_hinmokus = theTsuika_hinmokus;
        // 適用割引
        List<SeikyuSho_Tekiyo_waribikis> theTekiyo_waribikis = new List<SeikyuSho_Tekiyo_waribikis>();
        for(SogSok_Seikyusho_WaribikiLine__c tempTekiyo_waribiki : pSource.SogSok_Seikyusho_WaribikiLines__r){
            SeikyuSho_Tekiyo_waribikis theTekiyo_waribiki = new SeikyuSho_Tekiyo_waribikis();
            theTekiyo_waribiki.shohin_bango = String.isBlank(tempTekiyo_waribiki.ShohinBango__c) ? '' : tempTekiyo_waribiki.ShohinBango__c;
            theTekiyo_waribiki.name = String.isBlank(tempTekiyo_waribiki.Hinmei__c) ? '' : tempTekiyo_waribiki.Hinmei__c;
            theTekiyo_waribiki.unit_price = tempTekiyo_waribiki.UnitPrice__c == null ? 0 : tempTekiyo_waribiki.UnitPrice__c;
            theTekiyo_waribiki.quantity = tempTekiyo_waribiki.Quantity__c == null ? 0 : tempTekiyo_waribiki.Quantity__c;
            theTekiyo_waribiki.amount = tempTekiyo_waribiki.Amount__c == null ? 0 : tempTekiyo_waribiki.Amount__c;
            theTekiyo_waribikis.add(theTekiyo_waribiki);
        }
        theSeikyuSho.tekiyo_waribikis = theTekiyo_waribikis;
        // 支払
        SeikyuSho_Shiharai theShiharai = new SeikyuSho_Shiharai();
        theShiharai.loan_kingaku = pSource.Shiharai_LoanKingaku__c == null ? 0 : pSource.Shiharai_LoanKingaku__c;
        theShiharai.card_kingaku = pSource.Shiharai_CreditKingaku__c == null ? 0 : pSource.Shiharai_CreditKingaku__c;
        theShiharai.genkin_kingaku = pSource.Shiharai_GenkinKingaku__c == null ? 0 : pSource.Shiharai_GenkinKingaku__c;
        theShiharai.maeuke_kingaku = pSource.Shiharai_MaeukeKingaku__c == null ? 0 : pSource.Shiharai_MaeukeKingaku__c;
        theShiharai.gmo_kingaku = pSource.Shiharai_AtobaraiGMO__c == null ? 0 : pSource.Shiharai_AtobaraiGMO__c;
        theSeikyuSho.shiharai = theShiharai;
        // 支払者
        SeikyuSho_Shiharaisha theShiharaisha = new SeikyuSho_Shiharaisha();
        theShiharaisha.name = String.isBlank(pSource.ShiharaiSha_Name__c) ? '' : pSource.ShiharaiSha_Name__c;
        theShiharaisha.email = String.isBlank(pSource.ShiharaiSha_Mail__c) ? '' : pSource.ShiharaiSha_Mail__c;
        theShiharaisha.addr_postal_code = String.isBlank(pSource.ShiharaiSha_Addr_PostalCode__c) ? '' : pSource.ShiharaiSha_Addr_PostalCode__c;
        theShiharaisha.addr_state = String.isBlank(pSource.ShiharaiSha_Addr_State__c) ? '' : pSource.ShiharaiSha_Addr_State__c;
        theShiharaisha.addr_city = String.isBlank(pSource.ShiharaiSha_Addr_City__c) ? '' : pSource.ShiharaiSha_Addr_City__c;
        theShiharaisha.addr_street = String.isBlank(pSource.ShiharaiSha_Addr_Street__c) ? '' : pSource.ShiharaiSha_Addr_Street__c;
        theShiharaisha.atena = String.isBlank(pSource.ShiharaiSha_RyosyuAtena__c) ? '' : pSource.ShiharaiSha_RyosyuAtena__c;
        theSeikyuSho.shiharaisha = theShiharaisha;

        // root
        theSeikyuSho.lastupdatetime = pSource.LastModifiedDate == null ? '' : pSource.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
        theSeikyuSho.doc_status = String.isBlank(pSource.DocStatus__c) ? '' : pSource.DocStatus__c;
        theSeikyuSho.kinyu_date = toStringDate(pSource.KinyuDate__c);
        theSeikyuSho.sign_url = String.isBlank(pSource.Sign_Url__c) ? '' : pSource.Sign_Url__c;
        return theSeikyuSho;
    }

    public SeikyuSho selectSeikyuShoBySoukyakuBango(String pSoukyakuBango){
        List<SogSok_Sokyaku__c> theSogSokSokyakus =[
            select Id, SeikyuShoRef__c from SogSok_Sokyaku__c where Name = :pSoukyakuBango Limit 1
        ];
        if( theSogSokSokyakus.size() <= 0 ) return null;
        SogSok_Sokyaku__c theSogSokSokyaku = theSogSokSokyakus.get(0);
        if( theSogSokSokyaku.SeikyuShoRef__c == null ) return null;

        List<SogSok_SeikyuSho__c> theSogSokSeikyuShos = [
            select Id,
            Name,
            LastModifiedDate,
            SokyakuBango__c,
            ShodanBango__c,
            Soukyakusaki_TorihikisakiBango__c,
            SoukyakuSaki_TorihikiSakiName__c,
            SoukyakuSaki_Tantosha_Name__c,
            SoukyakuSaki_Tantosha_Tel__c,
            SoukyakuSaki_Tantosha_Fax__c,
            KinyuDate__c,
            SodanSha_TorihikiSakiBango__c,
            SodanSha_Sei__c,
            SodanSha_Mei__c,
            TaishoSha_TorihikiSakiBango__c,
            TaishoSha_Sei__c,
            TaishoSha_Mei__c,
            TaishoSha_SeiKana__c,
            TaishoSha_MeiKana__c,
            TaishoSha_BirthDate__c,
            TaishoSha_DeathDate__c,
            TaishoSha_Age__c,
            TaishoSha_Gender__c,
            Taishosha_Addr_PostalCode__c,
            TaishoSha_Addr_State__c,
            TaishoSha_Addr_City__c,
            TaishoSha_Addr_Street__c,
            TaishoSha_JumHyo_PostalCode__c,
            TaishoSha_JumHyo_State__c,
            TaishoSha_JumHyo_City__c,
            TaishoSha_JumHyo_Street__c,
            TaishoSha_Shushi__c,
            TaishoSha_Shuha__c,
            Moshu_TorihikiSakiBango__c,
            Moshu_Sei__c,
            Moshu_Mei__c,
            Moshu_SeiKana__c,
            Moshu_MeiKana__c,
            Moshu_BirthDate__c,
            Moshu_Gender__c,
            Moshu_Phone__c,
            Moshu_Mobile__c,
            Moshu_Addr_PostalCode__c,
            Moshu_Addr_State__c,
            Moshu_Addr_City__c,
            Moshu_Addr_Street__c,
            Moshu_ZokugaraFromSoudanSha__c,
            SogiPlan_ShohinBango__c,
            SogiPlan_PlanName__c,
            SogiPlan_ServiceId__c,
            SogiPlan_Amount__c,
            ButsuguNashiKibo__c,
            LastMessage__c,
            Ohanaire__c,
            MemorialCorner__c,
            IeiHanakazari__c,
            Sogi_TsuyaDateTime__c,
            Sogi_KokubetsuDateTime__c,
            Sogi_ShukkanDateTime__c,
            Sogi_KasoDateTime__c,
            Sogi_Shikijo_Name__c,
            Sogi_Kasoba_Name__c,
            Shiharai_MaeukeKingaku__c,
            Shiharai_LoanKingaku__c,
            Shiharai_CreditKingaku__c,
            Shiharai_GenkinKingaku__c,
            Shiharai_AtobaraiGMO__c,
            SoryoTehai__c,
            SoryoTehai_Kaimyo__c,
            ShiharaiSha_Name__c, ShiharaiSha_Mail__c,
            ShiharaiSha_Addr_PostalCode__c, ShiharaiSha_Addr_State__c, ShiharaiSha_Addr_City__c, ShiharaiSha_Addr_Street__c,
            ShiharaiSha_RyosyuAtena__c,
            DocStatus__c,
            TaishoSha_Shuha_Sonota__c,
            TaishoSha_Bodaiji_Umu__c,
            TaishoSha_ZokugaraFromMoshu__c,
            Sign_Url__c,
            (
                select 
                    Id,
                    IsDeleted,
                    Name,
                    ShohinBango__c, 
                    CreatedDate,
                    CreatedById,
                    LastModifiedDate,
                    LastModifiedById,
                    SystemModstamp,
                    SogSok_SeikyuShoRef__c,
                    HinmokuBunrui__c,
                    Hinmei__c,
                    UnitPrice__c,
                    Quantity__c,
                    Amount__c
                FROM SogSok_Seikyusho_TsuikaHinLines__r
            ),
            (
                select 
                    Id,
                    IsDeleted,
                    Name,
                    CreatedDate,
                    CreatedById,
                    LastModifiedDate,
                    LastModifiedById,
                    SystemModstamp,
                    ShohinBango__c,
                    Hinmei__c,
                    UnitPrice__c,
                    Quantity__c,
                    Amount__c,
                    SogSok_SeikyuShoRef__c
                FROM SogSok_Seikyusho_WaribikiLines__r
            )
            from SogSok_SeikyuSho__c where Id = :theSogSokSokyaku.SeikyuShoRef__c
            limit 1
        ];
        return theSogSokSeikyuShos.size() <= 0 ? null : this.createSeikyuSho( theSogSokSeikyuShos.get(0) );
    }

    private Date toDateStr(String pStr){
        return String.isBlank(pStr) ? null : Date.valueOf(pStr);
    }

    private Datetime toDatetimeStr(String pStr){
        return String.isBlank(pStr) ? null : Datetime.valueOf(pStr);
    }

    private String toStringDate(Date pDate){
         return pDate == null ? '' : pDate.format().replace('/', '-');
    }

    private String toStringDatetime(Datetime pDatetime){
         return pDatetime == null ? '' : String.valueOf(pDatetime);
    }
}