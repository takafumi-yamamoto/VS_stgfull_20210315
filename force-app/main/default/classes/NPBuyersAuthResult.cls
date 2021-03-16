public class NPBuyersAuthResult {
	private static final String BASEENDPOINT = NPkakebaraiConfig.getConfig().BaseEndPoint__c;
	private static final String TERMINAL_ID = NPkakebaraiConfig.getConfig().TERMINAL_ID__c;
	private static final String SP_CODE = NPkakebaraiConfig.getConfig().SP_CODE__c;

    /////////////////////////////////////////////////////////
    //NP掛け払いに送信構造
	private class ReqBody {
        ReqRoot root = new ReqRoot();
    }
	private class ReqRoot {
        BuyerAuthorizationResultParameter buyerAuthorizationResultParameter = new BuyerAuthorizationResultParameter();
    }
    private class BuyerAuthorizationResultParameter {
    	List<String> buyerIdLists = new List<String>();
    }

    private class Result{
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    /////////////////////////////////////////////////////////
    //NP掛け払いから戻り値構造
    private class ResBody {
        Root root;
    }
	private class Root {
		public BuyerAuthorizationResultResult buyerAuthorizationResultResult;
	}
	private class BuyerAuthorizationResultLists {
		public String buyerId;
		public String buyerAuthoriStatus;
		public String creditFacilityTermBegin;
		public Decimal amountCap;
		public String creditFacilityTermEnd;
		public String resultType;
		public String authoriRequiredDate;
	}
	private class ErrorLists {
		public String errorContents;
		public String errorLevel;
		public String errorNo;
	}
	private class ErrorResultLists {
		public String buyerId;
		public List<ErrorLists> errorLists;
	}
	private class BuyerAuthorizationResultResult {
		public List<ErrorResultLists> errorResultLists;
		public List<BuyerAuthorizationResultLists> buyerAuthorizationResultLists;
	}

    /////////////////////////////////////////////////////////
    private String getNpKonyuKigyoSinsaJokyo(String buyerAuthoriStatus) {
    	if(buyerAuthoriStatus == '01') return '未申請';
    	if(buyerAuthoriStatus == '02') return '審査中';
    	if(buyerAuthoriStatus == '03') return '審査完了';
    	return '連携エラー';
    }

    private Date toDate(String dateStr) {
    	if(String.isBlank(dateStr)) return null;
    	if(dateStr.length() != 8) return null;
    	return Date.newInstance(integer.valueof(dateStr.left(4)), integer.valueof(dateStr.substring(4, 6)), integer.valueof(dateStr.right(2)));
    }

    private String getReqBody(List<String> buyerIdLists) {
    	ReqBody reqBody = new ReqBody();
    	reqBody.root.buyerAuthorizationResultParameter.buyerIdLists = buyerIdLists;
        return JSON.serialize( reqBody );
    }

    /////////////////////////////////////////////////////////
    // sf->NP掛け払い連携
	private Result getResult(List<String> buyerIdLists) {
        Result theResult = new Result();
		try {
            theResult.endPoint = BASEENDPOINT + '/buyers/authorizations/results';
            theResult.reqBodyRaw = this.getReqBody(buyerIdLists);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('X-NP-Terminal-Id', TERMINAL_ID);
            request.setHeader('X-NP-Sp-Code', SP_CODE);
            request.setBody( theResult.reqBodyRaw );
            request.setTimeout(30000);

            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 201;

            String logTitle = theResult.isSuccess ? '購入企業審査結果取込-連携成功' : '購入企業審査結果取込-連携失敗';
            Loggings.writeLog(
                Loggings.createLogEntry(theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20181227-1000-01', 'NPBuyersAuthResult.getResult', logTitle)
                        .putAttr('reqBodyRaw', theResult.reqBodyRaw)
                        .putAttr('resBodyRaw', theResult.resBodyRaw)
                        .putAttr('endPoint', theResult.endPoint)
                        .putAttr('StatusCode', '' + response.getStatusCode())
            );

        } catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181227-1000-02', 'NPBuyersAuthResult.getResult', '購入企業審査結果取込失敗-連携失敗')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
                        .putAttr('reqBodyRaw', theResult.reqBodyRaw)
                        .putAttr('resBodyRaw', theResult.resBodyRaw)
                        .putAttr('endPoint', theResult.endPoint)
            );
        }
        return theResult;
	}

    /////////////////////////////////////////////////////////
    // 購入企業審査結果取込
	public void NpKonyuKigyoKekkaTorikomi(List<String> torihikisakiBangoList) {
        try {
    		Result theResult = this.getResult(torihikisakiBangoList);
            if(!theResult.isSuccess) return;
    		ResBody resBody = (ResBody)JSON.deserialize(theResult.resBodyRaw, ResBody.class);
            if(resBody.root.buyerAuthorizationResultResult.buyerAuthorizationResultLists == null
               || resBody.root.buyerAuthorizationResultResult.buyerAuthorizationResultLists.size() == 0) return;

    		Map<String, BuyerAuthorizationResultLists> buyerAuthorizationResultMap = new Map<String, BuyerAuthorizationResultLists>();
    		for(BuyerAuthorizationResultLists yosinResult : resBody.root.buyerAuthorizationResultResult.buyerAuthorizationResultLists){
    			buyerAuthorizationResultMap.put(yosinResult.buyerId, yosinResult);
    		}
            if(buyerAuthorizationResultMap.size() == 0) return;

            List<Account> accountList = [SELECT Id, TorihikisakiBango__c, YosinRef__c FROM Account WHERE TorihikisakiBango__c =: buyerAuthorizationResultMap.keySet()];
            List<Yosin__c> yosinList = new List<Yosin__c>();
            Map<Id, Yosin__c> accountYosinMap = new Map<Id, Yosin__c>(); 
            for(Account account : accountList){
                BuyerAuthorizationResultLists yosinResult = buyerAuthorizationResultMap.get(account.TorihikisakiBango__c);
                Yosin__c yosin = new Yosin__c(
                        Id = account.YosinRef__c,
                        NpKonyuKigyoInfoUpdatedTime__c = DateTime.now(),
                        NpKonyuKigyoSinsaJokyo__c = this.getNpKonyuKigyoSinsaJokyo(yosinResult.buyerAuthoriStatus),
                        NpYosinJogenKingaku__c = yosinResult.amountCap,
                        NpYosinWakuTekiyoKaishiBi__c = this.toDate(yosinResult.creditFacilityTermBegin),
                        NpYosinWakuTekiyoShuryoBi__c = this.toDate(yosinResult.creditFacilityTermEnd)
                         );
                if(String.isBlank(account.YosinRef__c)) {
                    yosin.NpSaikenHoshoStatus__c = 'OK';
                    yosin.NpTorihikiTorokuKahi__c = '可';
                }
                yosinList.add(yosin);
                if(String.isBlank(account.YosinRef__c)) accountYosinMap.put(account.Id, yosin);
            }
            if(yosinList.size() > 0) upsert yosinList;

            List<Account> accountForUpdateList = new List<Account>();
            for(Id accountId: accountYosinMap.keySet()) {
                Yosin__c yosin = accountYosinMap.get(accountId);
                accountForUpdateList.add(new Account(Id=accountId, YosinRef__c=yosin.Id));
            }
            if(accountForUpdateList.size() > 0) update accountForUpdateList;

        } catch(Exception e){
            System.debug(e);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181227-1000-03', 'NPBuyersAuthResult.NpKonyuKigyoKekkaTorikomi', '購入企業審査結果取込失敗')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
	}

}