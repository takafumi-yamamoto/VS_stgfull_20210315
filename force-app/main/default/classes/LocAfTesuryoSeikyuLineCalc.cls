public class LocAfTesuryoSeikyuLineCalc {

	private static Boolean m_IsEnabled = true;

	public static void turnOnLockRule(){m_IsEnabled = true; }

	public static void turnOffLockRule(){m_IsEnabled = false; }

	public void OnBeforeInsert(List<OkyakusamaSeikyuMeisai__c> newList){
		if( !m_IsEnabled ) return;

		Set<Id> OpportunityTesuryoKeisanzumiDataList = new Set<Id>();

		OpportunityTesuryoKeisanzumiDataList = getTesuryoKeisanzumiData(newList);

		if(OpportunityTesuryoKeisanzumiDataList.size() > 0){
			for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : newList){
				if(OpportunityTesuryoKeisanzumiDataList.contains(aOkyakusamaSeikyuMeisai.OpportunityRef__c)){
					aOkyakusamaSeikyuMeisai.addError('手数料計算後、お客様請求明細データの作成はできません。');
				}
			}
		}
	}

	public void OnBeforeUpdate(List<OkyakusamaSeikyuMeisai__c> newList, Map<ID, OkyakusamaSeikyuMeisai__c> oldMap){
		if( !m_IsEnabled ) return;

		Set<Id> OpportunityTesuryoKeisanzumiDataList = new Set<Id>();

		OpportunityTesuryoKeisanzumiDataList = getTesuryoKeisanzumiData(newList);

		if(OpportunityTesuryoKeisanzumiDataList.size() > 0){
			for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : newList){
				if(OpportunityTesuryoKeisanzumiDataList.contains(aOkyakusamaSeikyuMeisai.OpportunityRef__c)){
					aOkyakusamaSeikyuMeisai.addError('手数料計算後、お客様請求明細データの更新はできません。');
				}
			}
		}
	}

	public void OnBeforeDelete(List<OkyakusamaSeikyuMeisai__c> oldOnes){
		if( !m_IsEnabled ) return;

		Set<Id> OpportunityTesuryoKeisanzumiDataList = new Set<Id>();

		OpportunityTesuryoKeisanzumiDataList = getTesuryoKeisanzumiData(oldOnes);

		if(OpportunityTesuryoKeisanzumiDataList.size() > 0){
			for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : oldOnes){
				if(OpportunityTesuryoKeisanzumiDataList.contains(aOkyakusamaSeikyuMeisai.OpportunityRef__c)){
					aOkyakusamaSeikyuMeisai.addError('手数料計算後、お客様請求明細データの削除はできません。');
				}
			}
		}
		
	}

	public Set<Id> getTesuryoKeisanzumiData(List<OkyakusamaSeikyuMeisai__c> OkyakusamaSeikyuMeisaiList){

		Set<Id> returnOpportunityIdList = new Set<Id>();
		List<Opportunity> OpportunityList = new List<Opportunity>();
		Set<Id> setOpportunityId = new Set<Id>();

		for(OkyakusamaSeikyuMeisai__c aOkyakusamaSeikyuMeisai : OkyakusamaSeikyuMeisaiList){
			setOpportunityId.add(aOkyakusamaSeikyuMeisai.OpportunityRef__c);
		}

		if(setOpportunityId.size() > 0){
			OpportunityList = [SELECT Id, 
										TesuryoKeisanzumi__c 
								FROM Opportunity 
								WHERE RecordType.Name = 'シンプル安豪' 
								AND TesuryoKeisanzumi__c = true 
								AND Id IN :setOpportunityId];
			if(OpportunityList.size() > 0){
				for(Opportunity aOpp :OpportunityList){
					returnOpportunityIdList.add(aOpp.id);
				}
			}
		}
		return returnOpportunityIdList;
	}

}