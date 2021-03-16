public class MarketoCampaignAndOpportunity {

	public void addLinkMarketoCampaignAndOpportunity(List<Opportunity> ListOpportunity, String CampaignID){

		List<LinkMarketoCampaignAndOpportunity__c> l_in_LinkMarketoCampaignAndOpportunity = new List<LinkMarketoCampaignAndOpportunity__c>();
		SET<String> s_CheckOpportunityId = new SET<String>();

		List<LinkMarketoCampaignAndOpportunity__c> l_LinkMarketoCampaignAndOpportunity = [SELECT ID,
																								Opportunity__c
																						FROM LinkMarketoCampaignAndOpportunity__c
																						WHERE Campaign__c = :CampaignID
																						AND Opportunity__c = :ListOpportunity];

		for(LinkMarketoCampaignAndOpportunity__c aCM :l_LinkMarketoCampaignAndOpportunity){
			s_CheckOpportunityId.add(aCM.Opportunity__c);
		}

		for(Opportunity sOpportunity :ListOpportunity){
			if(!s_CheckOpportunityId.contains(sOpportunity.Id)){
				LinkMarketoCampaignAndOpportunity__c sLinkMarketoCampaignAndOpportunity = new LinkMarketoCampaignAndOpportunity__c(
				Campaign__c = CampaignID,
				Opportunity__c = sOpportunity.Id);
				l_in_LinkMarketoCampaignAndOpportunity.add(sLinkMarketoCampaignAndOpportunity);
			}
		}

		if(l_in_LinkMarketoCampaignAndOpportunity.size() > 0){
			insert l_in_LinkMarketoCampaignAndOpportunity;
		}
	}

}