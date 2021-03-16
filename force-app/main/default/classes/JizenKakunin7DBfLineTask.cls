public class JizenKakunin7DBfLineTask implements Queueable{

    //AsyncBegin
    public JizenKakunin7DBfLineTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    private void runTask(Id pTaskId){
        JizenKakunin7DBfLineTask__c theTask = (JizenKakunin7DBfLineTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, AccountRef__c, AccountRef__r.TorihikisakiBango__c, Msg__c, OppRef__c, ShoriStatus__c
                from JizenKakunin7DBfLineTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null){
            return;
        }
        if( theTask.AccountRef__c == null ||
            theTask.Msg__c == null ||
            theTask.OppRef__c == null
        ){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            return;
        }

        try{
            LineMsgSender.ReqArg pReqArg = new LineMsgSender.ReqArg();
            pReqArg.torihikisakiBango = theTask.AccountRef__r.TorihikisakiBango__c;
            pReqArg.text = theTask.Msg__c;
            pReqArg.accountIdToRelate = theTask.AccountRef__c;
            pReqArg.oppIdToRelate = theTask.OppRef__c;
            LineMsgSender.Result result = new LineMsgSender().sendTextMsg(pReqArg);
            if(result.resultKbn == LineMsgSender.ResultKbns.Success){
                theTask.ShoriStatus__c = 'Completed'; 
                Update theTask;
                Update new Opportunity(Id=theTask.OppRef__c, SubPhase__c='事前確認連絡1日前（システム）');
            } else {
                theTask.ShoriStatus__c = 'Faulted'; 
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20190606-1400-01', 'JizenKakunin7DBfLineTask')
                        .setSubjectRecordId(theTask.Id)
                        .putAttr( 'resultKbn', result.resultKbn + '' )
                        .putAttr( 'descr', result.descr )
                );
                Update theTask;
            }

        } catch (Exception e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190606-1400-02', 'JizenKakunin7DBfLineTask')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
                    .putAttr( 'e.getLineNumber()', String.valueOf(e.getLineNumber())  )
                    .putAttr( 'e.getStackTraceString()', e.getStackTraceString() )
            );
            return;
        }
    }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }
    //AsyncEnd

}