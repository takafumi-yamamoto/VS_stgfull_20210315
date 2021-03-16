public class Ctl_Soukyakusyo {

    String shodanId;
    public String soukyakushoId {get;set;}
    public String ptWebSokyakuFlg {get;set;}
    public String ketteisakiNullFlg {get;set;}
    public String ButsuguNashiKiboFlg {get;set;}
    public String CampaignSougiBouquetFlg {get;set;}

    public Ctl_Soukyakusyo(ApexPages.StandardController controller){
        shodanId = controller.getId();
        ptWebSokyakuFlg = 'false';
        ketteisakiNullFlg = 'false';
        ButsuguNashiKiboFlg = 'false';
        CampaignSougiBouquetFlg = 'false';
        Opportunity opp = [select Id, SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, SimpleYasugoRef__r.CanPtWebSokyakuExp__c,SimpleYasugoRef__r.ButsuguNashiKibo__c from Opportunity where id = :shodanId];

        if(String.isBlank(opp.SimpleYasugoRef__r.ButsuguNashiKibo__c)){
            ButsuguNashiKiboFlg = 'true';
        }

        if(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c == null){
            ketteisakiNullFlg = 'true';
        }
        else if(opp.SimpleYasugoRef__r.CanPtWebSokyakuExp__c){
            ptWebSokyakuFlg = 'true';
        }
        Boolean invalid = new CampNgSogisha.OppLineItemValidator().any_invalids(shodanId);
        if(invalid){
            CampaignSougiBouquetFlg = 'true';
        }
    }


    public PageReference createSoukyakusyo(){

        Opportunity searchResultOpportunity = Dao_Opportunity.SearchById(shodanId);

        String AccountId = searchResultOpportunity.AccountId;

        SimpleYasugo__c searchResultSimpleYasugo = Dao_SimpleYasugo.SearchById(searchResultOpportunity.SimpleYasugoRef__c);

        List<Achievement__c> campaignAchievement =  [select Id, Syubetsu__c , YukoKaishiBi__c ,  YukoFlag__c , SourceShodanRef__c ,TorihikiSakiRef__c from Achievement__c Where TorihikiSakiRef__c =: AccountId And Syubetsu__c = 'campaign_sougi_bouquet'];

        Soukyakusho__c insertSoukyakusyo = putValueInSoukyakusho(searchResultOpportunity, searchResultSimpleYasugo , campaignAchievement);

        insert insertSoukyakusyo;

        soukyakushoId = insertSoukyakusyo.Id;           

        return null;
    }


    private Soukyakusho__c putValueInSoukyakusho(Opportunity anOpportunity, SimpleYasugo__c aSimpleYasugo , List<Achievement__c> campaignAchievement ){

        Soukyakusho__c soukyakusyo = new Soukyakusho__c();

        if(campaignAchievement.size() > 0 ){
            soukyakusyo.Bouquetcampaign__c = true;
        }else{
            soukyakusyo.Bouquetcampaign__c = false;
        }

        if(anOpportunity.OpportunityLineItems.size() > 0){
            putOpportunityLineItemInSoukyakusho(anOpportunity, soukyakusyo);            
        }

        putOkyakusamaSeikyuMeisaiInSoukyakusho(anOpportunity, soukyakusyo);         
        

        putSimpleYasugoAndOpportunityInSoukyakusho(anOpportunity, aSimpleYasugo, soukyakusyo);


        return soukyakusyo;

    }

    private void putOpportunityLineItemInSoukyakusho(Opportunity anOpportunity, Soukyakusho__c soukyakusyo){

        Map<Id,SObject> theProducts = SobjectsExtension.listToMap(
            new List<Product2>([
                select Id, DataKubun__c,k_Service_Id_exp__c, k_ShohinSyubetsu_Id_exp__c, NameForCustomerExp__c, k_Service_Name_exp__c
                from Product2
                where Id = :OpportunityLineItemLinq.collectProductIds(anOpportunity.OpportunityLineItems)
            ])
        );

        Integer waribikicount = 0;
        Integer Couponcount = 0;
        for(OpportunityLineItem anOpportunityLineItem : anOpportunity.OpportunityLineItems){

            Product2 aProduct = (Product2)theProducts.get(anOpportunityLineItem.Product2Id);
            if(
                (aProduct.k_Service_Id_exp__c == '1' || aProduct.k_Service_Id_exp__c == '2')
                && aProduct.k_ShohinSyubetsu_Id_exp__c == '1'
            ){
                soukyakusyo.KiboFuneralPlan__c       = aProduct.NameForCustomerExp__c; // anOpportunityLineItem.Product2.Name;
                soukyakusyo.KiboFuneralPlanPrice__c  = anOpportunityLineItem.UnitPrice;
                soukyakusyo.ServiceType__c           = aProduct.k_Service_Name_exp__c; //anOpportunityLineItem.Product2.k_Service_Name_exp__c;
            }
            if(anOpportunityLineItem.Product2.DataKubun__c == '2:割引プラン' 
            || anOpportunityLineItem.Product2.DataKubun__c == '3:クーポン' ){
                waribikicount++;
                if(waribikicount==1){
                    soukyakusyo.TekiyoWaribikiKingaku__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoWaribiki__c    = aProduct.NameForCustomerExp__c; //anOpportunityLineItem.Product2.Name;
                }
                if(waribikicount==2){
                    soukyakusyo.TekiyoWaribikiKingaku2__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoWaribiki2__c    = aProduct.NameForCustomerExp__c;
                }
                if(waribikicount==3){
                    soukyakusyo.TekiyoWaribikiKingaku3__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoWaribiki3__c    = aProduct.NameForCustomerExp__c;
                }
                if(waribikicount==4){
                    soukyakusyo.TekiyoWaribikiKingaku4__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoWaribiki4__c    = aProduct.NameForCustomerExp__c;
                }
                if(waribikicount==5){
                    soukyakusyo.CouponWaribikiKingaku__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoCoupon__c      = aProduct.NameForCustomerExp__c; //anOpportunityLineItem.Product2.Name;
                }
                if(waribikicount==6){
                    soukyakusyo.CouponWaribikiKingaku2__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoCoupon2__c      = aProduct.NameForCustomerExp__c; //anOpportunityLineItem.Product2.Name;
                }
                if(waribikicount==7){
                    soukyakusyo.CouponWaribikiKingaku3__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoCoupon3__c      = aProduct.NameForCustomerExp__c; //anOpportunityLineItem.Product2.Name;
                }
                if(waribikicount==8){
                    soukyakusyo.TekiyoWaribikiKingaku5__c = anOpportunityLineItem.UnitPrice;
                    soukyakusyo.TekiyoKanoWaribiki5__c    = aProduct.NameForCustomerExp__c;
                }
            }
        }

    }

    private void putOkyakusamaSeikyuMeisaiInSoukyakusho(Opportunity anOpportunity, Soukyakusho__c soukyakusyo){

        Decimal maeukekinKingakuGokei = 0;
        for(OkyakusamaSeikyuMeisai__c anOkyakusamaSeikyuMeisai : anOpportunity.KaisyuYoteisOpportunity__r){

            if(anOkyakusamaSeikyuMeisai.SeikyuHouhou__c == 'sousai'){
                maeukekinKingakuGokei += anOkyakusamaSeikyuMeisai.SeikyuKingaku__c;
                soukyakusyo.MaeukekinUmu__c = true;
            }
        }

        soukyakusyo.MaeukekinKingaku__c = maeukekinKingakuGokei;
    }




    private void putSimpleYasugoAndOpportunityInSoukyakusho(Opportunity anOpportunity, SimpleYasugo__c aSimpleYasugo, Soukyakusho__c soukyakusyo){
        soukyakusyo.OmukaesakiStreet__c                   = aSimpleYasugo.OmukaeSakiStreet__c;
        soukyakusyo.OmukaesakiName__c                     = aSimpleYasugo.OmukaeSakiName__c;
        soukyakusyo.TaishoshaDeathDate__c                 = aSimpleYasugo.TaishoushaBotsunengappi__c;
        String anchisaki = aSimpleYasugo.KiboGoanchisaki__c + '　' + aSimpleYasugo.GoanchisakiJusho__c;
        soukyakusyo.Anchisaki__c                          = anchisaki.replace('null','');
        soukyakusyo.KiboFuneralArea__c                    = aSimpleYasugo.KiboAreaRef__r.Name;
        soukyakusyo.TaishoshaSyuha__c                     = aSimpleYasugo.TaishoshaRef__r.Syuha__c;
        soukyakusyo.TaishoshaAddress__c                   = aSimpleYasugo.TaishoshaAddress__c;
        soukyakusyo.TaishoshaSeibetsu__c                  = aSimpleYasugo.TaishoshaGender__c;
        soukyakusyo.TaishoshaBirthday__c                  = aSimpleYasugo.TaishoushaSeinengappi__c;
        soukyakusyo.TaishoshaAge__c                       = aSimpleYasugo.TaishoshaAge__c;
        soukyakusyo.TaishoshaSei__c                       = aSimpleYasugo.TaishoshaRef__r.LastName;
        soukyakusyo.TaishoshaMei__c                       = aSimpleYasugo.TaishoshaRef__r.FirstName;
        soukyakusyo.TaishoshaFurigana__c                  = aSimpleYasugo.TaishoshaNameFurigana__c;
        soukyakusyo.SokyakushoKisaiJiko__c                = aSimpleYasugo.SokyakushoKisaiJiko__c;
        soukyakusyo.MonkArrangements__c                   = aSimpleYasugo.MonkArrangements__c;
        soukyakusyo.MoshuAddress__c                       = aSimpleYasugo.MoshuAddress__c;
        soukyakusyo.MoshuDenwa__c                         = aSimpleYasugo.MoshuTelNo__c;
        soukyakusyo.MoshuSei__c                           = aSimpleYasugo.MoshuRef__r.LastName;
        soukyakusyo.MoshuMei__c                           = aSimpleYasugo.MoshuRef__r.FirstName;
        soukyakusyo.MoshuFurigana__c                      = aSimpleYasugo.MoshuFurigana__c;
        soukyakusyo.SodanshaFax__c                        = anOpportunity.Account.YusenFaxFormula__c;
        soukyakusyo.SodanshaKeitai__c                     = anOpportunity.Account.MobilePhone__c;
        soukyakusyo.SodanshaSei__c                        = anOpportunity.Account.LastName;
        soukyakusyo.SodanshaMei__c                        = anOpportunity.Account.FirstName;
        soukyakusyo.SodanshaFurigana__c                   = anOpportunity.Account.NameFurigana__c;
        soukyakusyo.SodanshaAddress__c                    = anOpportunity.Account.BillingAddressFormula__c;
        soukyakusyo.SodanshaDenwa__c                      = anOpportunity.Account.Phone;
        soukyakusyo.FuneralFaxNumber__c                   = aSimpleYasugo.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.YusenFaxFormula__c;
        soukyakusyo.SoukyakusakiFuneralName__c            = aSimpleYasugo.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
        soukyakusyo.FaxSoshinsakiFukusuAri__c             = aSimpleYasugo.SimpleYasugoKeiyakuRef__r.FaxSoshinsakiFukusuAri__c;
        soukyakusyo.ZokugaraSodanshaNitottenoTaishosha__c = aSimpleYasugo.ZokugaraSodanshaNitottenoTaishosha__c;
        soukyakusyo.KiboShiharaiHouhou__c                 = anOpportunity.KiboShiharaiHouhou__c;
        soukyakusyo.ShodanNumber__c                       = anOpportunity.ShodanBangoF__c;
        soukyakusyo.TekiyoKanokaiinWaribiki__c            = memberKaiinHikaku(aSimpleYasugo,anOpportunity);
        soukyakusyo.ShiryoseikyuUmu__c                    = anOpportunity.ShiryoSeikyuUmuExp__c;
        soukyakusyo.TaishoshaJuminhyouAddress__c          = aSimpleYasugo.TaishoshaJuminhyouAddress__c;
        soukyakusyo.ButsuguNashiKibo__c                   = aSimpleYasugo.ButsuguNashiKibo__c;
        soukyakusyo.SaidanKibo__c                         = aSimpleYasugo.SaidanKibo__c;
        soukyakusyo.KanjoHanatabaKibo__c                  = aSimpleYasugo.KanjoHanatabaKibo__c;
        soukyakusyo.MakurabanaKibo__c                     = aSimpleYasugo.MakurabanaKibo__c;
        soukyakusyo.KagobanaKibo__c                       = aSimpleYasugo.KagobanaKibo__c;

        if(aSimpleYasugo.TaishoshaBodaijinoUmu__c !=null && aSimpleYasugo.TaishoshaBodaijinoUmu__c.contains('有')){
            soukyakusyo.TaisyosyaBodaijinoUmu__c = true;
        } else {
            soukyakusyo.TaisyosyaBodaijinoUmu__c = false;
        }
        soukyakusyo.TaisyosyaBodaijinoUmuOrg__c = aSimpleYasugo.TaishoshaBodaijinoUmu__c;


    }


    private String memberKaiinHikaku(SimpleYasugo__c aSimpleYasugo, Opportunity anOpportunity){

        // 相談者メンバー情報
        String sodanshaMemberTokutenKubun       = anOpportunity.SodanshaMemberTokutenKubun__c;
        String sodanshaMemberTokutenKubunCode   = anOpportunity.SodanshaMemberTokutenKubunCode__c;

        // 対象者メンバー情報
        String taishoshaMemberTokutenKubun     = aSimpleYasugo.TaishoshaMemberTokutenKubun__c;
        String taishoshaMemberTokutenKubunCode = aSimpleYasugo.TaishoshaMemberTokutenKubunCode__c;

        String tekiyoKanokaiinWaribiki = '';

        if(sodanshaMemberTokutenKubunCode == taishoshaMemberTokutenKubunCode){
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubun;
        }

        else if(sodanshaMemberTokutenKubunCode == 'OsoshikiYoyaku' || taishoshaMemberTokutenKubunCode == 'OsoshikiYoyaku'){
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubunCode == 'OsoshikiYoyaku' ? sodanshaMemberTokutenKubun : taishoshaMemberTokutenKubun;
        }

        else if(sodanshaMemberTokutenKubunCode == 'Jizenwari' || taishoshaMemberTokutenKubunCode == 'Jizenwari'){
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubunCode == 'Jizenwari' ? sodanshaMemberTokutenKubun : taishoshaMemberTokutenKubun;
        }

        else if(sodanshaMemberTokutenKubunCode == 'ItteiJoken' || taishoshaMemberTokutenKubunCode == 'ItteiJoken'){
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubunCode == 'ItteiJoken' ? sodanshaMemberTokutenKubun : taishoshaMemberTokutenKubun;
        }

        else if(sodanshaMemberTokutenKubunCode == 'Muryo' || taishoshaMemberTokutenKubunCode == 'Muryo'){
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubunCode == 'Muryo' ? sodanshaMemberTokutenKubun : taishoshaMemberTokutenKubun;
        } 

        else {
            tekiyoKanokaiinWaribiki = sodanshaMemberTokutenKubun;
        }

        return tekiyoKanokaiinWaribiki;
    }
}