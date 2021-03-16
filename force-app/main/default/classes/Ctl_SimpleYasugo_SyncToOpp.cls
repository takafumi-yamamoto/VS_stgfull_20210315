public class Ctl_SimpleYasugo_SyncToOpp {

    public void onSimpleYasugoAfterUpdate(List<SimpleYasugo__c> newOnes, Map<Id, SimpleYasugo__c> oldOnes){

        List<Dto> theDtos = this.selectDtos(newOnes);

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        for(Dto aDto : theDtos){
            Boolean theOppIsToBeUpdated = false;
            if(aDto.Opp.TaishosyaRef__c != aDto.Service.TaishoshaRef__c){
                aDto.Opp.TaishosyaRef__c = aDto.Service.TaishoshaRef__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.MosyuRef__c != aDto.Service.MoshuRef__c){
                aDto.Opp.MosyuRef__c = aDto.Service.MoshuRef__c;
                theOppIsToBeUpdated = true;
            }
            if(aDto.Opp.KetteiSakiRef__c != aDto.Service.SimpleYasugoKeiyakuRef__c){
                aDto.Opp.KetteiSakiRef__c = aDto.Service.SimpleYasugoKeiyakuRef__c;
                theOppIsToBeUpdated = true;
            }
            if(theOppIsToBeUpdated) theOppsToBeUpdated.add(aDto.Opp);
        }
        update theOppsToBeUpdated;
    }

    private List<Dto> selectDtos(List<SimpleYasugo__c> pServices){
        List<Dto> theDtos = new List<Dto>();
        Map<Id,Opportunity> theOppsBySimpleYasugoRef =
            OpportunityLinqs.ListToMapBySimpleYasugoRef(
                Dao_Opportunity.getInstance().selectBySimpleYasugoIds(
                    SobjectsExtension.collectIds(pServices)
                )
            );

        for(SimpleYasugo__c aService: pServices){
            Opportunity aOpportunity = theOppsBySimpleYasugoRef.get(aService.Id);
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
        public SimpleYasugo__c Service { get; set; }
    }
}