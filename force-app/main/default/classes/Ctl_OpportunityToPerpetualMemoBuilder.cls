/**
 * 永代供養のサービスビルダー
 */
public class Ctl_OpportunityToPerpetualMemoBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToPerpetualMemoBuilder () {
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
		                                              //資料送付方法
		                                              ShiryoSoufuHoho__c
		                                              //ご検討中のプラン(永代供養)		                                              
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            EitaiKuyo__c service = new EitaiKuyo__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
                service.SiryoSeikyuKubun__c = c.ShiryoSoufuHoho__c;
            }
            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }   
}