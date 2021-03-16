public class Maps {
    public static Map<String, String> swap(Map<String, String> pMap, Boolean pIgnoreSwappedKeyDuplication){
        Map<String, String> theSwappedMap = new Map<String, String>();
        for(String aKey : pMap.keySet() ){
            String aValue = pMap.get(aKey);
            if( theSwappedMap.containsKey(aValue) && !pIgnoreSwappedKeyDuplication) throw new Exceptions.anException('swapped key duplicated');
            theSwappedMap.put(aValue, aKey);
        }
        return theSwappedMap;
    }
}