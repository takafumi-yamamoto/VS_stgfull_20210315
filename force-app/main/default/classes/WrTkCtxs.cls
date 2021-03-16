public class WrTkCtxs {
	
	public class ContextData{
		public String sodanshaMemberKubun;
		public ContextData setSodanshaMemberKubun(String pValue){ this.sodanshaMemberKubun = pValue; return this; }
		public String sodanshaJizenwariKekaKikan;
		public ContextData setSodanshaJizenwariKekaKikan(String pValue){ this.sodanshaJizenwariKekaKikan = pValue; return this; }
		public Date sodanshaJizenJunbiDate;
		public ContextData setSodanshaJizenJunbiDate(Date pValue){ this.sodanshaJizenJunbiDate = pValue; return this; }
		public String taishoshaMemberKubun;
		public ContextData setTaishoshaMemberKubun(String pValue){ this.taishoshaMemberKubun = pValue; return this; }
		public String taishoshaJizenwariKekaKikan;
		public ContextData setTaishoshaJizenwariKekaKikan(String pValue){ this.taishoshaJizenwariKekaKikan = pValue; return this; }
		public Date taishoshaJizenJunbiDate;
		public ContextData setTaishoshaJizenJunbiDate(Date pValue){ this.taishoshaJizenJunbiDate = pValue; return this; }
		public String surveyDiscountAgreeStatus;
		public ContextData setSurveyDiscountAgreeStatus(String pValue){ this.surveyDiscountAgreeStatus = pValue; return this; }
		public String kiboShiharaiHouhou;
		public ContextData setKiboShiharaiHouhou(String pValue){ this.kiboShiharaiHouhou = pValue; return this; }
		public String allianceName;
		public ContextData setAllianceName(String pValue){ this.allianceName = pValue; return this; }
		public String priceBookId;
		public ContextData setPriceBookId(String pValue){ this.priceBookId = pValue; return this; }
		public String butsuguNashiKibo;
		public ContextData setButsuguNashiKibo(String pValue){ this.butsuguNashiKibo = pValue; return this; }
		public String sodanshaId;
		public ContextData setSodanshaId(String pValue){ this.sodanshaId = pValue; return this; }
		public String keiyakuId;
		public ContextData setKeiyakuId(String pValue){ this.keiyakuId = pValue; return this; }
		public Boolean campaignSogiBouquetAchievement;
		public ContextData setCampaignSogiBouquetAchievement(Boolean pValue){ this.campaignSogiBouquetAchievement = pValue; return this; }
		public String campaignSogiBouquetTaio;
		public ContextData setCampaignSogiBouquetTaio(String pValue){ this.campaignSogiBouquetTaio = pValue; return this; }
	}

	public Map<String, ContextData> selectContextDataByOppIds(List<String> pOppIds){

		Map<String, ContextData> theOppIdToContextData = new Map<String, ContextData>();
		Map<String, String> oppIdSodanshaIdMap = new Map<String, String>();
		for(Opportunity aOpp : [
			SELECT Id, PriceBook2Id,
			AccountId,
			Account.MemberKubunCode__c,
			Account.JizenwariKekaKikan__c,
			Account.AcvmJizenJunbiMinDate__c,
			SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c,
			SimpleYasugoRef__r.TaishoshaRef__r.JizenwariKekaKikan__c,
			SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c,
			SimpleYasugoRef__r.ButsuguNashiKibo__c,
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
			SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c,
			AllianceRef__r.Teikeisaki__r.Name,
			SurveyDiscountAgreeStatus__c,
			KiboShiharaiHouhou__c
			FROM Opportunity 
			WHERE Id IN :pOppIds
		]){
			theOppIdToContextData.put( aOpp.Id,
				new ContextData().setPriceBookId(aOpp.PriceBook2Id)
					.setSodanshaMemberKubun(aOpp.Account.MemberKubunCode__c)
					.setSodanshaJizenwariKekaKikan(aOpp.Account.JizenwariKekaKikan__c)
					.setSodanshaJizenJunbiDate(aOpp.Account.AcvmJizenJunbiMinDate__c)
					.setTaishoshaMemberKubun(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.MemberKubunCode__c)
					.setTaishoshaJizenwariKekaKikan(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.JizenwariKekaKikan__c)
					.setTaishoshaJizenJunbiDate(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c)
					.setAllianceName(aOpp.AllianceRef__r.Teikeisaki__r.Name)
					.setSurveyDiscountAgreeStatus(aOpp.SurveyDiscountAgreeStatus__c)
					.setKiboShiharaiHouhou(aOpp.KiboShiharaiHouhou__c)
					.setButsuguNashiKibo(aOpp.SimpleYasugoRef__r.ButsuguNashiKibo__c)
					.setSodanshaId(aOpp.AccountId)
					.setKeiyakuId(aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c)
					.setCampaignSogiBouquetTaio(aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c)
			);

			oppIdSodanshaIdMap.put(aOpp.Id, aOpp.AccountId);
		}

		Map<String, Boolean> accIdCampaignSogiBouquetAchievement = new Map<String, Boolean>();
		for(Account aAcc : [
			SELECT Id, 
				(SELECT Id 
				FROM TorihikiSakiAchivements__r 
				WHERE Syubetsu__c = 'campaign_sougi_bouquet' 
				AND YukoKaishiBi__c <= :date.today() 
				AND YukoShuryoBi__c >= :date.today()
				) 
			FROM Account 
			WHERE Id = :oppIdSodanshaIdMap.values()
		]){
			Boolean isCampaignSogiBouquetAchievement = aAcc.TorihikiSakiAchivements__r.size() > 0 ? true : false;
			accIdCampaignSogiBouquetAchievement.put(aAcc.Id, isCampaignSogiBouquetAchievement);
		}

		for(String oppId : theOppIdToContextData.keySet()){
			String sodanshaIdTemp = oppIdSodanshaIdMap.get(oppId);
			Boolean isCampaignSogiBouquetAchievementTemp = accIdCampaignSogiBouquetAchievement.get(sodanshaIdTemp);

			ContextData theContextData = theOppIdToContextData.get(oppId);
			theContextData.setCampaignSogiBouquetAchievement(isCampaignSogiBouquetAchievementTemp);
		}

		return theOppIdToContextData;
	}
}