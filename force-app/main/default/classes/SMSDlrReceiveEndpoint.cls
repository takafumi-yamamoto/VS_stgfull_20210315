/** 
 * SMS送達結果 受信
 */
@RestResource(urlMapping='/v2/aossms/sendingstatuschanged')
global class SMSDlrReceiveEndpoint {

/**
    // --------- JSONデシリアライズ用クラス Start ------------------
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

    // --------- JSONデシリアライズ用クラス END ------------------

    public class ClientTag {
        public String negotiationID;
        public String pKey;
        public String formatType;
    }

    public class RestResponseParam{
        public Integer statusCode {get;set;}
        public String responseBody {get;set;}
    }

    public SMSDlrReceiveEndpoint(){
        system.debug('Constructor');
    }

    // @HttpPost
    global static void SendingStatusChanged(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        system.debug(req);
        system.debug(res);        
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }

        RestResponseParam resparam = new RestResponseParam();
        
        try {
            system.debug('req:' + req);
            system.debug('req-body:' + req.requestBody.toString());
            String requestBody = req.requestBody.toString();

            // AOS 日付形式の修正
            String jsonText = requestBody.replace('dateTime', 'dateTimeString').replace('\\"', '"');
            jsonText = jsonText.mid(1, jsonText.length()-2);
            system.debug(jsonText);

            // AOS メッセージの解析
            DLRValue dlr = (DLRValue)JSON.deserialize(jsonText, DLRValue.class);
            system.debug('dlr:' + dlr);
            EventNotifications eventNotifications = dlr.eventNotifications[0];
            Rawdata rawData = eventNotifications.Rawdata;
            Data data = (rawData != null)? eventNotifications.Rawdata.data : new Data();
            if(rawData == null) rawData = new Rawdata();


            // クライアントタグの解析
            ClientTag clientTag = deserializeClientTag(eventNotifications.clientTag);

            // 処理
            if(isToMessageToLog(eventNotifications.clientTag, eventNotifications.statusId)){ 
                SMSHistory__c smsHist = new SMSHistory__c();
                // 業務上の必要情報
                smsHist.ClientTag__c                = eventNotifications.clientTag;
                smsHist.DateTime__c                 = eventNotifications.dateTimeString;
                smsHist.MessageText__c              = eventNotifications.messageText.replaceAll('\\n', '<br>');
                smsHist.PhoneNumber__c              = eventNotifications.phoneNumber;
                smsHist.StatusId__c                 = eventNotifications.statusId;

                // 付加情報
                smsHist.EventNotifications_type__c  = eventNotifications.type;
                smsHist.MessageId__c                = eventNotifications.messageId;
                smsHist.SmsCode__c                  = eventNotifications.smsCode;
                smsHist.CarrierId__c                = eventNotifications.carrierId;
                smsHist.CarrierName__c              = eventNotifications.carrierName;
                smsHist.ClientId__c                 = eventNotifications.clientId;
                smsHist.StatusDescription__c        = eventNotifications.statusDescription;
                smsHist.Carrier__c                  = rawData.carrier;
                smsHist.Rawdata_Type__c             = rawData.type;
                smsHist.Code__c                     = data.code;
                smsHist.Submission_status__c        = data.submission_status;
                smsHist.MsgState__c                 = data.msgState;
                smsHist.Submission_err_code__c      = data.submission_err_code;
                smsHist.NtwkErr__c                  = data.ntwkErr;
                smsHist.CommandStatus__c            = data.commandStatus;
                smsHist.NetworkErrorCode__c         = data.networkErrorCode;
                smsHist.ReceivedJSON__c             = req.requestBody.toString();
                // smsHist.RecordTypeId                = Label.RTID_AosSMSSendingHistory_DLR;


                // 種別ごとに処理
                ISmsDlrHandler handler;
                // キャンペーン
                if( clientTag.formatType=='Campaign'){
                    handler = new SMSDlrCampaignMsgHandler(smsHist, clientTag.pKey, clientTag.negotiationID);
                }
                // お坊さん便施工確認
                else if(clientTag.formatType=='ObouSekouKakunin'){
                    handler = new SMSDlrSekoukakuninMsgHandler(smsHist, clientTag.pKey, clientTag.negotiationID); // TODO        
                }
                // その他(メッセージ)
                else {
                    handler = new SMSDlrMsgHandler(smsHist);
                }

                // 登録処理実行
                handler.handle();
            } else {
                system.debug('a message to be ignored received.'); 
            }

            // レスポンスの生成
            resparam.responseBody = 'success';
            resparam.statusCode = 200;
            res.responseBody = Blob.valueOf(json.serialize(resparam, true));

            system.debug('res:' + res);
            system.debug('res-body:' + res.responseBody.toString());

            return;

        } catch (Exception e) {
            // レスポンスの生成（エラー）
            resparam.responseBody = String.valueOf(e) + '\n\n' + e.getStackTraceString();
            resparam.statusCode = 500;
            res.responseBody = Blob.valueOf(json.serialize(resparam, true));

            system.debug('res:' + res);
            system.debug('res-body:' + res.responseBody.toString());
            return;
        }
    }

    

    //既存履歴及びAOSSMSステータスIDチェック  既存履歴が存在し、ステータスが２、３以外の場合は true
    private static boolean isToMessageToLog(string clientTag, string deliveryStatus){
        return !isAlreadyLogged(clientTag) && isDeliveryStatusToLog(deliveryStatus);
    }

    //既存履歴チェック
    private static boolean isAlreadyLogged(string clientTag){
        List<SMSHistory__c> aosList = [SELECT Id FROM SMSHistory__c WHERE StatusId__c IN ('2', '3')  AND ClientTag__c =: clientTag AND ClientTag__c !='' ];
        system.debug('duplicateCheck: ' + aosList.size() + ' record(s) found： StatusId=2 & ClientTag=SAME');
        return !(aosList.size() == 0);
    }

    // ----- AOS SMS 処理 -------------------
    // AOSSMS ステータスIDチェック
    private static boolean isDeliveryStatusToLog(string status){
        string deliverySuccess = '2';
        string deliveryFailed = '3';
        return (status == deliverySuccess || status == deliveryFailed);        
    }


    // クライアントタグ文字列の解析
    private static ClientTag deserializeClientTag(String clientTagStr){
        ClientTag clientTag = new ClientTag();

        List<String> clientTagList = clientTagStr.split(',');
        if(!clientTagList.isEmpty()) {
            clientTag.formatType = clientTagList[0];
            clientTag.negotiationID = clientTagList[4];
            clientTag.pKey = clientTagList[5];
        }
        return clientTag;
    }
**/
}