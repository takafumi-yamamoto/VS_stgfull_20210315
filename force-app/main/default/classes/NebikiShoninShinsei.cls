public class NebikiShoninShinsei {

	public void OnAfterUpdate(List<NebikiShoninShinsei__c> newList, Map<ID, NebikiShoninShinsei__c> oldMap){

		Map<Id,NebikiShoninShinsei__c> MapNebikiData = new Map<Id,NebikiShoninShinsei__c>();
		List<Id> ListOppRef = new List<Id>();
		for(NebikiShoninShinsei__c aNabiki :newList){
			MapNebikiData.put(aNabiki.OpportunityRef__c,aNabiki);
			ListOppRef.add(aNabiki.OpportunityRef__c);
		}

		List<Opportunity> ListOpp = new List<Opportunity>();
		List<Opportunity> ListUpdateOpp = new List<Opportunity>();

		if(ListOppRef.size() > 0){
			ListOpp = [SELECT Id, ShoinZumiNebikiKingaku__c, NebikiShoninStatus__c FROM Opportunity WHERE Id in :ListOppRef];
			if(ListOpp.size() > 0){
				for(Opportunity sOpp :ListOpp){
					if(MapNebikiData.containsKey(sOpp.Id)){
						if(MapNebikiData.get(sOpp.Id).NebikiShoninStatus__c != sOpp.NebikiShoninStatus__c){
							sOpp.NebikiShoninStatus__c = MapNebikiData.get(sOpp.Id).NebikiShoninStatus__c;
							if(MapNebikiData.get(sOpp.Id).NebikiShoninStatus__c == '未申請' ||
								MapNebikiData.get(sOpp.Id).NebikiShoninStatus__c == '承認'){
								sOpp.ShoinZumiNebikiKingaku__c = MapNebikiData.get(sOpp.Id).ShoinZumiNebikiKingaku__c;
							}
						ListUpdateOpp.add(sOpp);
						}
					}
				}
			}
		}

		if(ListUpdateOpp.size() > 0){
			update ListUpdateOpp;
		}

	}
}