public with sharing class Trg_KobetsuTesuryoEntry {
     private boolean m_isExecuting = false;
     private integer BatchSize = 0;

    public Trg_KobetsuTesuryoEntry(boolean isExecuting, integer size){
      m_isExecuting = isExecuting;
      BatchSize = size;
    }
    public void OnBeforeDelete(List<KobetsuTesuryoEntry__c> oldList){      
        new Ctl_KobetsuTesuryoEntry().checkIsEditableTesuryoTekiyo(oldList); 
    }

    public void OnBeforeInsert(List<KobetsuTesuryoEntry__c> newList){
    	new Ctl_KobetsuTesuryoEntry().checkIsEditableTesuryoTekiyo(newList);
    }

    public void OnAfterInsert(List<KobetsuTesuryoEntry__c> newList){ 	
    	
    }
    public void OnBeforeUpdate(List<KobetsuTesuryoEntry__c> newList, Map<ID, KobetsuTesuryoEntry__c> oldMap){ 
        new Ctl_KobetsuTesuryoEntry().checkIsEditableTesuryoTekiyo(newList);	     	
    }

    public void OnAfterUpdate(List<KobetsuTesuryoEntry__c> newList, Map<ID, KobetsuTesuryoEntry__c> oldMap){
    }    

}