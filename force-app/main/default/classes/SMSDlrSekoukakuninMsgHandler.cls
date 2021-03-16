public class SMSDlrSekoukakuninMsgHandler implements ISmsDlrHandler {

    private String newId;
    private String negotiationID;
    private SMSHistory__c smsHist;

    public SMSDlrSekoukakuninMsgHandler(SMSHistory__c smsHist,  String newId, String negotiationID) {
        this.smsHist = smsHist;
        this.newId = newId;
        this.negotiationID = negotiationID;
    }

    public void handle() {
        // List<MonkMng__c> monks = [SELECT Id FROM MonkMng__c WHERE MonkID__c =: clientTagList[5]];

        // if(monks.size() > 0){
        //     aosHist.Monk__c = monks[0].Id;    
        // }

        // aosHist.NegotiationID__c = clientTagList[4];
        // List<Opportunity> opportunities = [SELECT Id FROM Opportunity WHERE NegotiationID__c =: aosHist.NegotiationID__c];
        // List<OppObousanbin__c> oppobou = new List<OppObousanbin__c>();
        // if(opportunities.size() > 0){
        //     aosHist.OppId__c = opportunities[0].Id;
        //     aosHist.Opportunity__c = opportunities[0].Id;

        //     Boolean toUpdateSekouJoutai = (clientTagList[6] == '1') ? true : false;
        //     Boolean soutatuStatus = ( eventNotifications.statusId =='2') ? true : false;//送達ステータス 2：成功　3:失敗

        //     if(toUpdateSekouJoutai){

        //         oppobou = [SELECT SekoComfirmStatus__c,NegotiationID__c FROM OppObousanbin__c WHERE NegotiationID__c =: aosHist.NegotiationID__c];

        //         //施行確認状態：商談と施行確認状態紐づけが存在する場合は、状態のステータスを更新 
        //         if(oppobou.size() > 0 && oppobou[0].SekoComfirmStatus__c!=null){

        //             //施行確認状態取得
        //             EnforceConfirmState__c theSekoukakuninJoutai = [SELECT id,status__c,ObousanbinNegotiationID__c FROM EnforceConfirmState__c WHERE Id =:oppobou[0].SekoComfirmStatus__c];
        //             if(soutatuStatus){
        //                 theSekoukakuninJoutai.status__c = true;
        //                 theSekoukakuninJoutai.ObousanbinNegotiationID__c =  oppobou[0].NegotiationID__c;                            
        //                 update theSekoukakuninJoutai;

        //                 //施行確認明細にクライアントタグ登録
        //                 EnforceConfirmDetail__c theSekoukakuninMeisai = [SELECT id,ClientTag__c FROM EnforceConfirmDetail__c WHERE Jotai__c=:theSekoukakuninJoutai.id];
        //                 theSekoukakuninMeisai.ClientTag__c = eventNotifications.clientTag;
        //                 update theSekoukakuninMeisai;
        //             }

        //         }else if(oppobou.size() > 0 && oppobou[0].SekoComfirmStatus__c==null){

        //             //商談に施行確認状態紐づけ無い場合は新規作成
        //             EnforceConfirmState__c theSekoukakuninJoutai = new EnforceConfirmState__c();
        //             theSekoukakuninJoutai.ObousanbinNegotiationID__c =  oppobou[0].NegotiationID__c;                             
        //             if(soutatuStatus){
        //                 theSekoukakuninJoutai.status__c = true;                                    
        //             }else{
        //                 theSekoukakuninJoutai.status__c = false;                                    
        //             }
        //             insert theSekoukakuninJoutai;

        //             //商談　施行確認状態紐づけ更新
        //             oppobou[0].SekoComfirmStatus__c = theSekoukakuninJoutai.id;
        //             update oppobou[0];

        //             //施行確認明細作成
        //             EnforceConfirmDetail__c enf = new EnforceConfirmDetail__c(
        //                 ConfirmPersonName__c    = UserInfo.getName(),
        //                 ConfirmDatetime__c      = Datetime.now(),
        //                 ConfirmMethod__c        = methodStr_sms,
        //                 ClientTag__c            = eventNotifications.clientTag,
        //                 Jotai__c                = oppobou[0].SekoComfirmStatus__c
        //             );

        //             insert enf;

        //         }                            
        //     }
        // }                    

        // aosHistoriesToBeInserted.add(aosHist);
    }
}