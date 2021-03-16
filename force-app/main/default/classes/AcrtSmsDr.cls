public  class AcrtSmsDr {

    @TestVisible private static IClient mClientInstance;
    public static IClient getClient(){
        if(mClientInstance == null){
            mClientInstance = 
                new AcrtSmsDr.Client(
                    new AcrtApiSmsDr.Client()
                );
        }
        return mClientInstance;
    }

    public class Req {
        public String delivery_id { get; private set;}
        public Req set_delivery_id(String pValue){ this.delivery_id = pValue; return this; }
    }
    public class Res{
        public String delivery_id = '';
        public String result_code = '';
        public String message = '';
    }
    public class Result{
        public Res res = new Res();
        public Req req = new Req();
    }

    public interface IClient {
        Result sendRequest(Req pReq);
    }

    public class Client implements IClient{
        private AcrtApiSmsDr.IClient mApiClinet;

        public Client(AcrtApiSmsDr.IClient pApiClinet){
            this.mApiClinet = pApiClinet;
        }

        public Result sendRequest(Req pReq){
            try{
                AcrtSmsConf.Config theConfig = AcrtSmsConf.getConfig();
                String theEndPoint = 
                    theConfig.base_url + '/sms_dr/' + theConfig.accrete_account_id + '/json';

                AcrtApiSmsDr.Req theApiReq = new AcrtApiSmsDr.Req();
                theApiReq.Id = theConfig.request_id;
                theApiReq.pass = theConfig.request_pass;
                theApiReq.delivery_id = pReq.delivery_id;

                AcrtApiSmsDr.Result theApiResult = this.mApiClinet.sendRequest(theEndPoint, theApiReq);

                Result theResult = new Result();
                Res theRes = new Res();
                theRes.delivery_id = theApiResult.res.delivery_id;
                theRes.result_code = theApiResult.res.result_code;
                theRes.message = theApiResult.res.message;

                theResult.req = pReq;
                theResult.res = theRes;

                return theResult;
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200806-1423', 'AcrtSmsDr.Client.sendRequest')
                        .putAttr('Exception', ex.getMessage())
                        .putAttr('LineNumber', '' + ex.getLineNumber())
                        .putAttr('getStackTraceString', ex.getStackTraceString())
                        .putAttr('JSON.serializePretty(pReq)', JSON.serializePretty(pReq) )
                );
                throw ex;
            }
        }

    }
}