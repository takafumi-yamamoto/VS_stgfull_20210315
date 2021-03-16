public class ToribunRitsu {

    public void OnBeforeUpdate(List<Obosanbin__c> newList, Map<Id, Obosanbin__c> oldMap){
        List<Obosanbin__c> oboToProcess = new List<Obosanbin__c>();
        for(Obosanbin__c aNewOne : newList){
            Obosanbin__c aOldOne = oldMap.get(aNewOne.Id);
            Boolean isToBeProcessed = false;
            if(aNewOne.Sogisha__c != aOldOne.Sogisha__c) isToBeProcessed = true;
            if(aNewOne.TeiHehOfuseKingaku__c != aOldOne.TeiHehOfuseKingaku__c) isToBeProcessed = true;
            if(isToBeProcessed) {
                oboToProcess.add(aNewOne);
            }
        }
        this.setToribunRitsu(oboToProcess);
    }

    /**
    opp-->obo-->葬儀社
                  |<--契約 <--定額手配代行課金
    **/
    private void setToribunRitsu(List<Obosanbin__c> newList){
        if(newList.size() <= 0) return;


        Set<String> sogishaIds = new Set<String>();
        for(Obosanbin__c obo: newList) {
            if(String.isNotBlank(obo.Sogisha__c)) sogishaIds.add(obo.Sogisha__c);
        }

        Map<String, Opportunity> oppByOboIdMap = new Map<String, Opportunity>();
        for(Opportunity opp : [SELECT Id, Req_Day__c, ObosanbinRef__c FROM Opportunity WHERE ObosanbinRef__c =: newList]) {
            oppByOboIdMap.put(opp.ObosanbinRef__c, opp);
        }

        Map<String, Keiyaku__c> keiyakuBySougishaIdMap = new Map<String, Keiyaku__c>();
        String souryoTehaiDaikoRt = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SouryoTehaiDaiko').getRecordTypeId();
        for(Keiyaku__c keiyaku :
            [
                SELECT Id, Teikeisaki__c,
                (
                    SELECT Id,
                    BeginDate__c, EndDate__c,
                    SogishaTesuryoToribunRitsu__c, Kingaku__c,
                    KeiyakuRef__c, RyokinPlan__c
                    FROM TeiHehDaiKakinSchEnts__r
                    ORDER BY BeginDate__c desc
                )
                FROM Keiyaku__c
                WHERE Teikeisaki__c =: sogishaIds
                AND KeiyakuJokyo__c = '契約中'
                AND RecordTypeId = :souryoTehaiDaikoRt
            ])
        {
            keiyakuBySougishaIdMap.put(keiyaku.Teikeisaki__c, keiyaku);
        }

        for(Obosanbin__c obo: newList) {
            Opportunity opp = oppByOboIdMap.get(obo.Id);
            Keiyaku__c keiyaku = keiyakuBySougishaIdMap.get(obo.Sogisha__c);
            TeiHehDaiKakinSchEnt__c theTeiHehDaiKakinSchEnt = null;
            if(keiyaku != null) {
                for(TeiHehDaiKakinSchEnt__c teiHehDaiKakinSchEnt : keiyaku.TeiHehDaiKakinSchEnts__r) {
                    if(teiHehDaiKakinSchEnt.BeginDate__c != null && teiHehDaiKakinSchEnt.BeginDate__c <= opp.Req_Day__c){
                        theTeiHehDaiKakinSchEnt = teiHehDaiKakinSchEnt;
                        break;
                    }
                }
            }

            obo.TeiHehTesuryoRateSogisha__c = null;
            obo.TeiHehTesuryoRateSoryo__c = null;
            obo.TeiHehTesuryoSoryo__c = null;
            obo.TeiHehTesuryoSogisha__c = null;

            Boolean isCanCalc = true;
            if (theTeiHehDaiKakinSchEnt == null || theTeiHehDaiKakinSchEnt.SogishaTesuryoToribunRitsu__c == null) isCanCalc = false;
            if (obo.TeiHehOfuseKingaku__c == null) isCanCalc = false;

            if(isCanCalc){
                obo.TeiHehTesuryoRateSogisha__c = theTeiHehDaiKakinSchEnt.SogishaTesuryoToribunRitsu__c;
                obo.TeiHehTesuryoRateSoryo__c = 100 - theTeiHehDaiKakinSchEnt.SogishaTesuryoToribunRitsu__c;
                
                Decimal theToribun_Soryo = obo.TeiHehOfuseKingaku__c * obo.TeiHehTesuryoRateSoryo__c * 0.01;
                Decimal theMinimum_Toribun_Soryo = 20000;
                if(theToribun_Soryo <= theMinimum_Toribun_Soryo) theToribun_Soryo = theMinimum_Toribun_Soryo;
                if(theToribun_Soryo >= obo.TeiHehOfuseKingaku__c) theToribun_Soryo = obo.TeiHehOfuseKingaku__c;
                
                obo.TeiHehTesuryoSoryo__c = theToribun_Soryo;
                obo.TeiHehTesuryoSogisha__c = obo.TeiHehOfuseKingaku__c - obo.TeiHehTesuryoSoryo__c;
            }
        }

    }

}