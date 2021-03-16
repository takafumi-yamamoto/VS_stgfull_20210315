public class Ctl_Obosanbin{

	public void CopyTaisyoushaInfoToOpportunityForGloabalSearch(List<Opportunity> oppTaisyouUpdatedList,Map<Id, Account> ObosanbinTaisyoushaMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppTaisyouUpdatedList){
			Account acc = ObosanbinTaisyoushaMap.get(opp.ObosanbinRef__c);
			Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.TaisyousyaNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
	        tmpopp.TaisyousyaFurigana__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
	        tmpopp.TaisyousyaPhone__c = acc.Phone;    // 対象者電話番号(検索用)
	        tmpopp.TaisyousyaMobilePhone__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)	
	        UpdateOpportunityList.add(tmpopp);
		}
		update UpdateOpportunityList;
	}	
	public void CopyMoshuInfoToOpportunityForGloabalSearch(List<Opportunity> oppMoshuUpdatedList,Map<Id, Account> ObosanbinMoshuMap){
		list<Opportunity> UpdateOpportunityList =new list<Opportunity>();
		for(Opportunity opp : oppMoshuUpdatedList){
			Account acc = ObosanbinMoshuMap.get(opp.ObosanbinRef__c);
			Opportunity tmpopp = new Opportunity(Id=opp.Id); 
            tmpopp.MosyuNameTxt__c = acc.LastName+' '+acc.FirstName;    // 対象者氏名(検索用)
	        tmpopp.MosyuFuriganaTxt__c = acc.NameFurigana__c;    // 対象者氏名カナ(検索用)
	        tmpopp.MosyuPhoneTxt__c = acc.Phone;    // 対象者電話番号(検索用)
	        tmpopp.MosyuMobilePhoneTxt__c = acc.MobilePhone__c;    // 対象者携帯番号(検索用)	
	        UpdateOpportunityList.add(tmpopp);
		}
		update UpdateOpportunityList;
	}
	public void setTelAndMobileForSearch(List<Obosanbin__c> newList){
		system.debug('=================Ctl_Obosanbin.setTelAndMobileForSearch.begin===========================');
		system.debug('**newList='+newList);
		set<id> SekotantoAndMadoguchiIds=new set<id>();
		for (Obosanbin__c Obosanbin:newList){
			//お坊さん便契約(窓口)
			SekotantoAndMadoguchiIds.add(Obosanbin.ObosanbinKeiyakuMadoguchi__c);
			//お坊さん便契約(施行担当)
			SekotantoAndMadoguchiIds.add(Obosanbin.ObosanbinKeiyakuSekotanto__c);
		}
		system.debug('**SekotantoAndMadoguchiIds='+SekotantoAndMadoguchiIds);
		map<id,Keiyaku__c> KeiyakuMap=new map<id,Keiyaku__c>(Dao_Keiyaku.getInstance().selectByIds(new List<id>(SekotantoAndMadoguchiIds)));
		system.debug('**KeiyakuMap='+KeiyakuMap);
		for (Obosanbin__c Obosanbin:newList){	
			Keiyaku__c MadoguchiKeiyaku=KeiyakuMap.get(Obosanbin.ObosanbinKeiyakuMadoguchi__c);
			Keiyaku__c SekotantoKeiyaku=KeiyakuMap.get(Obosanbin.ObosanbinKeiyakuSekotanto__c);
			system.debug('**=MadoguchiKeiyaku'+MadoguchiKeiyaku);
			system.debug('**=SekotantoKeiyaku'+SekotantoKeiyaku);
			if (MadoguchiKeiyaku!=null){
				if (MadoguchiKeiyaku.Teikeisaki__c!=null){
					//窓口僧侶携帯電話番号(検索用)
					Obosanbin.MadoguchiTantoSoryoMobileForSearch__c=MadoguchiKeiyaku.Teikeisaki__r.MobilePhone__c;
					//窓口僧侶電話番号(検索用)
					Obosanbin.MadoguchiTantoSoryoTelForSearch__c=MadoguchiKeiyaku.Teikeisaki__r.Phone;
				}
			}
			if (SekotantoKeiyaku!=null){
				if (SekotantoKeiyaku.Teikeisaki__c!=null){
					//施行担当僧侶携帯電話番号(検索用)
					Obosanbin.SekoTantoSoryoMobileForSearch__c=SekotantoKeiyaku.Teikeisaki__r.MobilePhone__c;
					//施行担当僧侶電話番号(検索用)
					Obosanbin.SekoTantoSoryoTelForSearch__c=SekotantoKeiyaku.Teikeisaki__r.Phone;
				}
			}
			system.debug('**=Obosanbin'+Obosanbin);
		}		
		system.debug('=================Ctl_Obosanbin.setTelAndMobileForSearch.end===========================');
	}	
	
}