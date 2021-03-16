@isTest
private class Tes_PartnerMoshikomi_JohoshaDaos {
    static testMethod void testMethod1() {

    	List<PartnerMoshikomi_Obosanbin__c> partnermoshikomi_obosanbinList = new List<PartnerMoshikomi_Obosanbin__c>();
    	for(Integer i=0; i<5; i++){
    		PartnerMoshikomi_Obosanbin__c partnermoshikomi_obosanbin = new PartnerMoshikomi_Obosanbin__c();
    		partnermoshikomi_obosanbinList.add(partnermoshikomi_obosanbin);
    	}
    	insert partnermoshikomi_obosanbinList;
    	
    	
    	List<PartnerMoshikomi_Johosha__c> partnermoshikomi_johoshaList = new List<PartnerMoshikomi_Johosha__c>();
    	for(Integer i=0; i<1; i++){
    		PartnerMoshikomi_Johosha__c partnermoshikomi_johosha = new PartnerMoshikomi_Johosha__c();
    		partnermoshikomi_johosha.Obousanbin__c = partnermoshikomi_obosanbinList[i].Id;
    		partnermoshikomi_johoshaList.add(partnermoshikomi_johosha);
    	}
    	insert partnermoshikomi_johoshaList;
    	
    	
        PartnerMoshikomi_Johosha__c partnermoshikomi_johosha = PartnerMoshikomi_JohoshaDaos.GetInstance().SelectById(partnermoshikomi_johoshaList[0].id);

    }
}