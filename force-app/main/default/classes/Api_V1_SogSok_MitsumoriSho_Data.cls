public class Api_V1_SogSok_MitsumoriSho_Data {

    public class MitsumoriSho{
        public String soukyaku_bango = '';
        public String shodan_bango = '';
        public MitsumoriSho_SoukyakuSaki soukyakusaki = new MitsumoriSho_SoukyakuSaki();
        public MitsumoriSho_Sodansha sodansha = new MitsumoriSho_Sodansha();
        public MitsumoriSho_Taishosha taishosha = new MitsumoriSho_Taishosha();
        public MitsumoriSho_Moshu moshu = new MitsumoriSho_Moshu();
        public MitsumoriSho_Sogi sogi = new MitsumoriSho_Sogi();
        public MitsumoriSho_Soryo_tehai soryo_tehai = new MitsumoriSho_Soryo_tehai();
        public MitsumoriSho_Sogi_plan sogi_plan = new MitsumoriSho_Sogi_plan();
        public List<MitsumoriSho_Tsuika_hinmokus> tsuika_hinmokus = new List<MitsumoriSho_Tsuika_hinmokus>();
        public List<MitsumoriSho_Tekiyo_waribikis> tekiyo_waribikis = new List<MitsumoriSho_Tekiyo_waribikis>();
        public MitsumoriSho_Shiharai shiharai = new MitsumoriSho_Shiharai();
        public MitsumoriSho_Shiharaisha shiharaisha = new MitsumoriSho_Shiharaisha();
        public MitsumoriSho_Yoriso_Option_Kibo yoriso_option_kibo = new MitsumoriSho_Yoriso_Option_Kibo();
        public String lastupdatetime = '';
        public String doc_status = '';
        public String kinyu_date = '';
        public String sign_url = '';
        public String uchiawase_datetime = '';
    }
    public class MitsumoriSho_SoukyakuSaki{
        public String torihikisaki_bango = '';
        public String torihikisaki_name = '';
        public String tantosha_name = '';
        public String tantosha_tel = '';
        public String tantosha_fax = '';
    }
    public class MitsumoriSho_Sodansha{
        public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
    }
    public class MitsumoriSho_Taishosha{
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
    public class MitsumoriSho_Moshu{
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
    public class MitsumoriSho_Sogi{
        public String tsuya_datetime = '';
        public String kokubetsushiki_datetime = '';
        public String shukkan_datetime = '';
        public String kaso_datetime = '';
        public String shikijo_name = '';
        public String kasoba_name = '';
    }
    public class MitsumoriSho_Soryo_tehai{
        public String tehai_umu = '';
        public String kaimyo = '';
    }
    public class MitsumoriSho_Sogi_plan{
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
    public class MitsumoriSho_Tsuika_hinmokus{
        public List<String> hinmoku_bunrui = new List<String>();
        public String hinmoku_bunrui_name = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
        public String shohin_bango = '';
    }
    public class MitsumoriSho_Tekiyo_waribikis{
        public String shohin_bango = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
    }
    public class MitsumoriSho_Shiharai{
        public Decimal loan_kingaku = 0;
        public Decimal card_kingaku = 0;
        public Decimal genkin_kingaku = 0;
        public Decimal maeuke_kingaku = 0;
        public Decimal gmo_kingaku = 0;
    }
    public class MitsumoriSho_Shiharaisha{
        public String name = '';
        public String email = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String atena = '';
    }
    public class MitsumoriSho_Yoriso_Option_Kibo {
        public String saidan = '';
        public String owakare_bana = '';
        public String kanjo_hanataba = '';
        public String makura_bana = '';
    }

    public SogSok_MitsumoriSho__c createSogSokMitsumoriSho(MitsumoriSho pSource){
        SogSok_MitsumoriSho__c theSogSokMitsumoriSho = new SogSok_MitsumoriSho__c();

        theSogSokMitsumoriSho.JuryoDateTime__c = Datetime.now();
        // root
        theSogSokMitsumoriSho.SokyakuBango__c = pSource.soukyaku_bango;
        theSogSokMitsumoriSho.ShodanBango__c = pSource.shodan_bango;
        // 送客先
        theSogSokMitsumoriSho.Soukyakusaki_TorihikisakiBango__c = pSource.soukyakusaki.torihikisaki_bango;
        theSogSokMitsumoriSho.SoukyakuSaki_TorihikiSakiName__c = pSource.soukyakusaki.torihikisaki_name;
        theSogSokMitsumoriSho.SoukyakuSaki_Tantosha_Name__c = pSource.soukyakusaki.tantosha_name;
        theSogSokMitsumoriSho.SoukyakuSaki_Tantosha_Tel__c = pSource.soukyakusaki.tantosha_tel;
        theSogSokMitsumoriSho.SoukyakuSaki_Tantosha_Fax__c = pSource.soukyakusaki.tantosha_fax;
        // 相談者
        theSogSokMitsumoriSho.SodanSha_TorihikiSakiBango__c = pSource.sodansha.torihikisaki_bango;
        theSogSokMitsumoriSho.SodanSha_Sei__c = pSource.sodansha.sei;
        theSogSokMitsumoriSho.SodanSha_Mei__c = pSource.sodansha.mei;
        // 対象者
        theSogSokMitsumoriSho.TaishoSha_TorihikiSakiBango__c = pSource.taishosha.torihikisaki_bango;
        theSogSokMitsumoriSho.TaishoSha_Sei__c = pSource.taishosha.sei;
        theSogSokMitsumoriSho.TaishoSha_Mei__c = pSource.taishosha.mei;
        theSogSokMitsumoriSho.TaishoSha_SeiKana__c = pSource.taishosha.sei_kana;
        theSogSokMitsumoriSho.TaishoSha_MeiKana__c = pSource.taishosha.mei_kana;
        theSogSokMitsumoriSho.TaishoSha_BirthDate__c =  toDateStr(pSource.taishosha.birth_date);

        theSogSokMitsumoriSho.TaishoSha_DeathDate__c = toDateStr(pSource.taishosha.death_date);
        theSogSokMitsumoriSho.TaishoSha_Age__c = pSource.taishosha.age == null ? 0 : pSource.taishosha.age;
        theSogSokMitsumoriSho.TaishoSha_Gender__c = pSource.taishosha.gender;
        theSogSokMitsumoriSho.Taishosha_Addr_PostalCode__c = pSource.taishosha.addr_postal_code;
        theSogSokMitsumoriSho.TaishoSha_Addr_State__c = pSource.taishosha.addr_state;
        theSogSokMitsumoriSho.TaishoSha_Addr_City__c = pSource.taishosha.addr_city;
        theSogSokMitsumoriSho.TaishoSha_Addr_Street__c = pSource.taishosha.addr_street;
        theSogSokMitsumoriSho.TaishoSha_JumHyo_PostalCode__c = pSource.taishosha.jumhyo_postal_code;
        theSogSokMitsumoriSho.TaishoSha_JumHyo_State__c = pSource.taishosha.jumhyo_state;
        theSogSokMitsumoriSho.TaishoSha_JumHyo_City__c = pSource.taishosha.jumhyo_city;
        theSogSokMitsumoriSho.TaishoSha_JumHyo_Street__c = pSource.taishosha.jumhyo_street;
        theSogSokMitsumoriSho.TaishoSha_Shushi__c = pSource.taishosha.shushi;
        theSogSokMitsumoriSho.TaishoSha_Shuha__c = pSource.taishosha.shuha;
        theSogSokMitsumoriSho.TaishoSha_Shuha_Sonota__c = pSource.taishosha.shuha_sonotaShuha;
        theSogSokMitsumoriSho.TaishoSha_Bodaiji_Umu__c = pSource.taishosha.bodaiji_umu;
        theSogSokMitsumoriSho.TaishoSha_ZokugaraFromMoshu__c = pSource.taishosha.zokugara_from_moshu;
        
        // 喪主
        theSogSokMitsumoriSho.Moshu_Sei__c = pSource.moshu.sei;
        theSogSokMitsumoriSho.Moshu_Mei__c = pSource.moshu.mei;
        theSogSokMitsumoriSho.Moshu_SeiKana__c = pSource.moshu.sei_kana;
        theSogSokMitsumoriSho.Moshu_MeiKana__c = pSource.moshu.mei_kana;
        theSogSokMitsumoriSho.Moshu_BirthDate__c = toDateStr(pSource.moshu.birth_date);
        
        //theSogSokMitsumoriSho.Moshu_Age__c = pSource.moshu.age == null ? 0 : pSource.moshu.age;
        theSogSokMitsumoriSho.Moshu_Gender__c = pSource.moshu.gender;
        theSogSokMitsumoriSho.Moshu_Phone__c = pSource.moshu.phone;
        theSogSokMitsumoriSho.Moshu_Mobile__c = pSource.moshu.mobile;
        theSogSokMitsumoriSho.Moshu_Addr_PostalCode__c = pSource.moshu.addr_postal_code;
        theSogSokMitsumoriSho.Moshu_Addr_State__c = pSource.moshu.addr_state;
        theSogSokMitsumoriSho.Moshu_Addr_City__c = pSource.moshu.addr_city;
        theSogSokMitsumoriSho.Moshu_Addr_Street__c = pSource.moshu.addr_street;
        theSogSokMitsumoriSho.Moshu_ZokugaraFromSoudanSha__c = pSource.moshu.zokugara_from_soudansha;

        // 葬儀
        theSogSokMitsumoriSho.Sogi_TsuyaDateTime__c = toDatetimeStr(pSource.sogi.tsuya_datetime);
        theSogSokMitsumoriSho.Sogi_KokubetsuDateTime__c = toDatetimeStr(pSource.sogi.kokubetsushiki_datetime);
        theSogSokMitsumoriSho.Sogi_ShukkanDateTime__c = toDatetimeStr(pSource.sogi.shukkan_datetime);
        theSogSokMitsumoriSho.Sogi_KasoDateTime__c = toDatetimeStr(pSource.sogi.kaso_datetime);
        theSogSokMitsumoriSho.Sogi_Shikijo_Name__c = pSource.sogi.shikijo_name;
        theSogSokMitsumoriSho.Sogi_Kasoba_Name__c = pSource.sogi.kasoba_name;

        // 僧侶手配
        theSogSokMitsumoriSho.SoryoTehai__c = pSource.soryo_tehai.tehai_umu;
        theSogSokMitsumoriSho.SoryoTehai_Kaimyo__c = pSource.soryo_tehai.kaimyo;
        // 葬儀プラン
        theSogSokMitsumoriSho.SogiPlan_ShohinBango__c = pSource.sogi_plan.shohin_bango;
        theSogSokMitsumoriSho.SogiPlan_PlanName__c = pSource.sogi_plan.name;
        theSogSokMitsumoriSho.SogiPlan_Amount__c = pSource.sogi_plan.kingaku == null ? 0 : pSource.sogi_plan.kingaku;
        theSogSokMitsumoriSho.SogiPlan_ServiceId__c = pSource.sogi_plan.service_id;
        theSogSokMitsumoriSho.ButsuguNashiKibo__c = pSource.sogi_plan.butsugu_kibo;
        theSogSokMitsumoriSho.LastMessage__c = pSource.sogi_plan.last_message;
        theSogSokMitsumoriSho.Ohanaire__c = pSource.sogi_plan.ohanaire;
        theSogSokMitsumoriSho.MemorialCorner__c = pSource.sogi_plan.memorial_corner;
        theSogSokMitsumoriSho.IeiHanakazari__c = pSource.sogi_plan.iei_hanakazari;

        // 支払
        theSogSokMitsumoriSho.Shiharai_LoanKingaku__c = pSource.shiharai.loan_kingaku == null ? 0 : pSource.shiharai.loan_kingaku;
        theSogSokMitsumoriSho.Shiharai_CreditKingaku__c = pSource.shiharai.card_kingaku == null ? 0 : pSource.shiharai.card_kingaku;
        theSogSokMitsumoriSho.Shiharai_GenkinKingaku__c = pSource.shiharai.genkin_kingaku == null ? 0 : pSource.shiharai.genkin_kingaku;
        theSogSokMitsumoriSho.Shiharai_MaeukeKingaku__c = pSource.shiharai.maeuke_kingaku == null ? 0 : pSource.shiharai.maeuke_kingaku;
        theSogSokMitsumoriSho.Shiharai_AtobaraiGMO__c = pSource.shiharai.gmo_kingaku == null ? 0 : pSource.shiharai.gmo_kingaku;
        // 支払者
        theSogSokMitsumoriSho.ShiharaiSha_Name__c = pSource.shiharaisha.name;
        theSogSokMitsumoriSho.ShiharaiSha_Mail__c = pSource.shiharaisha.email;
        theSogSokMitsumoriSho.ShiharaiSha_Addr_PostalCode__c = pSource.shiharaisha.addr_postal_code;
        theSogSokMitsumoriSho.ShiharaiSha_Addr_State__c = pSource.shiharaisha.addr_state;
        theSogSokMitsumoriSho.ShiharaiSha_Addr_City__c = pSource.shiharaisha.addr_city;
        theSogSokMitsumoriSho.ShiharaiSha_Addr_Street__c = pSource.shiharaisha.addr_street;
        theSogSokMitsumoriSho.ShiharaiSha_RyosyuAtena__c = pSource.shiharaisha.atena;
        // よりそうオプション希望
        theSogSokMitsumoriSho.SaidanKibo__c = pSource.yoriso_option_kibo.saidan;
        theSogSokMitsumoriSho.KagobanaKibo__c = pSource.yoriso_option_kibo.owakare_bana;
        theSogSokMitsumoriSho.KanjoHanatabaKibo__c = pSource.yoriso_option_kibo.kanjo_hanataba;
        theSogSokMitsumoriSho.MakurabanaKibo__c = pSource.yoriso_option_kibo.makura_bana;
        // root
        theSogSokMitsumoriSho.DocStatus__c = pSource.doc_status;
        theSogSokMitsumoriSho.KinyuDate__c = toDateStr(pSource.kinyu_date);
        theSogSokMitsumoriSho.Sign_Url__c = pSource.sign_url;
        theSogSokMitsumoriSho.UchiawaseDateTime__c = toDatetimeStr(pSource.uchiawase_datetime);
        return theSogSokMitsumoriSho;
    }
    public List<SogSok_Mitsumorisho_TsuikaHinLine__c> createSogSokMitsumoriShoTsuikaHinLines(MitsumoriSho pSource, Id pSogSokMitsumoriShoId){
        List<SogSok_Mitsumorisho_TsuikaHinLine__c> theSogSokMitsumoriShoTsuikaHinLines = new List<SogSok_Mitsumorisho_TsuikaHinLine__c>();
        for(MitsumoriSho_Tsuika_hinmokus tsuika_hinmoku : pSource.tsuika_hinmokus){
            theSogSokMitsumoriShoTsuikaHinLines.add(new SogSok_Mitsumorisho_TsuikaHinLine__c(
                                                        MitsumoriShoRef__c = pSogSokMitsumoriShoId,
                                                        HinmokuBunrui__c = tsuika_hinmoku.hinmoku_bunrui.get(0) + ';' + tsuika_hinmoku.hinmoku_bunrui.get(1),
                                                        Hinmei__c = tsuika_hinmoku.name,
                                                        UnitPrice__c = tsuika_hinmoku.unit_price == null ? 0 : tsuika_hinmoku.unit_price,
                                                        Quantity__c = tsuika_hinmoku.quantity == null ? 0 : tsuika_hinmoku.quantity,
                                                        Amount__c = tsuika_hinmoku.amount == null ? 0 : tsuika_hinmoku.amount,
                                                        ShohinBango__c = tsuika_hinmoku.shohin_bango)
                                                );
        }
        return theSogSokMitsumoriShoTsuikaHinLines;
    }
    public List<SogSok_Mitsumorisho_WaribikiLine__c> createSogSokMitsumoriShoWaribikiLines(MitsumoriSho pSource, Id pSogSokMitsumoriShoId){
        List<SogSok_Mitsumorisho_WaribikiLine__c> theSogSokMitsumoriShoWaribikiLines = new List<SogSok_Mitsumorisho_WaribikiLine__c>();
        for(MitsumoriSho_Tekiyo_waribikis tekiyo_waribiki : pSource.tekiyo_waribikis){
            theSogSokMitsumoriShoWaribikiLines.add(new SogSok_Mitsumorisho_WaribikiLine__c(
                                                        MitsumoriShoRef__c = pSogSokMitsumoriShoId,
                                                        ShohinBango__c = tekiyo_waribiki.shohin_bango,
                                                        Hinmei__c = tekiyo_waribiki.name,
                                                        UnitPrice__c = tekiyo_waribiki.unit_price == null ? 0 : tekiyo_waribiki.unit_price,
                                                        Quantity__c = tekiyo_waribiki.quantity == null ? 0 : tekiyo_waribiki.quantity,
                                                        Amount__c = tekiyo_waribiki.amount == null ? 0 : tekiyo_waribiki.amount
                                                        )
                                                );
        }
        return theSogSokMitsumoriShoWaribikiLines;
    }

    public MitsumoriSho createMitsumoriSho(SogSok_MitsumoriSho__c pSource){
        MitsumoriSho theMitsumoriSho = new MitsumoriSho();
        // root
        theMitsumoriSho.soukyaku_bango = String.isBlank(pSource.SokyakuBango__c) ? '' : pSource.SokyakuBango__c;
        theMitsumoriSho.shodan_bango = String.isBlank(pSource.ShodanBango__c) ? '' : pSource.ShodanBango__c;
        // 送客先
        MitsumoriSho_SoukyakuSaki theSoukyakuSaki = new MitsumoriSho_SoukyakuSaki();
        theSoukyakuSaki.torihikisaki_bango = String.isBlank(pSource.Soukyakusaki_TorihikisakiBango__c) ? '' : pSource.Soukyakusaki_TorihikisakiBango__c;
        theSoukyakuSaki.torihikisaki_name = String.isBlank(pSource.SoukyakuSaki_TorihikiSakiName__c) ? '' : pSource.SoukyakuSaki_TorihikiSakiName__c;
        theSoukyakuSaki.tantosha_name = String.isBlank(pSource.SoukyakuSaki_Tantosha_Name__c) ? '' : pSource.SoukyakuSaki_Tantosha_Name__c;
        theSoukyakuSaki.tantosha_tel = String.isBlank(pSource.SoukyakuSaki_Tantosha_Tel__c) ? '' : pSource.SoukyakuSaki_Tantosha_Tel__c;
        theSoukyakuSaki.tantosha_fax = String.isBlank(pSource.SoukyakuSaki_Tantosha_Fax__c) ? '' : pSource.SoukyakuSaki_Tantosha_Fax__c;
        theMitsumoriSho.soukyakusaki = theSoukyakuSaki;
        // 相談者
        MitsumoriSho_Sodansha theSodansha = new MitsumoriSho_Sodansha();
        theSodansha.torihikisaki_bango = String.isBlank(pSource.SodanSha_TorihikiSakiBango__c) ? '' : pSource.SodanSha_TorihikiSakiBango__c;
        theSodansha.sei = String.isBlank(pSource.SodanSha_Sei__c) ? '' : pSource.SodanSha_Sei__c;
        theSodansha.mei = String.isBlank(pSource.SodanSha_Mei__c) ? '' : pSource.SodanSha_Mei__c;
        theMitsumoriSho.sodansha = theSodansha;
        // 対象者
        MitsumoriSho_Taishosha theTaishosha = new MitsumoriSho_Taishosha();
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
        theMitsumoriSho.taishosha = theTaishosha;
        // 喪主
        MitsumoriSho_Moshu theMoshu = new MitsumoriSho_Moshu();
        theMoshu.sei = String.isBlank(pSource.Moshu_Sei__c) ? '' : pSource.Moshu_Sei__c;
        theMoshu.mei = String.isBlank(pSource.Moshu_Mei__c) ? '' : pSource.Moshu_Mei__c;
        theMoshu.sei_kana = String.isBlank(pSource.Moshu_SeiKana__c) ? '' : pSource.Moshu_SeiKana__c;
        theMoshu.mei_kana = String.isBlank(pSource.Moshu_MeiKana__c) ? '' : pSource.Moshu_MeiKana__c;
        theMoshu.birth_date = toStringDate(pSource.Moshu_BirthDate__c);
        //theMoshu.age = pSource.Moshu_Age__c == null ? 0 : pSource.Moshu_Age__c;
        theMoshu.gender = String.isBlank(pSource.Moshu_Gender__c) ? '' : pSource.Moshu_Gender__c;
        theMoshu.phone = String.isBlank(pSource.Moshu_Phone__c) ? '' : pSource.Moshu_Phone__c;
        theMoshu.mobile = String.isBlank(pSource.Moshu_Mobile__c) ? '' : pSource.Moshu_Mobile__c;
        theMoshu.addr_postal_code = String.isBlank(pSource.Moshu_Addr_PostalCode__c) ? '' : pSource.Moshu_Addr_PostalCode__c;
        theMoshu.addr_state = String.isBlank(pSource.Moshu_Addr_State__c) ? '' : pSource.Moshu_Addr_State__c;
        theMoshu.addr_city = String.isBlank(pSource.Moshu_Addr_City__c) ? '' : pSource.Moshu_Addr_City__c;
        theMoshu.addr_street = String.isBlank(pSource.Moshu_Addr_Street__c) ? '' : pSource.Moshu_Addr_Street__c;
        theMoshu.zokugara_from_soudansha = String.isBlank(pSource.Moshu_ZokugaraFromSoudanSha__c) ? '' : pSource.Moshu_ZokugaraFromSoudanSha__c;
        theMitsumoriSho.moshu = theMoshu;
        // 葬儀
        MitsumoriSho_Sogi theSogi = new MitsumoriSho_Sogi();
        theSogi.tsuya_datetime = toStringDatetime(pSource.Sogi_TsuyaDateTime__c);
        theSogi.kokubetsushiki_datetime = toStringDatetime(pSource.Sogi_KokubetsuDateTime__c);
        theSogi.shukkan_datetime = toStringDatetime(pSource.Sogi_ShukkanDateTime__c);
        theSogi.kaso_datetime = toStringDatetime(pSource.Sogi_KasoDateTime__c);
        theSogi.shikijo_name = String.isBlank(pSource.Sogi_Shikijo_Name__c) ? '' : pSource.Sogi_Shikijo_Name__c;
        theSogi.kasoba_name = String.isBlank(pSource.Sogi_Kasoba_Name__c) ? '' : pSource.Sogi_Kasoba_Name__c;
        theMitsumoriSho.sogi = theSogi;
        // 僧侶手配
        MitsumoriSho_Soryo_tehai theSoryo_tehai = new MitsumoriSho_Soryo_tehai();
        theSoryo_tehai.tehai_umu = String.isBlank(pSource.SoryoTehai__c) ? '' : pSource.SoryoTehai__c;
        theSoryo_tehai.kaimyo = String.isBlank(pSource.SoryoTehai_Kaimyo__c) ? '' : pSource.SoryoTehai_Kaimyo__c;
        theMitsumoriSho.soryo_tehai = theSoryo_tehai;
        // 葬儀プラン
        MitsumoriSho_Sogi_plan theSogi_plan = new MitsumoriSho_Sogi_plan();
        theSogi_plan.shohin_bango = String.isBlank(pSource.SogiPlan_ShohinBango__c) ? '' : pSource.SogiPlan_ShohinBango__c;
        theSogi_plan.name = String.isBlank(pSource.SogiPlan_PlanName__c) ? '' : pSource.SogiPlan_PlanName__c;
        theSogi_plan.kingaku = pSource.SogiPlan_Amount__c == null ? 0 : pSource.SogiPlan_Amount__c;
        theSogi_plan.service_id = String.isBlank(pSource.SogiPlan_ServiceId__c) ? '' : pSource.SogiPlan_ServiceId__c;
        theSogi_plan.butsugu_kibo = String.isBlank(pSource.ButsuguNashiKibo__c) ? '' : pSource.ButsuguNashiKibo__c;
        theSogi_plan.last_message = String.isBlank(pSource.LastMessage__c) ? '' : pSource.LastMessage__c;
        theSogi_plan.ohanaire = String.isBlank(pSource.Ohanaire__c) ? '' : pSource.Ohanaire__c;
        theSogi_plan.memorial_corner = String.isBlank(pSource.MemorialCorner__c) ? '' : pSource.MemorialCorner__c;
        theSogi_plan.iei_hanakazari = String.isBlank(pSource.IeiHanakazari__c) ? '' : pSource.IeiHanakazari__c;
        theMitsumoriSho.sogi_plan = theSogi_plan;
        // 追加品目
        List<MitsumoriSho_Tsuika_hinmokus> theTsuika_hinmokus = new List<MitsumoriSho_Tsuika_hinmokus>();
        for(SogSok_Mitsumorisho_TsuikaHinLine__c tempTsuika_hinmoku : pSource.SogSok_Mitsumorisho_TsuikaHinLines__r){
            MitsumoriSho_Tsuika_hinmokus theTsuika_hinmoku = new MitsumoriSho_Tsuika_hinmokus();
            theTsuika_hinmoku.hinmoku_bunrui = String.isBlank(tempTsuika_hinmoku.HinmokuBunrui__c) ? null : tempTsuika_hinmoku.HinmokuBunrui__c.split(';');
            theTsuika_hinmoku.hinmoku_bunrui_name = tempTsuika_hinmoku.HinmokuBunrui__c;
            theTsuika_hinmoku.name = String.isBlank(tempTsuika_hinmoku.Hinmei__c) ? '' : tempTsuika_hinmoku.Hinmei__c;
            theTsuika_hinmoku.unit_price = tempTsuika_hinmoku.UnitPrice__c == null ? 0 : tempTsuika_hinmoku.UnitPrice__c;
            theTsuika_hinmoku.quantity = tempTsuika_hinmoku.Quantity__c == null ? 0 : tempTsuika_hinmoku.Quantity__c;
            theTsuika_hinmoku.amount = tempTsuika_hinmoku.Amount__c == null ? 0 : tempTsuika_hinmoku.Amount__c;
            theTsuika_hinmoku.shohin_bango = String.isBlank(tempTsuika_hinmoku.ShohinBango__c) ? '' : tempTsuika_hinmoku.ShohinBango__c;
            theTsuika_hinmokus.add(theTsuika_hinmoku);
        }
        theMitsumoriSho.tsuika_hinmokus = theTsuika_hinmokus;
        // 適用割引
        List<MitsumoriSho_Tekiyo_waribikis> theTekiyo_waribikis = new List<MitsumoriSho_Tekiyo_waribikis>();
        for(SogSok_Mitsumorisho_WaribikiLine__c tempTekiyo_waribiki : pSource.Mitsumorisho_WaribikiLines__r){
            MitsumoriSho_Tekiyo_waribikis theTekiyo_waribiki = new MitsumoriSho_Tekiyo_waribikis();
            theTekiyo_waribiki.shohin_bango = String.isBlank(tempTekiyo_waribiki.ShohinBango__c) ? '' : tempTekiyo_waribiki.ShohinBango__c;
            theTekiyo_waribiki.name = String.isBlank(tempTekiyo_waribiki.Hinmei__c) ? '' : tempTekiyo_waribiki.Hinmei__c;
            theTekiyo_waribiki.unit_price = tempTekiyo_waribiki.UnitPrice__c == null ? 0 : tempTekiyo_waribiki.UnitPrice__c;
            theTekiyo_waribiki.quantity = tempTekiyo_waribiki.Quantity__c == null ? 0 : tempTekiyo_waribiki.Quantity__c;
            theTekiyo_waribiki.amount = tempTekiyo_waribiki.Amount__c == null ? 0 : tempTekiyo_waribiki.Amount__c;
            theTekiyo_waribikis.add(theTekiyo_waribiki);
        }
        theMitsumoriSho.tekiyo_waribikis = theTekiyo_waribikis;
        // 支払
        MitsumoriSho_Shiharai theShiharai = new MitsumoriSho_Shiharai();
        theShiharai.loan_kingaku = pSource.Shiharai_LoanKingaku__c == null ? 0 : pSource.Shiharai_LoanKingaku__c;
        theShiharai.card_kingaku = pSource.Shiharai_CreditKingaku__c == null ? 0 : pSource.Shiharai_CreditKingaku__c;
        theShiharai.genkin_kingaku = pSource.Shiharai_GenkinKingaku__c == null ? 0 : pSource.Shiharai_GenkinKingaku__c;
        theShiharai.maeuke_kingaku = pSource.Shiharai_MaeukeKingaku__c == null ? 0 : pSource.Shiharai_MaeukeKingaku__c;
        theShiharai.gmo_kingaku = pSource.Shiharai_AtobaraiGMO__c == null ? 0 : pSource.Shiharai_AtobaraiGMO__c;
        theMitsumoriSho.shiharai = theShiharai;
        // 支払者
        MitsumoriSho_Shiharaisha theShiharaisha = new MitsumoriSho_Shiharaisha();
        theShiharaisha.name = String.isBlank(pSource.ShiharaiSha_Name__c) ? '' : pSource.ShiharaiSha_Name__c;
        theShiharaisha.email = String.isBlank(pSource.ShiharaiSha_Mail__c) ? '' : pSource.ShiharaiSha_Mail__c;
        theShiharaisha.addr_postal_code = String.isBlank(pSource.ShiharaiSha_Addr_PostalCode__c) ? '' : pSource.ShiharaiSha_Addr_PostalCode__c;
        theShiharaisha.addr_state = String.isBlank(pSource.ShiharaiSha_Addr_State__c) ? '' : pSource.ShiharaiSha_Addr_State__c;
        theShiharaisha.addr_city = String.isBlank(pSource.ShiharaiSha_Addr_City__c) ? '' : pSource.ShiharaiSha_Addr_City__c;
        theShiharaisha.addr_street = String.isBlank(pSource.ShiharaiSha_Addr_Street__c) ? '' : pSource.ShiharaiSha_Addr_Street__c;
        theShiharaisha.atena = String.isBlank(pSource.ShiharaiSha_RyosyuAtena__c) ? '' : pSource.ShiharaiSha_RyosyuAtena__c;
        theMitsumoriSho.shiharaisha = theShiharaisha;
        // よりそうオプション希望
        MitsumoriSho_Yoriso_Option_Kibo theYoriso_Option_Kibo  = new MitsumoriSho_Yoriso_Option_Kibo    ();
        theYoriso_Option_Kibo.saidan = String.isBlank(pSource.SaidanKibo__c) ? '' : pSource.SaidanKibo__c;
        theYoriso_Option_Kibo.owakare_bana = String.isBlank(pSource.KagobanaKibo__c) ? '' : pSource.KagobanaKibo__c;
        theYoriso_Option_Kibo.kanjo_hanataba = String.isBlank(pSource.KanjoHanatabaKibo__c) ? '' : pSource.KanjoHanatabaKibo__c;
        theYoriso_Option_Kibo.makura_bana = String.isBlank(pSource.MakurabanaKibo__c) ? '' : pSource.MakurabanaKibo__c;
        theMitsumoriSho.yoriso_option_kibo = theYoriso_Option_Kibo;
        // root
        theMitsumoriSho.lastupdatetime = pSource.LastModifiedDate == null ? '' : pSource.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
        theMitsumoriSho.doc_status = String.isBlank(pSource.DocStatus__c) ? '' : pSource.DocStatus__c;
        theMitsumoriSho.kinyu_date = toStringDate(pSource.KinyuDate__c);
        theMitsumoriSho.sign_url = String.isBlank(pSource.Sign_Url__c) ? '' : pSource.Sign_Url__c;
        theMitsumoriSho.uchiawase_datetime = toStringDatetime(pSource.UchiawaseDateTime__c);
        return theMitsumoriSho;
    }

    public MitsumoriSho selectMitsumoriShoBySoukyakuBango(String pSoukyakuBango){
        List<SogSok_Sokyaku__c> theSogSokSokyakus =[
            select Id, MitsumoriShoRef__c from SogSok_Sokyaku__c where Name = :pSoukyakuBango Limit 1
        ];
        if( theSogSokSokyakus.size() <= 0 ) return null;
        SogSok_Sokyaku__c theSogSokSokyaku = theSogSokSokyakus.get(0);
        if( theSogSokSokyaku.MitsumoriShoRef__c == null ) return null;

        List<SogSok_MitsumoriSho__c> theSogSokMitsumoriShos = [
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
            UchiawaseDateTime__c,
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
            ShiharaiSha_Name__c, ShiharaiSha_Mail__c,
            ShiharaiSha_Addr_PostalCode__c, ShiharaiSha_Addr_State__c, ShiharaiSha_Addr_City__c, ShiharaiSha_Addr_Street__c,
            ShiharaiSha_RyosyuAtena__c,
            KagobanaKibo__c,
            KanjoHanatabaKibo__c,
            SaidanKibo__c,
            MakurabanaKibo__c,
            SoryoTehai__c,
            SoryoTehai_Kaimyo__c,
            DocStatus__c,
            TaishoSha_Shuha_Sonota__c,
            TaishoSha_Bodaiji_Umu__c,
            TaishoSha_ZokugaraFromMoshu__c,
            Sign_Url__c,
            (
                select 
                    Id,
                    Name,
                    ShohinBango__c, 
                    LastModifiedDate,
                    MitsumoriShoRef__c,
                    HinmokuBunrui__c,
                    Hinmei__c,
                    UnitPrice__c,
                    Quantity__c,
                    Amount__c
                FROM SogSok_Mitsumorisho_TsuikaHinLines__r
            ),
            (
                select 
                    Id,
                    IsDeleted,
                    Name,
                    LastModifiedDate,
                    ShohinBango__c,
                    Hinmei__c,
                    UnitPrice__c,
                    Quantity__c,
                    Amount__c,
                    MitsumoriShoRef__c
                FROM Mitsumorisho_WaribikiLines__r
            )
            from SogSok_MitsumoriSho__c where Id = :theSogSokSokyaku.MitsumoriShoRef__c
            limit 1
        ];
        return theSogSokMitsumoriShos.size() <= 0 ? null : this.createMitsumoriSho( theSogSokMitsumoriShos.get(0) );
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