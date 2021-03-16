trigger Asyncs_StartReqTrigger on Asyncs_StartReq__e (after insert) {

    try{
        new Asyncs_Broker().subscriveOnAyncsStartReqAfterInserted(Trigger.new);
    }
    catch(Exception ex){
        Loggings.writeLog(
            Loggings.createLogEntry(Loggings.Level.Error, '20200319-1424', 'Asyncs_StartReqTrigger')
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serialize(Trigger.new)', JSON.serialize(Trigger.new))
        );
    }
    
}