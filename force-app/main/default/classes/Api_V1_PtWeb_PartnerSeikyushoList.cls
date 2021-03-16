@RestResource(urlMapping='/api/v1/partnerseikyusho/list/*')
global class Api_V1_PtWeb_PartnerSeikyushoList {

	public class ReqBody{
        public String torihikisaki_bango = '';
        public ReqBody readRequest(RestRequest pRestRequest){
        	System.debug('pRestRequest:' + pRestRequest);
            this.torihikisaki_bango = pRestRequest.params.get('torihikisaki_bango');
            return this;
        }
    }

    public class ResBody{
        public String seikyu_bango = '';
        public String shodan_bango = '';
        public String seikyu_date = '';
        public Decimal seikyu_amount = 0;
        public String shiharai_kijitsu = '';
        public String seikyu_status = '';
        public String nyukin_status = '';
    }

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');
        System.debug('theReq:' + theReq);
        ReqBody theReqBody = new ReqBody().readRequest(theReq);
        System.debug('theReqBody.torihikisaki_bango:' + theReqBody.torihikisaki_bango);
        if( String.isBlank(theReqBody.torihikisaki_bango) ){
            theRes.statusCode = 400;
            return;
        }

        try{
            List<ResBody> theResBodyList = new Processor().run(theReqBody);
            theRes.statusCode = 200;
            theRes.responseBody = Blob.valueOf( JSON.serialize( theResBodyList ) );
        }catch(Exception e){
            theRes.statusCode = 500;
            return;
        }
    }

    private class Processor{

        public List<ResBody> run(ReqBody pReqBody){
            List<ResBody> theResBodyList = new List<ResBody>();

            List<PartnerSeikyuSogisha__c> thePartnerSeikyuSogishaList = 
                [
                    select Id, 
	    				Name, 
	                    KokyakuId__c, 
                        TorihikisakiBango__c, 
                        SeikyuStatus__c, 
                        SeikyuKingaku__c, 
                        Seikyubi__c, 
                        ShiharaiKijitsu__c, 
                        NyukinShimekiribi__c, 
                        (
                            select Id, 
                                    OpportunityRef__r.SeikyuZandakaPartnerExp__c
                            from PartnerSeikyuSogishaPartnerSeikyuMeisais__r
                        )
                    from PartnerSeikyuSogisha__c 
                    where TorihikisakiBango__c = :pReqBody.torihikisaki_bango 
                    and SeikyuStatus__c = '請求済' 
                    order by Seikyubi__c desc 
                    limit 100
                ];

            String nyukinStatus = '入金済';
			for(PartnerSeikyuSogisha__c thePartnerSeikyuSogisha : thePartnerSeikyuSogishaList){
	            ResBody theResBody = new ResBody();
	            theResBody.seikyu_bango = thePartnerSeikyuSogisha.Name;
		        theResBody.shodan_bango = thePartnerSeikyuSogisha.KokyakuId__c;
		        theResBody.seikyu_date = thePartnerSeikyuSogisha.Seikyubi__c == null ? '' : String.valueOf(thePartnerSeikyuSogisha.Seikyubi__c);
		        theResBody.seikyu_amount = thePartnerSeikyuSogisha.SeikyuKingaku__c;
		        theResBody.shiharai_kijitsu = thePartnerSeikyuSogisha.ShiharaiKijitsu__c == null ? '' : String.valueOf(thePartnerSeikyuSogisha.ShiharaiKijitsu__c);
		        theResBody.seikyu_status = thePartnerSeikyuSogisha.SeikyuStatus__c;
                for(PartnerSeikyuMeisaiSogisha__c meisai : thePartnerSeikyuSogisha.PartnerSeikyuSogishaPartnerSeikyuMeisais__r){
                    if(meisai.OpportunityRef__r.SeikyuZandakaPartnerExp__c != 0){
                        nyukinStatus = '未入金';
                        break;
                    }
                }
		        theResBody.nyukin_status = nyukinStatus;
		        theResBodyList.add(theResBody);
            }
            return theResBodyList;
        }
    }

}