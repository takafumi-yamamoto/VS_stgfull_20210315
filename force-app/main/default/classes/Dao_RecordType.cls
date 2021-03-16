/**
 * レコードタイプDao
 */
public class Dao_RecordType {

  /**
   * レコードタイプIDを返す
   * @param String objName オブジェクト名
   * @param String rtName レコードタイプ名
   * @return String レコードタイプID
   */
    public static String getRecordTypeId(String objName, String rtName){

      String rtId = '';
        SObjectType sObjectType = Schema.getGlobalDescribe().get(objName);
        Schema.DescribeSObjectResult sobject_describe = sObjectType.getDescribe();
        List<Schema.RecordTypeInfo> rtype = sobject_describe.getRecordTypeInfos();
        System.debug('--rtype--' + rtype);
        for (RecordTypeInfo rti : rtype){
            if (rti.getName() == rtName) {
                rtId = rti.getRecordTypeId();
            }
        }
        return rtId;
    }
}