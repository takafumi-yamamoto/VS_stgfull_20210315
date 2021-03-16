public class Dao_OkyakusamaSeikyuMeisai {
	static public List<OkyakusamaSeikyuMeisai__c> getOkyakusamaSeikyuMeisaiByOppids(list<id> OpportunityIds){
		List<OkyakusamaSeikyuMeisai__c> lstOkyakusamaSeikyuMeisai = [SELECT Id,
		                                                                    //商談
																			OpportunityRef__c,
																			//請求方法コード
																			SeikyuHohoCode__c,
																			//決済日
																			Kessaibi__c,
																			//即時売上
																			sokujiUriage__c,
																			//請求金額
																			SeikyuKingaku__c,
																			SeikyuHouhou__c,
																			SousaiSakiShodanRef__r.ShodanBangoF__c
																		FROM OkyakusamaSeikyuMeisai__c
																		WHERE OpportunityRef__c in :OpportunityIds];
		return lstOkyakusamaSeikyuMeisai;																				
	}
	static public List<OkyakusamaSeikyuMeisai__c> getOkyakusamaSeikyuMeisaiByOppid(id OpportunityId){
		List<OkyakusamaSeikyuMeisai__c> lstOkyakusamaSeikyuMeisai = [SELECT Id,
		                                                                    //商談
																			OpportunityRef__c,
																			//請求方法コード
																			SeikyuHohoCode__c,
																			//決済日
																			Kessaibi__c,
																			//即時売上
																			sokujiUriage__c,
																			//請求金額
																			SeikyuKingaku__c,
																			SeikyuHouhou__c,
																			SousaiSakiShodanRef__r.ShodanBangoF__c
																		FROM OkyakusamaSeikyuMeisai__c
																		WHERE OpportunityRef__c = :OpportunityId];
		return lstOkyakusamaSeikyuMeisai;																				
	}

}