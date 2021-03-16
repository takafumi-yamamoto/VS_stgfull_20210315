trigger CaseTrigger on Case (after insert,before insert, before update,after update) {
    
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    Trg_Case handler = new Trg_Case();

    if(Trigger.isBefore && Trigger.isInsert){
        try{
            handler.OnBeforeInsert(Trigger.new);
        }
        catch(Exception ex){
            for(Case aCase : Trigger.new){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200212-1603-01', 'CaseTrigger.BeforeInsert')
                        .putAttr('CaseData', JSON.serialize(aCase))
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        try{
            handler.OnAfterInsert(Trigger.new);
        }
        catch(Exception ex){
            for(Case aCase : Trigger.new){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200212-1603-02', 'CaseTrigger.AfterInsert')
                        .putAttr('CaseData', JSON.serialize(aCase))
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
         handler.OnAfterUpdate(Trigger.new,Trigger.oldMap);
    }

}