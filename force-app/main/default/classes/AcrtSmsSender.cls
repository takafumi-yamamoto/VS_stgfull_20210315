public class AcrtSmsSender {
    @TestVisible private static IClient mClientInstance;
    public static IClient getClient(){
        if(mClientInstance == null){
            mClientInstance = new AcrtSmsSender.Client( AcrtApiSmsReg.getClient() );
                
        }
        return mClientInstance;
    }

    public class Req {

        public Req(){
            this.text_long = '';
            this.shorten_url = false;
            this.telno = '';
            this.msg_type = '';
            this.user_ref = '';
            this.msg_meta_data = '';
            this.account_id = null;
            this.opp_id = null;
            this.timeout = 0;
        }
        public String text_long { get; private set;}
        public Req set_text_long(String pValue){ this.text_long = pValue; return this; }

        public Boolean shorten_url { get; private set;}
        public Req set_shorten_url(Boolean pValue){ this.shorten_url = pValue; return this; }

        public String telno { get; private set;}
        public Req set_telno(String pValue){ 
            String theValue = pValue;
            if( !String.isBlank(theValue) ){
                theValue = theValue.replace('-', '').replace('―', '');
            }
            this.telno = theValue; 
            return this; 
        }
        public String msg_type { get; private set;}
        public Req set_msg_type(String pValue){ this.msg_type = pValue; return this; }

        /*optional fields begin */
        public String user_ref { get; private set;}//optional
        public Req set_user_ref(String pValue){ this.user_ref = pValue; return this; }

        public String msg_meta_data { get; private set;}//optional
        public Req set_msg_meta_data(String pValue){ this.msg_meta_data = pValue; return this; }

        public String account_id{ get; private set;}//optional
        public Req set_account_id(String pValue){ this.account_id = pValue; return this; }

        public String opp_id{ get; private set;}//optional
        public Req set_opp_id(String pValue){ this.opp_id = pValue; return this; }

        public Integer timeout{ get; private set;}//optional
        public Req set_timeout(Integer pValue){ this.timeout = pValue; return this; }
         /*optional fields end */
    }

    public class Result{
        public String delivery_id;
        public Datetime send_dt;
        public Req req;
    }

    public interface IClient {
        Result sendSms(Req pReq);
    }
    public class Client implements IClient{
        private AcrtApiSmsReg.IClient mAcrtApiSmsRegClinet;

        public Client(AcrtApiSmsReg.IClient pAcrtApiSmsRegClinet){
            this.mAcrtApiSmsRegClinet = pAcrtApiSmsRegClinet;
        }

        public Result sendSms(Req pReq){
            try{
                AcrtSmsConf.Config theConfig = AcrtSmsConf.getConfig();

                AcrtApiSmsReg.Req theAcrtApiSmsRegReq = new AcrtApiSmsReg.Req();
                theAcrtApiSmsRegReq.shorten_url = pReq.shorten_url ? 'yes' : 'no';
                theAcrtApiSmsRegReq.telno = pReq.telno;
                theAcrtApiSmsRegReq.text_long = pReq.text_long;
                theAcrtApiSmsRegReq.user_ref = pReq.user_ref;

                AcrtApiSmsReg.Result theAcrtApiSmsRegResult = this.mAcrtApiSmsRegClinet.sendRequest(theAcrtApiSmsRegReq);

                if( !theAcrtApiSmsRegResult.isSuccess ){
                    throw new SendSmsErrException(
                        Json.serializePretty(
                            new Map<String, String>{
                                'err_msg' => 'api call faield;',
                                'err_detail_pReq' => pReq == null ? '' : Json.serializePretty(pReq),
                                'err_detail_theAcrtApiSmsRegResult' => theAcrtApiSmsRegResult == null ? '' : Json.serializePretty(theAcrtApiSmsRegResult)
                            }
                        )
                    );
                }

                Result theResult = new Result();
                theResult.delivery_id = theAcrtApiSmsRegResult.res.delivery_id;
                theResult.send_dt = Datetime.now();
                theResult.req = pReq;

                return theResult;
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Warn, '20200720-1828', 'AcrtSmsSender.Client.sendSms')
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                    .putAttr('JSON.serializePretty(pReq)', pReq == null ? '' : JSON.serializePretty(pReq) )
                );
                throw ex;
            }
        }

    }

    public class SendSmsErrException extends Exception{}
}