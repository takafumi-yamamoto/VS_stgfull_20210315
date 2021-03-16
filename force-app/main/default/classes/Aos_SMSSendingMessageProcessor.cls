@RestResource(urlMapping='/v1/aossms/sendingstatuschanged')
global class Aos_SMSSendingMessageProcessor {

    //施行確認方法 文字列
    public static final String methodStr_sms='SMS';

    public class DLRValue{
        public List<EventNotifications> eventNotifications;
    }

    public class EventNotifications{
        public String type;
        public String dateTimeString;
        public String messageId;
        public String phoneNumber;
        public String smsCode;
        public String carrierId;
        public String carrierName;
        public String messageText;
        public String clientId;
        public String clientTag;
        public String statusId; //0:unknown 1:配信中 2:送達 3:配信失敗　
        public String statusDescription;
        public Rawdata rawdata;
    }

    public class Rawdata{
        public String carrier;
        public String type;
        public Data data;
    }

    public class Data{
        public String code;
        public String submission_status;
        public String msgState;
        public String submission_err_code;
        public String ntwkErr;
        public String commandStatus;
        public String networkErrorCode;
    }

    public class RestResponseParam{
        public Integer statusCode {get;set;}
        public String responseBody {get;set;}
    }

    public Aos_SMSSendingMessageProcessor(){
        system.debug('Constructor');
    }

    private static SMSHistory__c createDlrSMSHistory(EventNotifications pEventNotifications, Rawdata pRawdata, Data pData, String pReqBodyRaw){
        SMSHistory__c aosHist = new SMSHistory__c();
        aosHist.EventNotifications_type__c  = pEventNotifications.type;
        aosHist.DateTime__c                 = pEventNotifications.dateTimeString;
        aosHist.MessageId__c                = pEventNotifications.messageId;
        aosHist.PhoneNumber__c              = pEventNotifications.phoneNumber;
        aosHist.SmsCode__c                  = pEventNotifications.smsCode;
        aosHist.CarrierId__c                = pEventNotifications.carrierId;
        aosHist.CarrierName__c              = pEventNotifications.carrierName;
        aosHist.MessageText__c              = pEventNotifications.messageText.replaceAll('\\n', '<br>');
        aosHist.ClientId__c                 = pEventNotifications.clientId;
        aosHist.ClientTag__c                = pEventNotifications.clientTag;
        aosHist.StatusId__c                 = pEventNotifications.statusId;
        aosHist.StatusDescription__c        = pEventNotifications.statusDescription;
        aosHist.Carrier__c                  = pRawdata.carrier;
        aosHist.Rawdata_Type__c             = pRawdata.type;
        aosHist.Code__c                     = pData.code;
        aosHist.Submission_status__c        = pData.submission_status;
        aosHist.MsgState__c                 = pData.msgState;
        aosHist.Submission_err_code__c      = pData.submission_err_code;
        aosHist.NtwkErr__c                  = pData.ntwkErr;
        aosHist.CommandStatus__c            = pData.commandStatus;
        aosHist.NetworkErrorCode__c         = pData.networkErrorCode;
        aosHist.ReceivedJSON__c             = pReqBodyRaw;
        aosHist.RecordTypeId                = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('SMSHistory__c','DLR');
        return aosHist;
    }

    @HttpPost
    global static void SendingStatusChanged(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        RestResponseParam resparam = new RestResponseParam();

        try{
            String requestBody = req.requestBody.toString();

            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info, '20190801-1024', 'Aos_SMSSendingMessageProcessor.Dlr')
                    .putAttr('requestBody',requestBody)
            );

            String jsonText = requestBody.replace('dateTime', 'dateTimeString').replace('\\"', '"');
            jsonText = jsonText.mid(1, jsonText.length()-2);
            DLRValue dlr = (DLRValue)JSON.deserialize(jsonText, DLRValue.class);

            EventNotifications eventNotifications = dlr.eventNotifications[0];
            Rawdata rawData = dlr.eventNotifications[0].Rawdata;
            Data data = (rawData != null)? dlr.eventNotifications[0].Rawdata.data : new Data();
            if(rawData == null) rawData = new Rawdata();

            try{
                logSmsDlr(eventNotifications);
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20190801-1201', 'Aos_SMSSendingMessageProcessor.logSmsDlr')
                        .putAttr('ex.getMessage()', ex.getMessage())
                        .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                        .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
            }

            List<String> clientTagList = eventNotifications.clientTag.split(',');

            if( !isToMessageToLog(eventNotifications.clientTag, eventNotifications.statusId) ){
                system.debug('a message to be ignored received.');
                resparam.responseBody = 'success';
                resparam.statusCode = 200;
                res.responseBody = Blob.valueOf(json.serialize(resparam, true));
                return;
            }


            SMSHistory__c aosHist = createDlrSMSHistory( eventNotifications, rawData, data, req.requestBody.toString() );
            String formatType = clientTagList.size() > 0 ? clientTagList[0] : '';


            Boolean isHandled = false;
            if( !isHandled && formatType=='Campaign' ){
                isHandled = true;

                List<Account> accounts = [SELECT Id FROM Account WHERE TorihikisakiBangoF__c =:clientTagList[5]];
                if(accounts.size() > 0){
                    aosHist.Account__c = accounts[0].Id;
                }

                aosHist.NegotiationID__c = clientTagList[4];
                List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE ShodanBangoF__c =: aosHist.NegotiationID__c];
                if(opportunities.size() > 0){
                    aosHist.OppId__c = opportunities[0].Id;
                    aosHist.Opportunity__c = opportunities[0].Id;
                }
                Insert aosHist;
            }

            if( !isHandled && formatType=='ObouSekouKakunin'){
                isHandled = true;
                // 僧侶取引先レコードタイプの取得
                Id soryoTorihikisakiRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount');

                List<Account> monks = [SELECT Id FROM Account WHERE TorihikisakiBangoF__c =: clientTagList[5] AND RecordTypeId = :soryoTorihikisakiRecordTypeId];
                if(monks.size() > 0){
                    aosHist.Account__c = monks[0].Id;
                }

                aosHist.NegotiationID__c = clientTagList[4];
                List<Opportunity> opportunities = [SELECT Id,ObosanbinRef__c,ShodanBangoF__c  FROM Opportunity WHERE ShodanBangoF__c =: aosHist.NegotiationID__c];
                List<Obosanbin__c> oppobou = new List<Obosanbin__c>();

                if(opportunities.size() > 0){

                    aosHist.OppId__c = opportunities[0].Id;
                    aosHist.Opportunity__c = opportunities[0].Id;

                    Boolean toUpdateSekouJoutai = (clientTagList[6] == '1') ? true : false;
                    Boolean soutatuStatus = ( eventNotifications.statusId =='2') ? true : false;//送達ステータス 2：成功　3:失敗

                    if(toUpdateSekouJoutai){

                        oppobou = [SELECT SekoKakuninRef__c FROM Obosanbin__c WHERE Id =: opportunities[0].ObosanbinRef__c];

                        //施行確認状態：商談と施行確認状態紐づけが存在する場合は、状態のステータスを更新
                        if(oppobou.size() > 0 && oppobou[0].SekoKakuninRef__c!=null){

                            //施行確認状態取得
                            SekoKakunin__c theSekoukakuninJoutai = [SELECT id,status__c,ObosambinShodanBango__c FROM SekoKakunin__c WHERE Id =:oppobou[0].SekoKakuninRef__c];
                            if(soutatuStatus){
                                theSekoukakuninJoutai.status__c = true;
                                theSekoukakuninJoutai.ObosambinShodanBango__c = opportunities[0].ShodanBangoF__c;
                                update theSekoukakuninJoutai;

                                //施行確認明細にクライアントタグ登録
                                SekoKakunimMeisai__c theSekoukakuninMeisai = [SELECT id,ClientTag__c FROM SekoKakunimMeisai__c WHERE SekoKakuninRef__c=:theSekoukakuninJoutai.id];
                                theSekoukakuninMeisai.ClientTag__c = eventNotifications.clientTag;
                                update theSekoukakuninMeisai;
                            }

                        } else if(oppobou.size() > 0 && oppobou[0].SekoKakuninRef__c == null){

                            //商談に施行確認状態紐づけ無い場合は新規作成
                            SekoKakunin__c theSekoukakuninJoutai = new SekoKakunin__c();
                            theSekoukakuninJoutai.ObosambinShodanBango__c =  opportunities[0].ShodanBangoF__c;
                            if(soutatuStatus){
                                theSekoukakuninJoutai.status__c = true;
                            }else{
                                theSekoukakuninJoutai.status__c = false;
                            }
                            insert theSekoukakuninJoutai;

                            //商談　施行確認状態紐づけ更新
                            oppobou[0].SekoKakuninRef__c = theSekoukakuninJoutai.id;
                            update oppobou[0];

                            //施行確認明細作成
                            SekoKakunimMeisai__c enf = new SekoKakunimMeisai__c(
                                ConfirmPersonName__c    = UserInfo.getName(),
                                ConfirmDatetime__c      = Datetime.now(),
                                ConfirmMethod__c        = methodStr_sms,
                                ClientTag__c            = eventNotifications.clientTag,
                                SekoKakuninRef__c       = oppobou[0].SekoKakuninRef__c
                            );

                            insert enf;
                        }
                    }
                }
                Insert aosHist;
            }

            //お坊さん便事前確認SMS
            if( !isHandled && formatType=='ObosanJizenSms'){
                isHandled = true;
                new Aos_SMSSendingMessage_ObosanJizenSms().handle(aosHist);
            }

            if( !isHandled ){
                List<SMSHistory__c> aosHistoriesToBeInserted = new List<SMSHistory__c>();
                //キャンペーンでもお坊さん施行でも無い場合 取引先を検索して紐づける。
                String phNum = '0'+eventNotifications.phoneNumber.substring(3);

                List<Account> accountsPhoneNoMatched = [SELECT Id FROM Account WHERE MobilePhoneFormula__c =:phNum];

                for (Account itrOfAccount : accountsPhoneNoMatched) {
                    SMSHistory__c historyToBeInserted = aosHist.clone(false, false, false, false);
                    historyToBeInserted.Account__c = itrOfAccount.Id;
                    aosHistoriesToBeInserted.add(historyToBeInserted);
                }
                Insert aosHistoriesToBeInserted;
            }


            resparam.responseBody = 'success';
            resparam.statusCode = 200;
            res.responseBody = Blob.valueOf(json.serialize(resparam, true));

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



    //既存履歴チェック
    private static boolean isLoggedAlready(string clientTag){
        List<SMSHistory__c> aosList = [SELECT Id FROM SMSHistory__c WHERE StatusId__c IN ('2', '3')  AND ClientTag__c =: clientTag AND ClientTag__c !='' ];
        system.debug('duplicateCheck: ' + aosList.size() + ' record(s) found： StatusId=2 & ClientTag=SAME');
        return !(aosList.size() == 0);
    }

    //AOSSMS ステータスIDチェック
    private static boolean isDeliveryStatusToLog(string status){
        string deliverySuccess = '2';
        string deliveryFailed = '3';
        return (status == deliverySuccess || status == deliveryFailed);
    }

    //既存履歴及びAOSSMSステータスIDチェック  既存履歴が存在し、ステータスが２、３以外の場合は true
    private static boolean isToMessageToLog(string clientTag, string deliveryStatus){
        return !isLoggedAlready(clientTag) && isDeliveryStatusToLog(deliveryStatus);
    }

    private static void logSmsDlr(EventNotifications pNotification){

        String DlrDtRaw = pNotification.dateTimeString;
        Datetime theDlrDt = null;
        try{
            theDlrDt = Datetime.valueOf(DlrDtRaw.replace('+', ' ').replace('/', '-'));
        }catch(Exception e){ } //ignore
        String thePhoneNumberRaw = pNotification.phoneNumber;
        String thePhoneNumber = null;
        try{
            thePhoneNumber = '0'+pNotification.phoneNumber.substring(3);
        }catch(Exception e){} //ignore

        String theStatus = null;
        if(pNotification.statusId == '0') theStatus = 'Unknown';
        if(pNotification.statusId == '1') theStatus = 'Sending';
        if(pNotification.statusId == '2') theStatus = 'Delivered';
        if(pNotification.statusId == '3') theStatus = 'DeliveryFailed';

        List<SmsDlr__c> smsDlrList = [SELECT Id From SmsDlr__c WHERE DAY_ONLY(CreatedDate) = Today AND ClientTag__c =: pNotification.clientTag AND Status__c =: theStatus];
        if(smsDlrList.size() > 0) return;

        INSERT New SmsDlr__c(
            ClientTag__c = pNotification.clientTag,
            MsgText__c = pNotification.messageText,
            DlrDt__c = theDlrDt,
            PhoneNo__c = thePhoneNumber,
            Status__c = theStatus
        );
    }

}