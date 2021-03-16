public class Ctl_SimpleYasugo_UriageDate {
	public void onSimpleYasugoAfterUpdate(List<SimpleYasugo__c> newOnes, Map<ID, SimpleYasugo__c> oldOnes){

        List<SimpleYasugo__c> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Dto> theDtos = this.selectDtoBySimpleYasugos( theEntriesToProcess );

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
    private List<SimpleYasugo__c> getEntriesToProcess(List<SimpleYasugo__c> newOnes, Map<ID, SimpleYasugo__c> oldOnes){
        List<SimpleYasugo__c> theEntriesToProcess = new List<SimpleYasugo__c>();
        for(SimpleYasugo__c aNewOne : newOnes){
            SimpleYasugo__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aOldOne, aNewOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }
    private Boolean isToProcess(SimpleYasugo__c pNewOne, SimpleYasugo__c pOldOne){
        if(pNewOne.KasoDateTime_Inp__c != pOldOne.KasoDateTime_Inp__c) return true;
        return false;
    }   
    private Date tryCalcUriageDate(Dto pDto){
        if(pDto.SimpleYasugo == null || pDto.SimpleYasugo.KasoDateTime_Inp__c == null) return null;
        return pDto.SimpleYasugo.KasoDateTime_Inp__c.date();
    }   
    private class Dto{
        public Opportunity Opp { get; set; }
        public SimpleYasugo__c SimpleYasugo { get; set; }
    }
    private List<Dto> selectDtoBySimpleYasugos(List<SimpleYasugo__c> pSimpleYasugos){
        List<Dto> theDtos = new List<Dto>();

        Map<Id,Opportunity> theOppsBySimpleYasugoRef = 
            OpportunityLinqs.ListToMapBySimpleYasugoRef(
                Dao_Opportunity.getInstance().selectBySimpleYasugoIds( 
                    SobjectsExtension.collectIds(pSimpleYasugos) 
                )
            );
        for(SimpleYasugo__c aSimpleYasugo : pSimpleYasugos){
            Opportunity aOpp = theOppsBySimpleYasugoRef.get(aSimpleYasugo.Id);
            if(aOpp != null ){
                Dto aDto = new Dto(); aDto.Opp = aOpp; aDto.SimpleYasugo = aSimpleYasugo;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }              
}