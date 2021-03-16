/**
 * 供花配達レビのサービスビルダー
 */
public class Ctl_OpportunityToKyoukaBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToKyoukaBuilder() {
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
		                                              //ご質問・ご要望
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            KyokaHaitatsuRev__c service = new KyokaHaitatsuRev__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
            	//ご質問・ご要望
            }

            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
	}	
}