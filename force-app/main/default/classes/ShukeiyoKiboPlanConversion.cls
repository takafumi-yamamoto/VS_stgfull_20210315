public class ShukeiyoKiboPlanConversion {

	//希望プラン変換用プロパティ
	public MAP<String,ShukeiyoKiboPlanConversion__mdt> ShukeiyoKiboPlanConversionMap;

	public ShukeiyoKiboPlanConversion() {

		ShukeiyoKiboPlanConversionMap = new MAP<String,ShukeiyoKiboPlanConversion__mdt>();

		List<ShukeiyoKiboPlanConversion__mdt> ShukeiyokiboPlanConversionList = new List<ShukeiyoKiboPlanConversion__mdt>();

		// 期待売上_集計用希望プラン変換テーブルの取得
		ShukeiyokiboPlanConversionList = [SELECT Id, 
													DeveloperName, 
													SogiPlanUketsuke__c, 
													SogiPlanUketsukeNormalized__c, 
													SogiPlanUketsukeFormula__c, 
													SogiPlanUketsukeType__c 
												FROM ShukeiyoKiboPlanConversion__mdt];

		if(ShukeiyokiboPlanConversionList.size() > 0){
			for(ShukeiyoKiboPlanConversion__mdt aKiboPlanConversion :ShukeiyokiboPlanConversionList){
				ShukeiyoKiboPlanConversionMap.put(aKiboPlanConversion.SogiPlanUketsuke__c,aKiboPlanConversion);
			}
		}
	}

	public void UpdateShukeiyoKiboPlan(List<SimpleYasugo__c> newList){

		Boolean chkflg = false;
		for(SimpleYasugo__c aSimple :newList){

			chkflg = false;

			if(String.isNotBlank(aSimple.SogiPlanUketsuke__c)){
				if(ShukeiyoKiboPlanConversionMap.containsKey(aSimple.SogiPlanUketsuke__c)){
					chkflg = true;
				}
			}

			if(chkflg){
				aSimple.SogiPlanUketsukeNormalized__c = ShukeiyoKiboPlanConversionMap.get(aSimple.SogiPlanUketsuke__c).SogiPlanUketsukeNormalized__c;
				aSimple.SogiPlanUketsukeFormula__c = ShukeiyoKiboPlanConversionMap.get(aSimple.SogiPlanUketsuke__c).SogiPlanUketsukeFormula__c;
				aSimple.SogiPlanUketsukeType__c = ShukeiyoKiboPlanConversionMap.get(aSimple.SogiPlanUketsuke__c).SogiPlanUketsukeType__c;
			}else{
				aSimple.SogiPlanUketsukeNormalized__c = '未定';
				aSimple.SogiPlanUketsukeFormula__c = '未定';
				aSimple.SogiPlanUketsukeType__c = '未定';
			}
			
		}

	}

}