public class Ctl_KaiyoSankotsuUmie_UriageDate {

    public void onUmieAfterUpdate(List<KaiyoSankotsuUmie__c> newOnes, Map<ID, KaiyoSankotsuUmie__c> oldOnes){

        List<KaiyoSankotsuUmie__c> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Dto> theDtos = this.selectDtoByUmies( theEntriesToProcess );

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

    private List<KaiyoSankotsuUmie__c> getEntriesToProcess(List<KaiyoSankotsuUmie__c> newOnes, Map<ID, KaiyoSankotsuUmie__c> oldOnes){
        List<KaiyoSankotsuUmie__c> theEntriesToProcess = new List<KaiyoSankotsuUmie__c>();
        for(KaiyoSankotsuUmie__c aNewOne : newOnes){
            KaiyoSankotsuUmie__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aOldOne, aNewOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(KaiyoSankotsuUmie__c pNewOne, KaiyoSankotsuUmie__c pOldOne){
        if(pNewOne.KetteiSankotsuNichiji__c != pOldOne.KetteiSankotsuNichiji__c) return true;
        return false;
    }

    private Date tryCalcUriageDate(Dto pDto){
        if(pDto.Umie == null || pDto.Umie.KetteiSankotsuNichiji__c == null) return null;
        return pDto.Umie.KetteiSankotsuNichiji__c.date();
    }

    private class Dto{
        public Opportunity Opp { get; set; }
        public KaiyoSankotsuUmie__c Umie { get; set; }
    }
    private List<Dto> selectDtoByUmies(List<KaiyoSankotsuUmie__c> pUmies){
        List<Dto> theDtos = new List<Dto>();

        Map<Id,Opportunity> theOppsByUmieRef = 
            OpportunityLinqs.ListToMapByUmieRef(
                Dao_Opportunity.getInstance().selectByKaiyoSankotsuUmieIds( 
                    SobjectsExtension.collectIds(pUmies) 
                )
            );
        for(KaiyoSankotsuUmie__c aUmie : pUmies){
            Opportunity aOpp = theOppsByUmieRef.get(aUmie.Id);
            if(aOpp != null ){
                Dto aDto = new Dto(); aDto.Opp = aOpp; aDto.Umie = aUmie;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }
}