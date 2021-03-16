public class OppLineItemChecker {

    @AuraEnabled
    public static String getOldProductSize(String recordId) {

        String Strreturn = '';

        List<OpportunityLineItem> ListOppItem = new List<OpportunityLineItem>();
        ListOppItem = [Select id From OpportunityLineItem WHERE OpportunityId = :recordId AND Product2.LatestFlg__c = False ];
        if(ListOppItem.size() > 0){
            Strreturn = '注：旧商品が存在しています';
        }

        Opportunity opp = new Opportunity();
        opp = [SELECT Id,AccountId,SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c FROM Opportunity WHERE Id = :recordId limit 1];

        Date hanteibi = Date.today();
        String StrAccId = '';
        StrAccId = opp.AccountId;
        List<Achievement__c> ListAchieve = new List<Achievement__c>();
        String StrcampaignM = '決定葬儀社がキャンペーン対応不可のため、\r\n　　 「特別割引-2,200円」を登録する必要があります。';

        if(String.isNotBlank(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c)){
            if(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c == '対応不可'){
                if(String.isNotBlank(StrAccId)){
                    ListAchieve = [SELECT Id, 
                                          TorihikiSakiRef__c, 
                                          Syubetsu__c, 
                                          YukoKaishiBi__c, 
                                          YukoShuryoBi__c 
                                   FROM Achievement__c 
                                   WHERE TorihikiSakiRef__c = :StrAccId 
                                   AND Syubetsu__c = 'campaign_sougi_bouquet' 
                                   AND YukoKaishiBi__c <= :hanteibi
                                   AND YukoShuryoBi__c >= :hanteibi];
                    if(ListAchieve.size() > 0){
                        if(String.isNotBlank(Strreturn)){
                            Strreturn = Strreturn + ' \r\n　　　' + StrcampaignM;
                        }else{
                            Strreturn = StrcampaignM;
                        }
                    }
                }
            }
        }
        return Strreturn;
    }
}