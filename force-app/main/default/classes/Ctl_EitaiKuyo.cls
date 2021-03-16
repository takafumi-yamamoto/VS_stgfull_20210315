public class Ctl_EitaiKuyo {
    
	public void setSearchTxt(List<EitaiKuyo__c> newList, Map<ID, EitaiKuyo__c> oldMap){
		List<Id> accIds = new List<Id>();
		List<Id> taisyoushaEitaiKuyoIds = new List<Id>();
		Map<Id, Id> simpleTaisyoushaMap = new Map<Id, Id>();
		
		for(EitaiKuyo__c eitaiKuyo : newList){

			if(eitaiKuyo.TaishoshaRef__c != null && (oldMap == null || eitaiKuyo.TaishoshaRef__c != oldMap.get(eitaiKuyo.Id).TaishoshaRef__c)){
				// opp の検索用データ更新対象
				accIds.add(eitaiKuyo.TaishoshaRef__c);
				taisyoushaEitaiKuyoIds.add(eitaiKuyo.Id);
				simpleTaisyoushaMap.put(eitaiKuyo.Id, eitaiKuyo.TaishoshaRef__c);
			}
		}

		List<Account> accList = Dao_Account.getInstance().selectByIds(accIds);
		Map<Id, Account> accountMap = new Map<Id, Account>(accList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectByeitaiKuyoIds(taisyoushaEitaiKuyoIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id accId = simpleTaisyoushaMap.get(opp.eitaiKuyoRef__c);

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

	public void setSearchTxtKetteisaki(List<EitaiKuyo__c> newList, Map<ID, EitaiKuyo__c> oldMap){
		List<Id> serviceOppIds = new List<Id>();
		
		for(EitaiKuyo__c serviceOpp : newList){

			serviceOppIds.add(serviceOpp.Id);
		}

		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectByEitaiKuyoIds(serviceOppIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Opportunity tmpopp = new Opportunity(Id=opp.Id);
	        tmpopp.KetteiSakiRef__c = opp.EitaiKuyoRef__r.KetteiJiin__c;    
	        tmpopp.KetteiSakiKanaSerch__c = opp.EitaiKuyoRef__r.KetteiJiin__r.Teikeisaki__r.SangoJiinMeiFurigana__c;    
	        tmpopp.KetteiSakiDenwaBangoSearch__c = opp.EitaiKuyoRef__r.KetteiJiin__r.KeiyakuTantoTelNo__c;    
	        oppForUpdate.add(tmpopp);
		}
		update oppForUpdate;

		/*
	
		List<Id> keiyakuIds = new List<Id>();
		List<Id> serviceOppIds = new List<Id>();
		Map<Id, Id> serviceOppMap = new Map<Id, Id>();
		
		for(EitaiKuyo__c serviceOpp : newList){

			if(serviceOpp.KetteiJiin__c != null && (oldMap == null || serviceOpp.KetteiJiin__c != oldMap.get(serviceOpp.Id).KetteiJiin__c)){
				// opp の検索用データ更新対象
				keiyakuIds.add(serviceOpp.KetteiJiin__c);
				serviceOppIds.add(serviceOpp.Id);
				serviceOppMap.put(serviceOpp.Id, serviceOpp.KetteiJiin__c);
			}
		}

		List<Keiyaku__c> keiyakuList = Dao_Keiyaku.getListByIds(keiyakuIds);
		Map<Id, Keiyaku__c> keiyakuMap = new Map<Id, Keiyaku__c>(keiyakuList);
		List<Opportunity> oppTaisyouUpdate = Dao_Opportunity.getInstance().selectByEitaiKuyoIds(serviceOppIds);
		List<Opportunity> oppForUpdate = new List<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdate){
			Id keiyakuId = serviceOppMap.get(opp.EitaiKuyoRef__c);

			if(keiyakuMap.containsKey(keiyakuId)){
				Keiyaku__c keiyaku = keiyakuMap.get(keiyakuId);
				Opportunity tmpopp = new Opportunity(Id=opp.Id);
		        tmpopp.KetteiSakiRef__c = keiyaku.Id;    
		        tmpopp.KetteiSakiKanaSerch__c = keiyaku.Teikeisaki__r.SangoJiinMeiFurigana__c;
		        tmpopp.KetteiSakiDenwaBangoSearch__c = keiyaku.KeiyakuTantoTelNo__c;    
		        oppForUpdate.add(tmpopp);
			}
		}
		update oppForUpdate;*/
	}


	public void CopyTaisyoushaInfoToOpportunityForGloabalSearch(List<Opportunity> oppTaisyouUpdatedList,Map<Id, Account> EitaiKuyoTaisyoushaMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdatedList){
			Account acc = EitaiKuyoTaisyoushaMap.get(opp.EitaiKuyoRef__c);
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