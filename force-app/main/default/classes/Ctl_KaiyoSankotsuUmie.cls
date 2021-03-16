public class Ctl_KaiyoSankotsuUmie {
		public void setSearchTxt(List<KaiyoSankotsuUmie__c> newList, Map<ID, KaiyoSankotsuUmie__c> oldMap){
		List<Id> accIds = new List<Id>();
		List<Id> taisyoushaKaiyoSankotsuUmieIds = new List<Id>();
		Map<Id, Id> simpleTaisyoushaMap = new Map<Id, Id>();
		
		for(KaiyoSankotsuUmie__c KaiyoSankotsuUmie : newList){

			if(KaiyoSankotsuUmie.TaishoshaRef__c != null && (oldMap == null || KaiyoSankotsuUmie.TaishoshaRef__c != oldMap.get(KaiyoSankotsuUmie.Id).TaishoshaRef__c)){
				// opp の検索用データ更新対象
				accIds.add(KaiyoSankotsuUmie.TaishoshaRef__c);
				taisyoushaKaiyoSankotsuUmieIds.add(KaiyoSankotsuUmie.Id);
				simpleTaisyoushaMap.put(KaiyoSankotsuUmie.Id, KaiyoSankotsuUmie.TaishoshaRef__c);
			}
		}

		List<Account> accList = Dao_Account.getInstance().selectByIds(accIds);
		Map<Id, Account> accountMap = new Map<Id, Account>(accList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectByKaiyoSankotsuUmieIds(taisyoushaKaiyoSankotsuUmieIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id accId = simpleTaisyoushaMap.get(opp.KaiyoSankotsuUmieRef__c);

			if(accountMap.containsKey(accId)){
				Account acc = accountMap.get(accId);
				Opportunity tmpopp = new Opportunity(Id=opp.Id);
		        tmpopp.TaisyousyaNameTxt__c = acc.Name;    // 対象者氏名(検索用)
		        tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
		        tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
		        tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)
		        oppForUpdate.add(tmpopp);
			}
		}
		update oppForUpdate;


	}

	public void setSearchTxtKetteisaki(List<KaiyoSankotsuUmie__c> newList, Map<ID, KaiyoSankotsuUmie__c> oldMap){
		List<Id> keiyakuIds = new List<Id>();
		List<Id> serviceOppIds = new List<Id>();
		Map<Id, Id> serviceOppMap = new Map<Id, Id>();
		
		for(KaiyoSankotsuUmie__c serviceOpp : newList){

			if(serviceOpp.KetteiSogisha__c != null && (oldMap == null || serviceOpp.KetteiSogisha__c != oldMap.get(serviceOpp.Id).KetteiSogisha__c)){
				// opp の検索用データ更新対象
				keiyakuIds.add(serviceOpp.KetteiSogisha__c);
				serviceOppIds.add(serviceOpp.Id);
				serviceOppMap.put(serviceOpp.Id, serviceOpp.KetteiSogisha__c);
			}
		}

		List<Keiyaku__c> keiyakuList = Dao_Keiyaku.getListByIds(keiyakuIds);
		Map<Id, Keiyaku__c> keiyakuMap = new Map<Id, Keiyaku__c>(keiyakuList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectByKaiyoSankotsuUmieIds(serviceOppIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id keiyakuId = serviceOppMap.get(opp.KaiyoSankotsuUmieRef__c);

			if(keiyakuMap.containsKey(keiyakuId)){
				Keiyaku__c keiyaku = keiyakuMap.get(keiyakuId);
				Opportunity tmpopp = new Opportunity(Id=opp.Id);
		        tmpopp.KetteiSakiRef__c = keiyaku.Id;    
		        tmpopp.KetteiSakiKanaSerch__c = keiyaku.Teikeisaki__r.NameYagouFurigana__c;
		        tmpopp.KetteiSakiDenwaBangoSearch__c = keiyaku.Teikeisaki__r.Phone;    
		        oppForUpdate.add(tmpopp);
			}
		}
		update oppForUpdate;
	}

	public void CopyTaisyoushaInfoToOpportunityForGloabalSearch(List<Opportunity> oppTaisyouUpdatedList,Map<Id, Account> KaiyoSankotsuUmieTaisyoushaMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdatedList){
			Account acc = KaiyoSankotsuUmieTaisyoushaMap.get(opp.KaiyoSankotsuUmieRef__c);
			Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.TaisyousyaNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
	        tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
	        tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
	        tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)	
	        UpdateOpportunityList.add(tmpopp);
		}
		update UpdateOpportunityList;
	}	
    
}