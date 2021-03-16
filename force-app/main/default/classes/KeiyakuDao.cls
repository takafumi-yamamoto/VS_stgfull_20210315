public class KeiyakuDao{

    private String getQueryBody(){
        return 'SELECT Id, Name From Keiyaku__c WHERE Id != null ';
    }
    public List<Keiyaku__c> selectAllianceAll(){
        return Database.query(getQueryBody() + 'AND RecordTypeId = \'' + Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId() + '\'');
    }
    public Map<Id,Keiyaku__c> selectAllianceAllAsMap(){
        return ListToMapById(this.selectAllianceAll());
    }
    public Map<Id,Keiyaku__c> ListToMapById(List<Keiyaku__c> entries){
        Map<Id,Keiyaku__c> mapById = new Map<Id,Keiyaku__c>();
        for(Keiyaku__c aItem : entries){
            mapById.put(aItem.Id, aItem);
        }
        return mapById;
    }

}