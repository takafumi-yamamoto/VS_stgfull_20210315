public class NPCreditStatus implements Schedulable {
	private static final String BASEENDPOINT = NPkakebaraiConfig.getConfig().BaseEndPoint__c;
	private static final String TERMINAL_ID = NPkakebaraiConfig.getConfig().TERMINAL_ID__c;
	private static final String SP_CODE = NPkakebaraiConfig.getConfig().SP_CODE__c;

    /////////////////////////////////////////////////////////
    //NP掛け払いに送信構造
	private class ReqBody {
        ReqRoot root = new ReqRoot();
    }
	private class ReqRoot {
        ReqCreditStatusParameter creditStatusParameter = new ReqCreditStatusParameter();
    }
    private class ReqCreditStatusParameter {
    	String creditGuaranteeStatusUpdateDateBegin = ''; //債権保証ステータス更新日（下限） 
    	String creditGuaranteeStatusUpdateDateEnd = ''; //債権保証ステータス更新日（上限） 
    }
    private String getReqBody(String dateBegin, String dateEnd) {
        ReqBody reqBody = new ReqBody();
        reqBody.root.creditStatusParameter.creditGuaranteeStatusUpdateDateBegin = dateBegin;
        reqBody.root.creditStatusParameter.creditGuaranteeStatusUpdateDateEnd = dateEnd;
        return JSON.serialize( reqBody );
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
        public CreditStatusResult creditStatusResult;
    }
    private class CreditStatusResult {
        public List<CreditGuaranteeStatusLists> creditGuaranteeStatusLists;
        public List<ErrorLists> errorLists;
    }
    private class CreditGuaranteeStatusLists {
        public String npBuyerId;
        public String buyerId;
        public String companyName;
        public String department;
        public String customerName;
        public String creditGuaranteeExpireDate;
        public String creditGuaranteeStatus; // 対象購入企業の債権保証状況
        public String creditGuaranteeStatusUpdateDate;
        public String transactionRegistrationDueDate;
        public String transactionRegistrationStatus; // 取引登録可/不可 
        public Decimal billedAmount;
    }
    private class ErrorLists {
        public String errorContents;
        public String errorLevel;
        public String errorNo;
    }

    /////////////////////////////////////////////////////////
    private String getCreditGuaranteeStatus(String creditGuaranteeStatus) {
        if(creditGuaranteeStatus == '00') return 'OK';
        if(creditGuaranteeStatus == '01') return 'ALRT';
        if(creditGuaranteeStatus == '11') return 'NG';
        return '連携エラー';
    }

    private String getTransactionRegistrationStatus(String transactionRegistrationStatus) {
        if(transactionRegistrationStatus == '00') return '可';
        if(transactionRegistrationStatus == '11') return '不可';
        return '連携エラー';
    }

    private Date toDate(String dateStr) {
        if(String.isBlank(dateStr)) return null;
        if(dateStr.length() != 8) return null;
        return Date.newInstance(integer.valueof(dateStr.left(4)), integer.valueof(dateStr.substring(4, 6)), integer.valueof(dateStr.right(2)));
    }
    
    /////////////////////////////////////////////////////////
    // sf->NP掛け払い連携 : 与信ステータス取得 
	private Result getResult(String dateBegin, String dateEnd) {
        Result theResult = new Result();
		try {
            theResult.endPoint = BaseEndPoint + '/credit/status';
            theResult.reqBodyRaw = this.getReqBody(dateBegin, dateEnd);

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('X-NP-Terminal-Id', TERMINAL_ID);
            request.setHeader('X-NP-Sp-Code', SP_CODE);
            request.setBody( theResult.reqBodyRaw );

            request.setTimeout(20000);
            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 201;

            String logTitle = theResult.isSuccess ? '与信ファイル取込-連携成功' : '与信ファイル取込-連携失敗';
            Loggings.writeLog(
                Loggings.createLogEntry(theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20181228-1100-01', 'NPBuyersAuthResult.getResult', logTitle)
                        .putAttr('reqBodyRaw', theResult.reqBodyRaw)
                        .putAttr('resBodyRaw', theResult.resBodyRaw)
                        .putAttr('endPoint', theResult.endPoint)
                        .putAttr('StatusCode', '' + response.getStatusCode())
            );
        }catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181228-1100-02', 'NPCreditStatus.getResult', '与信ファイル取込失敗-連携失敗')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
        return theResult;
	}

    /////////////////////////////////////////////////////////
    // 与信ファイル取込
    @future(callout=true) 
    public static void NpYosinStatusTorikomi(String dateBegin, String dateEnd) {
        try {
            NPCreditStatus npCreditStatus = new NPCreditStatus();
            Result theResult = npCreditStatus.getResult(dateBegin, dateEnd);
            if(!theResult.isSuccess) return;
            ResBody resBody = (ResBody)JSON.deserialize(theResult.resBodyRaw, ResBody.class);
            if(resBody.root.creditStatusResult.creditGuaranteeStatusLists == null
               || resBody.root.creditStatusResult.creditGuaranteeStatusLists.size() == 0) return;

            Map<String, CreditGuaranteeStatusLists> buyerIdCreditStausResults = new Map<String, CreditGuaranteeStatusLists>();
            for(CreditGuaranteeStatusLists creditStausResult : resBody.root.creditStatusResult.creditGuaranteeStatusLists){
                buyerIdCreditStausResults.put(creditStausResult.buyerId, creditStausResult);
            }
            if(buyerIdCreditStausResults.size() == 0) return;
            
            List<Yosin__c> yosinList = new List<Yosin__c>();
            List<NpYosinStatusChgCheckTodo__c> theTodos = new List<NpYosinStatusChgCheckTodo__c>();
            for(Account account : 
                [
                SELECT Id, TorihikisakiBango__c, YosinRef__c , 
                YosinRef__r.NpSaikenHoshoStatus__c, YosinRef__r.NpSaikenHoshoStatusKosinBi__c
                FROM Account 
                WHERE TorihikisakiBango__c =: buyerIdCreditStausResults.keySet()
                ]
            ){
                if(String.isBlank(account.YosinRef__c)) continue;

                CreditGuaranteeStatusLists creditStausResult = buyerIdCreditStausResults.get(account.TorihikisakiBango__c);

                Yosin__c aYosin = 
                    new Yosin__c(
                        Id = account.YosinRef__c,
                        NpYosinStatusInfoUpdatedTime__c = DateTime.now(),
                        NpSaikenHoshoStatus__c = npCreditStatus.getCreditGuaranteeStatus(creditStausResult.creditGuaranteeStatus ),
                        NpTorihikiTorokuKigenBi__c = npCreditStatus.toDate(creditStausResult.transactionRegistrationDueDate),
                        NpSaikenHoshoKigenBi__c = npCreditStatus.toDate(creditStausResult.creditGuaranteeExpireDate),
                        NpSaikenHoshoStatusKosinBi__c = npCreditStatus.toDate(creditStausResult.creditGuaranteeStatusUpdateDate),
                        NpTorihikiTorokuKahi__c = npCreditStatus.getTransactionRegistrationStatus(creditStausResult.transactionRegistrationStatus)
                    );

                //filter out unchanged statusResults
                if(
                    account.YosinRef__r.NpSaikenHoshoStatusKosinBi__c == aYosin.NpSaikenHoshoStatusKosinBi__c
                    &&
                    account.YosinRef__r.NpSaikenHoshoStatus__c == aYosin.NpSaikenHoshoStatus__c
                ){
                    continue;
                }

                yosinList.add(aYosin);

                theTodos.add(
                    new NpYosinStatusChgCheckTodo__c(
                        BuyerId__c = creditStausResult.buyerId,
                        CompanyName__c = creditStausResult.companyName,
                        NpSaikenHoshoStatus__c = aYosin.NpSaikenHoshoStatus__c,
                        NpSaikenHoshoStatusBefore__c = account.YosinRef__r.NpSaikenHoshoStatus__c,
                        NpSaikenHoshoStatusKosinBi__c = aYosin.NpSaikenHoshoStatusKosinBi__c
                    )
                );
            }

            if(yosinList.size() > 0) update yosinList;
            if(theTodos.size() > 0) INSERT theTodos;

        } catch(Exception e){
            System.debug(e);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181228-1100-04', 'NPCreditStatus.NpYosinStatusTorikomi', '与信ファイル取込失敗')
                        .putAttr('Exception', e.getMessage())
                        .putAttr('LineNumber', '' + e.getLineNumber())
                        .putAttr('getStackTraceString', e.getStackTraceString())
            );
        }
    }

    /** スケジュール起動*/
    public void execute(SchedulableContext sc) {
        String dateBegin = Datetime.now().addDays(-1).format('YYYYMMdd');
        String dateEnd = Datetime.now().format('YYYYMMdd');
        NpYosinStatusTorikomi(dateBegin, dateEnd);
    }
}