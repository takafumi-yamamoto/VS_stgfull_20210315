public class SgSeikyuFaxSendRsltSyncShdl implements Schedulable, Database.AllowsCallouts {

    @TestVisible
    private static Boolean to_raise_error_for_test_coverage = false;
    
    public void execute(SchedulableContext context) {
        try{
            if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
            
            System.abortJob( context.getTriggerId() );

            this.run();

            this.scheduleNew();
        }catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20210226-1820-01', 'SgSeikyuFaxSendRsltSyncShdl.execute', 're-shedule needed.')
                    .putAttr('e.getMessage()', e.getMessage())
                    .putAttr('e.getLineNumber()',String.valueOf(e.getLineNumber()))
                    .putAttr('e.getStackTraceString()',String.valueOf(e.getStackTraceString()))
            );
        }
    }

    public void scheduleNew(){
        Integer theInterval = 10;
        String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('SgSeikyuFaxSendRsltSyncShdl' + '(' + theNextTimeCron + ')', theNextTimeCron, new SgSeikyuFaxSendRsltSyncShdl() );
    }

    public void run(){
        SgSeikyuFaxSendHistSyncs.ISgSeikyuFaxSendHistUpdateSyncer mSgSeikyuFaxSendHistSyncs = SgSeikyuFaxSendHistSyncs.getSgSeikyuFaxSendHistUpdateSyncer();
        mSgSeikyuFaxSendHistSyncs.syncSgSeikyuFaxSendHistUpdate();
    }
}