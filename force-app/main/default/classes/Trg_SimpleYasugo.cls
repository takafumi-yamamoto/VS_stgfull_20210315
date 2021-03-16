public class Trg_SimpleYasugo {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_SimpleYasugo(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<SimpleYasugo__c> newList){
        new Ctl_SimpleYasugo().simpleYasugoValuesSet(newList, null);
        // issues4314 --Start--
        new ShukeiyoKiboPlanConversion().UpdateShukeiyoKiboPlan(newList);
        // issues4314 --End--
   }

    public void OnBeforeUpdate(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> newMap, Map<ID, SimpleYasugo__c> oldMap){
        new Ctl_SimpleYasugo().chkInputRules(newList, oldMap);
        new Ctl_SimpleYasugo().simpleYasugoValuesSet(newList, oldMap);
        new KeirSimeLocksSogi.OnSimpleYasugo(new KeirSimeLocksChgNotAllows())
            .onSimpleYasugoBeforeUpdate(newList, oldMap);
        new ShukeiyoKiboPlanConversion().UpdateShukeiyoKiboPlan(newList);
        this.get_ITokuyakutenKeiyakuSetter_instance().set_tokuyakuten_keiyaku(newList, oldMap);
    }

    public void OnAfterInsert(List<SimpleYasugo__c> newList){
        new Ctl_SimpleYasugo().setSearchTxt(newList, null);
    }

    public void OnAfterUpdate(List<SimpleYasugo__c> newList, Map<ID, SimpleYasugo__c> oldMap){
        new Ctl_SimpleYasugo().setSearchTxt(newList, oldMap);
        new Ctl_SimpleYasugo().setSearchTxtKetteisaki(newList, oldMap);
        new Ctl_SimpleYasugo_SyncToOpp().onSimpleYasugoAfterUpdate(newList, oldMap);
        new Ctl_SimpleYasugo_UriageDate().onSimpleYasugoAfterUpdate(newList, oldMap);
    }
  
    @TestVisible
    private static SogitokuyakutenSetter.ITokuyakutenKeiyakuSetter m_ITokuyakutenKeiyakuSetter = SogitokuyakutenSetter.get_ITokuyakutenKeiyakuSetter(); 
    private SogitokuyakutenSetter.ITokuyakutenKeiyakuSetter get_ITokuyakutenKeiyakuSetter_instance(){
        return m_ITokuyakutenKeiyakuSetter;
    }
}