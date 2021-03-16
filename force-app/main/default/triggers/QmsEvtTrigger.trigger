trigger QmsEvtTrigger on QmsEvt__e (after insert) {

    try{
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Info, '20200920-1434', 'QmsEvtTrigger.isActive')
        );
        if( Trigger.isAfter && Trigger.isInsert ) QmsEvts.onQmsEvtAfterInserted(trigger.new);

        if( TestCtx.get_toRaiseException() ){
            throw new Exceptions.AnException();
        }
    }
    catch(Exception ex){
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '20200319-1458', 'QmsEvtTrigger')
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serialize(Trigger.new)', JSON.serialize(Trigger.new))
        );
    }
    
}