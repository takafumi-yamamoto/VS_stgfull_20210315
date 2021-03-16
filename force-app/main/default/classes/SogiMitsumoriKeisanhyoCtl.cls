public class SogiMitsumoriKeisanhyoCtl {

    public SogiMitsumoriKeisanhyoCtl(ApexPages.StandardController controller){

        String pOppId = Apexpages.currentPage().getParameters().get('oppid');
        if(pOppId != null && pOppId != '') { oppId = pOppId; }
        else { oppId = [select Id, OpportunityRef__c from SogiShiryoSofu__c where Id = :controller.getRecord().Id].OpportunityRef__c; }
        
        opp = [select Id, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c from Opportunity where Id = :oppId];
    }

    public Opportunity opp {get;set;}
    public String oppId {get;set;}
    public SogiMitsumoriKeisanhyoWrap displayKeisanhyoData {get;set;}
    public List<SogiMitsumoriKeisanhyoWrap> keisanhyoWrapList {get;set;}
    private SogiMitsumoriKeisanhyoHinmokuPrice.IPrice_Calculator iPrice_Calculator = SogiMitsumoriKeisanhyoHinmokuPrice.get_IPrice_Calculator_instance();
    public static Decimal tax = 1.1;
    public static List<Schema.PicklistEntry> keisanshyoAllianceSchema = SogiMitsumoriKeisanhyo__c.Alliance__c.getDescribe().getPicklistValues();

    public class SogiMitsumoriKeisanhyoWrap{
        public List<SelectOption> saidanUpGreadOption {get;set;}
        public List<SelectOption> yorisoOption {get;set;}
        public List<SelectOption> sogishaOption {get;set;}

        public SogiMitsumoriKeisanhyo__c keisanhyoObj {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoPlanName {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoTeianTaisho {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiPlan {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoButsuguNashi {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiWaribiki {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoJizenAnketoWaribiki {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiAnketoWaribiki {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoAllianceWaribiki {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiHontaiShokeiZeinuki {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiHontaiShokeiZeikomi {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSoryoTehai {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKaimyojuyo {get;set;}
        public List<SwitchRyokinhyoMeisaiWrap> ryokinhyoShikiKasobaRyokinList {get;set;}
        public List<SwitchRyokinhyoMeisaiWrap> ryokinhyoShikiSaijoRyokinList {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoSaidanUpGread {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoCampaignSogiyoBouquet {get;set;}
        public List<SwitchRyokinhyoMeisaiWrap> ryokinhyoYorisoOptionList {get;set;}
        public List<SwitchRyokinhyoMeisaiWrap> ryokinhyoSogishaOptionList {get;set;}
        public List<SwitchRyokinhyoMeisaiWrap> ryokinhyoShikiFreeWordList {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiOptionShokei {get;set;}
        public SwitchRyokinhyoMeisaiWrap ryokinhyoShikiGokei {get;set;}

        private SogiMitsumoriKeisanhyoHinmokuPrice.IPrice_Calculator iPrice_Calculator = SogiMitsumoriKeisanhyoHinmokuPrice.get_IPrice_Calculator_instance();

        public SogiMitsumoriKeisanhyoWrap(){

            keisanhyoObj = new SogiMitsumoriKeisanhyo__c();
            keisanhyoObj.ButsuguUmu__c = '仏具あり';
            keisanhyoObj.WaribikiService__c = '非会員';
            keisanhyoObj.KasobaMeisaiHyokimei__c = '火葬料金（非課税）';
            keisanhyoObj.ShikijoMeisaiHyokimei__c = '式場追加料金（プラン内式場料金超過分）';

            ryokinhyoTeianTaisho = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoTeianTaisho.keisanhyoMeisai.MeisaiType__c = '提案対象';
            ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.KasoSimpleTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.KasoKihonTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.KasoButsuguTeianTaisho__c = false;
            ryokinhyoTeianTaisho.keisanhyoMeisai.KasoOhanaTeianTaisho__c = false;

            ryokinhyoPlanName = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoPlanName.keisanhyoMeisai.MeisaiType__c = 'プラン名';
            ryokinhyoPlanName.keisanhyoMeisai.Kazoku1nichiName__c = '家族一日';
            ryokinhyoPlanName.keisanhyoMeisai.Kazoku2nichiName__c = '家族二日';
            ryokinhyoPlanName.keisanhyoMeisai.KazokuhanayakaName__c = '家族華やか';
            ryokinhyoPlanName.keisanhyoMeisai.KasoSimpleName__c = '火葬ｼﾝﾌﾟﾙ';
            ryokinhyoPlanName.keisanhyoMeisai.KasoKihonName__c = '火葬基本';
            ryokinhyoPlanName.keisanhyoMeisai.KasoButsuguName__c = '火葬仏具';
            ryokinhyoPlanName.keisanhyoMeisai.KasoOhanaName__c = '火葬お花';

            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuPlan = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuPlan.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.Plan;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPricePlan = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuPlan);
            ryokinhyoShikiPlan = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiPlan.keisanhyoMeisai.MeisaiType__c = 'プラン料金';
            ryokinhyoShikiPlan.keisanhyoMeisai.Kazoku1nichiFee__c = hinmokuPricePlan.kazoku1Nichi / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.kazoku2nichiFee__c = hinmokuPricePlan.kazoku2Nichi / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.kazokuhanayakaFee__c = hinmokuPricePlan.kazokuHanayaka / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.KasoSimpleFee__c = hinmokuPricePlan.kasoSimple / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.kasoKihonFee__c = hinmokuPricePlan.kasoKihon / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.kasoButsuguFee__c = hinmokuPricePlan.kasoButsugu / tax;
            ryokinhyoShikiPlan.keisanhyoMeisai.kasoOhanaFee__c = hinmokuPricePlan.kasoOhana / tax;
            ryokinhyoButsuguNashi = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoButsuguNashi.keisanhyoMeisai.MeisaiType__c = '仏具有無';
            ryokinhyoButsuguNashi.keisanhyoMeisai.OptionName__c = '仏具あり';
            ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku1nichiFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku2nichiFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.kazokuhanayakaFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.KasoSimpleFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.kasoKihonFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.kasoButsuguFee__c = 0;
            ryokinhyoButsuguNashi.keisanhyoMeisai.kasoOhanaFee__c = 0;
            ryokinhyoShikiWaribiki = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiWaribiki.keisanhyoMeisai.MeisaiType__c = '会員割引';
            ryokinhyoShikiWaribiki.keisanhyoMeisai.OptionName__c = '非会員';
            ryokinhyoJizenAnketoWaribiki = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.MeisaiType__c = '事前アンケート';
            ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.OptionName__c = '事前アンケート';
            ryokinhyoShikiAnketoWaribiki = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.MeisaiType__c = '式後アンケート';
            ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.OptionName__c = '式後アンケート';
            ryokinhyoAllianceWaribiki = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoAllianceWaribiki.keisanhyoMeisai.MeisaiType__c = 'アライアンス';
            ryokinhyoAllianceWaribiki.keisanhyoMeisai.OptionName__c = 'アライアンス';
            ryokinhyoShikiHontaiShokeiZeinuki = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.MeisaiType__c = '本体小計(税抜)';
            ryokinhyoShikiHontaiShokeiZeikomi = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.MeisaiType__c = '本体小計(税込)';

            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuSoryoTehai = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuSoryoTehai.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.SoryoTehai;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceSoryoTehai = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuSoryoTehai);

            Decimal soryoTehaiPrice = hinmokuPriceSoryoTehai.priceBookEntry.UnitPrice;
            ryokinhyoShikiSoryoTehai = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.MeisaiType__c = '僧侶手配(読経)';
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.ItemName__c = '僧侶手配(読経)';
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.Kazoku1nichiFee__c = hinmokuPriceSoryoTehai.kazoku1Nichi;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.Kazoku2nichiFee__c = hinmokuPriceSoryoTehai.kazoku2Nichi;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.KazokuhanayakaFee__c = hinmokuPriceSoryoTehai.kazokuHanayaka;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.KasoSimpleFee__c = 0;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.KasoKihonFee__c = 0;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.KasoButsuguFee__c = 0;
            ryokinhyoShikiSoryoTehai.keisanhyoMeisai.KasoOhanaFee__c = 0;

            ryokinhyoShikiKaimyojuyo = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.MeisaiType__c = '戒名授与';
            ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.ItemName__c = '戒名授与';
            ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.Suryo__c = 1;

            ryokinhyoShikiKasobaRyokinList = new List<SwitchRyokinhyoMeisaiWrap>();
            SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.SltFlg__c = true;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.MeisaiType__c = '火葬料金';
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ItemName__c = '火葬料金';
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ItemCode__c = 'SBG-0005518';
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ShisetsuFeeZeikomi__c = null;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.PlanJuto__c = false;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoSimpleFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoKihonFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoButsuguFee__c = 0;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoOhanaFee__c = 0;
            ryokinhyoShikiKasobaRyokinList.add(ryokinhyoShikiKasobaRyokin);

            ryokinhyoShikiSaijoRyokinList = new List<SwitchRyokinhyoMeisaiWrap>();
            SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.SltFlg__c = true;
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.MeisaiType__c = '斎場料金';
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ItemName__c = '斎場料金';
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ItemCode__c = 'SBG-0005519';
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.PlanJuto__c = false;
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ShisetsuFeeZeinuki__c = 0;
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ShisetsuFeeZeikomi__c = null;
            ryokinhyoShikiSaijoRyokinList.add(ryokinhyoShikiSaijoRyokin);

            ryokinhyoSaidanUpGread = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoSaidanUpGread.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoSaidanUpGread.keisanhyoMeisai.MeisaiType__c = '祭壇';
            ryokinhyoSaidanUpGread.keisanhyoMeisai.ItemName__c = '祭壇';
            ryokinhyoSaidanUpGread.keisanhyoMeisai.Suryo__c = 1;

            saidanUpGreadOption = new List<SelectOption>();
            saidanUpGreadOption.add(new SelectOption('SBG-0005401', 'M (家族葬 一日プラン)'));
            saidanUpGreadOption.add(new SelectOption('SBG-0005402', 'L (家族葬 一日プラン)'));
            saidanUpGreadOption.add(new SelectOption('SBG-0005403', 'LL (家族葬 一日プラン)'));
            saidanUpGreadOption.add(new SelectOption('SBG-0005404', 'L (家族葬 二日プラン)'));
            saidanUpGreadOption.add(new SelectOption('SBG-0005405', 'LL (家族葬 二日プラン)'));
            saidanUpGreadOption.add(new SelectOption('SBG-0005406', 'LL (家族葬 華やかプラン)'));

            yorisoOption = new List<SelectOption>();
            yorisoOption.add(new SelectOption('SBG-0005407', 'お別れ花 S'));
            yorisoOption.add(new SelectOption('SBG-0005408', 'お別れ花 M'));
            yorisoOption.add(new SelectOption('SBG-0005409', 'お別れ花 L'));
            yorisoOption.add(new SelectOption('SBG-0005410', '棺上花束 S'));
            yorisoOption.add(new SelectOption('SBG-0005411', '棺上花束 M'));
            yorisoOption.add(new SelectOption('SBG-0005412', '棺上花束 L'));
            yorisoOption.add(new SelectOption('SBG-0005413', '枕花 S'));
            yorisoOption.add(new SelectOption('SBG-0005414', '枕花 M'));
            yorisoOption.add(new SelectOption('SBG-0005415', '枕花 L'));
            yorisoOption.add(new SelectOption('SBG-0005416', '遺影写真 (大小2枚)'));
            yorisoOption.add(new SelectOption('SBG-0005417', '付添安置 (1泊)'));
            yorisoOption.add(new SelectOption('SBG-0005418', '搬送超過料金'));
            yorisoOption.add(new SelectOption('SBG-0005419', 'ご安置追加料金'));

            sogishaOption = new List<SelectOption>();
            sogishaOption.add(new SelectOption('SBG-0005501', '料理'));
            sogishaOption.add(new SelectOption('SBG-0005502', '返礼品'));
            sogishaOption.add(new SelectOption('SBG-0005505', 'ラストメイク'));
            sogishaOption.add(new SelectOption('SBG-0005506', 'ﾒｲｸ&ﾄﾞﾚｽ(古式湯灌)'));
            sogishaOption.add(new SelectOption('SBG-0005507', '湯灌'));
            sogishaOption.add(new SelectOption('SBG-0005510', '供花'));

            ryokinhyoYorisoOptionList = new List<SwitchRyokinhyoMeisaiWrap>();
            SwitchRyokinhyoMeisaiWrap ryokinhyoYorisoOption = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoYorisoOption.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoYorisoOption.keisanhyoMeisai.MeisaiType__c = 'よりそうオプション';
            ryokinhyoYorisoOption.keisanhyoMeisai.ItemName__c = 'よりそうオプション';
            ryokinhyoYorisoOption.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoYorisoOption.keisanhyoMeisai.OptionName__c = '';
            ryokinhyoYorisoOption.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoYorisoOptionList.add(ryokinhyoYorisoOption);

            ryokinhyoSogishaOptionList = new List<SwitchRyokinhyoMeisaiWrap>();
            SwitchRyokinhyoMeisaiWrap ryokinhyoSogishaOption = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoSogishaOption.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoSogishaOption.keisanhyoMeisai.MeisaiType__c = '葬儀社オプション';
            ryokinhyoSogishaOption.keisanhyoMeisai.ItemName__c = '葬儀社オプション';
            ryokinhyoSogishaOption.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoSogishaOption.keisanhyoMeisai.OptionName__c = '';
            ryokinhyoSogishaOptionList.add(ryokinhyoSogishaOption);

            ryokinhyoShikiFreeWordList = new List<SwitchRyokinhyoMeisaiWrap>();
            SwitchRyokinhyoMeisaiWrap ryokinhyoShikiFreeWordItem = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.MeisaiType__c = 'その他オプション';
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.ItemName__c = 'その他オプション';
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.ItemCode__c = 'SBG-0005517';
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.Suryo__c = 1;
            ryokinhyoShikiFreeWordItem.keisanhyoMeisai.OptionName__c = '';
            ryokinhyoShikiFreeWordList.add(ryokinhyoShikiFreeWordItem);

            ryokinhyoCampaignSogiyoBouquet = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.SltFlg__c = false;
            ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.MeisaiType__c = '葬儀用ブーケ';
            ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.ItemName__c = '葬儀用ブーケ';
            ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Suryo__c = 1;

            ryokinhyoShikiOptionShokei = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiOptionShokei.keisanhyoMeisai.MeisaiType__c = 'オプション小計(税込)';
            ryokinhyoShikiGokei = new SwitchRyokinhyoMeisaiWrap();
            ryokinhyoShikiGokei.keisanhyoMeisai.MeisaiType__c = '合計(税込)';
        }
    }

    public class SwitchRyokinhyoMeisaiWrap {
        public SogiMitsumoriKeisanMeisai__c keisanhyoMeisai {get;set;}

        public SwitchRyokinhyoMeisaiWrap(){
            keisanhyoMeisai = new SogiMitsumoriKeisanMeisai__c();
            keisanhyoMeisai.Kazoku1nichiFee__c = 0;
            keisanhyoMeisai.Kazoku2nichiFee__c = 0;
            keisanhyoMeisai.KazokuhanayakaFee__c = 0;
            keisanhyoMeisai.KasoSimpleFee__c = 0;
            keisanhyoMeisai.KasoKihonFee__c = 0;
            keisanhyoMeisai.KasoButsuguFee__c = 0;
            keisanhyoMeisai.KasoOhanaFee__c = 0;
        }
    }

    public void init(){
        keisanhyoWrapList = new List<SogiMitsumoriKeisanhyoWrap>();
        displayKeisanhyoData = new SogiMitsumoriKeisanhyoWrap();
        getMitsumoriKeisanhyoDataList();
        actPriceCalculation();
    }

    public void getMitsumoriKeisanhyoDataList(){

        keisanhyoWrapList = new List<SogiMitsumoriKeisanhyoWrap>();

        for(SogiMitsumoriKeisanhyo__c sltKeisanhyo : getSogiMitsumoriKeisanhyoDataList()){
            SogiMitsumoriKeisanhyoWrap wrap = new SogiMitsumoriKeisanhyoWrap();
            wrap.keisanhyoObj = sltKeisanhyo;
            keisanhyoWrapList.add(wrap);
        }
    }

    public String keisanhyoId {get;set;}
    public void actloadKeisanhyo(){
        displayKeisanhyoData = new SogiMitsumoriKeisanhyoWrap();
        keisanhyoId = Apexpages.currentPage().getParameters().get('pKeisanhyoId');

        SogiMitsumoriKeisanhyo__c sltKeisanhyo = [select 
                                                Id, 
                                                Name, 
                                                KaimyoHomyo__c, 
                                                KaimyoKibo__c, 
                                                WaribikiService__c, 
                                                KiboPlan__c, 
                                                MitsumoriKeisanBiko__c, 
                                                SanretsushaShinzokuFrom__c, 
                                                SanretsushaShinzokuTo__c, 
                                                SanretsushaShinzokuigaiFrom__c, 
                                                SanretsushaShinzokuigaiTo__c, 
                                                JizenSurvey__c, 
                                                ShikigoSurvey__c, 
                                                Alliance__c, 
                                                OpportunityRef__c, 
                                                SoryoTehaiKibo__c, 
                                                ButsuguUmu__c, 
                                                KazokusoIchinichi__c, 
                                                KazokusoHanayaka__c, 
                                                KazokusoFutsuka__c, 
                                                KasoshikiSimple__c, 
                                                KasoshikiKihon__c, 
                                                KasoshikiButsugu__c, 
                                                KasoshikiOhana__c, 
                                                KiboAreaRef__c, 
                                                Saijo__c, 
                                                Kasojo__c, 
                                                ShikijoMeisaiHyokimei__c, 
                                                KasobaMeisaiHyokimei__c, 
                                                CreatedDate, 
                                                (
                                                    select 
                                                        Id, 
                                                        Name, 
                                                        OptionName__c, 
                                                        PlanJuto__c, 
                                                        Kazoku1nichiTeianTaisho__c, 
                                                        Kazoku1nichiName__c, 
                                                        Kazoku1nichiFee__c, 
                                                        KazokuhanayakaTeianTaisho__c, 
                                                        KazokuhanayakaName__c, 
                                                        KazokuhanayakaFee__c, 
                                                        Kazoku2nichiTeianTaisho__c, 
                                                        Kazoku2nichiName__c, 
                                                        Kazoku2nichiFee__c, 
                                                        KasoKihonTeianTaisho__c, 
                                                        KasoKihonName__c, 
                                                        KasoKihonFee__c, 
                                                        KasoButsuguTeianTaisho__c, 
                                                        KasoButsuguName__c, 
                                                        KasoButsuguFee__c, 
                                                        KasoSimpleTeianTaisho__c, 
                                                        KasoSimpleName__c, 
                                                        KasoSimpleFee__c, 
                                                        KasoOhanaTeianTaisho__c, 
                                                        KasoOhanaName__c, 
                                                        KasoOhanaFee__c, 
                                                        ShisetsuFeeZeikomi__c, 
                                                        ShisetsuFeeZeinuki__c, 
                                                        ItemCode__c, 
                                                        ItemName__c, 
                                                        MeisaiType__c, 
                                                        Suryo__c, 
                                                        SltFlg__c, 
                                                        SogiMitsumoriKeisanhyoRef__c, 
                                                        UnitPriceZeinuki__c, 
                                                        UnitPriceZeikomi__c, 
                                                        Biko__c 
                                                    from SogiMitsumoriKeisanMeisais__r
                                                ) 
                                            from SogiMitsumoriKeisanhyo__c 
                                            where Id = :keisanhyoId 
                                            ];
        
        displayKeisanhyoData.keisanhyoObj = sltKeisanhyo;

        displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList = new List<SwitchRyokinhyoMeisaiWrap>();
        displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList = new List<SwitchRyokinhyoMeisaiWrap>();
        displayKeisanhyoData.ryokinhyoYorisoOptionList = new List<SwitchRyokinhyoMeisaiWrap>();
        displayKeisanhyoData.ryokinhyoSogishaOptionList = new List<SwitchRyokinhyoMeisaiWrap>();
        displayKeisanhyoData.ryokinhyoShikiFreeWordList = new List<SwitchRyokinhyoMeisaiWrap>();

        for(SogiMitsumoriKeisanMeisai__c meisai : sltKeisanhyo.SogiMitsumoriKeisanMeisais__r){
            if(meisai.MeisaiType__c == '提案対象'){
                displayKeisanhyoData.ryokinhyoTeianTaisho = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == 'プラン名'){
                displayKeisanhyoData.ryokinhyoPlanName = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoPlanName.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == 'プラン料金'){
                displayKeisanhyoData.ryokinhyoShikiPlan = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiPlan.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '仏具有無'){
                displayKeisanhyoData.ryokinhyoButsuguNashi = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '会員割引'){
                displayKeisanhyoData.ryokinhyoShikiWaribiki = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '事前アンケート'){
                displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '式後アンケート'){
                displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == 'アライアンス'){
                displayKeisanhyoData.ryokinhyoAllianceWaribiki = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '本体小計(税抜)'){
                displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '本体小計(税込)'){
                displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '僧侶手配(読経)'){
                displayKeisanhyoData.ryokinhyoShikiSoryoTehai = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiSoryoTehai.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '戒名授与'){
                displayKeisanhyoData.ryokinhyoShikiKaimyojuyo = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '火葬料金'){
                SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin = new SwitchRyokinhyoMeisaiWrap();
                ryokinhyoShikiKasobaRyokin.keisanhyoMeisai = meisai;
                displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList.add(ryokinhyoShikiKasobaRyokin);
            }
            else if(meisai.MeisaiType__c == '斎場料金'){
                SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin = new SwitchRyokinhyoMeisaiWrap();
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai = meisai;
                displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList.add(ryokinhyoShikiSaijoRyokin);
            }
            else if(meisai.MeisaiType__c == '祭壇'){
                displayKeisanhyoData.ryokinhyoSaidanUpGread = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == 'よりそうオプション'){
                SwitchRyokinhyoMeisaiWrap ryokinhyoYorisoOption = new SwitchRyokinhyoMeisaiWrap();
                ryokinhyoYorisoOption.keisanhyoMeisai = meisai;
                displayKeisanhyoData.ryokinhyoYorisoOptionList.add(ryokinhyoYorisoOption);
            }
            else if(meisai.MeisaiType__c == '葬儀社オプション'){
                SwitchRyokinhyoMeisaiWrap ryokinhyoSogishaOption = new SwitchRyokinhyoMeisaiWrap();
                ryokinhyoSogishaOption.keisanhyoMeisai = meisai;
                displayKeisanhyoData.ryokinhyoSogishaOptionList.add(ryokinhyoSogishaOption);
            }
            else if(meisai.MeisaiType__c == 'その他オプション'){
                SwitchRyokinhyoMeisaiWrap ryokinhyoShikiFreeWordItem = new SwitchRyokinhyoMeisaiWrap();
                ryokinhyoShikiFreeWordItem.keisanhyoMeisai = meisai;
                displayKeisanhyoData.ryokinhyoShikiFreeWordList.add(ryokinhyoShikiFreeWordItem);
            }
            else if(meisai.MeisaiType__c == '葬儀用ブーケ'){
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == 'オプション小計(税込)'){
                displayKeisanhyoData.ryokinhyoShikiOptionShokei = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai = meisai;
            }
            else if(meisai.MeisaiType__c == '合計(税込)'){
                displayKeisanhyoData.ryokinhyoShikiGokei = new SwitchRyokinhyoMeisaiWrap();
                displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai = meisai;
            }
        }
    }

    public void actInsertKeisanhyo(){
        SogiMitsumoriKeisanhyo__c insKeisanhyo = displayKeisanhyoData.keisanhyoObj;
        insKeisanhyo.OpportunityRef__c = oppId;
        insKeisanhyo.KazokusoIchinichi__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c;
        insKeisanhyo.KazokusoFutsuka__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c;
        insKeisanhyo.KazokusoHanayaka__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c;
        insKeisanhyo.KasoshikiSimple__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoSimpleTeianTaisho__c;
        insKeisanhyo.KasoshikiKihon__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoKihonTeianTaisho__c;
        insKeisanhyo.KasoshikiButsugu__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoButsuguTeianTaisho__c;
        insKeisanhyo.KasoshikiOhana__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoOhanaTeianTaisho__c;

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin : displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            if(ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.SltFlg__c) insKeisanhyo.Kasojo__c = ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.OptionName__c;
        }

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin : displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList){
            if(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.SltFlg__c) insKeisanhyo.Saijo__c = ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.OptionName__c;
        }
        
        if(insKeisanhyo.Id != null) insKeisanhyo = insKeisanhyo.clone(false, true);
        insert insKeisanhyo;

        insertKeisanhyoMeisai(insKeisanhyo.Id);
    }

    private SogiMitsumoriKeisanMeisai__c getInsKeisanMeisai(SogiMitsumoriKeisanMeisai__c obj){
        return obj.Id == null ? obj : obj.clone(false, true);
    }

    public void actUpdateKeisanhyo(){
        delete [select Id from SogiMitsumoriKeisanMeisai__c where SogiMitsumoriKeisanhyoRef__c = :displayKeisanhyoData.keisanhyoObj.Id];

        SogiMitsumoriKeisanhyo__c upKeisanhyo = displayKeisanhyoData.keisanhyoObj;
        upKeisanhyo.KazokusoIchinichi__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku1nichiTeianTaisho__c;
        upKeisanhyo.KazokusoFutsuka__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.Kazoku2nichiTeianTaisho__c;
        upKeisanhyo.KazokusoHanayaka__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KazokuhanayakaTeianTaisho__c;
        upKeisanhyo.KasoshikiSimple__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoSimpleTeianTaisho__c;
        upKeisanhyo.KasoshikiKihon__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoKihonTeianTaisho__c;
        upKeisanhyo.KasoshikiButsugu__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoButsuguTeianTaisho__c;
        upKeisanhyo.KasoshikiOhana__c = displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai.KasoOhanaTeianTaisho__c;

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin : displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            if(ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.SltFlg__c) upKeisanhyo.Kasojo__c = ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.OptionName__c;
        }

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin : displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList){
            if(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.SltFlg__c) upKeisanhyo.Saijo__c = ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.OptionName__c;
        }

        update upKeisanhyo;

        insertKeisanhyoMeisai(upKeisanhyo.Id);
    }

    private void insertKeisanhyoMeisai(String keisanhyoId){

        List<SogiMitsumoriKeisanMeisai__c> insKeisanMeisaiList = new List<SogiMitsumoriKeisanMeisai__c>();
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoTeianTaisho.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoPlanName.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiPlan.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiSoryoTehai.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai));

        Integer iKasojoIndex = 0;
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin : displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.HinmokuBunruiNaiJunjo__c = iKasojoIndex;
            insKeisanMeisaiList.add(getInsKeisanMeisai(ryokinhyoShikiKasobaRyokin.keisanhyoMeisai));
            iKasojoIndex++;
        }

        Integer iSaijoIndex = 0;
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin : displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList){
            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.HinmokuBunruiNaiJunjo__c = iSaijoIndex;
            insKeisanMeisaiList.add(getInsKeisanMeisai(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai));
            iSaijoIndex++;
        }
    
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai));

        Integer iYorisoOptionIndex = 0;
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoYorisoOption : displayKeisanhyoData.ryokinhyoYorisoOptionList){
            ryokinhyoYorisoOption.keisanhyoMeisai.HinmokuBunruiNaiJunjo__c = iYorisoOptionIndex;
            insKeisanMeisaiList.add(getInsKeisanMeisai(ryokinhyoYorisoOption.keisanhyoMeisai));
            iYorisoOptionIndex++;
        }

        Integer iSogishaOptionIndex = 0;
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoSogishaOption : displayKeisanhyoData.ryokinhyoSogishaOptionList){
            ryokinhyoSogishaOption.keisanhyoMeisai.HinmokuBunruiNaiJunjo__c = iSogishaOptionIndex;
            insKeisanMeisaiList.add(getInsKeisanMeisai(ryokinhyoSogishaOption.keisanhyoMeisai));
            iSogishaOptionIndex++;
        }
        
        Integer iAtherOptionIndex = 0;
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiFreeWord : displayKeisanhyoData.ryokinhyoShikiFreeWordList){
            ryokinhyoShikiFreeWord.keisanhyoMeisai.HinmokuBunruiNaiJunjo__c = iAtherOptionIndex;
            insKeisanMeisaiList.add(getInsKeisanMeisai(ryokinhyoShikiFreeWord.keisanhyoMeisai));
            iAtherOptionIndex++;
        }
        
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai));
        insKeisanMeisaiList.add(getInsKeisanMeisai(displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai));

        for(SogiMitsumoriKeisanMeisai__c meisai : insKeisanMeisaiList) meisai.SogiMitsumoriKeisanhyoRef__c = keisanhyoId;
        insert insKeisanMeisaiList;

        getMitsumoriKeisanhyoDataList();
    }

    public void actDeleteKeisanhyo(){

        String deletekeisanhyoId = Apexpages.currentPage().getParameters().get('pKeisanhyoId');
        delete [select Id from SogiMitsumoriKeisanhyo__c where Id = :deletekeisanhyoId];

        getMitsumoriKeisanhyoDataList();
    }

    public void conditionReset(){
        
    }

    private List<SogiMitsumoriKeisanhyo__c> getSogiMitsumoriKeisanhyoDataList(){
        return [select 
                    Id, 
                    Name, 
                    KaimyoHomyo__c, 
                    KaimyoKibo__c, 
                    WaribikiService__c, 
                    KiboPlan__c, 
                    MitsumoriKeisanBiko__c, 
                    SanretsushaShinzokuFrom__c, 
                    SanretsushaShinzokuTo__c, 
                    SanretsushaShinzokuigaiFrom__c, 
                    SanretsushaShinzokuigaiTo__c, 
                    JizenSurvey__c, 
                    ShikigoSurvey__c, 
                    Alliance__c, 
                    OpportunityRef__c, 
                    SoryoTehaiKibo__c, 
                    ButsuguUmu__c, 
                    KazokusoIchinichi__c, 
                    KazokusoHanayaka__c, 
                    KazokusoFutsuka__c, 
                    KasoshikiSimple__c, 
                    KasoshikiKihon__c, 
                    KasoshikiButsugu__c, 
                    KasoshikiOhana__c, 
                    KiboAreaRef__c, 
                    Saijo__c, 
                    Kasojo__c, 
                    ShikijoMeisaiHyokimei__c, 
                    KasobaMeisaiHyokimei__c, 
                    CreatedDate 
                from SogiMitsumoriKeisanhyo__c 
                where OpportunityRef__c = :oppId 
                order by CreatedDate desc];
    }

    public void actPriceCalculation(){
        
        List<SwitchRyokinhyoMeisaiWrap> hontaiShokeiList = new List<SwitchRyokinhyoMeisaiWrap>();

        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoShikiPlan);

        displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.OptionName__c = displayKeisanhyoData.keisanhyoObj.ButsuguUmu__c;
        if(displayKeisanhyoData.keisanhyoObj.ButsuguUmu__c == '仏具なし'){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuButsuguNashi = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuButsuguNashi.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.ButsuguNashiWaribiki;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceButsuguNashi = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuButsuguNashi);

            Decimal price = hinmokuPriceButsuguNashi.priceBookEntry.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku1nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku2nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazokuhanayakaFee__c = price;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoOhanaFee__c = 0;
        }
        else{
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoButsuguNashi.keisanhyoMeisai.kasoOhanaFee__c = 0;
        }
        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoButsuguNashi);
        
        displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.OptionName__c = displayKeisanhyoData.keisanhyoObj.WaribikiService__c;
        if(String.isNotBlank(displayKeisanhyoData.keisanhyoObj.WaribikiService__c)){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuKaiinWaribiki = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuKaiinWaribiki.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaiinWaribiki;
            oppDataHinmokuKaiinWaribiki.kaiinKubun = displayKeisanhyoData.keisanhyoObj.WaribikiService__c;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceKaiinWaribiki = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuKaiinWaribiki);

            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = hinmokuPriceKaiinWaribiki.kazoku1Nichi / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = hinmokuPriceKaiinWaribiki.kazoku2Nichi / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = hinmokuPriceKaiinWaribiki.kazokuHanayaka / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.KasoSimpleFee__c = hinmokuPriceKaiinWaribiki.kasoSimple / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kasoKihonFee__c = hinmokuPriceKaiinWaribiki.kasoKihon / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kasoButsuguFee__c = hinmokuPriceKaiinWaribiki.kasoButsugu / tax;
            displayKeisanhyoData.ryokinhyoShikiWaribiki.keisanhyoMeisai.kasoOhanaFee__c = hinmokuPriceKaiinWaribiki.kasoOhana / tax;
        }
        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoShikiWaribiki);
        
        if(displayKeisanhyoData.keisanhyoObj.JizenSurvey__c){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuJizenAnketoWaribiki = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuJizenAnketoWaribiki.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.JizenAnketoWaribiki;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceJizenAnketoWaribiki = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuJizenAnketoWaribiki);

            Decimal price = hinmokuPriceJizenAnketoWaribiki.priceBookEntry.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.KasoSimpleFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoKihonFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoButsuguFee__c = price;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoOhanaFee__c = price;
        }
        else{
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki.keisanhyoMeisai.kasoOhanaFee__c = 0;
        }
        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoJizenAnketoWaribiki);
        
        if(displayKeisanhyoData.keisanhyoObj.ShikigoSurvey__c){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuShikigoAnketoWaribiki = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuShikigoAnketoWaribiki.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.ShikigoAnketoWaribiki;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceShikigoAnketoWaribiki = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuShikigoAnketoWaribiki);
            
            Decimal price = hinmokuPriceShikigoAnketoWaribiki.priceBookEntry.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.KasoSimpleFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoKihonFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoButsuguFee__c = price;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoOhanaFee__c = price;
        }
        else{
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki.keisanhyoMeisai.kasoOhanaFee__c = 0;
        }
        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoShikiAnketoWaribiki);
        
        if(displayKeisanhyoData.keisanhyoObj.WaribikiService__c == '非会員' && String.isNotBlank(displayKeisanhyoData.keisanhyoObj.Alliance__c)){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuAllianceWaribiki = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuAllianceWaribiki.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.AllianceWaribiki;
            oppDataHinmokuAllianceWaribiki.shohinCode = displayKeisanhyoData.keisanhyoObj.Alliance__c;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceAllianceWaribiki = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuAllianceWaribiki);

            PricebookEntry alliance = hinmokuPriceAllianceWaribiki.priceBookEntry;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.ItemName__c = alliance.Name;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.ItemCode__c = alliance.Product2.ShohinBango__c;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.KasoSimpleFee__c = displayKeisanhyoData.keisanhyoObj.Alliance__c == 'SBG-0003620' ? 0 : alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoKihonFee__c = displayKeisanhyoData.keisanhyoObj.Alliance__c == 'SBG-0003620' ? 0 : alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoButsuguFee__c = displayKeisanhyoData.keisanhyoObj.Alliance__c == 'SBG-0003620' ? 0 : alliance.UnitPrice / tax;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoOhanaFee__c = displayKeisanhyoData.keisanhyoObj.Alliance__c == 'SBG-0003620' ? 0 : alliance.UnitPrice / tax;
            for(Schema.PicklistEntry schema : keisanshyoAllianceSchema){
                if(schema.getValue() == displayKeisanhyoData.keisanhyoObj.Alliance__c) displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.Biko__c = schema.getLabel();
            }
        }
        else{
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.ItemName__c = '';
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.ItemCode__c = '';
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.kasoOhanaFee__c = 0;
            displayKeisanhyoData.ryokinhyoAllianceWaribiki.keisanhyoMeisai.Biko__c = '';
        }
        hontaiShokeiList.add(displayKeisanhyoData.ryokinhyoAllianceWaribiki);
        
        Decimal dKazoku1Nichi = 0;
        Decimal dKazoku2Nichi = 0;
        Decimal dKazokuHanayaka = 0;
        Decimal dKasoSimple = 0;
        Decimal dKasoKihon = 0;
        Decimal dKasoButsugu = 0;
        Decimal dKasoOhana = 0;

        for(SwitchRyokinhyoMeisaiWrap hontaiShokei : hontaiShokeiList){
            if(hontaiShokei.keisanhyoMeisai.Kazoku1nichiFee__c != null) dKazoku1Nichi += hontaiShokei.keisanhyoMeisai.Kazoku1nichiFee__c;
            if(hontaiShokei.keisanhyoMeisai.Kazoku2nichiFee__c != null) dKazoku2Nichi += hontaiShokei.keisanhyoMeisai.Kazoku2nichiFee__c;
            if(hontaiShokei.keisanhyoMeisai.KazokuhanayakaFee__c != null) dKazokuHanayaka += hontaiShokei.keisanhyoMeisai.KazokuhanayakaFee__c;
            if(hontaiShokei.keisanhyoMeisai.KasoSimpleFee__c != null) dKasoSimple += hontaiShokei.keisanhyoMeisai.KasoSimpleFee__c;
            if(hontaiShokei.keisanhyoMeisai.KasoKihonFee__c != null) dKasoKihon += hontaiShokei.keisanhyoMeisai.KasoKihonFee__c;
            if(hontaiShokei.keisanhyoMeisai.KasoButsuguFee__c != null) dKasoButsugu += hontaiShokei.keisanhyoMeisai.KasoButsuguFee__c;
            if(hontaiShokei.keisanhyoMeisai.KasoOhanaFee__c != null) dKasoOhana += hontaiShokei.keisanhyoMeisai.KasoOhanaFee__c;
        }

        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.Kazoku1nichiFee__c = dKazoku1Nichi;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.Kazoku2nichiFee__c = dKazoku2Nichi;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.KazokuhanayakaFee__c = dKazokuHanayaka;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.KasoSimpleFee__c = dKasoSimple;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.KasoKihonFee__c = dKasoKihon;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.KasoButsuguFee__c = dKasoButsugu;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeinuki.keisanhyoMeisai.KasoOhanaFee__c = dKasoOhana;

        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.Kazoku1nichiFee__c = dKazoku1Nichi * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.Kazoku2nichiFee__c = dKazoku2Nichi * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.KazokuhanayakaFee__c = dKazokuHanayaka * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.KasoSimpleFee__c = dKasoSimple * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.KasoKihonFee__c = dKasoKihon * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.KasoButsuguFee__c = dKasoButsugu * tax;
        displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.KasoOhanaFee__c = dKasoOhana * tax;

        List<SwitchRyokinhyoMeisaiWrap> optionShohizeiList = new List<SwitchRyokinhyoMeisaiWrap>();

        optionShohizeiList.add(displayKeisanhyoData.ryokinhyoShikiSoryoTehai);

        if(String.isNotBlank(displayKeisanhyoData.keisanhyoObj.KaimyoHomyo__c)){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuKaimyoHomyo = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuKaimyoHomyo.Hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaimyoHomyo;
            oppDataHinmokuKaimyoHomyo.kaimyoHomyoKubun = displayKeisanhyoData.keisanhyoObj.KaimyoHomyo__c;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceKaimyoHomyo = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuKaimyoHomyo);

            Decimal kaimyoKingaku = hinmokuPriceKaimyoHomyo.priceBookEntry.UnitPrice;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.Kazoku1nichiFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.Kazoku2nichiFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KazokuhanayakaFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoSimpleFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoKihonFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoButsuguFee__c = kaimyoKingaku;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoOhanaFee__c = kaimyoKingaku;
        }
        else{
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.Kazoku1nichiFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.Kazoku2nichiFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KazokuhanayakaFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoSimpleFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoKihonFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoButsuguFee__c = 20000;
            displayKeisanhyoData.ryokinhyoShikiKaimyojuyo.keisanhyoMeisai.KasoOhanaFee__c = 20000;
        }
        optionShohizeiList.add(displayKeisanhyoData.ryokinhyoShikiKaimyojuyo);

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin : displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList){
            Decimal kasojoRyokin = ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.UnitPriceZeikomi__c == null ? 0 : ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.UnitPriceZeikomi__c;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku1nichiFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku2nichiFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KazokuhanayakaFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoSimpleFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoKihonFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoButsuguFee__c = kasojoRyokin;
            ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoOhanaFee__c = kasojoRyokin;
            optionShohizeiList.add(ryokinhyoShikiKasobaRyokin);
        }
        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin : displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList){
            Decimal kingaku = 0;
            Decimal kingakuZeikomi = 0;
            if(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.UnitPriceZeinuki__c != null){
                kingaku = ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.UnitPriceZeinuki__c;
                kingakuZeikomi = kingaku * tax;
            }
            else if(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.UnitPriceZeikomi__c != null){
                kingakuZeikomi = ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.UnitPriceZeikomi__c;
                kingaku = kingakuZeikomi / tax;
            }

            ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.UnitPriceZeikomi__c = kingakuZeikomi;
            if(ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.PlanJuto__c){
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Kazoku1nichiFee__c = kingakuZeikomi > 25000 ? kingakuZeikomi - 25000 : 0;
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Kazoku2nichiFee__c = kingakuZeikomi > 50000 ? kingakuZeikomi - 50000 : 0;
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.KazokuhanayakaFee__c = kingakuZeikomi > 70000 ? kingakuZeikomi - 70000 : 0;
            }
            else{
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Kazoku1nichiFee__c = kingakuZeikomi;
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Kazoku2nichiFee__c = kingakuZeikomi;
                ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.KazokuhanayakaFee__c = kingakuZeikomi;
            }
            optionShohizeiList.add(ryokinhyoShikiSaijoRyokin);
        }

        if(String.isNotBlank(displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.ItemCode__c)){
            SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuSaidanUpGread = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
            oppDataHinmokuSaidanUpGread.Hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.SaidanUpGread;
            oppDataHinmokuSaidanUpGread.shohinCode = displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.ItemCode__c;
            SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceSaidanUpGread = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuSaidanUpGread);

            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.Kazoku1nichiFee__c = hinmokuPriceSaidanUpGread.kazoku1Nichi;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.Kazoku2nichiFee__c = hinmokuPriceSaidanUpGread.kazoku2Nichi;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KazokuhanayakaFee__c = hinmokuPriceSaidanUpGread.kazokuHanayaka;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoSimpleFee__c = hinmokuPriceSaidanUpGread.kasoSimple;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoKihonFee__c = hinmokuPriceSaidanUpGread.kasoKihon;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoButsuguFee__c = hinmokuPriceSaidanUpGread.kasoButsugu;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoOhanaFee__c = hinmokuPriceSaidanUpGread.kasoOhana;
        }
        else{
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoSaidanUpGread.keisanhyoMeisai.KasoOhanaFee__c = 0;
        }
        optionShohizeiList.add(displayKeisanhyoData.ryokinhyoSaidanUpGread);

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoYorisoOption : displayKeisanhyoData.ryokinhyoYorisoOptionList){
            if(String.isNotBlank(ryokinhyoYorisoOption.keisanhyoMeisai.ItemCode__c)){
                SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppDataHinmokuSaidanUpGread = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
                oppDataHinmokuSaidanUpGread.Hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.YorisoOption;
                oppDataHinmokuSaidanUpGread.shohinCode = ryokinhyoYorisoOption.keisanhyoMeisai.ItemCode__c;
                SogiMitsumoriKeisanhyoHinmokuPrice.HinmokuPrice hinmokuPriceYorisoOption = iPrice_Calculator.get_hinmoku_price(oppDataHinmokuSaidanUpGread);

                Decimal yorisoOptionZeikomiKingaku = hinmokuPriceYorisoOption.priceBookEntry.UnitPrice;
                Decimal shokei = yorisoOptionZeikomiKingaku * ryokinhyoYorisoOption.keisanhyoMeisai.suryo__c;
                ryokinhyoYorisoOption.keisanhyoMeisai.Kazoku1nichiFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.Kazoku2nichiFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.KazokuhanayakaFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.KasoSimpleFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.KasoKihonFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.KasoButsuguFee__c = shokei;
                ryokinhyoYorisoOption.keisanhyoMeisai.KasoOhanaFee__c = shokei;
                optionShohizeiList.add(ryokinhyoYorisoOption);
            }
        }

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoSogishaOption : displayKeisanhyoData.ryokinhyoSogishaOptionList){
            Decimal kingaku = 0;
            if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005501'){ kingaku = 3000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005502'){ kingaku = 1000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005505'){ kingaku = 40000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005506'){ kingaku = 60000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005507'){ kingaku = 100000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005509'){ kingaku = 15000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005511'){ kingaku = 25000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005510'){ kingaku = 15000; }
            else if(ryokinhyoSogishaOption.keisanhyoMeisai.ItemCode__c == 'SBG-0005512'){ kingaku = 15000; }

            Decimal kingakuZeikomi = kingaku * tax;
            Decimal suryo = ryokinhyoSogishaOption.keisanhyoMeisai.Suryo__c == null ? 1 : ryokinhyoSogishaOption.keisanhyoMeisai.Suryo__c;
            Decimal shokei = kingakuZeikomi * suryo;

            ryokinhyoSogishaOption.keisanhyoMeisai.Suryo__c = suryo;
            ryokinhyoSogishaOption.keisanhyoMeisai.UnitPriceZeinuki__c = kingaku;
            ryokinhyoSogishaOption.keisanhyoMeisai.UnitPriceZeikomi__c = kingakuZeikomi;
            ryokinhyoSogishaOption.keisanhyoMeisai.Kazoku1nichiFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.Kazoku2nichiFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.KazokuhanayakaFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.KasoSimpleFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.KasoKihonFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.KasoButsuguFee__c = shokei;
            ryokinhyoSogishaOption.keisanhyoMeisai.KasoOhanaFee__c = shokei;
            optionShohizeiList.add(ryokinhyoSogishaOption);
        }

        for(SwitchRyokinhyoMeisaiWrap ryokinhyoShikiFreeWord : displayKeisanhyoData.ryokinhyoShikiFreeWordList){
            Decimal kingaku = ryokinhyoShikiFreeWord.keisanhyoMeisai.UnitPriceZeinuki__c == null ? 0 : ryokinhyoShikiFreeWord.keisanhyoMeisai.UnitPriceZeinuki__c;
            Decimal kingakuZeikomi = kingaku * tax;
            Decimal suryo = ryokinhyoShikiFreeWord.keisanhyoMeisai.Suryo__c == null ? 1 : ryokinhyoShikiFreeWord.keisanhyoMeisai.Suryo__c;
            Decimal shokei = kingakuZeikomi * suryo;

            ryokinhyoShikiFreeWord.keisanhyoMeisai.Suryo__c = suryo;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.UnitPriceZeinuki__c = kingaku;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.UnitPriceZeikomi__c = kingakuZeikomi;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.Kazoku1nichiFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.Kazoku2nichiFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.KazokuhanayakaFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.KasoSimpleFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.KasoKihonFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.KasoButsuguFee__c = shokei;
            ryokinhyoShikiFreeWord.keisanhyoMeisai.KasoOhanaFee__c = shokei;
            optionShohizeiList.add(ryokinhyoShikiFreeWord);
        }
        
        if(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c == null){
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoSimpleFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoKihonFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoButsuguFee__c = 0;
            displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoOhanaFee__c = 0;
        }
        else{
            if([select Id, campaign_sougi_bouquet__c from Keiyaku__c where Id = :opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c].campaign_sougi_bouquet__c == '対応不可'){
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku1nichiFee__c = -2200;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku2nichiFee__c = -2200;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KazokuhanayakaFee__c = -2200;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoSimpleFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoKihonFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoButsuguFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoOhanaFee__c = 0;
            }
            else{
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoSimpleFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoKihonFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoButsuguFee__c = 0;
                displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet.keisanhyoMeisai.KasoOhanaFee__c = 0;
            }
        }
        optionShohizeiList.add(displayKeisanhyoData.ryokinhyoCampaignSogiyoBouquet);

        Decimal dKazoku1NichiZei = 0;
        Decimal dKazoku2NichiZei = 0;
        Decimal dKazokuHanayakaZei = 0;
        Decimal dKasoSimpleZei = 0;
        Decimal dKasoKihonZei = 0;
        Decimal dKasoButsuguZei = 0;
        Decimal dKasoOhanaZei = 0;
        for(SwitchRyokinhyoMeisaiWrap optionShokei : optionShohizeiList){
            if(optionShokei.keisanhyoMeisai.sltFlg__c){
                if(optionShokei.keisanhyoMeisai.kazoku1nichiFee__c != null) dKazoku1NichiZei += optionShokei.keisanhyoMeisai.kazoku1nichiFee__c;
                if(optionShokei.keisanhyoMeisai.kazoku2nichiFee__c != null) dKazoku2NichiZei += optionShokei.keisanhyoMeisai.kazoku2nichiFee__c;
                if(optionShokei.keisanhyoMeisai.kazokuhanayakaFee__c != null) dKazokuHanayakaZei += optionShokei.keisanhyoMeisai.kazokuhanayakaFee__c;
                if(optionShokei.keisanhyoMeisai.kasoSimpleFee__c != null) dKasoSimpleZei += optionShokei.keisanhyoMeisai.kasoSimpleFee__c;
                if(optionShokei.keisanhyoMeisai.kasoKihonFee__c != null) dKasoKihonZei += optionShokei.keisanhyoMeisai.kasoKihonFee__c;
                if(optionShokei.keisanhyoMeisai.kasoButsuguFee__c != null) dKasoButsuguZei += optionShokei.keisanhyoMeisai.kasoButsuguFee__c;
                if(optionShokei.keisanhyoMeisai.kasoOhanaFee__c != null) dKasoOhanaZei += optionShokei.keisanhyoMeisai.kasoOhanaFee__c;
            }
        }

        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kazoku1nichiFee__c = dKazoku1NichiZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kazoku2nichiFee__c = dKazoku2NichiZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kazokuhanayakaFee__c = dKazokuHanayakaZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kasoSimpleFee__c = dKasoSimpleZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kasoKihonFee__c = dKasoKihonZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kasoButsuguFee__c = dKasoButsuguZei;
        displayKeisanhyoData.ryokinhyoShikiOptionShokei.keisanhyoMeisai.kasoOhanaFee__c = dKasoOhanaZei;

        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kazoku1nichiFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kazoku1nichiFee__c + dKazoku1NichiZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kazoku2nichiFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kazoku2nichiFee__c + dKazoku2NichiZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kazokuhanayakaFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kazokuhanayakaFee__c + dKazokuHanayakaZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kasoSimpleFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kasoSimpleFee__c + dKasoSimpleZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kasoKihonFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kasoKihonFee__c + dKasoKihonZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kasoButsuguFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kasoButsuguFee__c + dKasoButsuguZei;
        displayKeisanhyoData.ryokinhyoShikiGokei.keisanhyoMeisai.kasoOhanaFee__c = displayKeisanhyoData.ryokinhyoShikiHontaiShokeiZeikomi.keisanhyoMeisai.kasoOhanaFee__c + dKasoOhanaZei;
    }

    public void addKasobaItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddKasobaIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        SwitchRyokinhyoMeisaiWrap ryokinhyoShikiKasobaRyokin = new SwitchRyokinhyoMeisaiWrap();
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.SltFlg__c = false;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.MeisaiType__c = '火葬料金';
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ItemName__c = '火葬料金';
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ItemCode__c = 'SBG-0005518';
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Suryo__c = 1;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.ShisetsuFeeZeikomi__c = null;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.PlanJuto__c = false;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoSimpleFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoKihonFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoButsuguFee__c = 0;
        ryokinhyoShikiKasobaRyokin.keisanhyoMeisai.KasoOhanaFee__c = 0;
        if(displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList.size() == iIndex + 1){
            displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList.add(ryokinhyoShikiKasobaRyokin);
        }   
        else{
            displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList.add(iIndex + 1, ryokinhyoShikiKasobaRyokin);
        }
        actPriceCalculation();
    }

    public void delKasobaItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelKasobaIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        displayKeisanhyoData.ryokinhyoShikiKasobaRyokinList.remove(iIndex);
        actPriceCalculation();
    }

    public void addSaijoItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddSaijoIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        SwitchRyokinhyoMeisaiWrap ryokinhyoShikiSaijoRyokin = new SwitchRyokinhyoMeisaiWrap();
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.MeisaiType__c = '斎場料金';
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ItemName__c = '斎場料金';
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ItemCode__c = 'SBG-0005519';
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.Suryo__c = 1;
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.PlanJuto__c = false;
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ShisetsuFeeZeinuki__c = 0;
        ryokinhyoShikiSaijoRyokin.keisanhyoMeisai.ShisetsuFeeZeikomi__c = null;
        if(displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList.size() == iIndex + 1){
            displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList.add(ryokinhyoShikiSaijoRyokin);
        }   
        else{
            displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList.add(iIndex + 1, ryokinhyoShikiSaijoRyokin);
        }
        actPriceCalculation();
    }

    public void delSaijoItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelSaijoIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        displayKeisanhyoData.ryokinhyoShikiSaijoRyokinList.remove(iIndex);
        actPriceCalculation();
    }

    public void addYorisoOptionItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        SwitchRyokinhyoMeisaiWrap ryokinhyoYorisoOption = new SwitchRyokinhyoMeisaiWrap();
        ryokinhyoYorisoOption.keisanhyoMeisai.SltFlg__c = false;
        ryokinhyoYorisoOption.keisanhyoMeisai.MeisaiType__c = 'よりそうオプション';
        ryokinhyoYorisoOption.keisanhyoMeisai.ItemName__c = 'よりそうオプション';
        ryokinhyoYorisoOption.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.KasoSimpleFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.KasoKihonFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.KasoButsuguFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.KasoOhanaFee__c = 0;
        ryokinhyoYorisoOption.keisanhyoMeisai.suryo__c = 1;
        if(displayKeisanhyoData.ryokinhyoYorisoOptionList.size() == iIndex + 1){
            displayKeisanhyoData.ryokinhyoYorisoOptionList.add(ryokinhyoYorisoOption);
        }   
        else{
            displayKeisanhyoData.ryokinhyoYorisoOptionList.add(iIndex + 1, ryokinhyoYorisoOption);
        }
    }

    public void delYorisoOptionItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        displayKeisanhyoData.ryokinhyoYorisoOptionList.remove(iIndex);
        actPriceCalculation();
    }

    public void addSogishaOptionItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        SwitchRyokinhyoMeisaiWrap ryokinhyoSogishaOption = new SwitchRyokinhyoMeisaiWrap();
        ryokinhyoSogishaOption.keisanhyoMeisai.sltFlg__c = false;
        ryokinhyoSogishaOption.keisanhyoMeisai.MeisaiType__c = '葬儀社オプション';
        ryokinhyoSogishaOption.keisanhyoMeisai.ItemName__c = '葬儀社オプション';
        ryokinhyoSogishaOption.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.KasoSimpleFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.KasoKihonFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.KasoButsuguFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.KasoOhanaFee__c = 0;
        ryokinhyoSogishaOption.keisanhyoMeisai.suryo__c = 1;
        if(displayKeisanhyoData.ryokinhyoSogishaOptionList.size() == iIndex + 1){
            displayKeisanhyoData.ryokinhyoSogishaOptionList.add(ryokinhyoSogishaOption);
        }   
        else{
            displayKeisanhyoData.ryokinhyoSogishaOptionList.add(iIndex + 1, ryokinhyoSogishaOption);
        }
    }

    public void delSogishaOptionItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        displayKeisanhyoData.ryokinhyoSogishaOptionList.remove(iIndex);
        actPriceCalculation();
    }

    public void addFreeWordItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbAddIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        SwitchRyokinhyoMeisaiWrap ryokinhyoShikiFreeWordItem = new SwitchRyokinhyoMeisaiWrap();
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.SltFlg__c = false;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.MeisaiType__c = 'その他オプション';
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.ItemName__c = 'その他オプション';
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.ItemCode__c = 'SBG-0005517';
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.OptionName__c = '';
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.Kazoku1nichiFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.Kazoku2nichiFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.KazokuhanayakaFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.KasoSimpleFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.KasoKihonFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.KasoButsuguFee__c = 0;
        ryokinhyoShikiFreeWordItem.keisanhyoMeisai.KasoOhanaFee__c = 0;
        if(displayKeisanhyoData.ryokinhyoShikiFreeWordList.size() == iIndex + 1){
            displayKeisanhyoData.ryokinhyoShikiFreeWordList.add(ryokinhyoShikiFreeWordItem);
        }   
        else{
            displayKeisanhyoData.ryokinhyoShikiFreeWordList.add(iIndex + 1, ryokinhyoShikiFreeWordItem);
        }
    }

    public void delFreeWordItem(){
        String strIndex = Apexpages.currentPage().getParameters().get('ojbDelIndex');
        Integer iIndex = Integer.valueOf(strIndex);
        
        displayKeisanhyoData.ryokinhyoShikiFreeWordList.remove(iIndex);
        actPriceCalculation();
    }
}