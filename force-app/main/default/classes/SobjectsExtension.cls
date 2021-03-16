public class SobjectsExtension{
    public static String GetObjectApiNameById( String recordId ){
        return ((Id)recordId).getSObjectType().getDescribe().getName();
    }

    public static List<Id> collectIds(List<SObject> objects){
        Set<Id> theIds = new Set<Id>();
        for(SObject aObject : objects){
            theIds.add(aObject.Id);
        }
        return new List<Id>(theIds);
    }

    public static Map<Id,SObject> listToMap(List<SObject> pSobjects){
        Map<Id,SObject> theMap = new Map<Id,SObject>();
        for(SObject aSobject : pSobjects){ theMap.put(aSobject.Id, aSobject); }
        return theMap;
    }

    public static Sobject firstOrNull( List<Sobject> pSobjects ){
        if(pSobjects.size() <= 0) return null;
        return pSobjects.get(0);
    }
}