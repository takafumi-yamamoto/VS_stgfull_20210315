public class Ctl_KaiyoSankotsuUmie_SyncToOpp {

    public void onUmieAfterUpdate(List<KaiyoSankotsuUmie__c> newOnes, Map<Id, KaiyoSankotsuUmie__c> oldOnes){

        List<Dto> theDtos = this.selectDtos(newOnes);

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        for(Dto aDto : theDtos){
            Boolean theOppIsToBeUpdated = false;
            if(aDto.Opp.TaishosyaRef__c != aDto.Service.TaishoshaRef__c){
                aDto.Opp.TaishosyaRef__c = aDto.Service.TaishoshaRef__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiSakiRef__c != aDto.Service.KetteiSogisha__c){
                aDto.Opp.KetteiSakiRef__c = aDto.Service.KetteiSogisha__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiPlanName__c != aDto.Service.KetteiPlan__c){
                aDto.Opp.KetteiPlanName__c = aDto.Service.KetteiPlan__c;
                theOppIsToBeUpdated = true;
            }
            if(theOppIsToBeUpdated) theOppsToBeUpdated.add(aDto.Opp);
        }
        update theOppsToBeUpdated;
    }

    private List<Dto> selectDtos(List<KaiyoSankotsuUmie__c> pServices){
        List<Dto> theDtos = new List<Dto>();
        Map<Id,Opportunity> theOppsByUmieRef =
            OpportunityLinqs.ListToMapByUmieRef(
                Dao_Opportunity.getInstance().selectByKaiyoSankotsuUmieIds(
                    SobjectsExtension.collectIds(pServices)
                )
            );

        for(KaiyoSankotsuUmie__c aService: pServices){
            Opportunity aOpportunity = theOppsByUmieRef.get(aService.Id);
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
        public KaiyoSankotsuUmie__c Service { get; set; }
    }
}