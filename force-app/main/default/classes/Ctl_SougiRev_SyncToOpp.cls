public class Ctl_SougiRev_SyncToOpp {

    public void onReviAfterUpdate(List<SougiRev__c> newOnes, Map<Id, SougiRev__c> oldOnes){

        List<Dto> theDtos = this.selectDtos(newOnes);

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        for(Dto aDto : theDtos){
            Boolean theOppIsToBeUpdated = false;
            if(aDto.Opp.TaishosyaRef__c != aDto.Service.TaisyosyaRef__c){
                aDto.Opp.TaishosyaRef__c = aDto.Service.TaisyosyaRef__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.MosyuRef__c != aDto.Service.Mosyu__c){
                aDto.Opp.MosyuRef__c = aDto.Service.Mosyu__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiSakiRef__c != aDto.Service.KetteiSogisya__c){
                aDto.Opp.KetteiSakiRef__c = aDto.Service.KetteiSogisya__c;
                theOppIsToBeUpdated = true;
            }
            if(theOppIsToBeUpdated) theOppsToBeUpdated.add(aDto.Opp);
        }
        update theOppsToBeUpdated;
    }

    private List<Dto> selectDtos(List<SougiRev__c> pServices){
        List<Dto> theDtos = new List<Dto>();
        Map<Id,Opportunity> theOppsByReviRef =
            OpportunityLinqs.ListToMapByReviRef(
                Dao_Opportunity.getInstance().selectBySougiRevIds(
                    SobjectsExtension.collectIds(pServices)
                )
            );

        for(SougiRev__c aService: pServices){
            Opportunity aOpportunity = theOppsByReviRef.get(aService.Id);
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
        public SougiRev__c Service { get; set; }
    }
}