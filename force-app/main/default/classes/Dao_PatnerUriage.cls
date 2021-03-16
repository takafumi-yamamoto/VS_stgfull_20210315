public with sharing class Dao_PatnerUriage {
	static public List<PatnerUriage__c> getPatnerUriageByOppids(list<id> OpportunityIds){
		List<PatnerUriage__c> lstPatnerUriage = [SELECT Id,
		                                                //金額
														Kingaku__c,
														//商談
														Syodan__c,
														//商品
														Syohin__c,														
														//商品名
														Syohin__r.name
														//パートナー売上
													FROM PatnerUriage__c
													WHERE Syodan__c in :OpportunityIds];
		return lstPatnerUriage;																				
	}	
	static public List<PatnerUriage__c> getPatnerUriageByOppid(id OpportunityId){
		List<PatnerUriage__c> lstPatnerUriage = [SELECT Id,
		                                                //金額
														Kingaku__c,
														//商談
														Syodan__c,
														//商品
														Syohin__c,
														//商品名
														Syohin__r.name
														//パートナー売上
													FROM PatnerUriage__c
													WHERE Syodan__c = :OpportunityId];
		return lstPatnerUriage;																				
	}	
	

}