public class OpportunityLineItemCheck {

	public static Boolean is_kyu_shohin_protect_enabled = true;

	private static ID torihiki = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId();
	private static ID simple = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
	
	public static void checkYorisoNoOsoshiki(List<OpportunityLineItem> newList) {
		
		Map<Id, Profile> profileMap = new Map<Id, Profile>([select Id from Profile where Name in ('CS一般', 'CS一般(リモートワーク用)')]);
		if(!profileMap.containskey(UserInfo.getProfileId())) return;

		Set<ID> oppIdSet = new Set<ID>();
		Set<ID> prod2IdSet = new Set<ID>();
		for(OpportunityLineItem oppLI : newList){
			oppIdSet.add(oppLI.OpportunityId);
			prod2IdSet.add(oppLI.Product2Id);
		}

		Map<Id, Product2> prod2Map = new Map<Id, Product2>([select Id, 
																	Name, 
																	ShohinBango__c, 
																	LatestFlg__c 
															from Product2 
															where Id = :prod2IdSet]);
		
		Map<String, Opportunity> oppMap = new Map<String, Opportunity>([select Id, 
																			RecordTypeId, 
																			TorihikiShodanRef__r.RecordTypeId, 
																			(select Id, ProductShohinBangoExp__c from OpportunityLineItems) 
																		from Opportunity
																		where Id = :oppIdSet]);

		Map<String, List<String>> opportunityIdShohinBangoListMap = new Map<String, List<String>>();
		for(String oppId : oppMap.keySet()){
			Opportunity aOpportunity = oppMap.get(oppId);
			List<String> shohinBangoList = new List<String>();
			if(opportunityIdShohinBangoListMap.containskey(aOpportunity.Id)){
				shohinBangoList = opportunityIdShohinBangoListMap.get(aOpportunity.Id);
			}
			
			for(OpportunityLineItem oppLI : aOpportunity.OpportunityLineItems){
				shohinBangoList.add(oppLI.ProductShohinBangoExp__c);
			}
			opportunityIdShohinBangoListMap.put(aOpportunity.Id, shohinBangoList);
		}
		
		for(OpportunityLineItem oppLI : newList){
			List<String> shohinBangoList = new List<String>();
			if(opportunityIdShohinBangoListMap.containskey(oppLI.OpportunityId)){
				shohinBangoList = opportunityIdShohinBangoListMap.get(oppLI.OpportunityId);
			}
			shohinBangoList.add(prod2Map.get(oppLI.Product2Id).ShohinBango__c);
			opportunityIdShohinBangoListMap.put(oppLI.OpportunityId, shohinBangoList);
		}

		for(OpportunityLineItem oppLI : newList){

			if(oppMap.get(oppLI.OpportunityId).RecordTypeId != simple){
				continue;
			}
			
			if(is_kyu_shohin_protect_enabled){
				if(oppMap.get(oppLI.OpportunityId).TorihikiShodanRef__r.RecordTypeId == torihiki && !prod2Map.get(oppLI.Product2Id).LatestFlg__c){
					oppLI.addError('旧商品は設定できません');
					continue;
				}
			}

			if(opportunityIdShohinBangoListMap.containskey(oppLI.OpportunityId)){
				
				List<String> shodanBangoList = opportunityIdShohinBangoListMap.get(oppLI.OpportunityId);
				
				if((shodanBangoList.contains('SBG-0005004') || shodanBangoList.contains('SBG-0005007') || shodanBangoList.contains('SBG-0005009') || shodanBangoList.contains('SBG-0005013')|| shodanBangoList.contains('SBG-0005014')|| shodanBangoList.contains('SBG-0005015')|| shodanBangoList.contains('SBG-0005016')) && //【20.11】よりそう火葬式 直葬プラン 【20.12】よりそう火葬式 直葬プラン 【21.03】よりそう火葬式 直葬シンプルプラン 【21.04】よりそう火葬式 シンプルプラン 【21.04】よりそう火葬式 基本プラン  【21.04】よりそう火葬式 仏具セットプラン 【21.04】よりそう火葬式 お花セットプラン
					(shodanBangoList.contains('SBG-0005108') || shodanBangoList.contains('SBG-0005225')) ){ //【20.11】よりそうお葬式 仏具なし割引 【21.04】よりそうお葬式 仏具なし割引
					oppLI.addError('直葬プランと仏具なし割引は併用できません');
					continue;
				}

				if((shodanBangoList.contains('SBG-0005001') || shodanBangoList.contains('SBG-0005006')|| shodanBangoList.contains('SBG-0005008') || shodanBangoList.contains('SBG-0005010')) && 	//【20.11】よりそう家族葬 一日プラン 【20.12】よりそう家族葬 一日プラン 【21.04】よりそう家族葬 一日プラン
					(shodanBangoList.contains('SBG-0005404') || //【20.11】祭壇アップグレード L (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005405') || //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005406'))){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
					
					oppLI.addError('プランと祭壇アップグレードが一致していません');
					continue;
				}

				if(shodanBangoList.contains('SBG-0005002') || shodanBangoList.contains('SBG-0005011') && 	//【20.11】よりそう家族葬 二日プラン 【21.04】よりそう家族葬 二日プラン
					(shodanBangoList.contains('SBG-0005401') || //【20.11】祭壇アップグレード M (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005402') || //【20.11】祭壇アップグレード L (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005403') || //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005406'))){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
					
					oppLI.addError('プランと祭壇アップグレードが一致していません');
					continue;
				}

				if(shodanBangoList.contains('SBG-0005003') || shodanBangoList.contains('SBG-0005012')&& 	//【20.11】よりそう家族葬 華やかプラン 【21.04】よりそう家族葬 華やかプラン
					(shodanBangoList.contains('SBG-0005401') || //【20.11】祭壇アップグレード M (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005402') || //【20.11】祭壇アップグレード L (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005403') || //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005404') || //【20.11】祭壇アップグレード L (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005405'))){ //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
					
					oppLI.addError('プランと祭壇アップグレードが一致していません');
					continue;
				}

				if((shodanBangoList.contains('SBG-0005004') || shodanBangoList.contains('SBG-0005007') || shodanBangoList.contains('SBG-0005009')//【20.11】よりそう火葬式 直葬プラン 【20.12】よりそう火葬式 直葬プラン 【21.03】よりそう火葬式 直葬Liteプラン
				 ||shodanBangoList.contains('SBG-0005013') ||shodanBangoList.contains('SBG-0005014') ||shodanBangoList.contains('SBG-0005015')||shodanBangoList.contains('SBG-0005016'))&& //  【21.04】よりそう火葬式 シンプルプラン 【21.04】よりそう火葬式 基本プラン 【21.04】よりそう火葬式 仏具セットプラン  【21.04】よりそう火葬式 お花セットプラン 	
					(shodanBangoList.contains('SBG-0005401') || //【20.11】祭壇アップグレード M (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005402') || //【20.11】祭壇アップグレード L (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005403') || //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005404') || //【20.11】祭壇アップグレード L (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005405') || //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005406'))){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
					
					oppLI.addError('プランと祭壇アップグレードが一致していません');
					continue;
				}

				if(shodanBangoList.contains('SBG-0005005') && 	//【20.11】よりそう火葬式 標準プラン
					(shodanBangoList.contains('SBG-0005401') || //【20.11】祭壇アップグレード M (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005402') || //【20.11】祭壇アップグレード L (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005403') || //【20.11】祭壇アップグレード LL (家族葬 一日プラン)
					 shodanBangoList.contains('SBG-0005404') || //【20.11】祭壇アップグレード L (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005405') || //【20.11】祭壇アップグレード LL (家族葬 二日プラン)
					 shodanBangoList.contains('SBG-0005406'))){ //【20.11】祭壇アップグレード LL (家族葬 華やかプラン)
					
					oppLI.addError('プランと祭壇アップグレードが一致していません');
					continue;
				}
			}
		}
	}
}