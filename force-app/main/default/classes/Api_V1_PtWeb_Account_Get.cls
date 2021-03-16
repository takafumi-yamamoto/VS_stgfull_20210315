@RestResource(urlMapping='/api/v1/ptwebs/account/*')
global class Api_V1_PtWeb_Account_Get {
    
    public class ReqBody{
        public String torihikisaki_bango = '';
        public ReqBody readRequest(RestRequest pRestRequest){
            this.torihikisaki_bango = pRestRequest.params.get('torihikisaki_bango');
            return this;
        }
    }
    public class ResBody{
        public String torihikisaki_bango = '';
        public String torihikisaki_name = '';
        public String status = '';
    }
    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');

        ReqBody theReqBody = new ReqBody().readRequest(theReq);

        if( String.isBlank(theReqBody.torihikisaki_bango ) ){
            theRes.statusCode = 400;
            return;
        }

        try{
            ResBody theResBody = new Processor().run(theReqBody);
            theRes.responseBody = Blob.valueOf( JSON.serialize( theResBody ) );
        }catch(AccountNotFoundException e){
            theRes.statusCode = 404;
            return;
        }
    }

    private class Processor{

        public ResBody run(ReqBody pReqBody){
            ResBody theResBody = new ResBody();

            Account theAccount = (Account)SobjectsExtension.FirstOrNull(
                [
                    select 
                    Id, TorihikiSakiBango__c, Name, PtWebAcceptedDate__c
                    From Account
                    where TorihikiSakiBango__c = :pReqBody.torihikisaki_bango
                    limit 1
                ]
            );
            if(theAccount == null) throw new AccountNotFoundException();

            theResBody.torihikisaki_bango = theAccount.TorihikiSakiBango__c;
            theResBody.torihikisaki_name = theAccount.Name;
            theResBody.status = theAccount.PtWebAcceptedDate__c != null ? 'completed' : 'incomplete';
            return theResBody;
        }
    }

    private class AccountNotFoundException extends Exception{}
}