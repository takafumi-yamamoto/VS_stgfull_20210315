trigger LogWriteReqTrigger on LogWriteReq__e (after insert) {

    try{
        Loggings.subscriveOnLogWriteReqAfterInserted(Trigger.New);
    }
    catch(Exception ex){ /*ignore*/ }
}