public class Api_V1_SogSok_SrthIraiSho_Data {

    public class SrthIraiSho{
        public String soukyaku_bango = '';
        public String shodan_bango = '';
        public String lastupdatetime = '';
        public String doc_status = '';
        public String kinyu_date = '';
        public String renrakujiko = '';

        public SrthIraiSho_SoukyakuSaki soukyakusaki = new SrthIraiSho_SoukyakuSaki();
        public SrthIraiSho_Sodansha sodansha = new SrthIraiSho_Sodansha();
        public SrthIraiSho_Taishosha taishosha = new SrthIraiSho_Taishosha();
        public SrthIraiSho_Moshu moshu = new SrthIraiSho_Moshu();
        public SrthIraiSho_Sogi sogi = new SrthIraiSho_Sogi();
        public SrthIraiSho_Sogi_plan sogi_plan = new SrthIraiSho_Sogi_plan();
        public SrthIraiSho_Soryo_tehai soryo_tehai = new SrthIraiSho_Soryo_tehai();

    }
    public class SrthIraiSho_SoukyakuSaki{
        public String torihikisaki_bango = '';
        public String torihikisaki_name = '';
        public String tantosha_name = '';
        public String tantosha_tel = '';
        public String tantosha_fax = '';
    }
    public class SrthIraiSho_Sodansha{
        public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
    }
    public class SrthIraiSho_Taishosha{
        public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
        public String sei_kana = '';
        public String mei_kana = '';
        public String birth_date = '';
        public String death_date = '';
        public Integer age = 0;
        public String shushi = '';
        public String shuha = '';
        public String shuha_sonotaShuha = '';
        public String bodaiji_umu = '';
        public String zokugara_from_moshu = '';
    }
    public class SrthIraiSho_Moshu{
        //public String torihikisaki_bango = '';
        public String sei = '';
        public String mei = '';
        public String sei_kana = '';
        public String mei_kana = '';
        public String phone = '';
        public String mobile = '';
        public String addr_postal_code = '';
        public String addr_state = '';
        public String addr_city = '';
        public String addr_street = '';
    }
    public class SrthIraiSho_Sogi{
        public String tsuya_datetime = '';
        public String kokubetsushiki_datetime = '';
        public String kaso_datetime = '';
        public String shonanoka = '';
        public String shikijo_name = '';
        public String shikijo_address = '';
        public String shikijo_phone = '';
        public String kasoba_name = '';
        public String kasoba_address = '';
        public String kasoba_phone = '';
    }
    public class SrthIraiSho_Sogi_plan{
        public String shohin_bango = '';
        public String name = '';
        public Decimal kingaku = 0;
        public String service_id = '';
    }
    public class SrthIraiSho_Soryo_tehai{
        public String plan = '';
        public String kaimyo = '';
        public String makurakyo = '';
        public Decimal kingaku = 0;
    }

