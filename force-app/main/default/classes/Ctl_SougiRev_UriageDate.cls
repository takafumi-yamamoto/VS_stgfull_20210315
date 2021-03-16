public class Ctl_SougiRev_UriageDate {

    public void onReviAfterUpdate(List<SougiRev__c> newOnes, Map<ID, SougiRev__c> oldOnes){

        List<SougiRev__c> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Dto> theDtos = this.selectDtoByRevis( theEntriesToProcess );

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

    private List<SougiRev__c> getEntriesToProcess(List<SougiRev__c> newOnes, Map<ID, SougiRev__c> oldOnes){
        List<SougiRev__c> theEntriesToProcess = new List<SougiRev__c>();
        for(SougiRev__c aNewOne : newOnes){
            SougiRev__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aOldOne, aNewOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(SougiRev__c pNewOne, SougiRev__c pOldOne){
        if(pNewOne.SekoBi__c != pOldOne.SekoBi__c) return true;
        return false;
    }

    private Date tryCalcUriageDate(Dto pDto){
        if(pDto.Revi == null || pDto.Revi.SekoBi__c == null) return null;
        return pDto.Revi.SekoBi__c;
    }

    private class Dto{
        public Opportunity Opp { get; set; }
        public SougiRev__c Revi { get; set; }
    }
    private List<Dto> selectDtoByRevis(List<SougiRev__c> pRevis){
        List<Dto> theDtos = new List<Dto>();

        Map<Id,Opportunity> theOppsByReviRef = 
            OpportunityLinqs.ListToMapByReviRef(
                Dao_Opportunity.getInstance().selectBySougiRevIds( 
                    SobjectsExtension.collectIds(pRevis) 
                )
            );
        for(SougiRev__c aRevi : pRevis){
            Opportunity aOpp = theOppsByReviRef.get(aRevi.Id);
            if(aOpp != null ){
                Dto aDto = new Dto(); aDto.Opp = aOpp; aDto.Revi = aRevi;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }
}