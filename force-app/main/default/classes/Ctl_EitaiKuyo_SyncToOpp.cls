public class Ctl_EitaiKuyo_SyncToOpp {

    public void onEitaiAfterUpdate(List<EitaiKuyo__c> newOnes, Map<Id, EitaiKuyo__c> oldOnes){

        List<Dto> theDtos = this.selectDtos(newOnes);

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        for(Dto aDto : theDtos){
            Boolean theOppIsToBeUpdated = false;
            if(aDto.Opp.TaishosyaRef__c != aDto.Service.TaishoshaRef__c){
                aDto.Opp.TaishosyaRef__c = aDto.Service.TaishoshaRef__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiSakiRef__c != aDto.Service.KetteiJiin__c){
                aDto.Opp.KetteiSakiRef__c = aDto.Service.KetteiJiin__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiPlanName__c != aDto.Service.KakuteiPlan__c){
                aDto.Opp.KetteiPlanName__c = aDto.Service.KakuteiPlan__c;
                theOppIsToBeUpdated = true;
            }
            if(theOppIsToBeUpdated) theOppsToBeUpdated.add(aDto.Opp);
        }
        update theOppsToBeUpdated;
    }

    private List<Dto> selectDtos(List<EitaiKuyo__c> pServices){
        List<Dto> theDtos = new List<Dto>();
        Map<Id,Opportunity> theOppsByEitaiKuyoRef =
            OpportunityLinqs.ListToMapByEitaiKuyoRef(
                Dao_Opportunity.getInstance().selectByEitaiKuyoIds(
                    SobjectsExtension.collectIds(pServices)
                )
            );

        for(EitaiKuyo__c aService: pServices){
            Opportunity aOpportunity = theOppsByEitaiKuyoRef.get(aService.Id);
            if(aOpportunity != null){
                Dto aDto = new Dto();
                aDto.Opp = aOpportunity;
                aDto.Service = aService;
                theDtos.add(aDto);
            }
        }
        return theDtos;
    }

    private class Dto{
        public Opportunity Opp { get; set; }
        public EitaiKuyo__c Service { get; set; }
    }
}