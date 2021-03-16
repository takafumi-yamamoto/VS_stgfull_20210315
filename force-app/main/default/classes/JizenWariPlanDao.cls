public class JizenWariPlanDao{

    private String getQueryBody(){
        return 'SELECT Id, Code__c From JizenWariPlan__c WHERE Id != null ';
    }

    public List<JizenWariPlan__c> selectAll(){
        return Database.query(getQueryBody());
    }
    public Map<String,JizenWariPlan__c> selectAllAsMap(){
        return ListToMapByCode(this.selectAll());
    }
    public Map<String,JizenWariPlan__c> ListToMapByCode(List<JizenWariPlan__c> entries){
        Map<String,JizenWariPlan__c> mapById = new Map<String,JizenWariPlan__c>();
        for(JizenWariPlan__c aItem : entries)
        {
            mapById.put(aItem.Code__c, aItem);
        }
        return mapById;
    }
}