    public SogSok_SrthIraiSho__c createSogSokSrthIraiSho(SrthIraiSho pSource){
        SogSok_SrthIraiSho__c theSogSokSrthIraiSho = new SogSok_SrthIraiSho__c();
        theSogSokSrthIraiSho.JuryoDateTime__c = Datetime.now();

        theSogSokSrthIraiSho.SokyakuBango__c = String.isBlank(pSource.soukyaku_bango) ? null : pSource.soukyaku_bango;
        theSogSokSrthIraiSho.ShodanBango__c = String.isBlank(pSource.shodan_bango) ? null : pSource.shodan_bango;
        theSogSokSrthIraiSho.DocStatus__c = String.isBlank(pSource.doc_status) ? null : pSource.doc_status; 
        theSogSokSrthIraiSho.KinyuDate__c = String.isBlank(pSource.kinyu_date) ? null : Date.valueOf(pSource.kinyu_date);
        theSogSokSrthIraiSho.RenrakuJiko__c = String.isBlank(pSource.renrakujiko) ? null : pSource.renrakujiko;

        theSogSokSrthIraiSho.Soukyakusaki_TorihikisakiBango__c = String.isBlank(pSource.soukyakusaki.torihikisaki_bango) ? null : pSource.soukyakusaki.torihikisaki_bango;
        theSogSokSrthIraiSho.SoukyakuSaki_TorihikiSakiName__c = String.isBlank(pSource.soukyakusaki.torihikisaki_name) ? null : pSource.soukyakusaki.torihikisaki_name;
        theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Name__c = String.isBlank(pSource.soukyakusaki.tantosha_name) ? null : pSource.soukyakusaki.tantosha_name;
        theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Tel__c = String.isBlank(pSource.soukyakusaki.tantosha_tel) ? null : pSource.soukyakusaki.tantosha_tel;
        theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Fax__c = String.isBlank(pSource.soukyakusaki.tantosha_fax) ? null : pSource.soukyakusaki.tantosha_fax;

        theSogSokSrthIraiSho.SodanSha_TorihikiSakiBango__c = String.isBlank(pSource.sodansha.torihikisaki_bango) ? null : pSource.sodansha.torihikisaki_bango;
        theSogSokSrthIraiSho.SodanSha_Sei__c = String.isBlank(pSource.sodansha.sei) ? null : pSource.sodansha.sei;
        theSogSokSrthIraiSho.SodanSha_Mei__c = String.isBlank(pSource.sodansha.mei) ? null : pSource.sodansha.mei;

        theSogSokSrthIraiSho.TaishoSha_TorihikiSakiBango__c = String.isBlank(pSource.taishosha.torihikisaki_bango) ? null : pSource.taishosha.torihikisaki_bango;
        theSogSokSrthIraiSho.TaishoSha_Sei__c = String.isBlank(pSource.taishosha.sei) ? null : pSource.taishosha.sei;
        theSogSokSrthIraiSho.TaishoSha_Mei__c = String.isBlank(pSource.taishosha.mei) ? null : pSource.taishosha.mei;
        theSogSokSrthIraiSho.TaishoSha_SeiKana__c = String.isBlank(pSource.taishosha.sei_kana) ? null : pSource.taishosha.sei_kana;
        theSogSokSrthIraiSho.TaishoSha_MeiKana__c = String.isBlank(pSource.taishosha.mei_kana) ? null : pSource.taishosha.mei_kana;
        theSogSokSrthIraiSho.TaishoSha_BirthDate__c = String.isBlank(pSource.taishosha.birth_date) ? null : Date.valueOf(pSource.taishosha.birth_date);
        theSogSokSrthIraiSho.TaishoSha_DeathDate__c = String.isBlank(pSource.taishosha.death_date) ? null : Date.valueOf(pSource.taishosha.death_date);
        theSogSokSrthIraiSho.TaishoSha_Age__c = pSource.taishosha.age == null ? 0 : Integer.valueOf(pSource.taishosha.age);
        theSogSokSrthIraiSho.TaishoSha_Shushi__c = String.isBlank(pSource.taishosha.shushi) ? null : pSource.taishosha.shushi;
        theSogSokSrthIraiSho.TaishoSha_Shuha__c = String.isBlank(pSource.taishosha.shuha) ? null : pSource.taishosha.shuha;
        theSogSokSrthIraiSho.TaishoSha_Shuha_Sonota__c = String.isBlank(pSource.taishosha.shuha_sonotaShuha) ? null : pSource.taishosha.shuha_sonotaShuha;
        theSogSokSrthIraiSho.TaishoSha_Bodaiji_Umu__c = String.isBlank(pSource.taishosha.bodaiji_umu) ? null : pSource.taishosha.bodaiji_umu;
        theSogSokSrthIraiSho.TaishoSha_ZokugaraFromMoshu__c = String.isBlank(pSource.taishosha.zokugara_from_moshu) ? null : pSource.taishosha.zokugara_from_moshu;

        //theSogSokSrthIraiSho.Moshu_TorihikiSakiBango__c = String.isBlank(pSource.moshu.torihikisaki_bango) ? null : pSource.moshu.torihikisaki_bango;
        theSogSokSrthIraiSho.Moshu_Sei__c = String.isBlank(pSource.moshu.sei) ? null : pSource.moshu.sei;
        theSogSokSrthIraiSho.Moshu_Mei__c = String.isBlank(pSource.moshu.mei) ? null : pSource.moshu.mei;
        theSogSokSrthIraiSho.Moshu_SeiKana__c = String.isBlank(pSource.moshu.sei_kana) ? null : pSource.moshu.sei_kana;
        theSogSokSrthIraiSho.Moshu_MeiKana__c = String.isBlank(pSource.moshu.mei_kana) ? null : pSource.moshu.mei_kana;
        theSogSokSrthIraiSho.Moshu_Phone__c = String.isBlank(pSource.moshu.phone) ? null : pSource.moshu.phone;
        theSogSokSrthIraiSho.Moshu_Mobile__c = String.isBlank(pSource.moshu.mobile) ? null : pSource.moshu.mobile;
        theSogSokSrthIraiSho.Moshu_Addr_PostalCode__c = String.isBlank(pSource.moshu.addr_postal_code) ? null : pSource.moshu.addr_postal_code;
        theSogSokSrthIraiSho.Moshu_Addr_State__c = String.isBlank(pSource.moshu.addr_state) ? null : pSource.moshu.addr_state;
        theSogSokSrthIraiSho.Moshu_Addr_City__c = String.isBlank(pSource.moshu.addr_city) ? null : pSource.moshu.addr_city;
        theSogSokSrthIraiSho.Moshu_Addr_Street__c = String.isBlank(pSource.moshu.addr_street) ? null : pSource.moshu.addr_street;
        
        theSogSokSrthIraiSho.sogi_TsuyaDateTime__c = String.isBlank(pSource.sogi.tsuya_datetime) ? null : DateTime.valueOf(pSource.sogi.tsuya_datetime);
        theSogSokSrthIraiSho.Sogi_KokubetsuDateTime__c = String.isBlank(pSource.sogi.kokubetsushiki_datetime) ? null : DateTime.valueOf(pSource.sogi.kokubetsushiki_datetime);
        theSogSokSrthIraiSho.Sogi_KasoDateTime__c = String.isBlank(pSource.sogi.kaso_datetime) ? null : DateTime.valueOf(pSource.sogi.kaso_datetime);
        theSogSokSrthIraiSho.Sogi_Shonanoka__c = String.isBlank(pSource.sogi.shonanoka) ? null : pSource.sogi.shonanoka;
        theSogSokSrthIraiSho.Sogi_Shikijo_Name__c = String.isBlank(pSource.sogi.shikijo_name) ? null : pSource.sogi.shikijo_name;
        theSogSokSrthIraiSho.Sogi_Shikijo_Address__c = String.isBlank(pSource.sogi.shikijo_address) ? null : pSource.sogi.shikijo_address;
        theSogSokSrthIraiSho.Sogi_Shikijo_Phone__c = String.isBlank(pSource.sogi.shikijo_phone) ? null : pSource.sogi.shikijo_phone;
        theSogSokSrthIraiSho.Sogi_Kasoba_Name__c = String.isBlank(pSource.sogi.kasoba_name) ? null : pSource.sogi.kasoba_name;
        theSogSokSrthIraiSho.Sogi_Kasoba_Address__c = String.isBlank(pSource.sogi.kasoba_address) ? null : pSource.sogi.kasoba_address;
        theSogSokSrthIraiSho.Sogi_Kasoba_Phone__c = String.isBlank(pSource.sogi.kasoba_phone) ? null : pSource.sogi.kasoba_phone;

        // 葬儀プラン
        theSogSokSrthIraiSho.SogiPlan_ShohinBango__c = pSource.sogi_plan.shohin_bango;
        theSogSokSrthIraiSho.SogiPlan_PlanName__c = pSource.sogi_plan.name;
        theSogSokSrthIraiSho.SogiPlan_Amount__c = pSource.sogi_plan.kingaku == null ? 0 : pSource.sogi_plan.kingaku;
        theSogSokSrthIraiSho.SogiPlan_ServiceId__c = pSource.sogi_plan.service_id;

        theSogSokSrthIraiSho.SoryoTehai_Plan__c = String.isBlank(pSource.soryo_tehai.plan) ? null : pSource.soryo_tehai.plan;
        theSogSokSrthIraiSho.SoryoTehai_Kaimyo__c = String.isBlank(pSource.soryo_tehai.kaimyo) ? null : pSource.soryo_tehai.kaimyo;
        theSogSokSrthIraiSho.SoryoTehai_Makurakyo__c = String.isBlank(pSource.soryo_tehai.makurakyo) ? null : pSource.soryo_tehai.makurakyo;
        theSogSokSrthIraiSho.SoryoTehai_Kingaku__c = pSource.soryo_tehai.kingaku == null ? 0 : pSource.soryo_tehai.kingaku;

        return theSogSokSrthIraiSho;
    }
    public SrthIraiSho createSrthIraiShoDto(SogSok_SrthIraiSho__c pSource){
        SrthIraiSho theSrthIraiSho = new SrthIraiSho();
        theSrthIraiSho.soukyaku_bango = String.isBlank(pSource.SokyakuBango__c) ? '' : pSource.SokyakuBango__c;
        theSrthIraiSho.shodan_bango = String.isBlank(pSource.ShodanBango__c) ? '' : pSource.ShodanBango__c;
        theSrthIraiSho.lastupdatetime = pSource.LastModifiedDate == null ? '' : pSource.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss');
        theSrthIraiSho.doc_status = String.isBlank(pSource.DocStatus__c) ? '' : pSource.DocStatus__c;
        theSrthIraiSho.kinyu_date = pSource.KinyuDate__c == null ? '' : pSource.KinyuDate__c.format().replace('/', '-');
        theSrthIraiSho.renrakujiko = String.isBlank(pSource.RenrakuJiko__c) ? '' : pSource.RenrakuJiko__c;

        theSrthIraiSho.soukyakusaki.torihikisaki_bango = String.isBlank(pSource.Soukyakusaki_TorihikisakiBango__c) ? '' : pSource.Soukyakusaki_TorihikisakiBango__c;
        theSrthIraiSho.soukyakusaki.torihikisaki_name = String.isBlank(pSource.SoukyakuSaki_TorihikiSakiName__c) ? '' : pSource.SoukyakuSaki_TorihikiSakiName__c;
        theSrthIraiSho.soukyakusaki.tantosha_name = String.isBlank(pSource.SoukyakuSaki_Tantosha_Name__c) ? '' : pSource.SoukyakuSaki_Tantosha_Name__c;
        theSrthIraiSho.soukyakusaki.tantosha_tel = String.isBlank(pSource.SoukyakuSaki_Tantosha_Tel__c) ? '' : pSource.SoukyakuSaki_Tantosha_Tel__c;
        theSrthIraiSho.soukyakusaki.tantosha_fax = String.isBlank(pSource.SoukyakuSaki_Tantosha_Fax__c) ? '' : pSource.SoukyakuSaki_Tantosha_Fax__c;
        
        theSrthIraiSho.sodansha.torihikisaki_bango = String.isBlank(pSource.SodanSha_TorihikiSakiBango__c) ? '' : pSource.SodanSha_TorihikiSakiBango__c;
        theSrthIraiSho.sodansha.sei = String.isBlank(pSource.SodanSha_Sei__c) ? '' : pSource.SodanSha_Sei__c;
        theSrthIraiSho.sodansha.mei = String.isBlank(pSource.SodanSha_Mei__c) ? '' : pSource.SodanSha_Mei__c;

        theSrthIraiSho.taishosha.torihikisaki_bango = String.isBlank(pSource.TaishoSha_TorihikiSakiBango__c) ? '' : pSource.TaishoSha_TorihikiSakiBango__c;
        theSrthIraiSho.taishosha.sei = String.isBlank(pSource.TaishoSha_Sei__c) ? '' : pSource.TaishoSha_Sei__c;
        theSrthIraiSho.taishosha.mei = String.isBlank(pSource.TaishoSha_Mei__c) ? '' : pSource.TaishoSha_Mei__c;
        theSrthIraiSho.taishosha.sei_kana = String.isBlank(pSource.TaishoSha_SeiKana__c) ? '' : pSource.TaishoSha_SeiKana__c;
        theSrthIraiSho.taishosha.mei_kana = String.isBlank(pSource.TaishoSha_MeiKana__c) ? '' : pSource.TaishoSha_MeiKana__c;
        theSrthIraiSho.taishosha.birth_date = pSource.TaishoSha_BirthDate__c == null ? '' : pSource.TaishoSha_BirthDate__c.format().replace('/', '-');
        theSrthIraiSho.taishosha.death_date = pSource.TaishoSha_DeathDate__c == null ? '' : pSource.TaishoSha_DeathDate__c.format().replace('/', '-');
        theSrthIraiSho.taishosha.age = pSource.TaishoSha_Age__c == null ? 0 : Integer.valueOf(pSource.TaishoSha_Age__c);
        theSrthIraiSho.taishosha.shushi = String.isBlank(pSource.TaishoSha_Shushi__c) ? '' : pSource.TaishoSha_Shushi__c;
        theSrthIraiSho.taishosha.shuha = String.isBlank(pSource.TaishoSha_Shuha__c) ? '' : pSource.TaishoSha_Shuha__c;
        theSrthIraiSho.taishosha.shuha_sonotaShuha = String.isBlank(pSource.TaishoSha_Shuha_Sonota__c) ? '' : pSource.TaishoSha_Shuha_Sonota__c;
        theSrthIraiSho.taishosha.bodaiji_umu = String.isBlank(pSource.TaishoSha_Bodaiji_Umu__c) ? '' : pSource.TaishoSha_Bodaiji_Umu__c;
        theSrthIraiSho.taishosha.zokugara_from_moshu = String.isBlank(pSource.TaishoSha_ZokugaraFromMoshu__c) ? '' : pSource.TaishoSha_ZokugaraFromMoshu__c;
        
        //theSrthIraiSho.moshu.torihikisaki_bango = String.isBlank(pSource.Moshu_TorihikiSakiBango__c) ? '' : pSource.Moshu_TorihikiSakiBango__c;
        theSrthIraiSho.moshu.sei = String.isBlank(pSource.Moshu_Sei__c) ? '' : pSource.Moshu_Sei__c;
        theSrthIraiSho.moshu.mei = String.isBlank(pSource.Moshu_Mei__c) ? '' : pSource.Moshu_Mei__c;
        theSrthIraiSho.moshu.sei_kana = String.isBlank(pSource.Moshu_SeiKana__c) ? '' : pSource.Moshu_SeiKana__c;
        theSrthIraiSho.moshu.mei_kana = String.isBlank(pSource.Moshu_MeiKana__c) ? '' : pSource.Moshu_MeiKana__c;
        theSrthIraiSho.moshu.phone = String.isBlank(pSource.Moshu_Phone__c) ? '' : pSource.Moshu_Phone__c;
        theSrthIraiSho.moshu.mobile = String.isBlank(pSource.Moshu_Mobile__c) ? '' : pSource.Moshu_Mobile__c;
        theSrthIraiSho.moshu.addr_postal_code = String.isBlank(pSource.Moshu_Addr_PostalCode__c) ? '' : pSource.Moshu_Addr_PostalCode__c;
        theSrthIraiSho.moshu.addr_state = String.isBlank(pSource.Moshu_Addr_State__c) ? '' : pSource.Moshu_Addr_State__c;
        theSrthIraiSho.moshu.addr_city = String.isBlank(pSource.Moshu_Addr_City__c) ? '' : pSource.Moshu_Addr_City__c;
        theSrthIraiSho.moshu.addr_street = String.isBlank(pSource.Moshu_Addr_Street__c) ? '' : pSource.Moshu_Addr_Street__c;

        theSrthIraiSho.sogi.tsuya_datetime = pSource.sogi_TsuyaDateTime__c == null ? '' : pSource.sogi_TsuyaDateTime__c.format('yyyy-MM-dd HH:mm:ss');
        theSrthIraiSho.sogi.kokubetsushiki_datetime = pSource.Sogi_KokubetsuDateTime__c == null ? '' : pSource.Sogi_KokubetsuDateTime__c.format('yyyy-MM-dd HH:mm:ss');
        theSrthIraiSho.sogi.kaso_datetime = pSource.Sogi_KasoDateTime__c == null ? '' : pSource.Sogi_KasoDateTime__c.format('yyyy-MM-dd HH:mm:ss');
        theSrthIraiSho.sogi.shonanoka = String.isBlank(pSource.Sogi_Shonanoka__c) ? '' : pSource.Sogi_Shonanoka__c;
        theSrthIraiSho.sogi.shikijo_name = String.isBlank(pSource.Sogi_Shikijo_Name__c) ? '' : pSource.Sogi_Shikijo_Name__c;
        theSrthIraiSho.sogi.shikijo_address = String.isBlank(pSource.Sogi_Shikijo_Address__c) ? '' : pSource.Sogi_Shikijo_Address__c;
        theSrthIraiSho.sogi.shikijo_phone = String.isBlank(pSource.Sogi_Shikijo_Phone__c) ? '' : pSource.Sogi_Shikijo_Phone__c;
        theSrthIraiSho.sogi.kasoba_name = String.isBlank(pSource.Sogi_Kasoba_Name__c) ? '' : pSource.Sogi_Kasoba_Name__c;
        theSrthIraiSho.sogi.kasoba_address = String.isBlank(pSource.Sogi_Kasoba_Address__c) ? '' : pSource.Sogi_Kasoba_Address__c;
        theSrthIraiSho.sogi.kasoba_phone = String.isBlank(pSource.Sogi_Kasoba_Phone__c) ? '' : pSource.Sogi_Kasoba_Phone__c;

        // 葬儀プラン
        theSrthIraiSho.sogi_plan.shohin_bango = String.isBlank(pSource.SogiPlan_ShohinBango__c) ? '' : pSource.SogiPlan_ShohinBango__c;
        theSrthIraiSho.sogi_plan.name = String.isBlank(pSource.SogiPlan_PlanName__c) ? '' : pSource.SogiPlan_PlanName__c;
        theSrthIraiSho.sogi_plan.kingaku = pSource.SogiPlan_Amount__c == null ? 0 : pSource.SogiPlan_Amount__c;
        theSrthIraiSho.sogi_plan.service_id = String.isBlank(pSource.SogiPlan_ServiceId__c) ? '' : pSource.SogiPlan_ServiceId__c;
        
        theSrthIraiSho.soryo_tehai.plan = String.isBlank(pSource.SoryoTehai_Plan__c) ? '' : pSource.SoryoTehai_Plan__c;
        theSrthIraiSho.soryo_tehai.kaimyo = String.isBlank(pSource.SoryoTehai_Kaimyo__c) ? '' : pSource.SoryoTehai_Kaimyo__c;
        theSrthIraiSho.soryo_tehai.makurakyo = String.isBlank(pSource.SoryoTehai_Makurakyo__c) ? '' : pSource.SoryoTehai_Makurakyo__c;
        theSrthIraiSho.soryo_tehai.kingaku = pSource.SoryoTehai_Kingaku__c == null ? 0 : pSource.SoryoTehai_Kingaku__c;

        return theSrthIraiSho;
    }

