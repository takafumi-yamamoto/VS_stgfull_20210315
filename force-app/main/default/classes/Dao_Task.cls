public class Dao_Task {

    static final String strSelectFrom  = ' SELECT '
                                        + ' Id, '
                                        + ' WhoId, '
                                        + ' Status, '
                                        + ' Whatid, '
                                        + ' What.Type, '
                                        + ' B_PhoneFromFormula__c '
                                        + ' FROM Task ';


    static public List<Task> getList(String strWhereParam, String strOrderByParam){
        return Database.query(strSelectFrom + strWhereParam + strOrderByParam);
    }


    static public List<Task> getTaskListByPhoneNumber(String strWhereParam, String LabelSysBiztelLeadData, Set<String> phoneNumberSet){

      return Database.query(strSelectFrom + strWhereParam);
    }


    static public List<Task> SearchByIds(List<Id> idList){
        // ----- パラメータ -------
        List<Id> params = new List<Id>();
        // ----- パラメータ(配列型) -------
        List<List<Id>> arrayableParams = new List<List<Id>>();
        arrayableParams.add(idList); // arrayableParam0 にバインド
        
        // String whereString = 'WHERE id in (:arrayableParam0) '; // 規則に従ったバインド変数名にする。
        String strOrderByParam = ' ORDER BY id';

        // バインド変数verがうまく動かないので、暫定でjoin実装
        String whereString = 'WHERE id in (\'' + String.join(idList, '\',') + '\') '; // 規則に従ったバインド変数名にする。
        System.debug(whereString + strOrderByParam);
        return getList(whereString, strOrderByParam);
    }
}