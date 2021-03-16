public class Ctl_EitaiKuyo_UriageDate {

    public void onEitaiKuyoAfterUpdate(List<EitaiKuyo__c> newOnes, Map<ID, EitaiKuyo__c> oldOnes){

        List<EitaiKuyo__c> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Dto> theDtos = this.selectDtoByEitaiKuyos( theEntriesToProcess );

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

    private List<EitaiKuyo__c> getEntriesToProcess(List<EitaiKuyo__c> newOnes, Map<ID, EitaiKuyo__c> oldOnes){
        List<EitaiKuyo__c> theEntriesToProcess = new List<EitaiKuyo__c>();
        for(EitaiKuyo__c aNewOne : newOnes){
            EitaiKuyo__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aOldOne, aNewOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(EitaiKuyo__c pNewOne, EitaiKuyo__c pOldOne){
        if(pNewOne.EitaiKuyoKaishibi__c != pOldOne.EitaiKuyoKaishibi__c) return true;
        return false;
    }

    private Date tryCalcUriageDate(Dto pDto){
        if(pDto.EitaiKuyo == null) return null;
        return pDto.EitaiKuyo.EitaiKuyoKaishibi__c;
    }

    private class Dto{
        public Opportunity Opp { get; set; }
        public EitaiKuyo__c EitaiKuyo { get; set; }
    }
    private List<Dto> selectDtoByEitaiKuyos(List<EitaiKuyo__c> pEitaiKuyos){
        List<Dto> theDtos = new List<Dto>();

        Map<Id,Opportunity> theOppsByEitaiKuyoRef = 
            OpportunityLinqs.ListToMapByEitaiKuyoRef(
                Dao_Opportunity.getInstance().selectByEitaiKuyoIds( 
                    SobjectsExtension.collectIds(pEitaiKuyos) 
                )
            );
        for(EitaiKuyo__c aEitaiKuyo : pEitaiKuyos){
            Opportunity aOpp = theOppsByEitaiKuyoRef.get(aEitaiKuyo.Id);
            if(aOpp != null ){
                Dto aDto = new Dto(); aDto.Opp = aOpp; aDto.EitaiKuyo = aEitaiKuyo;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }
}