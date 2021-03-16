public class LineMsgSender {

    private LineMsgConfig my_LineMsgConfig = new LineMsgConfig();
    private OboStApi_MessagePush_Post my_lineSvc = new OboStApi_MessagePush_Post();

    public enum ResultKbns { Undefined, Success, Error, NotAllowed }
    public class Result{
        public ResultKbns resultKbn = ResultKbns.Undefined;
        public String descr = '';
        public Result setKbn(ResultKbns pValue){ this.resultKbn = pValue; return this; }
        public Result setDescr(String pValue){ this.descr = pValue; return this; }
    }

    public class ReqArg{
        public String torihikisakiBango = '';
        public String text = '';
        public Id accountIdToRelate = null;
        public Id oppIdToRelate = null;
    }

    public Result sendTextMsg(ReqArg pReqArg){

        if( String.isBlank( pReqArg.text ) ){
            return new Result().setKbn(ResultKbns.Error).setDescr('text is mandatory');
        }
        if( String.isBlank( pReqArg.torihikisakiBango ) ){
            return new Result().setKbn(ResultKbns.Error).setDescr('torihikisakiBango is mandatory');
        }
        if( String.isBlank( pReqArg.accountIdToRelate ) ){
            return new Result().setKbn(ResultKbns.Error).setDescr('accountIdToRelate is mandatory');
        }

        if( !this.my_LineMsgConfig.canSend(pReqArg.torihikisakiBango) ){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Warn, '20190523-1125-01', 'LineMsgSender.sendTextMsg', 'NotAllowed')
                    .putAttr('pReqArg.torihikisakiBango',pReqArg.torihikisakiBango)
                    .putAttr('theResult.descr','NotAllowed')
            );
            return new Result().setKbn(ResultKbns.NotAllowed);
        }

        OboStApi_MessagePush_Post.Result theLineSvcResult = 
            my_lineSvc.sendRequest(
                new OboStApi_MessagePush_Post.ReqBody()
                    .setPartnerId(pReqArg.torihikisakiBango)
                    .addTextMsg(pReqArg.text)
            );

        if(theLineSvcResult.isSuccess){
            Insert new LineMsg__c(
                AccountRef__c = pReqArg.accountIdToRelate,
                Content__c = pReqArg.text,
                Direction__c = 'Send',
                MsgDateTime__c = DateTime.now(),
                OppRef__c = pReqArg.oppIdToRelate,
                SendStatus__c = 'Sent'
            );
            return new Result().setKbn(ResultKbns.Success);
        }

        return new Result().setKbn(ResultKbns.Error);
    }
}