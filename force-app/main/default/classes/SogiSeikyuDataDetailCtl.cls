public class SogiSeikyuDataDetailCtl {

    public class IllegalParametersException extends Exception {}

    public Boolean newFlg = false;
    public String seikyuNumber {get; set;}
    public String seikyuId {get; set;}
    public String ptWebEndPoint {get; set;}
      public PartnerSeikyuSogisha__c seikyuHeader {get;set;}
      public List<PartnerSeikyuMeisaiSogisha__c> seikyuMeisaiList {get;set;}
      public List<String> idList = new List<String>();
      public String searchOpp = 'select Id, ' + 
                                  'ShodanBango__c, ' + 
                                  'Utiagebi__c, ' + 
                                  'Amount, ' + 
                                  'SeikyuYoteiGakuPartnerExp__c, ' + 
                                  'NyukinSimekiriBiPartner__c, ' + 
                                  'UriageGakuPartnerExp__c, ' + 
                                  'TesuryoPartnerForPlan__c, ' + 
                                  'UriageCyoseiGakuPartnerExp__c, ' + 
                                  'TesuryoPartnerForOption__c, ' + 
                                  'JimuTesuryo__c, ' + 
                                  'TokuyakutenTesuryo__c, ' + 
                                  'SeikyushoHassoubiPartner__c, ' + 
                                  'ShiharaiKijitsuPartner__c, ' + 
                                  'SimpleYasugoRef__r.PlanNaiyo__c, ' + 
                                  'SimpleYasugoRef__r.TaishoshaRef__r.LastName, ' +  
                                  'SimpleYasugoRef__r.TaishoshaRef__r.FirstName, ' + 
                                  'SimpleYasugoRef__r.ReturnGoodsTotalFee__c, ' + 
                                  'SimpleYasugoRef__r.CookingTotalFee__c, ' + 
                                  'SimpleYasugoRef__r.LastMakeupPrice__c, ' + 
                                  'SimpleYasugoRef__r.MakeupDressPrice__c, ' + 
                                  'SimpleYasugoRef__r.YukanPrice__c, ' + 
                                  'SimpleYasugoRef__r.MakurahanaPrice__c, ' + 
                                  'SimpleYasugoRef__r.BouquetPrice__c, ' + 
                                  'SimpleYasugoRef__r.PartingPrice__c, ' + 
                                  'SimpleYasugoRef__r.KugePrice__c, ' + 
                                  'SimpleYasugoRef__r.IeiPrice__c, ' + 
                                  'SimpleYasugoRef__r.FrontSignPrice__c, ' + 
                                  'SimpleYasugoRef__r.ExteriorPrice__c, ' + 
                                  'SimpleYasugoRef__r.UrnPrice__c, ' + 
                                  'SimpleYasugoRef__r.Hitsugi__c, ' + 
                                  'SimpleYasugoRef__r.EmbalmingPrice__c, ' + 
                                  'SimpleYasugoRef__r.SaidanPrice__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SeikyuSakiAtena__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.NameShogo__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanCodeTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanMeiTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaShubetsuTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaBangoTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiKanaTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenCodeTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenMeiTosha__c, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.Id, ' + 
                                  'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.PtWebSeikyushoRenkei__c ' + 
                                  'from Opportunity ' + 
                                  'where ShodanBango__c = :idList ' + 
                                  'order by ShodanBango__c ';
  
      public String searchSeikyu = 'select Id, ' + 
                    'Name,' + 
                                  'KokyakuId__c, ' + 
                                  'TorihikisakiBango__c, ' + 
                                  'ShiharaiKijitsu__c, ' + 
                                  'SeikyuStatus__c, ' + 
                                  'SeikyuKingaku__c, ' + 
                                  'Seikyubi__c, ' + 
                                  'SogishaName__c, ' + 
                                  'SeikyusakiName__c, ' + 
                                  'NyukinShimekiribi__c, ' + 
                                  'SashimodoshiRiyu__c, ' + 
                                  'SeikyuSakuseiShaRef__c, ' + 
                                  'KinyukikanMeiTosha__c, ' + 
                                  'KinyukikanCodeTosha__c, ' + 
                                  'ShitenMeiTosha__c, ' + 
                                  'ShitenCodeTosha__c, ' + 
                                  'KozaShubetsuTosha__c, ' + 
                                  'KozaBangoTosha__c, ' + 
                                  'KozaMeigiKanaTosha__c, ' + 
                                  'KozaMeigiTosha__c, ' + 
                                  'SeikyushoSoshinTaisho__c, ' + 
                                  'PartnerKeiyakuRef__r.Teikeisaki__r.Fax,' + 
                                  'PartnerKeiyakuRef__r.Teikeisaki__r.SeikyuSakiFax1__c,' + 
                                  'PartnerKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c, ' + 
                                  '(select Id, ' + 
                                    'No__c, ' + 
                    'OptionTesuryo__c,' + 
                    'OkyakusamaMei__c,' + 
                    'OwakareBana__c,' + 
                    'OwakareBanaFeeRate__c,' + 
                    'OwakareBanaFee__c,' + 
                    'PartnerSeikyuSogishaRef__c,' + 
                    'PlanTesuryo__c,' + 
                    'TokuyakutenTesuryo__c,' + 
                    'PlanNaiyo__c,' + 
                    'MakeDress__c,' + 
                    'MakeDressFeeRate__c,' + 
                    'MakeDressFee__c,' + 
                    'LastMake__c,' + 
                    'LastMakeFeeRate__c,' + 
                    'LastMakeFee__c,' + 
                    'IeiShashin__c,' + 
                    'IeiShashinFeeRate__c,' + 
                    'IeiShashinFee__c,' + 
                    'GaisoSetsubiTsuika__c,' + 
                    'GaisoSetsubiTsuikaFeeRate__c,' + 
                    'GaisoSetsubiTsuikaFee__c,' + 
                    'Hitsugi__c,' + 
                    'HitsugiFeeRate__c,' + 
                    'HitsugiFee__c,' + 
                    'KanjoHanataba__c,' + 
                    'KanjoHanatabaFeeRate__c,' + 
                    'KanjoHanatabaFee__c,' + 
                    'Kyoka__c,' + 
                    'KyokaFeeRate__c,' + 
                    'KyokaFee__c,' + 
                    'Kumotsu__c,' + 
                    'KokyakuId__c,' + 
                    'GokeiKingaku__c,' + 
                    'KotsutsuboRankUp__c,' + 
                    'KotsutsuboRankUpFeeRate__c,' + 
                    'KotsutsuboRankUpFee__c,' + 
                    'Sashihikigaku__c,' + 
                    'Sekobi__c,' + 
                    'OpportunityRef__c,' + 
                    'ShomenKanban__c,' + 
                    'ShomenKanbanFeeRate__c,' + 
                    'ShomenKanbanFee__c,' + 
                    'Yukan__c,' + 
                    'YukanFeeRate__c,' + 
                    'YukanFee__c,' + 
                    'Henreihin__c,' + 
                    'HenreihinFeeRate__c,' + 
                    'HenreihinFee__c,' + 
                    'MakuraBana__c,' + 
                    'MakuraBanaFeeRate__c,' + 
                    'MakuraBanaFee__c,' + 
                    'EmbalmingPrice__c,' + 
                    'EmbalmingPriceFeeRate__c,' + 
                    'EmbalmingPriceFee__c,' + 
                    'SaidanPrice__c,' + 
                    'SaidanPriceFeeRate__c,' + 
                    'SaidanPriceFee__c,' + 
                    'Ryori__c, ' + 
                    'RyoriFeeRate__c, ' + 
                    'RyoriFee__c, ' + 
                    'JimuTesuryo__c, ' + 
                    'kishafutankingaku__c, ' + 
                    'Yorisofutankingaku__c, ' + 
                    'Verified__c ' +
                    'from PartnerSeikyuSogishaPartnerSeikyuMeisais__r ' +
                    'order by KokyakuId__c) ' + 
                                  'from PartnerSeikyuSogisha__c ' + 
                                  'where Id = :seikyuId ' + 
                                  'order by KokyakuId__c ' + 
                                  'limit 1 ';
  
    public String openType {get; set;}
      
      public SogiSeikyuDataDetailCtl () {
        seikyuHeader = new PartnerSeikyuSogisha__c();
        seikyuMeisaiList = new List<PartnerSeikyuMeisaiSogisha__c>();
        openType = Apexpages.currentPage().getParameters().get('openType');
      seikyuNumber = Apexpages.currentPage().getParameters().get('seikyuNumber');
      seikyuId = Apexpages.currentPage().getParameters().get('seikyuId');
      }
  
      public void init(){
        ptWebEndPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c;
      if(openType == 'new') { openTypeNew(); }
      else if(openType == 'add') { openTypeAdd(); }
      else if(openType == 'reference') { openTypeReference(); }
    }
    
    private void openTypeNew(){
      idList.add(seikyuNumber);
      String seikyuNumbers = Apexpages.currentPage().getParameters().get('seikyuNumbers');
      for(String sNo : seikyuNumbers.split(',')){
        if(String.isNotBlank(sNo)){
          idList.add(sNo);
        }
      }
  
      List<Opportunity> sltOppList = Database.query(searchOpp);
      List<Opportunity> sltOppTempList = new List<Opportunity>();
      for(Opportunity sltOppTemp : sltOppList){
        if(sltOppTemp.ShodanBango__c == seikyuNumber){
          sltOppTempList.add(sltOppTemp);
        }
      }
  
      for(Opportunity sltOppTemp : sltOppList){
        if(sltOppTemp.ShodanBango__c != seikyuNumber){
          sltOppTempList.add(sltOppTemp);
        }
      }
      
      Integer i = 1;
      Decimal seikyuKingaku = 0;
      for(Opportunity sltOpp : sltOppTempList){
        PartnerSeikyuMeisaiSogisha__c sm = new PartnerSeikyuMeisaiSogisha__c();
  
        if(sltOpp.ShodanBango__c == seikyuNumber){
          seikyuHeader.SeikyuStatus__c = '未作成';
          seikyuHeader.PartnerKeiyakuRef__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;
          seikyuHeader.SogishaName__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
          seikyuHeader.SeikyusakiName__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SeikyuSakiAtena__c != null ? sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SeikyuSakiAtena__c : sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.NameShogo__c;
          seikyuHeader.KokyakuId__c = sltOpp.ShodanBango__c;
          seikyuHeader.ShiharaiKijitsu__c = sltOpp.ShiharaiKijitsuPartner__c;
          seikyuHeader.TorihikisakiBango__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c;
          seikyuHeader.NyukinShimekiribi__c = sltOpp.NyukinSimekiriBiPartner__c;
          seikyuHeader.KinyukikanCodeTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanCodeTosha__c;
          seikyuHeader.KinyukikanMeiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanMeiTosha__c;
          seikyuHeader.KozaShubetsuTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaShubetsuTosha__c;
          seikyuHeader.KozaBangoTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaBangoTosha__c;
          seikyuHeader.KozaMeigiKanaTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiKanaTosha__c;
          seikyuHeader.KozaMeigiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiTosha__c;
          seikyuHeader.ShitenCodeTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenCodeTosha__c;
          seikyuHeader.ShitenMeiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenMeiTosha__c;
          seikyuHeader.SeikyushoSoshinTaisho__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.PtWebSeikyushoRenkei__c;
        }
        sm.No__c = i;
        sm.OpportunityRef__c = sltOpp.Id;
        sm.Sekobi__c = sltOpp.Utiagebi__c;
        sm.KokyakuId__c = sltOpp.ShodanBango__c;
        sm.OkyakusamaMei__c = sltOpp.SimpleYasugoRef__r.TaishoshaRef__r.LastName + ' 家様';
        sm.PlanNaiyo__c = sltOpp.SimpleYasugoRef__r.PlanNaiyo__c;
        sm.GokeiKingaku__c = sltOpp.Amount;
        
        
        sm.Henreihin__c = sltOpp.SimpleYasugoRef__r.ReturnGoodsTotalFee__c == null ? 0 : sltOpp.SimpleYasugoRef__r.ReturnGoodsTotalFee__c;
        sm.HenreihinFeeRate__c = 0.1;
        sm.HenreihinFee__c = (sm.Henreihin__c * sm.HenreihinFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.Ryori__c = sltOpp.SimpleYasugoRef__r.CookingTotalFee__c == null ? 0 : sltOpp.SimpleYasugoRef__r.CookingTotalFee__c;
        sm.RyoriFeeRate__c = 0.05;
        sm.RyoriFee__c = (sm.Ryori__c * sm.RyoriFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.LastMake__c = sltOpp.SimpleYasugoRef__r.LastMakeupPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.LastMakeupPrice__c;
        sm.LastMakeFeeRate__c = 0.1;
        sm.LastMakeFee__c = (sm.LastMake__c * sm.LastMakeFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.MakeDress__c = sltOpp.SimpleYasugoRef__r.MakeupDressPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.MakeupDressPrice__c;
        sm.MakeDressFeeRate__c = 0.1;
        sm.MakeDressFee__c = (sm.MakeDress__c * sm.MakeDressFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.Yukan__c = sltOpp.SimpleYasugoRef__r.YukanPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.YukanPrice__c;
        sm.YukanFeeRate__c = 0.1;
        sm.YukanFee__c = (sm.Yukan__c * sm.YukanFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.MakuraBana__c = sltOpp.SimpleYasugoRef__r.MakurahanaPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.MakurahanaPrice__c;
        sm.MakuraBanaFeeRate__c = 0.1;
        sm.MakuraBanaFee__c = (sm.MakuraBana__c * sm.MakuraBanaFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.KanjoHanataba__c = sltOpp.SimpleYasugoRef__r.BouquetPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.BouquetPrice__c;
        sm.KanjoHanatabaFeeRate__c = 0.1;
        sm.KanjoHanatabaFee__c = (sm.KanjoHanataba__c * sm.KanjoHanatabaFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.OwakareBana__c = sltOpp.SimpleYasugoRef__r.PartingPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.PartingPrice__c;
        sm.OwakareBanaFeeRate__c = 0.1;
        sm.OwakareBanaFee__c = (sm.OwakareBana__c * sm.OwakareBanaFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.Kyoka__c = sltOpp.SimpleYasugoRef__r.KugePrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.KugePrice__c;
        sm.KyokaFeeRate__c = 0.1;
        sm.KyokaFee__c = (sm.Kyoka__c * sm.KyokaFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.IeiShashin__c = sltOpp.SimpleYasugoRef__r.IeiPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.IeiPrice__c;
        sm.IeiShashinFeeRate__c = 0.1;
        sm.IeiShashinFee__c = (sm.IeiShashin__c * sm.IeiShashinFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.ShomenKanban__c = sltOpp.SimpleYasugoRef__r.FrontSignPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.FrontSignPrice__c;
        sm.ShomenKanbanFeeRate__c = 0.1;
        sm.ShomenKanbanFee__c = (sm.ShomenKanban__c * sm.ShomenKanbanFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.GaisoSetsubiTsuika__c = sltOpp.SimpleYasugoRef__r.ExteriorPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.ExteriorPrice__c;
        sm.GaisoSetsubiTsuikaFeeRate__c = 0.1;
        sm.GaisoSetsubiTsuikaFee__c = (sm.GaisoSetsubiTsuika__c * sm.GaisoSetsubiTsuikaFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.KotsutsuboRankUp__c = sltOpp.SimpleYasugoRef__r.UrnPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.UrnPrice__c;
        sm.KotsutsuboRankUpFeeRate__c = 0.1;
        sm.KotsutsuboRankUpFee__c = (sm.KotsutsuboRankUp__c * sm.KotsutsuboRankUpFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.Hitsugi__c = sltOpp.SimpleYasugoRef__r.Hitsugi__c == null ? 0 : sltOpp.SimpleYasugoRef__r.Hitsugi__c;
        sm.HitsugiFeeRate__c = 0.1;
        sm.HitsugiFee__c = (sm.Hitsugi__c * sm.HitsugiFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.EmbalmingPrice__c = sltOpp.SimpleYasugoRef__r.EmbalmingPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.EmbalmingPrice__c;
        sm.EmbalmingPriceFeeRate__c = 0.1;
        sm.EmbalmingPriceFee__c = (sm.EmbalmingPrice__c * sm.EmbalmingPriceFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.SaidanPrice__c = sltOpp.SimpleYasugoRef__r.SaidanPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.SaidanPrice__c;
        sm.SaidanPriceFeeRate__c = 0.1;
        sm.SaidanPriceFee__c = (sm.SaidanPrice__c * sm.SaidanPriceFeeRate__c).round(System.RoundingMode.DOWN);
  
        sm.JimuTesuryo__c = sltOpp.JimuTesuryo__c == null ? 0 : sltOpp.JimuTesuryo__c;
        SogiShiharaitsuchisyoWaribikiKeisan.ResultSogiwaribiki WaribikiData = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalizationSeikyu(sltOpp.id);
        { //総額-差引額の部
          sm.PlanTesuryo__c =  (sltOpp.TesuryoPartnerForPlan__c != null ? sltOpp.TesuryoPartnerForPlan__c : 0);
            
          sm.OptionTesuryo__c = 
            ( sltOpp.TesuryoPartnerForOption__c != null ? sltOpp.TesuryoPartnerForOption__c : 0 )
            +
            ( sltOpp.JimuTesuryo__c == null ? 0 : sltOpp.JimuTesuryo__c )//事務手数料は請求書の場合は発生しないはずだが、オプション手数料に繰り入れ。
            + (WaribikiData.yorisofutan + WaribikiData.kishafutan); 
  
          sm.TokuyakutenTesuryo__c = sltOpp.TokuyakutenTesuryo__c != null ? sltOpp.TokuyakutenTesuryo__c : 0;
  
          sm.Sashihikigaku__c = sltOpp.SeikyuYoteiGakuPartnerExp__c;
        }
        WaribikiData = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(sltOpp.id);
        sm.Verified__c = false;
        seikyuKingaku += sm.Sashihikigaku__c;
        sm.Yorisofutankingaku__c = WaribikiData.yorisofutan;
        sm.kishafutankingaku__c = WaribikiData.kishafutan;
        seikyuMeisaiList.add(sm);
        i++;
      }
      seikyuHeader.SeikyuKingaku__c = seikyuKingaku;
    }
  
    private void openTypeAdd(){
      idList.add(seikyuNumber);
      String seikyuNumbers = Apexpages.currentPage().getParameters().get('seikyuNumbers');
      for(String sNo : seikyuNumbers.split(',')){
        if(String.isNotBlank(sNo)){
          idList.add(sNo);
        }
      }
  
      Set<String> seikyuDetailIdSet = new Set<String>();
      String seikyuDetailIds = Apexpages.currentPage().getParameters().get('seikyuDetailIds');
      for(String sNo : seikyuDetailIds.split(',')){
        if(String.isNotBlank(sNo)){
          seikyuDetailIdSet.add(sNo);
        }
      }
  
      Map<String, PartnerSeikyuMeisaiSogisha__c> oppBangoSeikyuDetailMap = getPartnerSeikyuMeisaiSogishaByIds(seikyuDetailIdSet);
  
      List<Opportunity> sltOppList = Database.query(searchOpp);
      List<Opportunity> sltOppTempList = new List<Opportunity>();
      for(Opportunity sltOppTemp : sltOppList){
        if(sltOppTemp.ShodanBango__c == seikyuNumber){
          sltOppTempList.add(sltOppTemp);
        }
      }
  
      for(Opportunity sltOppTemp : sltOppList){
        if(sltOppTemp.ShodanBango__c != seikyuNumber){
          sltOppTempList.add(sltOppTemp);
        }
      }
      
      Integer i = 1;
      Decimal seikyuKingaku = 0;
      for(Opportunity sltOpp : sltOppTempList){
        if(sltOpp.ShodanBango__c == seikyuNumber){
          seikyuHeader.Id = seikyuId;
          seikyuHeader.SeikyuStatus__c = '確認中';
          seikyuHeader.PartnerKeiyakuRef__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;
          seikyuHeader.SogishaName__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
          seikyuHeader.SeikyusakiName__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SeikyuSakiAtena__c != null ? sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SeikyuSakiAtena__c : sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.NameShogo__c;
          seikyuHeader.KokyakuId__c = sltOpp.ShodanBango__c;
          seikyuHeader.ShiharaiKijitsu__c = sltOpp.ShiharaiKijitsuPartner__c;
          seikyuHeader.TorihikisakiBango__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c;
          seikyuHeader.NyukinShimekiribi__c = sltOpp.NyukinSimekiriBiPartner__c;
          seikyuHeader.KinyukikanCodeTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanCodeTosha__c;
          seikyuHeader.KinyukikanMeiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KinyukikanMeiTosha__c;
          seikyuHeader.KozaShubetsuTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaShubetsuTosha__c;
          seikyuHeader.KozaBangoTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaBangoTosha__c;
          seikyuHeader.KozaMeigiKanaTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiKanaTosha__c;
          seikyuHeader.KozaMeigiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.KozaMeigiTosha__c;
          seikyuHeader.ShitenCodeTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenCodeTosha__c;
          seikyuHeader.ShitenMeiTosha__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.ShitenMeiTosha__c;
          seikyuHeader.SeikyushoSoshinTaisho__c = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.PtWebSeikyushoRenkei__c;
        }
  
        PartnerSeikyuMeisaiSogisha__c sm = new PartnerSeikyuMeisaiSogisha__c();
        SogiShiharaitsuchisyoWaribikiKeisan.ResultSogiwaribiki WaribikiData = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalizationSeikyu(sltOpp.id);
        if(oppBangoSeikyuDetailMap.containskey(sltOpp.ShodanBango__c)){
          sm = oppBangoSeikyuDetailMap.get(sltOpp.ShodanBango__c);
        }
        else{
          sm.OpportunityRef__c = sltOpp.Id;
          sm.Sekobi__c = sltOpp.Utiagebi__c;
          sm.KokyakuId__c = sltOpp.ShodanBango__c;
          sm.OkyakusamaMei__c = sltOpp.SimpleYasugoRef__r.TaishoshaRef__r.LastName + ' 家様';
          sm.PlanNaiyo__c = sltOpp.SimpleYasugoRef__r.PlanNaiyo__c;
          sm.GokeiKingaku__c = sltOpp.Amount;
          
          sm.Henreihin__c = sltOpp.SimpleYasugoRef__r.ReturnGoodsTotalFee__c == null ? 0 : sltOpp.SimpleYasugoRef__r.ReturnGoodsTotalFee__c;
          sm.HenreihinFeeRate__c = 0.1;
          sm.HenreihinFee__c = (sm.Henreihin__c * sm.HenreihinFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.Ryori__c = sltOpp.SimpleYasugoRef__r.CookingTotalFee__c == null ? 0 : sltOpp.SimpleYasugoRef__r.CookingTotalFee__c;
          sm.RyoriFeeRate__c = 0.05;
          sm.RyoriFee__c = (sm.Ryori__c * sm.RyoriFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.LastMake__c = sltOpp.SimpleYasugoRef__r.LastMakeupPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.LastMakeupPrice__c;
          sm.LastMakeFeeRate__c = 0.1;
          sm.LastMakeFee__c = (sm.LastMake__c * sm.LastMakeFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.MakeDress__c = sltOpp.SimpleYasugoRef__r.MakeupDressPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.MakeupDressPrice__c;
          sm.MakeDressFeeRate__c = 0.1;
          sm.MakeDressFee__c = (sm.MakeDress__c * sm.MakeDressFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.Yukan__c = sltOpp.SimpleYasugoRef__r.YukanPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.YukanPrice__c;
          sm.YukanFeeRate__c = 0.1;
          sm.YukanFee__c = (sm.Yukan__c * sm.YukanFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.MakuraBana__c = sltOpp.SimpleYasugoRef__r.MakurahanaPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.MakurahanaPrice__c;
          sm.MakuraBanaFeeRate__c = 0.1;
          sm.MakuraBanaFee__c = (sm.MakuraBana__c * sm.MakuraBanaFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.KanjoHanataba__c = sltOpp.SimpleYasugoRef__r.BouquetPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.BouquetPrice__c;
          sm.KanjoHanatabaFeeRate__c = 0.1;
          sm.KanjoHanatabaFee__c = (sm.KanjoHanataba__c * sm.KanjoHanatabaFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.OwakareBana__c = sltOpp.SimpleYasugoRef__r.PartingPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.PartingPrice__c;
          sm.OwakareBanaFeeRate__c = 0.1;
          sm.OwakareBanaFee__c = (sm.OwakareBana__c * sm.OwakareBanaFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.Kyoka__c = sltOpp.SimpleYasugoRef__r.KugePrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.KugePrice__c;
          sm.KyokaFeeRate__c = 0.1;
          sm.KyokaFee__c = (sm.Kyoka__c * sm.KyokaFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.IeiShashin__c = sltOpp.SimpleYasugoRef__r.IeiPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.IeiPrice__c;
          sm.IeiShashinFeeRate__c = 0.1;
          sm.IeiShashinFee__c = (sm.IeiShashin__c * sm.IeiShashinFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.ShomenKanban__c = sltOpp.SimpleYasugoRef__r.FrontSignPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.FrontSignPrice__c;
          sm.ShomenKanbanFeeRate__c = 0.1;
          sm.ShomenKanbanFee__c = (sm.ShomenKanban__c * sm.ShomenKanbanFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.GaisoSetsubiTsuika__c = sltOpp.SimpleYasugoRef__r.ExteriorPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.ExteriorPrice__c;
          sm.GaisoSetsubiTsuikaFeeRate__c = 0.1;
          sm.GaisoSetsubiTsuikaFee__c = (sm.GaisoSetsubiTsuika__c * sm.GaisoSetsubiTsuikaFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.KotsutsuboRankUp__c = sltOpp.SimpleYasugoRef__r.UrnPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.UrnPrice__c;
          sm.KotsutsuboRankUpFeeRate__c = 0.1;
          sm.KotsutsuboRankUpFee__c = (sm.KotsutsuboRankUp__c * sm.KotsutsuboRankUpFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.Hitsugi__c = sltOpp.SimpleYasugoRef__r.Hitsugi__c == null ? 0 : sltOpp.SimpleYasugoRef__r.Hitsugi__c;
          sm.HitsugiFeeRate__c = 0.1;
          sm.HitsugiFee__c = (sm.Hitsugi__c * sm.HitsugiFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.EmbalmingPrice__c = sltOpp.SimpleYasugoRef__r.EmbalmingPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.EmbalmingPrice__c;
          sm.EmbalmingPriceFeeRate__c = 0.1;
          sm.EmbalmingPriceFee__c = (sm.EmbalmingPrice__c * sm.EmbalmingPriceFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.SaidanPrice__c = sltOpp.SimpleYasugoRef__r.SaidanPrice__c == null ? 0 : sltOpp.SimpleYasugoRef__r.SaidanPrice__c;
          sm.SaidanPriceFeeRate__c = 0.1;
          sm.SaidanPriceFee__c = (sm.SaidanPrice__c * sm.SaidanPriceFeeRate__c).round(System.RoundingMode.DOWN);
  
          sm.JimuTesuryo__c = sltOpp.JimuTesuryo__c == null ? 0 : sltOpp.JimuTesuryo__c;
          { //総額-差引額の部
            sm.PlanTesuryo__c =  
              (sltOpp.TesuryoPartnerForPlan__c != null ? sltOpp.TesuryoPartnerForPlan__c : 0);
              
            sm.OptionTesuryo__c = 
              ( sltOpp.TesuryoPartnerForOption__c != null ? sltOpp.TesuryoPartnerForOption__c : 0 )
              +
              ( sltOpp.JimuTesuryo__c == null ? 0 : sltOpp.JimuTesuryo__c ) // 事務手数料は請求書の場合は発生しないはずだが、オプション手数料に繰り入れ。
              + (WaribikiData.yorisofutan + WaribikiData.kishafutan); 
    
            sm.TokuyakutenTesuryo__c = sltOpp.TokuyakutenTesuryo__c != null ? sltOpp.TokuyakutenTesuryo__c : 0;
    
            sm.Sashihikigaku__c = sltOpp.SeikyuYoteiGakuPartnerExp__c;
          }
          sm.Verified__c = false;
        }
        WaribikiData = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(sltOpp.id);
        sm.No__c = i;
        seikyuKingaku += sm.Sashihikigaku__c;
        sm.Yorisofutankingaku__c = WaribikiData.yorisofutan;
        sm.kishafutankingaku__c = WaribikiData.kishafutan;
        seikyuMeisaiList.add(sm);
        i++;
      }
      seikyuHeader.SeikyuKingaku__c = seikyuKingaku;
    }
  
    private void openTypeReference(){
      seikyuHeader = Database.query(searchSeikyu);
          for(PartnerSeikyuMeisaiSogisha__c sltSeikyuMeisai : seikyuHeader.PartnerSeikyuSogishaPartnerSeikyuMeisais__r){
        seikyuMeisaiList.add(sltSeikyuMeisai);
      }
    }
  
      public void doKakuminIrai(){
  
        Savepoint sp = Database.setSavepoint();
        
        try{
          PartnerSeikyuSogisha__c seikyuHeaderClone = seikyuHeader.clone(false, true);
          seikyuHeaderClone.SeikyuStatus__c = '確認中';
          seikyuHeaderClone.SashimodoshiRiyu__c = '';
          seikyuHeaderClone.SeikyuSakuseiShaRef__c = UserInfo.getUserId();
          insert seikyuHeaderClone;
  
          List<PartnerSeikyuMeisaiSogisha__c> seikyuMeisaiCloneList = new List<PartnerSeikyuMeisaiSogisha__c>();
          for(PartnerSeikyuMeisaiSogisha__c seikyuMeisai : seikyuMeisaiList){
            PartnerSeikyuMeisaiSogisha__c seikyuMeisaiClone = seikyuMeisai.clone(false, true);
            seikyuMeisaiClone.PartnerSeikyuSogishaRef__c = seikyuHeaderClone.Id;
            seikyuMeisaiCloneList.add(seikyuMeisaiClone);
          }
  
          insert seikyuMeisaiCloneList;
  
           seikyuHeader = new PartnerSeikyuSogisha__c();
           seikyuMeisaiList = new List<PartnerSeikyuMeisaiSogisha__c>();
  
           seikyuHeader = seikyuHeaderClone;
           for(PartnerSeikyuMeisaiSogisha__c seikyuMeisaiClone : seikyuMeisaiCloneList){
            seikyuMeisaiList.add(seikyuMeisaiClone);
          }
        }
        catch(Exception e){
          Database.rollback(sp);
        }
    }
    
    public void doAddKakuminIrai(){
  
        Savepoint sp = Database.setSavepoint();
        
        try{
        update seikyuHeader;
        for(PartnerSeikyuMeisaiSogisha__c seikyuMeisai : seikyuMeisaiList){
            if(seikyuMeisai.PartnerSeikyuSogishaRef__c == null) seikyuMeisai.PartnerSeikyuSogishaRef__c = seikyuId;
          }
          upsert seikyuMeisaiList;
        }
        catch(Exception e){
          Database.rollback(sp);
        }
      }

    public String pdfFileName {get;set;}
    public String pdfFileData {get;set;}
    private SgSeikyuFaxSendHistSyncs.ISgSeikyuFaxSendHistCreateSyncer mSgSeikyuFaxSendHistSyncer = SgSeikyuFaxSendHistSyncs.getSgSeikyuFaxSendHistCreateSyncer();

    public void doSeikyuSoshin(){
      try{
        seikyuSoshin();
        futureSeikyuHeaderUpdate(seikyuHeader.Id);
      }catch(Exception e){
        System.debug('e.getMessage():' + e.getMessage());
        ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.ERROR, e.getMessage()));
      }
    }

    public void doSaiso(){
      try{
        seikyuSoshin();
      }catch(Exception e){
        System.debug('e.getMessage():' + e.getMessage());
        ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.ERROR, e.getMessage()));
      }
    }

      private String chkFaxNumber(){
        if(String.isNotBlank(seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SeikyuSakiFax1__c)){ return seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SeikyuSakiFax1__c; }
        else{ return seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.Fax; }
      }

    private void seikyuSoshin(){

        String faxNumber = chkFaxNumber();
        if(String.isBlank(seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c)){ throw new IllegalParametersException('送信区分が設定されていません'); }
        if(seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c.contains('Fax')){
            if(String.isBlank(faxNumber)){ throw new IllegalParametersException('Fax番号が設定されていません'); }

            faxNumber = faxNumber.replace('-', '');
            Pattern patternFaxNumber = Pattern.compile('^[0-9]+$');
            Matcher matcherFaxNumber = patternFaxNumber.matcher(faxNumber);
            if(!matcherFaxNumber.matches()){ throw new IllegalParametersException('Fax番号のフォーマットが不正です'); }
        }

        if(seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c.contains('Fax')){
            mSgSeikyuFaxSendHistSyncer.syncSgSeikyuFaxSendHist(
                seikyuId, 
                faxNumber, 
                pdfFileName, 
                pdfFileData
            );
        }

        if(seikyuHeader.PartnerKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c.contains('PWeb')){
            futureSeikyuTsuchi(seikyuHeader.TorihikisakiBango__c, seikyuHeader.Name, seikyuHeader.KokyakuId__c);
        }
    }
  
      public void doSashimodoshi(){
        try{
          seikyuHeader.SeikyuStatus__c = '差戻';
          update seikyuHeader;
        }
        catch(Exception e){

        }
      }
  
      public void doSaiseikyu(){
  
        try{
          seikyuHeader.SeikyuStatus__c = '再請求';
          seikyuHeader.SashimodoshiRiyu__c = '';
          update seikyuHeader;
        }
        catch(Exception e){

        }
      }
  
    @future(callout=true)
    public static void futureSeikyuTsuchi(String torihikisakiBango, String name, String kokyakuId) {
        PtWebApi_SeikyuTsuchi.ReqArgs theReqArgs = new PtWebApi_SeikyuTsuchi.ReqArgs();
        theReqArgs.torihikisaki_bango = torihikisakiBango;
        theReqArgs.seikyu_bango = name;
        theReqArgs.kokyaku_id = kokyakuId;
        PtWebApi_SeikyuTsuchi.Result theResult = new PtWebApi_SeikyuTsuchi.Agent().sendRequest(theReqArgs);
    }

    @future(callout=true)
    public static void futureSeikyuHeaderUpdate(String seikyuHeaderId){
        update new PartnerSeikyuSogisha__c(
            Id = seikyuHeaderId,
            SeikyuStatus__c = '請求済',
            SashimodoshiRiyu__c = '',
            Seikyubi__c = Date.today(),
            SeikyuKakuninShaRef__c = UserInfo.getUserId()
        );
    }
    
    private Map<String, PartnerSeikyuMeisaiSogisha__c> getPartnerSeikyuMeisaiSogishaByIds(Set<String> seikyuDetailIdSet){
      Map<String, PartnerSeikyuMeisaiSogisha__c> resultMap = new Map<String, PartnerSeikyuMeisaiSogisha__c>();
      for(PartnerSeikyuMeisaiSogisha__c seikyuDetail : [select Id,
                                    No__c, 
                                    OptionTesuryo__c,
                                    OkyakusamaMei__c,
                                    OwakareBana__c,
                                    OwakareBanaFeeRate__c,
                                    OwakareBanaFee__c,
                                    PartnerSeikyuSogishaRef__c,
                                    PlanTesuryo__c,
                                    TokuyakutenTesuryo__c,
                                    PlanNaiyo__c,
                                    MakeDress__c,
                                    MakeDressFeeRate__c,
                                    MakeDressFee__c,
                                    LastMake__c,
                                    LastMakeFeeRate__c,
                                    LastMakeFee__c,
                                    IeiShashin__c,
                                    IeiShashinFeeRate__c,
                                    IeiShashinFee__c,
                                    GaisoSetsubiTsuika__c,
                                    GaisoSetsubiTsuikaFeeRate__c,
                                    GaisoSetsubiTsuikaFee__c,
                                    Hitsugi__c,
                                    HitsugiFeeRate__c,
                                    HitsugiFee__c,
                                    KanjoHanataba__c,
                                    KanjoHanatabaFeeRate__c,
                                    KanjoHanatabaFee__c,
                                    Kyoka__c,
                                    KyokaFeeRate__c,
                                    KyokaFee__c,
                                    Kumotsu__c,
                                    KokyakuId__c,
                                    GokeiKingaku__c,
                                    KotsutsuboRankUp__c,
                                    KotsutsuboRankUpFeeRate__c,
                                    KotsutsuboRankUpFee__c,
                                    Sashihikigaku__c,
                                    Sekobi__c,
                                    OpportunityRef__c,
                                    OpportunityRef__r.ShodanBango__c,
                                    ShomenKanban__c,
                                    ShomenKanbanFeeRate__c,
                                    ShomenKanbanFee__c,
                                    Yukan__c,
                                    YukanFeeRate__c,
                                    YukanFee__c,
                                    Henreihin__c,
                                    HenreihinFeeRate__c,
                                    HenreihinFee__c,
                                    MakuraBana__c,
                                    MakuraBanaFeeRate__c,
                                    MakuraBanaFee__c,
                                    EmbalmingPrice__c,
                                    EmbalmingPriceFeeRate__c,
                                    EmbalmingPriceFee__c,
                                    SaidanPrice__c,
                                    SaidanPriceFeeRate__c,
                                    SaidanPriceFee__c,
                                    Ryori__c,
                                    RyoriFeeRate__c,
                                    RyoriFee__c,
                                    JimuTesuryo__c,
                                    Verified__c 
                                  from PartnerSeikyuMeisaiSogisha__c 
                                  where Id = :seikyuDetailIdSet]){
        resultMap.put(seikyuDetail.OpportunityRef__r.ShodanBango__c, seikyuDetail);
      }
      return resultMap;
    }
  }