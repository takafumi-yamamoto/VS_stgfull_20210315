public class OpportunitySelector{

    private String getQueryBody(){
        return 'SELECT Id, Name, RecordTypeId, StageName, TorihikiShodanRef__c FROM Opportunity WHERE (1=1) ';
    }

    public Map<Id,Opportunity> ListToMapById(List<Opportunity> entries){
        Map<Id,Opportunity> mapById = new Map<Id,Opportunity>();
        for(Opportunity aItem : entries)
        {
            mapById.put(aItem.Id, aItem);
        }
        return mapById;
    }

    public List<Opportunity> SelectOpportunityiesByTorihikiSakiId(Id accountId){
        return Database.query(getQueryBody() + 'AND AccountId = :accountId');
    }
}