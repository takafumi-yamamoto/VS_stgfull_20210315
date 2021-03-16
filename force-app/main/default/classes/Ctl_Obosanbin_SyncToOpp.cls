public class Ctl_Obosanbin_SyncToOpp {
    public static boolean isActive = true;

    public void OnAfterInsert(List<Obosanbin__c> newList){
        if(!Ctl_Obosanbin_SyncToOpp.isActive) {return;}
    	List<Obosanbin__c> oboToProcess = new List<Obosanbin__c>();
        for(Obosanbin__c aNewOne : newList){
            Boolean isToBeProcessed = false;
            if(aNewOne.Taishosha1Ref__c != null) isToBeProcessed = true;
            if(aNewOne.MoshuRef__c != null) isToBeProcessed = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != null) isToBeProcessed = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != null) isToBeProcessed = true;
            if( !String.isBlank(aNewOne.MemorialServicePlan__c) ) isToBeProcessed = true;

            if(isToBeProcessed) {
            	oboToProcess.add(aNewOne);
            }
        }
        this.startCopy(oboToProcess);
    }

    public void OnAfterUpdate(List<Obosanbin__c> newList, Map<Id, Obosanbin__c> oldMap){
        if(!Ctl_Obosanbin_SyncToOpp.isActive) {return;}
    	List<Obosanbin__c> oboToProcess = new List<Obosanbin__c>();
        for(Obosanbin__c aNewOne : newList){
            Obosanbin__c aOldOne = oldMap.get(aNewOne.Id);

            Boolean isToBeProcessed = false;
            if(aNewOne.Taishosha1Ref__c != aOldOne.Taishosha1Ref__c) isToBeProcessed = true;
            if(aNewOne.MoshuRef__c != aOldOne.MoshuRef__c) isToBeProcessed = true;
            if(aNewOne.ObosanbinKeiyakuMadoguchi__c != aOldOne.ObosanbinKeiyakuMadoguchi__c) isToBeProcessed = true;
            if(aNewOne.ObosanbinKeiyakuSekotanto__c != aOldOne.ObosanbinKeiyakuSekotanto__c) isToBeProcessed = true;
            if(aNewOne.MemorialServicePlan__c != aOldOne.MemorialServicePlan__c) isToBeProcessed = true;

            if(isToBeProcessed) {
            	oboToProcess.add(aNewOne);
            }
        }
        this.startCopy(oboToProcess);
    }

    private void startCopy(List<Obosanbin__c> newList) {
    	if(newList.size() <= 0) return;
    	List<Opportunity> opps = [SELECT Id, ObosanbinRef__c, TaishosyaRef__c, MosyuRef__c, KetteiPlanName__c, KetteiSakiRef__c, SekouTantoRef__c
    							  FROM Opportunity WHERE ObosanbinRef__c = :newList];
    	Map<Id, Obosanbin__c> oboMap = new Map<Id, Obosanbin__c>(newList);

    	List<Opportunity> oppsToBeUpdated = new List<Opportunity>();
    	for(Opportunity theOpp : opps){
    		if(oboMap.containsKey(theOpp.ObosanbinRef__c)) {
    			Obosanbin__c theObosanbin = oboMap.get(theOpp.ObosanbinRef__c);
    			Boolean theOppToBeUpdated = false;

		        if(theOpp.TaishosyaRef__c != theObosanbin.Taishosha1Ref__c) { theOpp.TaishosyaRef__c = theObosanbin.Taishosha1Ref__c; theOppToBeUpdated = true; }
		        if(theOpp.MosyuRef__c != theObosanbin.MoshuRef__c) { theOpp.MosyuRef__c = theObosanbin.MoshuRef__c; theOppToBeUpdated = true; }
		        if(theOpp.KetteiPlanName__c != theObosanbin.MemorialServicePlan__c) { theOpp.KetteiPlanName__c = theObosanbin.MemorialServicePlan__c; theOppToBeUpdated = true; }
		        if(theOpp.KetteiSakiRef__c != theObosanbin.ObosanbinKeiyakuMadoguchi__c) { theOpp.KetteiSakiRef__c = theObosanbin.ObosanbinKeiyakuMadoguchi__c; theOppToBeUpdated = true; }
		        if(theOpp.SekouTantoRef__c != theObosanbin.ObosanbinKeiyakuSekotanto__c) { theOpp.SekouTantoRef__c = theObosanbin.ObosanbinKeiyakuSekotanto__c; theOppToBeUpdated = true; }

		        if(theOppToBeUpdated){
		            oppsToBeUpdated.add(theOpp);
		        }
    		}
    	}
    	if(oppsToBeUpdated.size() > 0) {
    		Trg_Opportunity.isActive = False;
    		update oppsToBeUpdated;
    		Trg_Opportunity.isActive = True;
    	}
    }
}