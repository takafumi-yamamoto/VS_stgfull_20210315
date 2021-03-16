public class Aos_SMSSendingMessage {

    private static final String accessToken = Label.AccessToken;
    private static final String clienId = Label.ClientId;
    private static final String smsCode = Label.SmsCode;
    private static final Integer timeSleepValue = Integer.valueOf(Label.SmsTimeSleepValue);
    private String shodanBango;

    public List<SMSHistory__c> aosSMSSendingHistoryList {get;set;}
    
    public Aos_SMSSendingMessage(ApexPages.StandardController controller) {

    	System.debug('---Aos_SMSSendingMessage----');

        Opportunity tempOpp = (Opportunity)controller.getRecord();
        Opportunity opp = [SELECT Id, Name, ShodanBangoF__c, Account.Id FROM Opportunity WHERE Id =: tempOpp.Id];
        shodanBango = opp.ShodanBangoF__c;

        aosSMSSendingHistoryList = [
            SELECT Name, Account__c, MessageText__c, MessageTextFormula__c, SMSType__c, CreatedDate 
            FROM SMSHistory__c 
            WHERE Account__c =: opp.Account.Id 
            ORDER BY Name desc limit 20];
    }

    public String sendText {get;set;}
    public String resBody {get;set;}
    public Integer status {get;set;}
    public Map<String, String> queryStringMap {get;set;}
    public String responseDateTime {get;set;}

    public Class ObjectDTO {
        public Account acc {get;set;}
        public Opportunity opp {get;set;}
    }

    public class RestResponseParam{
        public Integer responseCode {get;set;}
    }


    public void SendAosSMSMessage(){

    	System.debug('----SendAosSMSMessage----');

        Datetime now     = Datetime.now();
        String timeSpace = now.format('yyyy') + now.format('MM') + now.format('dd') + now.format('HH') + now.format('mm') + now.format('ss');

        ObjectDTO dto = new ObjectDTO();
        dto.opp = [SELECT Id, ShodanBangoF__c, Account.Id FROM Opportunity WHERE ShodanBangoF__c =:shodanBango];
        dto.acc = [SELECT Id, Name, TorihikisakiBangoF__c, MobilePhoneFormula__c FROM Account WHERE Id =: dto.opp.Account.Id];

       if(dto.acc.MobilePhoneFormula__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '相談者（取引先）に携帯電話番号が登録されていません。' ));
        }else{

            String sendTextParam = '';
            Integer startIndex = 0;
            Integer indexLength = 70;
            Decimal count = Decimal.valueOf(sendText.length()).divide(Decimal.valueOf(indexLength), 10, System.RoundingMode.CEILING);
            system.debug('text-count:' + count);

            for(Integer i = 0; i < count; i++){
                sendTextParam = sendText.mid(startIndex, indexLength);
                system.debug('sendTextParam:' + sendTextParam);
                startIndex = startIndex + indexLength;

                String countString = String.valueOf(i);
                if(countString.length() == 1) countString = '0' + countString;
                String phoneNumber = dto.acc.MobilePhoneFormula__c; 
                String clientTag = GetClientTag(2, timeSpace, phoneNumber, dto.opp.ShodanBangoF__c, dto.acc.TorihikisakiBangoF__c, countString);
                SendHttpRequest(clientTag, phoneNumber, sendTextParam);

                Long startTime = DateTime.now().getTime();
                Long finishTime = DateTime.now().getTime();
                while ((finishTime - startTime) < timeSleepValue ) {
                    //sleep for 1s
                    finishTime = DateTime.now().getTime();
                }            
            }

            DateTime dateTimeNow = DateTime.Now();
            responseDateTime = '[' + dateTimeNow.format('yyyy/MM/dd HH:mm', 'JST') + ']';

        }
    }

    /*
    formatTypeId
        1:ObouSekouKakunin 
        2:Campaign
    */
    public String GetClientTag(Integer formatTypeId, String timeSpace, String phoneNumber, String option1, String option2, String option3){

        String rs = '';
        String formatType = '';
        formatType = (formatTypeId == 1)? 'ObouSekouKakunin':'';
        formatType = (formatTypeId == 2)? 'Campaign':'';

        SMSHistory__c smsHistory = [
            SELECT Id, ClientTagCountUp__c 
            FROM SMSHistory__c 
            WHERE ClientTagCountUp__c !=: null 
            ORDER BY ClientTagCountUp__c desc limit 1
            ];

        System.debug('----smsHistory----' + smsHistory);

        String phoneNumber4digit = phoneNumber.right(4);
        String basic = formatType + ',' + timeSpace + ',' + smsHistory.ClientTagCountUp__c + ',' + phoneNumber4digit;

        String option = '';
        option = (option1 == '')? '' : ',' + option1;
        option = (option2 == '')? option : option + ',' + option2;
        option = (option3 == '')? option : option + ',' + option3;

        rs = basic + option;

        system.debug('clientTag:'+ rs);
        return rs;
    }

    public void SendHttpRequest(String clientTag, String phoneNumber, String sendTextParam){
        
        Boolean isResricted = false;
        try{
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(phoneNumber);
        }catch(Testers.NotTesterException ex){
            isResricted = true;
        }
        if(isResricted) return;

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        queryStringMap = new Map<String, String>();
        queryStringMap.put('token', accessToken);
        queryStringMap.put('clientId', clienId);
        queryStringMap.put('smsCode', smsCode);
        queryStringMap.put('message', EncodingUtil.urlEncode(sendTextParam,'UTF-8'));
        queryStringMap.put('phoneNumber', EncodingUtil.urlEncode(phoneNumber,'UTF-8'));
        queryStringMap.put('clientTag', EncodingUtil.urlEncode(clientTag,'UTF-8'));
 
        String queryString = '';
        for(String s : queryStringMap.keyset()){
            queryString = queryString + s + '=' + queryStringMap.get(s) + '&';
        }
        queryString = queryString.removeEnd('&');

        system.debug('queryString:' + queryString);
        req.setEndpoint('https://qpd-api.aossms.com/p1/api/mt.json?' + queryString);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        system.debug('req-EndPoint---' + req);

        HttpResponse res = http.send(req);
        resBody = res.getBody();
        System.debug(res.getBody());
        RestResponseParam resparam = (RestResponseParam)JSON.deserialize(resBody, RestResponseParam.class);        
        status = resparam.responseCode;
    }

}