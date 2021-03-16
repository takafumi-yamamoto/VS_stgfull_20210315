/**
 * 葬儀レビのサービスビルダー
 */
public class Ctl_OpportunityToSogiRevBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToSogiRevBuilder() {
        opps = new List<Opportunity>();
    }   
    public void addOpp(Opportunity opp) {
        opps.add(opp);
    }    
    
    public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
		List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
		set<id> caseIdset = new set<id>();
		for(Opportunity opp : opps) {
			caseIdset.add(opp.CaseRef__c);
		}
		map<id,case> caseMap=new map<id,case>([select id,
                                                  IraiHoho__c,
                                                  RenrakuKiboJikantai__c,
                                                  ZokugaraSodanshaNitottenoTaishosha__c,
                                                  MitsumoriTochakuKiboKikan__c,
                                                  Gofuannakoto__c,
                                                  GenzainoBasho__c,
                                                  KiboAreaState__c,
                                                  KiboAreaCity__c,
                                                  SogiojoNoGokibo__c,
                                                  AnchiKubun__c,
                                                  Shinzokusu__c,
                                                  Goyosan__c,
                                                  OkyakusamaCommnet__c,
                                                  Sanretsushasu__c,
                                                  SogiNoStyle__c,
                                                  ShukyoshaNoTehai__c,
                                                  Mitsumori__c,
                                                  RyoriHenreihinNoTehai__c,
                                                  Shukyo__c,
                                                  ImporantMessage__c,
                                                  SonotanoSyukyoSyuha__c
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            SougiRev__c service = new SougiRev__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){

                // 依頼方法
                service.Iraihoho__c = c.IraiHoho__c;            
                // 連絡希望時間帯
                service.RenrakuKiboJikanTai__c = c.RenrakuKiboJikantai__c;
                // 対象者にとっての相談者
                service.Zokugara__c = c.ZokugaraSodanshaNitottenoTaishosha__c;
                // 見積り到着希望機関
                service.MitsumoriTouchakuKibouKikan__c = c.MitsumoriTochakuKiboKikan__c;
                // ご不安なこと
                service.FuanNaKoto__c = c.Gofuannakoto__c;
                // 対象者 現在の場所
                service.TaisyosyaGenzaiBasyo__c = c.GenzainoBasho__c; 
                // 希望エリア都道府県
                service.KiboAreaStates__c = c.KiboAreaState__c;
                // 希望エリア_市区町村など
                service.KiboAreaCityStreet__c = c.KiboAreaCity__c;
                // 総議場のご希望
                service.KiboSougijo__c = c.SogiojoNoGokibo__c;
                // 安置場所 
                service.Anchibasho__c = c.AnchiKubun__c;
                // 親族数 
                service.SinzokuSu__c = c.Shinzokusu__c;
                // ご予算 
                service.Yosan__c = c.Goyosan__c;
                
                // 葬儀形式
                service.SougiKeishiki__c = c.SogiNoStyle__c;
                // 宗教者の手配
                service.ShukyoshaNoTehai__c = c.ShukyoshaNoTehai__c;
                // 見積もり
                service.CompetitiveQuotes__c = c.Mitsumori__c;
                // 料理、返礼品の手配
                service.RyoriHenreihinTehai__c = c.RyoriHenreihinNoTehai__c;                
                // 会葬者数
                service.KaisosyaSu__c = c.Sanretsushasu__c;
                //ケース．宗教　→　葬儀レビュー.宗教
                service.Syukyo__c=c.Shukyo__c;
                //ケース.お客様コメント →　葬儀レビュー.要望内容
                service.YoubouNaiyo__c=c.OkyakusamaCommnet__c;
                
                //ケース.その他宗教(Web受付時)
                service.SonotaSyukyo__c=c.SonotanoSyukyoSyuha__c;
                service.ChoikinSmsAnnai__c='未案内';
                //相見積り
                if (c.Mitsumori__c=='相見積りなし'||c.Mitsumori__c=='相見積り中'){                	
                	opp.AimitsumoriSaki__c = c.Mitsumori__c;
                }
                
                // 重要連絡事項
                opp.JuyoRenrakuJiko__c = c.ImporantMessage__c;
            }


            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }   

    /**
     * 希望エリアID取得
     * @param  state 都道府県
     * @param  city  市区群(+町名、市区群Name項目形式)
     * @return       市区群ID
     */ 
    private Id getKiboAreaId(String state, String city) {
        List<Shikugun__c> kiboAreaList = Dao_Shikugun.SearchShikugunByFullName(state + city);
        if(!kiboAreaList.isEmpty()) {
            return kiboAreaList[0].id;
        }
        return null;
    } 

}