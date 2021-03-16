public class ShukeiyoKetteiPlanConversion {

	//処理対象のレコードタイプID格納プロパティ
	public Id SimpleYasugoRecordTypeId;

	//決定プラン変換用プロパティ
	public MAP<String,ShukeiyoKetteiPlanConversion__mdt> ShukeiyoKetteiPlanConversionMap;

	//検索用商品番号プロパティ
	public List<String> ShohinBangoList;

	public ShukeiyoKetteiPlanConversion() {

		SimpleYasugoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

		ShukeiyoKetteiPlanConversionMap = new MAP<String,ShukeiyoKetteiPlanConversion__mdt>();

		List<ShukeiyoKetteiPlanConversion__mdt> ShukeiyoKetteiPlanConversionList = new List<ShukeiyoKetteiPlanConversion__mdt>();

		ShohinBangoList = new List<String>();

		// 期待売上_集計用決定プラン変換テーブルの取得
		ShukeiyoKetteiPlanConversionList = [SELECT Id, 
													DeveloperName, 
													ShohinBango__c, 
													SogiPlanFormula__c, 
													SogiPlanNormalized__c, 
													SogiPlanType__c 
												FROM ShukeiyoKetteiPlanConversion__mdt];

		if(ShukeiyoKetteiPlanConversionList.size() > 0){
			for(ShukeiyoKetteiPlanConversion__mdt aKetteiPlanConversion :ShukeiyoKetteiPlanConversionList){
				ShukeiyoKetteiPlanConversionMap.put(aKetteiPlanConversion.ShohinBango__c,aKetteiPlanConversion);
				ShohinBangoList.add(aKetteiPlanConversion.ShohinBango__c);
			}
		}
	}

	public void updateSimpleYasugoList(List<OpportunityLineItem> newList){

		Set<Id> TargetOppIdList = new Set<Id>();
		List<Opportunity> TargetOppList = new List<Opportunity>();
		List<SimpleYasugo__c> updateSimpleYasugoList = new List<SimpleYasugo__c>();

		// 商談商品で処理された商品の商品番号が、期待売上_集計用決定プランに登録された商品番号であることの確認する
		if(ShukeiyoKetteiPlanConversionMap.size() > 0){
			for(OpportunityLineItem aOppItem :newList){
				if(ShohinBangoList.contains(aOppItem.ProductShohinBangoExp__c)){
					TargetOppIdList.add(aOppItem.OpportunityId);
					
				}
			}

			if(TargetOppIdList.size() > 0){

				// 商談に紐づく商談商品に登録されたプランを取得するSOQL
				TargetOppList = [SELECT Id, 
									SimpleYasugoRef__c, 
									(SELECT Id, 
										Product2.ShohinBango__c 
									 from OpportunityLineItems
									 WHERE Product2.ShohinBango__c in :ShohinBangoList)
								FROM Opportunity 
								WHERE Id in :TargetOppIdList
								And RecordTypeId = :SimpleYasugoRecordTypeId];

				if(TargetOppList.size() > 0){

					for(Opportunity aOpp :TargetOppList){

						if(aOpp.OpportunityLineItems!=null && aOpp.OpportunityLineItems.size() > 0){

							if(aOpp.OpportunityLineItems.size() == 1){

								// 商談商品に登録されたプランが１件のみの場合、シンプル安豪オブジェクトの集計項目に期待売上_集計用決定プランに登録された値を設定する
								String ShohinBango = aOpp.OpportunityLineItems[0].Product2.ShohinBango__c;
								String SogiPlanNormalized = ShukeiyoKetteiPlanConversionMap.get(ShohinBango).SogiPlanNormalized__c;
								String SogiPlanFormula = ShukeiyoKetteiPlanConversionMap.get(ShohinBango).SogiPlanFormula__c;
								String SogiPlanType = ShukeiyoKetteiPlanConversionMap.get(ShohinBango).SogiPlanType__c;
								updateSimpleYasugoList.add(updateSimpleYasugo(aOpp.SimpleYasugoRef__c,SogiPlanNormalized,SogiPlanFormula,SogiPlanType));

							}else{

								// 商談商品に登録されたプランが１件以上の場合、シンプル安豪オブジェクトの集計項目に「未定」を設定する
								updateSimpleYasugoList.add(updateSimpleYasugo(aOpp.SimpleYasugoRef__c,'未定','未定','未定'));

							}

						}else{

								// 商談商品に登録されたプランがない場合、シンプル安豪オブジェクトの集計項目に空白を設定する
							updateSimpleYasugoList.add(updateSimpleYasugo(aOpp.SimpleYasugoRef__c,'','',''));

						}
					}

					if(updateSimpleYasugoList.size() > 0){
						update updateSimpleYasugoList;
					}

				}

			}

		}
	}

	public SimpleYasugo__c updateSimpleYasugo(ID SimpleId, String SogiPlanNormalized, String SogiPlanFormula, String SogiPlanType){
		SimpleYasugo__c Simple = new SimpleYasugo__c(
			ID = SimpleId,
			SogiPlanNormalized__c = SogiPlanNormalized,
			SogiPlanFormula__c = SogiPlanFormula,
			SogiPlanType__c = SogiPlanType);
		return Simple;
	}

}