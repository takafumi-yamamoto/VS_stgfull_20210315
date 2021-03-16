/**
 * Soraeのサービスビルダー
 */
public class Ctl_OpportunityToSpaceFuneralBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToSpaceFuneralBuilder() {
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
		map<id,case> caseMap=new map<id,case>([select id
		                                                //備考
		                                                //故人様とのご関係
		                                                //どなたのご意向で宇宙葬をお考えになっていますか？
		                                                //宇宙葬になぜ興味をもっていただけましたか？
		                                                //宇宙葬になぜ興味をもっていただけましたか？(その他テキスト)
		                                                //当サイトをどこで知りましたか？
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            UchusoSorae__c service = new UchusoSorae__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
                //備考
                //service.Biko__c=c.Biko__c;
                //故人様とのご関係
                //どなたのご意向で宇宙葬をお考えになっていますか？
                //宇宙葬になぜ興味をもっていただけましたか？
                //宇宙葬になぜ興味をもっていただけましたか？(その他テキスト)
                //当サイトをどこで知りましたか？
            }

            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
	}
}