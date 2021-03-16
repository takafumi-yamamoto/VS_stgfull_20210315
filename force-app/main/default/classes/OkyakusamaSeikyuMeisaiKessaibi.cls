public class OkyakusamaSeikyuMeisaiKessaibi {

    public static void onOpportunityAfterUpdated(List<Opportunity> newOnes){

        Map<Id, Opportunity> theOppOkyakusamaSeikyuMeisais = new Map<Id, Opportunity>(
            [
                select Id, 
                (select Id, SeikyuHouhou__c, Kessaibi__c from KaisyuYoteisOpportunity__r)
                from Opportunity 
                where Id = :SobjectsExtension.collectIds(newOnes)
            ]
        );

        List<OkyakusamaSeikyuMeisai__c> theOkyakusamaSeikyuMeisaisTobeUpdated = new List<OkyakusamaSeikyuMeisai__c>();
        for(Opportunity aNewOne : newOnes){

            List<OkyakusamaSeikyuMeisai__c> theOkyakusamaSeikyuMeisais = theOppOkyakusamaSeikyuMeisais.get(aNewOne.Id).KaisyuYoteisOpportunity__r;
            for(OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOkyakusamaSeikyuMeisais ){
                if(aSeikyuMeisai.SeikyuHouhou__c == 'Partner' || aSeikyuMeisai.SeikyuHouhou__c == 'sousai' 
                || aSeikyuMeisai.SeikyuHouhou__c == 'sosaifujo' || aSeikyuMeisai.SeikyuHouhou__c == 'gmo_atobarai'){
					if(aSeikyuMeisai.Kessaibi__c != aNewOne.Utiagebi__c){
						aSeikyuMeisai.Kessaibi__c = aNewOne.Utiagebi__c;
						theOkyakusamaSeikyuMeisaisTobeUpdated.add(aSeikyuMeisai);		
					}	 
                }

                if(aSeikyuMeisai.SeikyuHouhou__c == 'Amazon' || aSeikyuMeisai.SeikyuHouhou__c == 'Yahoo'){
                    if(aSeikyuMeisai.Kessaibi__c == null && aNewOne.Utiagebi__c != null){
                        aSeikyuMeisai.Kessaibi__c = aNewOne.Utiagebi__c;
                        theOkyakusamaSeikyuMeisaisTobeUpdated.add(aSeikyuMeisai);	
                    }
                }
            }
        }
        Update theOkyakusamaSeikyuMeisaisTobeUpdated;
    }
}