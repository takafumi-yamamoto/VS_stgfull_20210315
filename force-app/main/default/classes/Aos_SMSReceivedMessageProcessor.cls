@RestResource(urlMapping='/v1/aossms/messagereceived')
global class Aos_SMSReceivedMessageProcessor {

  public Aos_SMSReceivedMessageProcessor(){
    system.debug('Constructor');
  }

    public class RestResponseParam{
        public Integer statusCode {get;set;}
        public String responseBody {get;set;}
    }

    public class ReceivedMessage{
        public MoNotification moNotification;
    }

    public class MoNotification{
        public String dateTimeString;
        public String clientId;
        public String smsCode;
        public String phoneNumber;
        public String carrierId;
        public String carrierName;
        public String message;
    }


    @HttpPost
    global static void MessageReceived(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        system.debug(req);
        system.debug(res);        
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        RestResponseParam resparam = new RestResponseParam();

        try{

            system.debug('req:' + req);
            system.debug('req-body:' + req.requestBody.toString());
            String requestBody = req.requestBody.toString();

            /*紐づけ先検索*/
            String jsonText = requestBody.replace('dateTime', 'dateTimeString').replace('\\"', '"');
            jsonText = jsonText.mid(1, jsonText.length()-2);
            ReceivedMessage bodyValue = (ReceivedMessage)JSON.deserialize(jsonText, ReceivedMessage.class);
            system.debug('bodyValue:' + bodyValue);
            MoNotification moNotificationValue = bodyValue.moNotification;

            List<SMSHistory__c> aosList = 
            [SELECT Id FROM SMSHistory__c 
            WHERE DateTime__c =: moNotificationValue.dateTimeString AND PhoneNumber__c =: moNotificationValue.phoneNumber AND MessageText__c =: moNotificationValue.message AND CreatedDate > YESTERDAY];

            system.debug('duplicateCheck: ' + aosList.size() + ' record(s) found： dateTime=SAME & phoneNumber=SAME & message=SAME');
            if(!aosList.isEmpty()){ system.debug('Proccess Stopped'); }

            if(aosList.size() == 0){            

                if(moNotificationValue.phoneNumber <> null){
                    String phoneNumberNational = moNotificationValue.phoneNumber.replace(moNotificationValue.phoneNumber.left(3), '0');
                    system.debug(phoneNumberNational);

                    // 個人取引先レコードタイプ取得
                    Id customerTorihikisakiRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer');
                    // 僧侶取引先レコードタイプの取得
					Id soryoTorihikisakiRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount');


					List<Account> accountList =  [SELECT Id, Name, MobilePhoneFormula__c FROM Account WHERE MobilePhoneFormula__c =: phoneNumberNational AND RecordTypeId = :customerTorihikisakiRecordTypeId];
					List<Account> soryoList   =  [SELECT Id, Name, MobilePhoneFormula__c FROM Account WHERE MobilePhoneFormula__c =: phoneNumberNational AND RecordTypeId = :soryoTorihikisakiRecordTypeId];
                   	Id receivedRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('SMSHistory__c','ReceivedMessage');
                   	System.debug(receivedRecordTypeId);

                    if(accountList.size() > 0){
                        for(Account acc : accountList){
                            SMSHistory__c aosHist   = new SMSHistory__c();
                            aosHist.DateTime__c     = moNotificationValue.dateTimeString;
                            aosHist.ClientId__c     = moNotificationValue.clientId;
                            aosHist.SmsCode__c      = moNotificationValue.smsCode;
                            aosHist.PhoneNumber__c  = moNotificationValue.phoneNumber;
                            aosHist.CarrierId__c    = moNotificationValue.carrierId;
                            aosHist.CarrierName__c  = moNotificationValue.carrierName;
                            aosHist.MessageText__c  = moNotificationValue.message;
                            aosHist.ReceivedJSON__c = requestBody;
                            aosHist.RecordTypeId    = receivedRecordTypeId;
                            aosHist.Account__c = acc.Id;
                            insert aosHist;
                        }
                    }

                    if(soryoList.size() > 0){
                        for(Account monk : soryoList){
                            SMSHistory__c aosHist   = new SMSHistory__c();
                            aosHist.DateTime__c     = moNotificationValue.dateTimeString;
                            aosHist.ClientId__c     = moNotificationValue.clientId;
                            aosHist.SmsCode__c      = moNotificationValue.smsCode;
                            aosHist.PhoneNumber__c  = moNotificationValue.phoneNumber;
                            aosHist.CarrierId__c    = moNotificationValue.carrierId;
                            aosHist.CarrierName__c  = moNotificationValue.carrierName;
                            aosHist.MessageText__c  = moNotificationValue.message;
                            aosHist.ReceivedJSON__c = requestBody;
                            aosHist.RecordTypeId    = receivedRecordTypeId;
                            aosHist.Account__c      = monk.Id;
                            insert aosHist;
                        }
                    }
                }
            }


            resparam.responseBody = 'success';
            resparam.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(resparam, true));

            system.debug('res:' + res);
            system.debug('res-body:' + res.responseBody.toString());
            return;


        } catch (Exception e) {

            resparam.responseBody = String.valueOf(e) + '\n\n' + e.getStackTraceString();
            resparam.statusCode = 500;
            res.responseBody = Blob.valueOf(json.serialize(resparam, true));

            system.debug('res:' + res);
            system.debug('res-body:' + res.responseBody.toString());
            return;
        }
    }
}