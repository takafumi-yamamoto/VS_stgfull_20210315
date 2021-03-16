public class Trg_TesuryoTekiyo{
     private boolean m_isExecuting = false;
     private integer BatchSize = 0;

    public Trg_TesuryoTekiyo(boolean isExecuting, integer size){
      m_isExecuting = isExecuting;
      BatchSize = size;
    }

    public void OnBeforeInsert(List<TesuryoTekiyo__c> newList){
        new Ctl_TesuryoTekiyo().checkTekiyoKaishiBi(newList, null);    
        new Ctl_TesuryoTekiyo().initTesuryoTekiyo(newList);    			
    }

    public void OnBeforeUpdate(List<TesuryoTekiyo__c> newList, Map<ID, TesuryoTekiyo__c> oldMap){
        new Ctl_TesuryoTekiyo().checkTekiyoKaishiBi(newList, oldMap);
        new Ctl_TesuryoTekiyo().checkIsEditableTesuryoTekiyo(newList, oldMap);
        new Ctl_TesuryoTekiyo().checkValidation(newList, oldMap);    	     	
    }

    public void OnAfterUpdate(List<TesuryoTekiyo__c> newList, Map<ID, TesuryoTekiyo__c> oldMap){
        new TesuryoTekiyoCurrentChanger().subscribeOnTesuryoTekiyoAfterUpdated(newList, oldMap);
        new KeiyakuCoreSyncings().subscriveOnTesuryoTekiyoAfterUpdated(newList, oldMap);
    }
}