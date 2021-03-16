public class Ctl_JizenwariMoushikomiKanryo {

	public List<JizenwariShodan> moushikomiKanryo(List<Opportunity> pOpps){

		List<Id> targetJizenwariIds = new List<Id>();
		for(Opportunity aOpp: pOpps){
			if(aOpp.JizenwariRef__c != null) targetJizenwariIds.add(aOpp.JizenwariRef__c);
		}

		
		// 商談と事前割のペアリスト取得
		List<JizenwariShodan> jizenwariShodans = Dao_JizenwariShodans.getInstance().selectByjizenwariIds(targetJizenwariIds);

		Map<Id, OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiMap = createMapOfOpportunityIdAndOkyakusamaSeikyuMeisai(jizenwariShodans);

		Map<Id, JizenwariPlan__c> jizenwariPlanMap = createMapOfIdAndJizenwariPlan(jizenwariShodans);

		List<JizenwariShodan> theJizenwariShodans = getMoushikomiKanryoJizenwariShodans(jizenwariShodans, okyakusamaSeikyuMeisaiMap, jizenwariPlanMap);
		return theJizenwariShodans;
	}


	private Map<Id, OkyakusamaSeikyuMeisai__c> createMapOfOpportunityIdAndOkyakusamaSeikyuMeisai(List<JizenwariShodan> jizenwariShodans){

		Set<Id> opportunityIds = new Set<Id>();

		for(JizenwariShodan aJizenwariShodan: jizenwariShodans){
			opportunityIds.add(aJizenwariShodan.Opp.Id);
		}

		List<OkyakusamaSeikyuMeisai__c> targetOkyakusamaSeikyuMeisai = [SELECT Id, 
																			   OpportunityRef__c,
																			   Kessaibi__c 
																	    FROM 
																	    	   OkyakusamaSeikyuMeisai__c
																	    WHERE 
																	    	   OpportunityRef__c IN :opportunityIds
																	    ];

		Map<Id, OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiMap = new Map<Id, OkyakusamaSeikyuMeisai__c>();
		for(OkyakusamaSeikyuMeisai__c anOkyakusamaSeikyuMeisai : targetOkyakusamaSeikyuMeisai){
			okyakusamaSeikyuMeisaiMap.put(anOkyakusamaSeikyuMeisai.OpportunityRef__c, anOkyakusamaSeikyuMeisai);
		}

		return okyakusamaSeikyuMeisaiMap;
	}


	private Map<Id, JizenwariPlan__c> createMapOfIdAndJizenwariPlan(List<JizenwariShodan> jizenwariShodans){

		Set<Id> jizenwariPlanIds = new Set<Id>();
		for(JizenwariShodan aJizenwariShodan: jizenwariShodans){
			jizenwariPlanIds.add(aJizenwariShodan.Jizenwari.JizenWariPlanRef__c);
		}

		List<JizenWariPlan__c> jizenwariPlans = [SELECT Id,YukoTsukiSu__c FROM JizenWariPlan__c WHERE Id IN :jizenwariPlanIds];

		return new Map<Id, JizenwariPlan__c>(jizenwariPlans); 
	}

	private List<JizenwariShodan> getMoushikomiKanryoJizenwariShodans(List<JizenwariShodan> jizenwariShodans, Map<Id, OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiMap, Map<Id, JizenwariPlan__c> jizenwariPlanMap){

		List<JizenwariShodan> theEntries = new List<JizenwariShodan>();
		for(JizenwariShodan aJizenwariShodan : jizenwariShodans){

			Jizenwari__c aJizenwari    = aJizenwariShodan.Jizenwari;
			Opportunity  anOpportunity = aJizenwariShodan.Opp;
			OkyakusamaSeikyuMeisai__c anOkyakusamaSeikyuMeisai = okyakusamaSeikyuMeisaiMap.get(aJizenwariShodan.Opp.Id);
			JizenwariPlan__c aJizenwariPlan = jizenwariPlanMap.get(aJizenwari.JizenWariPlanRef__c);

			if(anOpportunity.KessaiKingakuGoukei__c > 0 && anOpportunity.SeikyuZandaka__c <= 0 ){
				
				if(aJizenwari.MoushikomiKanryoBi__c == null && anOkyakusamaSeikyuMeisai != null){
					aJizenwari.MoushikomiKanryoBi__c = anOkyakusamaSeikyuMeisai.Kessaibi__c;	
				}
				
				if(aJizenwari.Yuko_kigenStart__c == null && anOkyakusamaSeikyuMeisai != null){
					aJizenwari.Yuko_kigenStart__c = anOkyakusamaSeikyuMeisai.Kessaibi__c.addDays(30);
				}
				
				if(aJizenwariPlan.YukoTsukiSu__c != 0 && anOkyakusamaSeikyuMeisai != null){
					aJizenwari.Yuko_kigenEnd__c = anOkyakusamaSeikyuMeisai.Kessaibi__c.addMonths((Integer)aJizenwariPlan.YukoTsukiSu__c);	
				}

				if(anOpportunity.Utiagebi__c == null && anOkyakusamaSeikyuMeisai != null){
					anOpportunity.Utiagebi__c = anOkyakusamaSeikyuMeisai.Kessaibi__c;	
				}
				
				anOpportunity.StageName = '証書発送待ち';
				anOpportunity.SubPhase__c = '';
				theEntries.add(aJizenwariShodan);
			}
		}
		return theEntries;
	}

}