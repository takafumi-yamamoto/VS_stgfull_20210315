/**
 * 生前契約（事前契約）  のサービスビルダー
 */
public class Ctl_OpportunityToseizenKeiyakuBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToseizenKeiyakuBuilder() {
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
		                                              //希望エリア都道府県
                                                      KiboAreaState__c,
		                                              //希望エリア市区群
                                                      KiboAreaCity__c
		                                              	                                              
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            SeizenKeiyaku__c service = new SeizenKeiyaku__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
            	// 希望エリア
            	service.KiboAreaRef__c = getKiboAreaId(c.KiboAreaState__c, c.KiboAreaCity__c);
            }
            //契約者
            service.KeiyakuSya__c=opp.AccountId;
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