public class SaijoHallRyokinUpdate {
	
	public static void ryokinKoshinbiUpdate(List<SaijoHall__c> newList, Map<Id, SaijoHall__c> oldMap){

		for(SaijoHall__c aSaijoHall : newList){
			if(isTargetData(aSaijoHall, oldMap)) aSaijoHall.RyokinKoshinbi__c = date.today();
		}
	}

	private static Boolean isTargetData(SaijoHall__c aSaijoHall, Map<Id, SaijoHall__c> oldMap){

		if(oldMap == null){
			if(aSaijoHall.X1ShiyoRyokinIppan__c != null) return true;
			if(aSaijoHall.X1ShiyoRyokinShimin__c != null) return true;
			if(aSaijoHall.X1ShiyoRyokinSonota__c != null) return true;
			if(aSaijoHall.X2ShiyoRyokinIppan__c != null) return true;
			if(aSaijoHall.X2ShiyoRyokinShimin__c != null) return true;
			if(aSaijoHall.X2ShiyoRyokinSonota__c != null) return true;
		}
		else{
			SaijoHall__c tempOldSaijoHall = oldMap.get(aSaijoHall.Id);
			if(aSaijoHall.X1ShiyoRyokinIppan__c != tempOldSaijoHall.X1ShiyoRyokinIppan__c) return true;
			if(aSaijoHall.X1ShiyoRyokinShimin__c != tempOldSaijoHall.X1ShiyoRyokinShimin__c) return true;
			if(aSaijoHall.X1ShiyoRyokinSonota__c != tempOldSaijoHall.X1ShiyoRyokinSonota__c) return true;
			if(aSaijoHall.X2ShiyoRyokinIppan__c != tempOldSaijoHall.X2ShiyoRyokinIppan__c) return true;
			if(aSaijoHall.X2ShiyoRyokinShimin__c != tempOldSaijoHall.X2ShiyoRyokinShimin__c) return true;
			if(aSaijoHall.X2ShiyoRyokinSonota__c != tempOldSaijoHall.X2ShiyoRyokinSonota__c) return true;
		}

		return false;
	}
}