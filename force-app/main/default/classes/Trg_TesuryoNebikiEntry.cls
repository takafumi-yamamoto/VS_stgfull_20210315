public with sharing class Trg_TesuryoNebikiEntry {
     private boolean m_isExecuting = false;
     private integer BatchSize = 0;

    public Trg_TesuryoNebikiEntry(boolean isExecuting, integer size){
      m_isExecuting = isExecuting;
      BatchSize = size;
    }
    public void OnBeforeDelete(List<TesuryoNebikiEntry__c> oldList){  
        new Ctl_TesuryoNebikiEntry().checkIsEditableTesuryoTekiyo(oldList);
    }

    public void OnBeforeInsert(List<TesuryoNebikiEntry__c> newList){
    	new Ctl_TesuryoNebikiEntry().checkIsEditableTesuryoTekiyo(newList);
    }

    public void OnAfterInsert(List<TesuryoNebikiEntry__c> newList){ 	
    	
    }
    public void OnBeforeUpdate(List<TesuryoNebikiEntry__c> newList, Map<ID, TesuryoNebikiEntry__c> oldMap){ 
        new Ctl_TesuryoNebikiEntry().checkIsEditableTesuryoTekiyo(newList);	     	
    }

    public void OnAfterUpdate(List<TesuryoNebikiEntry__c> newList, Map<ID, TesuryoNebikiEntry__c> oldMap){
    } 
}