    public SrthIraiSho selectSrthIraiShoBySoukyakuBango(String pSoukyakuBango){
        List<SogSok_Sokyaku__c> theSogSokSokyakus =[
            select Id, SrthIraiShoRef__c from SogSok_Sokyaku__c where Name = :pSoukyakuBango Limit 1
        ];
        if( theSogSokSokyakus.size() <= 0 ) return null;
        SogSok_Sokyaku__c theSogSokSokyaku = theSogSokSokyakus.get(0);
        if( theSogSokSokyaku.SrthIraiShoRef__c == null ) return null;

        List<SogSok_SrthIraiSho__c> theSrthIraiShos = [
            select Id,
            LastModifiedDate,
            SokyakuBango__c, ShodanBango__c, DocStatus__c, KinyuDate__c, RenrakuJiko__c,
            Soukyakusaki_TorihikisakiBango__c, SoukyakuSaki_TorihikiSakiName__c, 
            SoukyakuSaki_Tantosha_Name__c, SoukyakuSaki_Tantosha_Tel__c, SoukyakuSaki_Tantosha_Fax__c,
            SodanSha_TorihikiSakiBango__c, SodanSha_Sei__c, SodanSha_Mei__c,
            TaishoSha_TorihikiSakiBango__c, 
            TaishoSha_Sei__c, TaishoSha_Mei__c, TaishoSha_SeiKana__c, TaishoSha_MeiKana__c,
            TaishoSha_BirthDate__c, TaishoSha_DeathDate__c, TaishoSha_Age__c, 
            TaishoSha_Shushi__c, TaishoSha_Shuha__c, TaishoSha_Shuha_Sonota__c, TaishoSha_Bodaiji_Umu__c,
            TaishoSha_ZokugaraFromMoshu__c,
            Moshu_TorihikiSakiBango__c, 
            Moshu_Sei__c, Moshu_Mei__c, Moshu_SeiKana__c, Moshu_MeiKana__c,
            Moshu_Phone__c, Moshu_Mobile__c, 
            Moshu_Addr_PostalCode__c, Moshu_Addr_State__c, Moshu_Addr_City__c, Moshu_Addr_Street__c,
            sogi_TsuyaDateTime__c, Sogi_KokubetsuDateTime__c, Sogi_KasoDateTime__c, Sogi_Shonanoka__c,
            Sogi_Shikijo_Name__c, Sogi_Shikijo_Address__c, Sogi_Shikijo_Phone__c,
            Sogi_Kasoba_Name__c, Sogi_Kasoba_Address__c, Sogi_Kasoba_Phone__c,
            SogiPlan_ShohinBango__c, SogiPlan_PlanName__c, SogiPlan_ServiceId__c, SogiPlan_Amount__c,
            SoryoTehai_Plan__c, SoryoTehai_Kaimyo__c, SoryoTehai_Makurakyo__c, SoryoTehai_Kingaku__c
            from SogSok_SrthIraiSho__c
            where Id = :theSogSokSokyaku.SrthIraiShoRef__c
        ];
        if(theSrthIraiShos.size() <= 0 ) return null;
        SogSok_SrthIraiSho__c theSrthIraiSho = theSrthIraiShos.get(0);

        return this.createSrthIraiShoDto( theSrthIraiSho );
    }
}