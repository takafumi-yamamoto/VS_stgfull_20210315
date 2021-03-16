/**
 * クロスセル提案オブジェクトのトリガー
 *
 */
trigger CrossSellingTeianTrigger on CrossSellingTeian__c (before insert,before update, after insert,after update) {

    System.debug('CrossSellingTeianTrigger');
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c && !Test.isRunningTest()){return;}
    if(Trg_CrossSellingTeian.isActive==true){
        system.debug('1回目の起動です。');
        Trg_CrossSellingTeian.isActive=false;
    }
    else{
        system.debug('2回目の起動です。');
        return;
    }
   
    Trg_CrossSellingTeian handler = new Trg_CrossSellingTeian();

    if(Trigger.isInsert && Trigger.isBefore){
        System.debug('----Insert_Before----');
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        System.debug('----Update_Before----');
        handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        System.debug('----Insert_After----');
        handler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        System.debug('>>>OnAfterUpdate');
        handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    }
}