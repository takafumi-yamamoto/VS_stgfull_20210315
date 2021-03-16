public class RecordTypeCachedDaos{
    private static IRecordTypeCachedDao f_RecordTypeCachedDao;

    public static IRecordTypeCachedDao getInstance(){
        if(f_RecordTypeCachedDao == null){
            f_RecordTypeCachedDao = new RecordTypeCachedDao(new RecordTypeDao());
        }
        return f_RecordTypeCachedDao;
    }

    public interface IRecordTypeCachedDao{
        String SelectDeveloperNameById(Id recordTypeId);
        String SelectIdByObjectTypeNameAndDevName(String pObjectTypeName, String pDevName);
    }

    public class RecordTypeCachedDao Implements IRecordTypeCachedDao{

        private RecordTypeDao f_recordTypeDao;
        private Map<Id,RecordType> f_mapOfRecordTypesById = new Map<Id,RecordType>();
        private Map<String,Map<String,RecordType>> f_mapOfRecordTypesByObjectTypeDevName = new Map<String,Map<String,RecordType>>();
        private Boolean f_isLoaded = false;

        public RecordTypeCachedDao(RecordTypeDao recordTypeDao){
            this.f_recordTypeDao = recordTypeDao;
        }

        private void Load(){
            this.f_mapOfRecordTypesById = this.f_recordTypeDao.selectAllAsMap();

            for(RecordType aRecordType: this.f_mapOfRecordTypesById.values()){
                String theSobjectType = aRecordType.SobjectType;
                if(!f_mapOfRecordTypesByObjectTypeDevName.containsKey(theSobjectType)){
                    Map<String,RecordType> aMapOfRecordTypeByDevName = new Map<String,RecordType>();
                    f_mapOfRecordTypesByObjectTypeDevName.put(theSobjectType,aMapOfRecordTypeByDevName);
                }
                Map<String,RecordType> theMapOfRecordTypeByDevName = f_mapOfRecordTypesByObjectTypeDevName.get(theSobjectType);

                String theDevName = aRecordType.DeveloperName;
                if(!theMapOfRecordTypeByDevName.containsKey(theDevName)){
                    theMapOfRecordTypeByDevName.put(theDevName, aRecordType);
                }
            }

            this.f_isLoaded = true;
        }

        public String SelectDeveloperNameById(Id recordTypeId){
            if(!this.f_isLoaded){this.Load();}
            RecordType theRecordType = f_mapOfRecordTypesById.get(recordTypeId);

            if(theRecordType == null) return '';
            return theRecordType.DeveloperName;
        }

        public Id SelectIdByObjectTypeNameAndDevName(String pObjectTypeName, String pDevName){
            if(!this.f_isLoaded){this.Load();}

            Map<String,RecordType> theMapOfRecordTypeByDevName = this.f_mapOfRecordTypesByObjectTypeDevName.get(pObjectTypeName);
            if(theMapOfRecordTypeByDevName == null){ return null; }

            RecordType theRecordType = theMapOfRecordTypeByDevName.get(pDevName);

            if(theRecordType == null) return null;
            return theRecordType.Id;
        }

        // public static RecordTypeCachedDao GetInstance(){
        //     return new RecordTypeCachedDao(new RecordTypeDao());
        // }
    }
}