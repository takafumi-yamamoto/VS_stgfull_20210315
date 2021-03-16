public class SimpleYasugoDao{
    private String getQueryBody(){
        return 'SELECT Id, OpportunityRef__c From SimpleYasugo__c WHERE Id != null ';
    }
    public SimpleYasugo__c selectById(Id id){
        List<SimpleYasugo__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
        if(theEntities.size()>0){
            return theEntities.get(0);
        }
        return null;
    }
    public List<SimpleYasugo__c> selectByOppIds(List<Id> oppIds){
        return Database.query(getQueryBody() + 'AND OpportunityRef__c IN :oppIds');
    }
    public Map<Id,SimpleYasugo__c> selectByOppIdsAsMapByOppId(List<Id> oppIds){
        return listToMapByOppId(this.selectByOppIds(oppIds));
    }
    public Map<Id,SimpleYasugo__c> listToMapByOppId(List<SimpleYasugo__c> entries){
        Map<Id,SimpleYasugo__c> theMap = new Map<Id,SimpleYasugo__c>();
        for(SimpleYasugo__c aItem : entries)
        {
            theMap.put(aItem.OpportunityRef__c, aItem);
        }
        return theMap;
    }
}