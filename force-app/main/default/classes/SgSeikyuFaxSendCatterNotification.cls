public class SgSeikyuFaxSendCatterNotification {

    private String catterNotificationId;
    private String getCatterNotificationId(){
        if(catterNotificationId == null){
            catterNotificationId = [select Id from CollaborationGroup where Name = 'パートナーWeb 請求書受領'].Id;
        }
        return catterNotificationId;
    }

    public void sgSeikyuFaxSendReqCatterNotification(List<PartnerSeikyuSendHistory__c> newList) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        for(PartnerSeikyuSendHistory__c aPartnerSeikyuSendHistory : newList){
            if(aPartnerSeikyuSendHistory.SendRequestStatus__c == '送信依頼NG'){
                //メンション先
                mentionSegmentInput.id = getCatterNotificationId();
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                //本文
                String textBody = '\r\n請求書FAX送信依頼に失敗しました。\r\n';
                textBody += URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/PartnerSeikyuSendHistory__c/' + aPartnerSeikyuSendHistory.Id + '/view?0.source=alohaHeader';
                textBody += '\r\nシステム管理者へ通知されました。\r\n';

                textSegmentInput.text = textBody;
                messageBodyInput.messageSegments.add(textSegmentInput);
                feedItemInput.body = messageBodyInput;
                //投稿先
                feedItemInput.subjectId = mentionSegmentInput.id;
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210302-1444-01', '葬儀請求書FAX送信依頼NG')
                    .putAttr('PartnerSeikyuSendHistory__c.Id', aPartnerSeikyuSendHistory.Id)
                );
            }
        }
    }

    public void sgSeikyuFaxSendRsltCatterNotification(List<PartnerSeikyuSendHistory__c> newList) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        for(PartnerSeikyuSendHistory__c aPartnerSeikyuSendHistory : newList){
            if(aPartnerSeikyuSendHistory.SendResultStatus__c == '送信NG'){
                //メンション先
                mentionSegmentInput.id = getCatterNotificationId();
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                //本文
                String textBody = '\r\n請求書FAX送信に失敗しました。\r\n';
                textBody += URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/PartnerSeikyuSendHistory__c/' + aPartnerSeikyuSendHistory.Id + '/view?0.source=alohaHeader';
                textBody += '\r\nシステム管理者へ通知されました。\r\n';

                textSegmentInput.text = textBody;
                messageBodyInput.messageSegments.add(textSegmentInput);
                feedItemInput.body = messageBodyInput;
                //投稿先
                feedItemInput.subjectId = mentionSegmentInput.id;
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20210302-1444-02', '葬儀請求書FAX送信NG')
                    .putAttr('PartnerSeikyuSendHistory__c.Id', aPartnerSeikyuSendHistory.Id)
                );
            }
        }
    }
}