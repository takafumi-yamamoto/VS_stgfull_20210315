public class sche_Pickls {
    public static List<Schema.PicklistEntry> getEntries(String sObjName, String fieldName){
        
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType == null) throw new Exceptions.AnException( String.format( 'ObjectNotFound:{0}; ', new List<String>{sObjName} ) );

        Map<String, Schema.SObjectField> fieldmap = sObjType.getDescribe().fields.getMap();
        Schema.SObjectField field = (Schema.SObjectField) fieldmap.get(fieldName);
        if(field == null) throw new Exceptions.AnException( String.format( 'FieldNotFound:{0}.{1}; ', new List<String>{sObjName, fieldName} ) );

        Schema.DescribeFieldResult fieldDescr = field.getDescribe();

        List<Schema.PicklistEntry> thEntries = new List<Schema.PicklistEntry>();
        for(PicklistEntry aEntry : fieldDescr.getPicklistValues() ){
            if( aEntry.isActive() ) thEntries.add( aEntry );
        }
        
        return thEntries;
    }

    public static Map<String, String> getEntriesMap(String sObjName, String fieldName){
        Map<String, String> theMap = new Map<String, String>();

        List<Schema.PicklistEntry> theEntries = getEntries(sObjName, fieldName);
        for(Schema.PicklistEntry aEntry : theEntries){
            theMap.put( aEntry.getValue(), aEntry.getLabel() );
        }
        
        return theMap;
    }

    public static String tryGetLabel(String sObjName, String fieldName, String pKey, String pNotFoundValue){
        Map<String, String> theMap = getEntriesMap(sObjName, fieldName);
        if( !theMap.containsKey(pKey) ) return pNotFoundValue;
        return theMap.get(pKey);
    }
}