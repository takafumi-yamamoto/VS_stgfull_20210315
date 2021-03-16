public class RecordTypeDao{

    private String getQueryBody(){
        return 'SELECT Id, SobjectType, DeveloperName, Name From RecordType WHERE Id != null ';
    }
    public List<RecordType> selectAll(){
        return Database.query(getQueryBody());
    }
    public Map<Id,RecordType> selectAllAsMap(){
        return ListToMapById(this.selectAll());
    }
    public Map<Id,RecordType> ListToMapById(List<RecordType> entries){
        Map<Id,RecordType> mapById = new Map<Id,RecordType>();
        for(RecordType aItem : entries)
        {
            mapById.put(aItem.Id, aItem);
        }
        return mapById;
    }
    public RecordType selectRecordBySobjectTypeDeveloperName(String SobjectType, String DeveloperName){
        return Database.query(getQueryBody() + 'AND SobjectType = :SobjectType AND DeveloperName = :DeveloperName');
    }

    public Map<Id,RecordType> selectRecordBySobjectTypeDeveloperNames(String SobjectType, List<String> DeveloperNames){
        List<RecordType> temp = Database.query(getQueryBody() + 'AND SobjectType = :SobjectType AND DeveloperName in :DeveloperNames');
        return ListToMapById(temp);
    }

}