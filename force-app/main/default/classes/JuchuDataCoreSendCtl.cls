public without sharing class JuchuDataCoreSendCtl {

    @AuraEnabled
    public static List<String> sltCheckOpportunity(String recordId) {
        List<String> errMsgList = new List<String>();
        Opportunity opp = [
            select Id,
                Req_Day__c,
                CloseDate,
                KakuteibiSyodan__c,
                Utiagebi__c,
                SimpleYasugoRef__r.SeikyushojuryoDay__c,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
                SeikyuZandaka__c,
                (
                    select Id, Product2.k_Service_Id_exp__c
                    from OpportunityLineItems
                    where Product2.DataKubun__c != '3:クーポン'
                )
            from Opportunity
            where Id = :recordId];
        if(opp.KakuteibiSyodan__c == null){
            errMsgList.add('【確定日】を入力してください');
        }
        if(opp.Utiagebi__c == null){
            errMsgList.add('【売上日】を入力してください');
        }
        if(opp.SimpleYasugoRef__r.SeikyushojuryoDay__c == null){
            errMsgList.add('【請求書受領日】を入力してください');
        }
        if(opp.SeikyuZandaka__c != 0){
            errMsgList.add('【請求残高】を￥0にしてください');
        }
        if(opp.OpportunityLineItems.size() > 0){
            String serviceId = '';
            for(OpportunityLineItem oppLI : opp.OpportunityLineItems){
                if(serviceId == ''){
                    serviceId = oppLI.Product2.k_Service_Id_exp__c;
                }

                if(serviceId != oppLI.Product2.k_Service_Id_exp__c){
                    errMsgList.add('異なるサービスの商品が設定されています');
                    break;
                }
            }
        }

        if(opp.KakuteibiSyodan__c != null){
            List<TesuryoTekiyo__c> tesuryoTekiyoList = [
                select Id
                from TesuryoTekiyo__c
                where KeiyakuRef__c = :opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c
                and ShoninStatus__c = '承認済'
                and TekiyoKaishiBi__c <= :opp.KakuteibiSyodan__c.date()
                and TekiyoSyuryoBi__c >= :opp.KakuteibiSyodan__c.date()];

            if(tesuryoTekiyoList.size() == 0){
                errMsgList.add('確定日に対して、アクティブな手数料適用がありません');
            }
            if(tesuryoTekiyoList.size() > 1){
                errMsgList.add('アクティブな手数料適用が複数存在しています');
            }
        }

        return errMsgList;
    }

    @AuraEnabled
    public static String doJuchuDataCoreSend(String recordId) {

        String msg = '手数料計算処理を実行しました。少し待ってから「手数料」の値を確認してください';
        try{
            System.debug('recordId ' + recordId);
            Opportunity opp = [
                select Id,
                    IsWon,
                    ShodanBangoF__c,
                    SeikyuYoteiGakuPartnerExp__c,
                    SeikyushoHassoubiPartner__c,
                    Utiagebi__c,
                    KakuteibiSyodan__c,
                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
                    NyukinSimekiriBiPartner__c
                from Opportunity where Id = :recordId
            ];
            RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService service = new RsCoreKaikeiApi_JucyuDenpyoServices.JucyuDenpyoService();
            service.runTesuryoKeisanProc(opp);
            SimpleOptionItemTotalAmount.doSimpleOptionItemTotalAmountCalculation(opp.Id);
        }
        catch(Exception e){
            msg = 'エラーが発生しました。システム管理者へ連絡してください。' + '\r\n' + e.getMessage();
        }

        return msg;
    }
}