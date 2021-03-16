public class Api_V1_SogSok_Soukyakusho_Data {

    public class SoukyakuSho{
        public String soukyaku_bango = '';//送客番号
        public String shodan_bango = ''; //商談番号
        public String soukyaku_date = ''; //依頼日
        public String renrakujiko = ''; //連絡事項
        public String lastupdatetime = ''; //最終更新日時

        public SoukyakuSho_SoukyakuSaki soukyakusaki = new SoukyakuSho_SoukyakuSaki(); //送客先
        public SoukyakuSho_Sodansha sodansha = new SoukyakuSho_Sodansha(); //相談者
        public SoukyakuSho_Taishosha taishosha = new SoukyakuSho_Taishosha(); //対象者
        public SoukyakuSho_Moshu moshu = new SoukyakuSho_Moshu(); //喪主
        public SoukyakuSho_omukaesaki omukaesaki = new SoukyakuSho_omukaesaki(); //お迎え先
        public SoukyakuSho_Sogi sogi = new SoukyakuSho_Sogi();
        public SoukyakuSho_SoryoTehai soryo_tehai = new SoukyakuSho_SoryoTehai();
        public SoukyakuSho_SogiPlan sogi_plan = new SoukyakuSho_SogiPlan();
        public List<SoukyakuSho_TsuikaHinLine> tsuika_hinmokus = new List<SoukyakuSho_TsuikaHinLine>();
        public List<SoukyakuSho_TekiyoWaribiki> tekiyo_waribikis = new List<SoukyakuSho_TekiyoWaribiki>();
        public SoukyakuSho_Shiharai shiharai = new SoukyakuSho_Shiharai();
        public SoukyakuSho_Shiharaisha shiharaisha = new SoukyakuSho_Shiharaisha();
        public SoukyakuSho_Yoriso_Option_Kibo yoriso_option_kibo = new SoukyakuSho_Yoriso_Option_Kibo();
    }
    public class SoukyakuSho_SoukyakuSaki{
        public String torihikisaki_bango = ''; //送客先葬儀社_取引先番号
        public String torihikisaki_name = ''; //送客先葬儀社_葬儀社名
        public String tantosha_fax = ''; //送客先葬儀社_担当者FAX
        public Boolean fax_soufu = False; //送客先葬儀社_Fax送付要
    }
    public class SoukyakuSho_Sodansha {
        public String torihikisaki_bango = ''; //相談者_取引先番号
        public String sei = ''; //相談者_姓
        public String mei = ''; //相談者_名
        public String sei_kana = ''; //相談者_姓カナ
        public String mei_kana = ''; //相談者_名カナ
        public String phone = ''; //相談者_電話番号
        public String mobile = ''; //相談者_携帯電話番号
        public String addr_postal_code = '';
        public String addr_state = ''; //相談者住所_都道府県名
        public String addr_city = ''; //相談者住所_市区郡名
        public String addr_street = ''; //相談者住所_町名番地
    }
    public class SoukyakuSho_Taishosha {
        public String torihikisaki_bango = ''; //対象者_取引先番号
        public String sei = ''; //対象者_姓
        public String mei = ''; //対象者_名
        public String sei_kana = ''; //対象者_姓カナ
        public String mei_kana = ''; //対象者_名カナ
        public String birth_date = ''; //対象者_生年月日
        public String death_date = ''; //対象者_ご逝去日
        public Integer age = 0; //対象者_年齢
        public String gender = ''; //対象者_性別
        public String addr_postal_code = '';
        public String addr_state = ''; //対象者住所_都道府県名
        public String addr_city = ''; //対象者住所_市区郡名
        public String addr_street = ''; //対象者住所_町名番地
        public String jumhyo_state = ''; //対象者住民票住所_都道府県名
        public String jumhyo_city = ''; //対象者住民票住所_市区郡名
        public String shushi = ''; 
        public String shuha = ''; //対象者_宗派
        public String shuha_sonotaShuha = '';
        public String bodaiji_umu = '';
        public String zokugara_from_soudansha = ''; //対象者_続柄(相談者にとっての対象者)
        public String zokugara_from_moshu = ''; //続柄_続柄(喪主にとっての対象者)
    }
    public class SoukyakuSho_Moshu{
        public String sei = '';
        public String mei = '';
        public String sei_kana = '';
        public String mei_kana = '';
        public String birth_date = '';
        public String gender = '';
        public String mobile = '';
        public String phone = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String zokugara_from_soudansha = '';
    }
    public class SoukyakuSho_omukaesaki {
        public String name = '';
        public String address = '';
        public String anchisaki = '';
    }
    public class SoukyakuSho_Sogi{
        public String kibo_area = '';
    }
    public class SoukyakuSho_SoryoTehai{
        public String tehai_umu = '';
        public String kaimyo = '';
    }
    public class SoukyakuSho_SogiPlan{
        public String shohin_bango = '';
        public String name = '';
        public Decimal kingaku = 0;
        public String service_id = '';
        public String butsugu_kibo = '';
    }
    public class SoukyakuSho_TsuikaHinLine {
        public List<String> hinmoku_bunrui = new List<String>();
        public String hinmoku_bunrui_name = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
        public String shohin_bango = '';
    }
    public class SoukyakuSho_TekiyoWaribiki {
        public String shohin_bango = '';
        public String name = '';
        public Decimal unit_price = 0;
        public Decimal quantity = 0;
        public Decimal amount = 0;
    }
    public class SoukyakuSho_Shiharai{
        public String kibo_shiharai_hoho = '';
        public Decimal maeuke_kingaku = 0;
    }
    public class SoukyakuSho_Shiharaisha{
        public String name = '';
        public String email = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
        public String atena = '';
    }
    public class SoukyakuSho_Yoriso_Option_Kibo{
        public String saidan = '';
        public String owakare_bana = '';
        public String kanjo_hanataba = '';
        public String makura_bana = '';
    }


    private String toDataStr(Date d){
        if(d == null) return '';
        Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
        return dt.format('yyyy-MM-dd');
    }

    // private Integer toInteger(Decimal d){
    //     if(d == null) return null;
    //     return Integer.valueOf(d);
    // }

    private SoukyakuSho_TsuikaHinLine createSoukyakuShoTsuikaHinLine(SogSok_SokyakuSho_TsuikaHinLine__c pSource){
        SoukyakuSho_TsuikaHinLine tsuika = new SoukyakuSho_TsuikaHinLine();
        SogSok_SokyakuSho_TsuikaHinLine__c tsuikaHinLine = pSource;
        tsuika.hinmoku_bunrui = String.isBlank(tsuikaHinLine.HinmokuBunrui__c) ? null : tsuikaHinLine.HinmokuBunrui__c.split(';');
        tsuika.hinmoku_bunrui_name = tsuikaHinLine.HinmokuBunrui__c;
        tsuika.name = String.isBlank(tsuikaHinLine.Hinmei__c) ? '' : tsuikaHinLine.Hinmei__c;
        tsuika.unit_price = tsuikaHinLine.UnitPrice__c == null ? 0 : tsuikaHinLine.UnitPrice__c;
        tsuika.quantity = tsuikaHinLine.Quantity__c == null ? 0 : tsuikaHinLine.Quantity__c;
        tsuika.amount = tsuikaHinLine.Amount__c == null ? 0 : tsuikaHinLine.Amount__c;
        tsuika.shohin_bango = String.isBlank(tsuikaHinLine.ShohinBango__c) ? '' : tsuikaHinLine.ShohinBango__c;
        return tsuika;
    }

    private SoukyakuSho_TekiyoWaribiki createSoukyakuShoTekiyoWaribiki(SogSok_SokyakuSho_WaribikiLine__c pSource){
        SoukyakuSho_TekiyoWaribiki waribiki = new SoukyakuSho_TekiyoWaribiki();
        SogSok_SokyakuSho_WaribikiLine__c waribikiLine = pSource;
        waribiki.shohin_bango = String.isBlank(waribikiLine.ShohinBango__c) ? '' : waribikiLine.ShohinBango__c;
        waribiki.name = String.isBlank(waribikiLine.Hinmei__c) ? '' : waribikiLine.Hinmei__c;
        waribiki.unit_price = waribikiLine.UnitPrice__c == null ? 0 : waribikiLine.UnitPrice__c;
        waribiki.quantity = waribikiLine.Quantity__c == null ? 0 : waribikiLine.Quantity__c;
        waribiki.amount = waribikiLine.Amount__c == null ? 0 : waribikiLine.Amount__c;
        return waribiki;
    }

    private SoukyakuSho createSoukyakuSho(SogSok_SokyakuSho__c pSource){

        SoukyakuSho theSoukyakuSho = new SoukyakuSho();
        SogSok_SokyakuSho__c sokyakusho = pSource;

        theSoukyakuSho.soukyaku_bango = sokyakusho.SokyakuBango__c == null ? '' : sokyakusho.SokyakuBango__c; 
        theSoukyakuSho.shodan_bango = sokyakusho.ShodanBango__c == null ? '' : sokyakusho.ShodanBango__c; 
        theSoukyakuSho.soukyaku_date = this.toDataStr(Date.today());
        theSoukyakuSho.renrakujiko = sokyakusho.RenrakuJiko__c == null ? '' : sokyakusho.RenrakuJiko__c;
        theSoukyakuSho.lastupdatetime = sokyakusho.LastModifiedDate == null ? '' : sokyakusho.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');

        theSoukyakuSho.soukyakusaki.torihikisaki_bango = 
            sokyakusho.Soukyakusaki_TorihikisakiBango__c == null ? '' : sokyakusho.Soukyakusaki_TorihikisakiBango__c;
        theSoukyakuSho.soukyakusaki.torihikisaki_name = 
            sokyakusho.SoukyakuSaki_TorihikiSakiName__c == null ? '' : sokyakusho.SoukyakuSaki_TorihikiSakiName__c;
        theSoukyakuSho.soukyakusaki.tantosha_fax = 
            String.isBlank(sokyakusho.SoukyakuSaki_Tantosha_Fax__c) ? null : sokyakusho.SoukyakuSaki_Tantosha_Fax__c;
        theSoukyakuSho.soukyakusaki.fax_soufu = sokyakusho.SoukyakuSak_FaxSoufu__c;

        //相談者
        theSoukyakuSho.sodansha.torihikisaki_bango = 
            String.isBlank(sokyakusho.SodanSha_TorihikiSakiBango__c) ? '' : sokyakusho.SodanSha_TorihikiSakiBango__c;
        theSoukyakuSho.sodansha.sei = 
            String.isBlank(sokyakusho.SodanSha_Sei__c) ? '' : sokyakusho.SodanSha_Sei__c;
        theSoukyakuSho.sodansha.mei = 
            String.isBlank(sokyakusho.SodanSha_Mei__c) ? '' : sokyakusho.SodanSha_Mei__c;
        theSoukyakuSho.sodansha.sei_kana = 
            String.isBlank(sokyakusho.SodanSha_SeiKana__c) ? '' : sokyakusho.SodanSha_SeiKana__c;
        theSoukyakuSho.sodansha.mei_kana = 
            String.isBlank(sokyakusho.SodanSha_MeiKana__c) ? '' : sokyakusho.SodanSha_MeiKana__c;
        theSoukyakuSho.sodansha.phone = 
            String.isBlank(sokyakusho.SodanSha_Phone__c) ? '' : sokyakusho.SodanSha_Phone__c ;
        theSoukyakuSho.sodansha.mobile = 
            String.isBlank(sokyakusho.SodanSha_Mobile__c) ? '' : sokyakusho.SodanSha_Mobile__c;
        theSoukyakuSho.sodansha.addr_postal_code = 
            String.isBlank(sokyakusho.SodanSha_Addr_PostalCode__c) ? '' : sokyakusho.SodanSha_Addr_PostalCode__c;
        theSoukyakuSho.sodansha.addr_state = 
            String.isBlank(sokyakusho.SodanSha_Addr_State__c) ? '' : sokyakusho.SodanSha_Addr_State__c; 
        theSoukyakuSho.sodansha.addr_city = 
            String.isBlank(sokyakusho.SodanSha_Addr_City__c) ? '' : sokyakusho.SodanSha_Addr_City__c; 
        theSoukyakuSho.sodansha.addr_street = 
            String.isBlank(sokyakusho.SodanSha_Addr_Street__c) ? '' : sokyakusho.SodanSha_Addr_Street__c; 

        //対象者
        theSoukyakuSho.taishosha.torihikisaki_bango = 
            String.isBlank(sokyakusho.TaishoSha_TorihikiSakiBango__c) ? '' : sokyakusho.TaishoSha_TorihikiSakiBango__c;
        theSoukyakuSho.taishosha.sei = 
            String.isBlank(sokyakusho.TaishoSha_Sei__c) ? '' : sokyakusho.TaishoSha_Sei__c;
        theSoukyakuSho.taishosha.mei = 
            String.isBlank(sokyakusho.TaishoSha_Mei__c) ? '' : sokyakusho.TaishoSha_Mei__c;
        theSoukyakuSho.taishosha.sei_kana = 
            String.isBlank(sokyakusho.TaishoSha_SeiKana__c) ? '' : sokyakusho.TaishoSha_SeiKana__c;
        theSoukyakuSho.taishosha.mei_kana = 
            String.isBlank(sokyakusho.TaishoSha_MeiKana__c) ? '' : sokyakusho.TaishoSha_MeiKana__c;
        theSoukyakuSho.taishosha.birth_date = this.toDataStr(sokyakusho.TaishoSha_BirthDate__c);
        theSoukyakuSho.taishosha.death_date = this.toDataStr(sokyakusho.TaishoSha_DeathDate__c);
        theSoukyakuSho.taishosha.age = 
            sokyakusho.TaishoSha_Age__c == null ? 0 : Integer.valueOf(sokyakusho.TaishoSha_Age__c) ;
        theSoukyakuSho.taishosha.gender = 
            String.isBlank(sokyakusho.TaishoSha_Gender__c) ? '' : sokyakusho.TaishoSha_Gender__c;
        theSoukyakuSho.taishosha.addr_postal_code = 
            String.isBlank(sokyakusho.TaishoSha_Addr_PostalCode__c) ? '' : sokyakusho.TaishoSha_Addr_PostalCode__c;
        theSoukyakuSho.taishosha.addr_state = 
            String.isBlank(sokyakusho.TaishoSha_Addr_State__c) ? '' : sokyakusho.TaishoSha_Addr_State__c; 
        theSoukyakuSho.taishosha.addr_city = 
            String.isBlank(sokyakusho.TaishoSha_Addr_City__c) ? '' : sokyakusho.TaishoSha_Addr_City__c; 
        theSoukyakuSho.taishosha.addr_street = 
            String.isBlank(sokyakusho.TaishoSha_Addr_Street__c) ? '' : sokyakusho.TaishoSha_Addr_Street__c;
        theSoukyakuSho.taishosha.jumhyo_state = 
            String.isBlank(sokyakusho.TaishoSha_JumHyo_State__c) ? '' : sokyakusho.TaishoSha_JumHyo_State__c; 
        theSoukyakuSho.taishosha.jumhyo_city = 
            String.isBlank(sokyakusho.TaishoSha_JumHyo_City__c) ? '' : sokyakusho.TaishoSha_JumHyo_City__c;
        theSoukyakuSho.taishosha.shushi = 
            String.isBlank(sokyakusho.TaishoSha_Shushi__c) ? '' : sokyakusho.TaishoSha_Shushi__c; 
        theSoukyakuSho.taishosha.shuha = 
            String.isBlank(sokyakusho.TaishoSha_Shuha__c) ? '' : sokyakusho.TaishoSha_Shuha__c; 
        theSoukyakuSho.taishosha.shuha_sonotaShuha = 
            String.isBlank(sokyakusho.TaishoSha_Shuha_Sonota__c) ? '' : sokyakusho.TaishoSha_Shuha_Sonota__c; 
        theSoukyakuSho.taishosha.bodaiji_umu = 
            String.isBlank(sokyakusho.TaishoSha_BodaijiUmu__c) ? '' : sokyakusho.TaishoSha_BodaijiUmu__c;
        theSoukyakuSho.taishosha.zokugara_from_soudansha = 
            String.isBlank(sokyakusho.TaishoSha_ZokugaraFromSoudanSha__c) ? '' : sokyakusho.TaishoSha_ZokugaraFromSoudanSha__c;
        theSoukyakuSho.taishosha.zokugara_from_moshu = 
            String.isBlank(sokyakusho.TaishoSha_ZokugaraFromMoshu__c) ? '' : sokyakusho.TaishoSha_ZokugaraFromMoshu__c; 

        //喪主
        theSoukyakuSho.moshu.sei = 
            String.isBlank(sokyakusho.Moshu_Sei__c) ? '' : sokyakusho.Moshu_Sei__c;
        theSoukyakuSho.moshu.mei = 
            String.isBlank(sokyakusho.Moshu_Mei__c) ? '' : sokyakusho.Moshu_Mei__c;
        theSoukyakuSho.moshu.sei_kana = 
            String.isBlank(sokyakusho.Moshu_SeiKana__c) ? '' : sokyakusho.Moshu_SeiKana__c;
        theSoukyakuSho.moshu.mei_kana = 
            String.isBlank(sokyakusho.Moshu_MeiKana__c) ? '' : sokyakusho.Moshu_MeiKana__c;
        theSoukyakuSho.moshu.birth_date = this.toDataStr(sokyakusho.Moshu_BirthDate__c);
        theSoukyakuSho.moshu.gender = 
            String.isBlank(sokyakusho.Moshu_Gender__c) ? '' : sokyakusho.Moshu_Gender__c;
        theSoukyakuSho.moshu.mobile = 
            String.isBlank(sokyakusho.Moshu_Mobile__c) ? '' : sokyakusho.Moshu_Mobile__c;
        theSoukyakuSho.moshu.phone = 
            String.isBlank(sokyakusho.Moshu_Phone__c) ? '' : sokyakusho.Moshu_Phone__c;
        theSoukyakuSho.moshu.addr_postal_code = 
            String.isBlank(sokyakusho.Moshu_Addr_PostalCode__c) ? '' : sokyakusho.Moshu_Addr_PostalCode__c; 
        theSoukyakuSho.moshu.addr_state = 
            String.isBlank(sokyakusho.Moshu_Addr_State__c) ? '' : sokyakusho.Moshu_Addr_State__c;
        theSoukyakuSho.moshu.addr_city = 
            String.isBlank(sokyakusho.Moshu_Addr_City__c) ? '' : sokyakusho.Moshu_Addr_City__c;
        theSoukyakuSho.moshu.addr_street = 
            String.isBlank(sokyakusho.Moshu_Addr_Street__c) ? '' : sokyakusho.Moshu_Addr_Street__c;
        theSoukyakuSho.moshu.zokugara_from_soudansha = 
            String.isBlank(sokyakusho.Moshu_ZokugaraFromSoudanSha__c) ? '' : sokyakusho.Moshu_ZokugaraFromSoudanSha__c;

        //お迎え先
        theSoukyakuSho.omukaesaki.name = 
            String.isBlank(sokyakusho.OmukaeSaki_Name__c) ? '' : sokyakusho.OmukaeSaki_Name__c;
        theSoukyakuSho.omukaesaki.address = 
            String.isBlank(sokyakusho.OmukaeSaki_Addr_Street__c) ? '' : sokyakusho.OmukaeSaki_Addr_Street__c;
        theSoukyakuSho.omukaesaki.anchisaki = 
            sokyakusho.AnchiSaki__c == null ? '' : sokyakusho.AnchiSaki__c;

        //葬儀
        theSoukyakuSho.sogi.kibo_area = 
            sokyakusho.SogiPlan_KiboArea__c == null ? '' : sokyakusho.SogiPlan_KiboArea__c;

        //僧侶手配
        theSoukyakuSho.soryo_tehai.tehai_umu = 
            String.isBlank(sokyakusho.SoryoTehai_KiboUmu__c) ? '' : sokyakusho.SoryoTehai_KiboUmu__c;
        theSoukyakuSho.soryo_tehai.kaimyo = 
            String.isBlank(sokyakusho.SoryoTehai_Kaimyo__c) ? '' : sokyakusho.SoryoTehai_Kaimyo__c;

        //希望プラン
        theSoukyakuSho.sogi_plan.shohin_bango = 
            String.isBlank(sokyakusho.SogiPlan_ShohinBango__c) ? '' : sokyakusho.SogiPlan_ShohinBango__c;
        theSoukyakuSho.sogi_plan.name = 
            String.isBlank(sokyakusho.SogiPlan_PlanName__c) ? '' : sokyakusho.SogiPlan_PlanName__c;
        theSoukyakuSho.sogi_plan.kingaku = 
            sokyakusho.SogiPlan_Amount__c == null ? 0 : sokyakusho.SogiPlan_Amount__c;
        theSoukyakuSho.sogi_plan.service_id = 
            String.isBlank(sokyakusho.SogiPlan_ServiceId__c) ? '' : sokyakusho.SogiPlan_ServiceId__c;
        theSoukyakuSho.sogi_plan.butsugu_kibo = 
            String.isBlank(sokyakusho.ButsuguNashiKibo__c) ? '' : sokyakusho.ButsuguNashiKibo__c;
        //追加品目
        for(SogSok_SokyakuSho_TsuikaHinLine__c aWrLine : sokyakusho.SogSok_SokyakuSho_TsuikaHinLine__r){
            theSoukyakuSho.tsuika_hinmokus.add(
                this.createSoukyakuShoTsuikaHinLine(aWrLine)
            );
        }

        //割引
        for(SogSok_SokyakuSho_WaribikiLine__c aWrLine : sokyakusho.SokyakuSho_WaribikiLines__r){
            theSoukyakuSho.tekiyo_waribikis.add(
                this.createSoukyakuShoTekiyoWaribiki(aWrLine)
            );
        }

        //支払
        theSoukyakuSho.shiharai.kibo_shiharai_hoho = 
            String.isBlank(sokyakusho.Shiharai_KiboShiharaiHoho__c) ? '' : sokyakusho.Shiharai_KiboShiharaiHoho__c; 
        theSoukyakuSho.shiharai.maeuke_kingaku = 
            sokyakusho.Shiharai_MaeukeKingaku__c == null ? 0 : sokyakusho.Shiharai_MaeukeKingaku__c;

        // 支払者
        theSoukyakuSho.shiharaisha.name = String.isBlank(sokyakusho.ShiharaiSha_Name__c) ? '' : sokyakusho.ShiharaiSha_Name__c;
        theSoukyakuSho.shiharaisha.email = String.isBlank(sokyakusho.ShiharaiSha_Mail__c) ? '' : sokyakusho.ShiharaiSha_Mail__c;
        theSoukyakuSho.shiharaisha.addr_postal_code = String.isBlank(sokyakusho.ShiharaiSha_Addr_PostalCode__c) ? '' : sokyakusho.ShiharaiSha_Addr_PostalCode__c;
        theSoukyakuSho.shiharaisha.addr_state = String.isBlank(sokyakusho.ShiharaiSha_Addr_State__c) ? '' : sokyakusho.ShiharaiSha_Addr_State__c;
        theSoukyakuSho.shiharaisha.addr_city = String.isBlank(sokyakusho.ShiharaiSha_Addr_City__c) ? '' : sokyakusho.ShiharaiSha_Addr_City__c;
        theSoukyakuSho.shiharaisha.addr_street = String.isBlank(sokyakusho.ShiharaiSha_Addr_Street__c) ? '' : sokyakusho.ShiharaiSha_Addr_Street__c;
        theSoukyakuSho.shiharaisha.atena = String.isBlank(sokyakusho.ShiharaiSha_RyosyuAtena__c) ? '' : sokyakusho.ShiharaiSha_RyosyuAtena__c;

        // よりそうオプション希望
        theSoukyakuSho.yoriso_option_kibo.saidan = String.isBlank(sokyakusho.SaidanKibo__c) ? '' : sokyakusho.SaidanKibo__c;
        theSoukyakuSho.yoriso_option_kibo.owakare_bana = String.isBlank(sokyakusho.KagobanaKibo__c) ? '' : sokyakusho.KagobanaKibo__c;
        theSoukyakuSho.yoriso_option_kibo.kanjo_hanataba = String.isBlank(sokyakusho.KanjoHanatabaKibo__c) ? '' : sokyakusho.KanjoHanatabaKibo__c;
        theSoukyakuSho.yoriso_option_kibo.makura_bana = String.isBlank(sokyakusho.MakurabanaKibo__c) ? '' : sokyakusho.MakurabanaKibo__c;
        
        return theSoukyakuSho;
    }

    public String getSelectBody(){
        String theQuery = 'select Id, Name,';
        theQuery += 'SokyakuBango__c, ShodanBango__c, SoukyakuDate__c,' + ' ';
        theQuery += 'Soukyakusaki_TorihikisakiBango__c, SoukyakuSaki_TorihikiSakiName__c, SoukyakuSaki_Tantosha_Fax__c, SoukyakuSak_FaxSoufu__c,' + ' ';
        theQuery += 'SodanSha_TorihikiSakiBango__c,' + ' ';
        theQuery += 'SodanSha_Sei__c, SodanSha_Mei__c, SodanSha_SeiKana__c, SodanSha_MeiKana__c,' + ' ';
        theQuery += 'SodanSha_Phone__c, SodanSha_Mobile__c,' + ' ';
        theQuery += 'SodanSha_Addr_PostalCode__c, SodanSha_Addr_State__c, SodanSha_Addr_City__c, SodanSha_Addr_Street__c,' + ' ';
        theQuery += 'TaishoSha_TorihikiSakiBango__c,' + ' ';
        theQuery += 'TaishoSha_Sei__c, TaishoSha_Mei__c, TaishoSha_SeiKana__c, TaishoSha_MeiKana__c, ' + ' ';
        theQuery += 'TaishoSha_BirthDate__c, TaishoSha_DeathDate__c, TaishoSha_Age__c, TaishoSha_Gender__c,' + ' ';
        theQuery += 'TaishoSha_Addr_PostalCode__c, TaishoSha_Addr_State__c, TaishoSha_Addr_City__c, TaishoSha_Addr_Street__c, TaishoSha_JumHyo_State__c, TaishoSha_JumHyo_City__c,' + ' ';
        theQuery += 'TaishoSha_Shushi__c, TaishoSha_Shuha__c, TaishoSha_Shuha_Sonota__c, TaishoSha_BodaijiUmu__c, TaishoSha_ZokugaraFromSoudanSha__c, TaishoSha_ZokugaraFromMoshu__c,' + ' ';
        theQuery += 'Moshu_TorihikiSakiBango__c,' + ' ';
        theQuery += 'Moshu_Sei__c, Moshu_Mei__c, Moshu_SeiKana__c, Moshu_MeiKana__c, Moshu_BirthDate__c, Moshu_Gender__c,' + ' ';
        theQuery += 'Moshu_Mobile__c, Moshu_Phone__c,' + ' ';
        theQuery += 'Moshu_Addr_PostalCode__c, Moshu_Addr_State__c, Moshu_Addr_City__c, Moshu_Addr_Street__c, Moshu_ZokugaraFromSoudanSha__c,' + ' ';
        theQuery += 'OmukaeSaki_Addr_PostalCode__c, OmukaeSaki_Addr_City__c, OmukaeSaki_Addr_State__c, OmukaeSaki_Addr_Street__c, OmukaeSaki_Name__c, AnchiSaki__c,' + ' ';
        theQuery += 'SogiPlan_KiboArea__c, SogiPlan_ShohinBango__c, SogiPlan_PlanName__c, SogiPlan_ServiceId__c, SogiPlan_Amount__c, ButsuguNashiKibo__c,' + ' ';
        theQuery += 'Shiharai_MaeukeKingaku__c, Shiharai_KiboShiharaiHoho__c, ' + ' ';
        theQuery += 'ShiharaiSha_Name__c, ShiharaiSha_Mail__c, ShiharaiSha_Addr_PostalCode__c, ShiharaiSha_Addr_State__c, ShiharaiSha_Addr_City__c, ShiharaiSha_Addr_Street__c, ShiharaiSha_RyosyuAtena__c, ' + ' ';
        theQuery += 'SaidanKibo__c, KagobanaKibo__c, KanjoHanatabaKibo__c, MakurabanaKibo__c, ' + ' ';
        theQuery += 'SoryoTehai_KiboUmu__c, SoryoTehai_Kaimyo__c,' + ' ';
        theQuery += 'RenrakuJiko__c,' + ' ';
        theQuery += 'LastModifiedDate,' + ' ';
        theQuery += '(' + ' ';
        theQuery += 'select Id, Name, HinmokuBunrui__c, Hinmei__c, UnitPrice__c, Quantity__c, Amount__c, ShohinBango__c FROM SogSok_SokyakuSho_TsuikaHinLine__r' + ' ';
        theQuery += '),' + ' ';
        theQuery += '(' + ' ';
        theQuery += 'select Id, ShohinBango__c, Hinmei__c, UnitPrice__c, Quantity__c, Amount__c from SokyakuSho_WaribikiLines__r' + ' ';
        theQuery += ')' + ' ';
        theQuery += 'from SogSok_SokyakuSho__c' + ' ';
        theQuery += 'where Id != null' + ' ';
        return theQuery;
    }



    public SoukyakuSho selectSoukyakuShoBySoukyakuShoId(Id pSogSokSokyakuShoId){
        List<SogSok_SokyakuSho__c> theSogSokSokyakuShos = Database.query(
            this.getSelectBody()
            + 'and Id = :pSogSokSokyakuShoId' + ' '
            + 'limit 1' + ' '
        );
        return theSogSokSokyakuShos.size() <= 0 ? null : this.createSoukyakuSho( theSogSokSokyakuShos.get(0) );
    }

    public SoukyakuSho selectSoukyakuShoBySoukyakuBango(String pSoukyakuBango){
        List<SogSok_Sokyaku__c> theSogSokSokyakus =[
            select Id, SokyakuShoRef__c from SogSok_Sokyaku__c where Name = :pSoukyakuBango Limit 1
        ];
        if( theSogSokSokyakus.size() <= 0 ) return null;
        SogSok_Sokyaku__c theSogSokSokyaku = theSogSokSokyakus.get(0);
        if( theSogSokSokyaku.SokyakuShoRef__c == null ) return null;
        return this.selectSoukyakuShoBySoukyakuShoId( theSogSokSokyaku.SokyakuShoRef__c );
    }
    
}