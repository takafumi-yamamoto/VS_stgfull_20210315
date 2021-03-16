public class Trg_WebAccountTourokuIrai {
    public static boolean isFirstRun = true;

    // public List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByIds(Map<Id, WebAccountTourokuIrai__c> newMap) {
    // 	return Dao_WebAccountTourokuIrai.GetInstance().getWebAccountTourokuIraiListByIds(newMap.keySet());
    // }
    public void OnBeforeInsert(List<WebAccountTourokuIrai__c> newList){
        new Ctl_WebAccountTourokuIrai.WebAccountTourokuIraiValidate().onWebAccountTourokuIraiBeforeInsert(newList);
    }

    public void OnBeforeUpdate(List<WebAccountTourokuIrai__c> newList){
        new Ctl_WebAccountTourokuIrai.WebAccountCompleting().onWebAccountTourokuIraiBeforeUpdate(newList);
    }

    public void OnAfterInsert(List<WebAccountTourokuIrai__c> newList){
        new Ctl_WebAccountTourokuIrai.SendingTourokuRequstToKaiinKiban().onWebAccountTourokuIraiAfterInsert(newList);
    }


}