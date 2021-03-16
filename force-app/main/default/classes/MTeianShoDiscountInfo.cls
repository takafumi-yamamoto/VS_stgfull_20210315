public class MTeianShoDiscountInfo {

	public static MAP<String,MTeianShoDiscountInfo__mdt> getConfig(){

        List<MTeianShoDiscountInfo__mdt> f_cachedData = new List<MTeianShoDiscountInfo__mdt>();

        f_cachedData =
            [
                select id, 
				PlanDiscountName__c,
				Waribiki1_Hinmei__c,
				Waribiki1_Kingaku__c,
				Waribiki2_Hinmei__c,
				Waribiki2_Kingaku__c,
				Waribiki3_Hinmei__c,
				Waribiki3_Kingaku__c
                from MTeianShoDiscountInfo__mdt
            ];
        
        MAP<String,MTeianShoDiscountInfo__mdt> info_cachedData = new MAP<String,MTeianShoDiscountInfo__mdt>(); 
        for(MTeianShoDiscountInfo__mdt MTSDI : f_cachedData){
            info_cachedData.put(MTSDI.PlanDiscountName__c,MTSDI);
        }

        return info_cachedData;

    }

}