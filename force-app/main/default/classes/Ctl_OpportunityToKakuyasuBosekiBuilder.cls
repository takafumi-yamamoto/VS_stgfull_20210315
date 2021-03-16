/**
 * 格安墓石のサービスビルダー
 */
public class Ctl_OpportunityToKakuyasuBosekiBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToKakuyasuBosekiBuilder() {
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
		                                                 //霊園住所　郵便番号
		                                                 //霊園住所　都道府県
		                                                 //霊園住所　市区町村
		                                                 //霊園住所　町名・番地
		                                                 //希望プラン(格安の墓石)
		                                                 //完成希望日   
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            KakuyasuBoseki__c service = new KakuyasuBoseki__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
             //ご質問・ご要望
             //霊園住所　郵便番号
             //霊園住所　都道府県
             //霊園住所　市区町村
             //霊園住所　町名・番地
             //希望プラン(格安の墓石)
             //完成希望日   
            }

            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }   
}