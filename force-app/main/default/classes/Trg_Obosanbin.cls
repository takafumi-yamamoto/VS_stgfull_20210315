public class Trg_Obosanbin{

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_Obosanbin(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Obosanbin__c> newList){
        new OboAddrCopy().onObosanbinBeforeInsert(newList);
        new Ctl_Obosanbin().setTelAndMobileForSearch(newList);
        system.Debug('Trg_Obosanbin invoked');
    }

    public void OnBeforeUpdate(List<Obosanbin__c> newList, Map<ID, Obosanbin__c> oldMap){
        new KeirSimeLocksObo.OnObosanbin(new KeirSimeLocksChgNotAllows())
            .onObosanbinBeforeUpdate(newList, oldMap);
        new OboAddrCopy().onObosanbinBeforeUpdate(newList,oldMap);
        new Ctl_Obosanbin().setTelAndMobileForSearch(newList);
        new ToribunRitsu().OnBeforeUpdate(newList, oldMap);
        OboAtooi.subscriveOnObosanbinBeforeUpdated(newList, oldMap);
    }

    public void OnAfterInsert(List<Obosanbin__c> newList){
        new Ctl_Obosanbin_SyncToOpp().OnAfterInsert(newList);
        GlbSearchingByObo.subscriveOnObosanbinAfterInserted(newList);
        new ObosanbinGeoLocTasks().onObosanbinAfterInserted(newList);
    }

    public void OnAfterUpdate(List<Obosanbin__c> newList, Map<ID, Obosanbin__c> oldMap){

        new Ctl_Obosanbin_SyncToOpp().OnAfterUpdate(newList, oldMap);
        GlbSearchingByObo.subscriveOnObosanbinAfterUpdated(newList, oldMap);
        new SrscFrObOpQms.QueuingByObo().onOboAfterUpdate(newList, oldMap);//僧侶スケジュール更新
        new ObosanbinGeoLocTasks().onObosanbinAfterUpdated(newList, oldMap);
    }

  public void OnAfterDelete(List<Obosanbin__c> oldList){
  }

}