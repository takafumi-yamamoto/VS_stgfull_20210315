public class Ctl_SougiRev {
    
	public void setSearchTxt(List<SougiRev__c> newList, Map<ID, SougiRev__c> oldMap){
		List<Id> accIds = new List<Id>();
		List<Id> taisyoushaSimpleIds = new List<Id>();
		List<Id> moshuSimpleIds = new List<Id>();
		Map<Id, Id> simpleTaisyoushaMap = new Map<Id, Id>();
		Map<Id, Id> simpleMoshuMap = new Map<Id, Id>();
		
		for(SougiRev__c SougiRev : newList){

			if(SougiRev.TaisyosyaRef__c != null && (oldMap == null || SougiRev.TaisyosyaRef__c != oldMap.get(SougiRev.Id).TaisyosyaRef__c)){
				// opp の検索用データ更新対象
				accIds.add(SougiRev.TaisyosyaRef__c);
				taisyoushaSimpleIds.add(SougiRev.Id);
				simpleTaisyoushaMap.put(SougiRev.Id, SougiRev.TaisyosyaRef__c);
			}
			if(SougiRev.Mosyu__c != null && (oldMap == null || SougiRev.Mosyu__c != oldMap.get(SougiRev.Id).Mosyu__c)){
				// opp の検索用データ更新対象
				accIds.add(SougiRev.Mosyu__c);
				moshuSimpleIds.add(SougiRev.Id);
				simpleMoshuMap.put(SougiRev.Id, SougiRev.Mosyu__c);
			}
		}

		List<Account> accList = Dao_Account.getInstance().selectByIds(accIds);
		Map<Id, Account> accountMap = new Map<Id, Account>(accList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectBySougiRevIds(taisyoushaSimpleIds);
		List<Opportunity> oppMoshuUpdate = Dao_Opportunity.getInstance().selectBySougiRevIds(moshuSimpleIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id accId = simpleTaisyoushaMap.get(opp.SogiReviRef__c);

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
		oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppMoshuUpdate){
			Id accId = simpleMoshuMap.get(opp.SogiReviRef__c);

			if(accountMap.containsKey(accId)){
				Account acc = accountMap.get(accId);
				Opportunity tmpopp = new Opportunity(Id=opp.Id);
		        tmpopp.MosyuNameTxt__c = acc.Name;    // 対象者氏名(検索用)
		        tmpopp.MosyuFuriganaTxt__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
		        tmpopp.MosyuPhoneTxt__c = acc.Phone;    // 対象者電話番号(検索用)
		        tmpopp.MosyuMobilePhoneTxt__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)
		        oppForUpdate.add(tmpopp);
			}
		}
		update oppForUpdate;
	}

	public void setSearchTxtKetteisaki(List<SougiRev__c> newList, Map<ID, SougiRev__c> oldMap){

		List<Id> serviceOppIds = new List<Id>();
		
		for(SougiRev__c serviceOpp : newList){

			serviceOppIds.add(serviceOpp.Id);
		}

		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectBySougiRevIds(serviceOppIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Opportunity tmpopp = new Opportunity(Id=opp.Id);
	        tmpopp.KetteiSakiRef__c = opp.SogiReviRef__r.KetteiSogisya__c;    
	        tmpopp.KetteiSakiKanaSerch__c = opp.SogiReviRef__r.KetteiSogisya__r.Teikeisaki__r.NameYagouFurigana__c;    
	        tmpopp.KetteiSakiDenwaBangoSearch__c = opp.SogiReviRef__r.KetteiSogisya__r.Teikeisaki__r.Phone;    
	        oppForUpdate.add(tmpopp);
		}
		update oppForUpdate;

		/*
		List<Id> keiyakuIds = new List<Id>();
		List<Id> serviceOppIds = new List<Id>();
		Map<Id, Id> serviceOppMap = new Map<Id, Id>();
		
		for(SougiRev__c serviceOpp : newList){

			if(serviceOpp.KetteiSogisya__c != null && (oldMap == null || serviceOpp.KetteiSogisya__c != oldMap.get(serviceOpp.Id).KetteiSogisya__c)){
				// opp の検索用データ更新対象
				keiyakuIds.add(serviceOpp.KetteiSogisya__c);
				serviceOppIds.add(serviceOpp.Id);
				serviceOppMap.put(serviceOpp.Id, serviceOpp.KetteiSogisya__c);
			}
		}

		List<Keiyaku__c> keiyakuList = Dao_Keiyaku.getListByIds(keiyakuIds);
		Map<Id, Keiyaku__c> keiyakuMap = new Map<Id, Keiyaku__c>(keiyakuList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectBySougiRevIds(serviceOppIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id keiyakuId = serviceOppMap.get(opp.SogiReviRef__c);

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
		*/
	}
	
	public void CopyTaisyoushaInfoToOpportunityForGloabalSearch(List<Opportunity> oppTaisyouUpdatedList,Map<Id, Account> SougiRevTaisyoushaMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdatedList){
			Account acc = SougiRevTaisyoushaMap.get(opp.SogiReviRef__c);
			Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.TaisyousyaNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
	        tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
	        tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
	        tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)	
	        UpdateOpportunityList.add(tmpopp);
		}
		update UpdateOpportunityList;
	}	

	public void CopyMoshuInfoToOpportunityForGloabalSearch(List<Opportunity> oppMoshuUpdatedList,Map<Id, Account> SogiReviMoshuMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppMoshuUpdatedList){
			Account acc = SogiReviMoshuMap.get(opp.SogiReviRef__c);
			Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.MosyuNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
	        tmpopp.MosyuFuriganaTxt__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
	        tmpopp.MosyuPhoneTxt__c = acc.Phone;    // 対象者電話番号(検索用)
	        tmpopp.MosyuMobilePhoneTxt__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)	
	        UpdateOpportunityList.add(tmpopp);
		}
		update UpdateOpportunityList;
	}    
}