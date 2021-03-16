/**
 * Umieのサービスビルダー
 */
public class Ctl_OpportunityToKaiyoUmieBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToKaiyoUmieBuilder() {
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
                                                  SankotsuKaiiki__c,
                                                  OkyakusamaCommnet__c,
                                                  TaishoshaRef__c,
                                                  RecordTypeId
		                                        from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            KaiyoSankotsuUmie__c service = new KaiyoSankotsuUmie__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
            	if (c.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyosankotsuMoshikomiWebForm')){
                    //散骨海域
                	service.KiboKaiiki__c = c.SankotsuKaiiki__c;
                    // 対象者
                    service.TaishoshaRef__c = c.TaishoshaRef__c;
                    //お客様コメント
                    Opp.JuyoRenrakuJiko__c = c.OkyakusamaCommnet__c;
            	}
            }
            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }   
}