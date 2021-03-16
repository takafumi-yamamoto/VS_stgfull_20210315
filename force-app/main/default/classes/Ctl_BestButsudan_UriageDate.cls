public class Ctl_BestButsudan_UriageDate {

    public void onBestButsudanAfterUpdate(List<BestButsudan__c> newOnes, Map<ID, BestButsudan__c> oldOnes){

        List<BestButsudan__c> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Dto> theDtos = this.selectDtoByBestButsudans( theEntriesToProcess );

        List<Opportunity> theOpportunityToBeUpdated = new List<Opportunity>();
        for(Dto aDto : theDtos){
            
            Date theUriageDate = this.tryCalcUriageDate(aDto);
            if(aDto.Opp.Utiagebi__c != theUriageDate) {
                aDto.Opp.Utiagebi__c = theUriageDate;
                theOpportunityToBeUpdated.add(aDto.Opp);
            }
        }
        update theOpportunityToBeUpdated;
    }

    private List<BestButsudan__c> getEntriesToProcess(List<BestButsudan__c> newOnes, Map<ID, BestButsudan__c> oldOnes){
        List<BestButsudan__c> theEntriesToProcess = new List<BestButsudan__c>();
        for(BestButsudan__c aNewOne : newOnes){
            BestButsudan__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aOldOne, aNewOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(BestButsudan__c pNewOne, BestButsudan__c pOldOne){
        if(pNewOne.Hassoubi__c != pOldOne.Hassoubi__c) return true;
        return false;
    }

    private Date tryCalcUriageDate(Dto pDto){
        if(pDto.BestButsudan == null || pDto.BestButsudan.Hassoubi__c == null) return null;
        return pDto.BestButsudan.Hassoubi__c;
    }

    private class Dto{
        public Opportunity Opp { get; set; }
        public BestButsudan__c BestButsudan { get; set; }
    }
    private List<Dto> selectDtoByBestButsudans(List<BestButsudan__c> pBestButsudans){
        List<Dto> theDtos = new List<Dto>();

        Map<Id,Opportunity> theOppsByBestButsudanRef = 
            OpportunityLinqs.ListToMapByBestButsudanRef(
                Dao_Opportunity.getInstance().selectByBestButsudanIds( 
                    SobjectsExtension.collectIds(pBestButsudans) 
                )
            );
        for(BestButsudan__c aBestButsudan : pBestButsudans){
            Opportunity aOpp = theOppsByBestButsudanRef.get(aBestButsudan.Id);
            if(aOpp != null ){
                Dto aDto = new Dto(); aDto.Opp = aOpp; aDto.BestButsudan = aBestButsudan;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }
}