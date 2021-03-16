@RestResource(urlMapping='/api/v1/obo-teikei-moushikomi/*')
global class Api_V1_OboTeikeiMoushikomi {

    public class Result{
        Integer statusCode = 200;
        String reqBodyRaw = '';
        String descr = '';
    }

    public class ReqBody{
        public String last_name = '';
		public String first_name = '';
		public String sei_kana = '';
		public String mei_kana = '';
		public String postal_code = '';
		public String state = '';
		public String city = '';
		public String street = '';
		public String mobile_phone = '';
		public String email = '';
		public String shuha = '';
		public String jiinmei = '';
		public String jiinmei_kana = '';
		public String tani_shubetsu = '';
		public String tasha_toroku_kakunin = '';
		public String moshikomi_keii = '';
		public String biko = '';
        public ReqBody readJson(String pJson){
            return (ReqBody)JSON.deserializeStrict(pJson, ReqBody.class);
        }
    }

    @HttpPost
    global static void doPost() {

        Result theResult = new Result(); theResult.statusCode = 200;
        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;

        ReqBody theReqBody = null;
        if(theResult.statusCode == 200){
            try{
                theResult.reqBodyRaw = theReq.requestBody.toString();
                theReqBody = new ReqBody().readJson(theResult.reqBodyRaw);
            }catch(Exception e){
                theResult.statusCode = 400;
                theResult.descr = e.getMessage();
            }
        }

        if(theResult.statusCode == 200){
            try{
                process(theResult, theReqBody);
            }catch(Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
            }
        }
        
        theRes.statusCode = theResult.statusCode;

        Loggings.Level theLogLevel = Loggings.Level.Info;
        if(theResult.statusCode == 400) theLogLevel = Loggings.Level.Warn;
        if(theResult.statusCode == 500) theLogLevel = Loggings.Level.Error;
        Loggings.writeLog(
            Loggings.createLogEntry(
                theLogLevel, '20190919-2014-01', 'Api_V1_OboTeikeiMoushikomi')
                .putAttr('theResult.statusCode',String.valueOf(theResult.statusCode) )
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
    }

    public static void process(Result pResult, ReqBody pReqBody){

        Result theResult = pResult;
        ReqBody theReqBody = pReqBody;

        if(theResult.statusCode == 200){
            try{
				INSERT New Lead(
					RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Teikeisaki_Soryo').getRecordTypeId(),
					LastName = pReqBody.last_name,
					FirstName = pReqBody.first_name,
					SeiKana__c = pReqBody.sei_kana,
					MeiKana__c = pReqBody.mei_kana,
					PostalCode = pReqBody.postal_code,
					State = pReqBody.state,
					City = pReqBody.city,
					Street = pReqBody.street,
					MobilePhone = pReqBody.mobile_phone,
					Email = pReqBody.email,
					Shuha__c = pReqBody.shuha,
					Jiinmei__c = pReqBody.jiinmei,
					JiinmeiKana__c = pReqBody.jiinmei_kana,
					TaniShubetsu__c = pReqBody.tani_shubetsu,
					TashaTorokuKakunin__c = pReqBody.tasha_toroku_kakunin,
					MoshikomiKeii__c = pReqBody.moshikomi_keii,
					Biko__c = pReqBody.biko
				);

                OboTeikeiMoushikomiRtnMail.CreateMailArg theArg = new OboTeikeiMoushikomiRtnMail.CreateMailArg();
				theArg.last_name = pReqBody.last_name;
				theArg.first_name = pReqBody.first_name;
				theArg.last_kana = pReqBody.sei_kana;
				theArg.first_kana = pReqBody.mei_kana;
				theArg.zip = pReqBody.postal_code;
				theArg.state = pReqBody.state;
				theArg.city = pReqBody.city;
				theArg.street = pReqBody.street;
				theArg.MobilePhone = pReqBody.mobile_phone;
				theArg.email = pReqBody.email;
				theArg.shuha = pReqBody.shuha;
				theArg.Temple = pReqBody.jiinmei;
				theArg.JiinMeiKana = pReqBody.jiinmei_kana;
				theArg.unit = pReqBody.tani_shubetsu;
				theArg.Other_company = pReqBody.tasha_toroku_kakunin;
				theArg.MoshikomiKeii = pReqBody.moshikomi_keii;
				theArg.SonotaRenrakuJiko = pReqBody.biko;

                INSERT new OboTeikeiMoushikomiRtnMail().createMail(theArg);
            }catch (Exception e){
                theResult.statusCode = 500;
                theResult.descr = e.getMessage();
            }         
        }
    }
}