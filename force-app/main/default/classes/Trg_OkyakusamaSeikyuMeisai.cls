public class Trg_OkyakusamaSeikyuMeisai {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_OkyakusamaSeikyuMeisai(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<OkyakusamaSeikyuMeisai__c> newList){
        new LocAfTesuryoSeikyuLineCalc().OnBeforeInsert(newList);
        new Ctl_OkyakusamaSeikyuMeisai().initialProcessing(newList, null);
        KeirSimeLocks.onOkyakusamaSeikyuMeisaiBeforeInsert(newList);
    }

    public void OnBeforeUpdate(List<OkyakusamaSeikyuMeisai__c> newList, Map<ID, OkyakusamaSeikyuMeisai__c> oldMap){
        new LocAfTesuryoSeikyuLineCalc().OnBeforeUpdate(newList, oldMap);
        new OkyakusamaSeikyuMeisaiCrudPolicy().validateOnBeforeUpdate(newList,oldMap );
        new Ctl_OkyakusamaSeikyuMeisai().initialProcessing(newList, oldMap);
        KeirSimeLocks.onOkyakusamaSeikyuMeisaiBeforeUpdate(newList, oldMap);
    }

    public void OnBeforeDelete(List<OkyakusamaSeikyuMeisai__c> oldOnes){
        new LocAfTesuryoSeikyuLineCalc().OnBeforeDelete(oldOnes);
        new OkyakusamaSeikyuMeisaiCrudPolicy().validateOnBeforeDelete(oldOnes);
        KeirSimeLocks.onOkyakusamaSeikyuMeisaiBeforeDelete(oldOnes);
    }

    public void OnAfterInsert(List<OkyakusamaSeikyuMeisai__c> newList){
        Ctl_OkyakusamaSeikyuMeisai ctl_OkyakusamaSeikyuMeisai = new Ctl_OkyakusamaSeikyuMeisai();
        // コンビニ伝票の場合は請求番号を設定する
        ctl_OkyakusamaSeikyuMeisai.putSeikyuBango(newList);
        // 支払通知書出力用にいくつかの項目に値を設定する
        ctl_OkyakusamaSeikyuMeisai.setShiharaiKanrenJoho(newList);
        // 商談の確定日を更新する
        updateOpportunity(insertListToUpdateOpportunity(newList));
        // クロスセル提案元の商談に紐づくクロスセル提案を更新する
        updateCrossSellTeian(insertListToUpdateOpportunity(newList));

    }

    public void OnAfterUpdate(List<OkyakusamaSeikyuMeisai__c> newList, Map<ID, OkyakusamaSeikyuMeisai__c> oldMap){
        // 支払通知書出力用にいくつかの項目に値を設定する
        new Ctl_OkyakusamaSeikyuMeisai().setShiharaiKanrenJoho(newList);
        // 商談の確定日を更新する
        updateOpportunity(updateListToUpdateOpportunity(newList,oldMap));
        // クロスセル提案元の商談に紐づくクロスセル提案を更新する
        updateCrossSellTeian(updateListToUpdateOpportunity(newList,oldMap));
    }

    public void OnAfterDelete(List<OkyakusamaSeikyuMeisai__c> oldList){
        // 支払通知書出力用にいくつかの項目に値を設定する
        new Ctl_OkyakusamaSeikyuMeisai().setShiharaiKanrenJoho(oldList);
    }

    private void updateOpportunity(Map<Id,OkyakusamaSeikyuMeisai__c> newMap){
        //お客様請求明細を取得し直す
        //対象となるレコードタイプを設定する
        List<Id> targetRecordTypeIdList = new List<Id>{
            Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId()
            ,Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KakuyasuButsudan').getRecordTypeId()
            ,Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId()
        };
        List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiList = [
                                                                        SELECT
                                                                            Id
                                                                            ,OpportunityRef__c
                                                                            ,Kessaibi__c
                                                                        FROM OkyakusamaSeikyuMeisai__c
                                                                        WHERE Id in:newMap.keyset()
                                                                        AND OpportunityRef__r.RecordTypeId in :targetRecordTypeIdList
                                                                        ORDER BY Kessaibi__c ASC
        ];

        //商談を更新する
        Map<Id,Opportunity> updateOpportunityMap = new Map<Id,Opportunity>();
        for(OkyakusamaSeikyuMeisai__c okyakusamaseikyuMeisai:okyakusamaSeikyuMeisaiList){
            Opportunity opportunity = updateOpportunityMap.get(okyakusamaseikyuMeisai.OpportunityRef__c);
            if(opportunity==null) opportunity = new Opportunity(Id = okyakusamaseikyuMeisai.OpportunityRef__c);
            opportunity.KakuteibiSyodan__c = datetime.newInstance(okyakusamaSeikyuMeisai.Kessaibi__c.year(), okyakusamaSeikyuMeisai.Kessaibi__c.month(), okyakusamaSeikyuMeisai.Kessaibi__c.day());
            updateOpportunityMap.put(opportunity.Id,opportunity);
        }
        if(updateOpportunityMap.size() > 0) update updateOpportunityMap.values();
    }

    private void updateCrossSellTeian(Map<Id,OkyakusamaSeikyuMeisai__c> newMap){
        //お客様請求明細を取得し直す
        List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiList = [
                                                                        SELECT
                                                                            Id
                                                                            ,OpportunityRef__c
                                                                            ,Kessaibi__c
                                                                        FROM OkyakusamaSeikyuMeisai__c
                                                                        WHERE Id in:newMap.keyset()
                                                                        ORDER BY Kessaibi__c ASC
        ];
        Set<Id> sakiOpportunityIdSet = new Set<Id>();
        Map<Id,OkyakusamaSeikyuMeisai__c> okyakusamaMapByOpportunity = new Map<Id,OkyakusamaSeikyuMeisai__c>();
        for(OkyakusamaSeikyuMeisai__c okyakusamaseikyumeisai:okyakusamaSeikyuMeisaiList){
            sakiOpportunityIdSet.add(okyakusamaseikyumeisai.OpportunityRef__c);
            okyakusamaMapByOpportunity.put(okyakusamaseikyumeisai.OpportunityRef__c,okyakusamaseikyumeisai);
        }
        //クロスセル提案を取得する
        Map<Id,CrossSellingTeian__c> crossSellingTeianMap = new Map<Id,CrossSellingTeian__c>([
            SELECT
                Id
                ,CrossSellingSakiOpportunityRef__c
            FROM CrossSellingTeian__c
            WHERE CrossSellingSakiOpportunityRef__c in :sakiOpportunityIdSet //クロスセル提案先で検索する
        ]);
        //クロスセル提案を更新する
        List<CrossSellingTeian__c> updateCrossSellingTeianList = new List<CrossSellingTeian__c>();
        for(CrossSellingTeian__c crossSellTeian:crossSellingTeianMap.values()){
            OkyakusamaSeikyuMeisai__c okyakusamameisai = okyakusamaMapByOpportunity.get(crossSellTeian.CrossSellingSakiOpportunityRef__c);
            crossSellTeian.Juchubi__c = okyakusamameisai.Kessaibi__c;
            updateCrossSellingTeianList.add(crossSellTeian);
        }

        if(updateCrossSellingTeianList.size() > 0) update updateCrossSellingTeianList;
    }

    private Map<Id,OkyakusamaSeikyuMeisai__c> insertListToUpdateOpportunity(List<OkyakusamaSeikyuMeisai__c> newList){
        Map<Id,OkyakusamaSeikyuMeisai__c> newMap = new Map<Id,OkyakusamaSeikyuMeisai__c>();
        for(OkyakusamaSeikyuMeisai__c okyakusamaSeikyumeisai:newList){
            if(chkKessaibi(okyakusamaSeikyumeisai)) newMap.put(okyakusamaSeikyumeisai.Id,okyakusamaSeikyumeisai);
        }
        return newMap;
    }
    private Map<Id,OkyakusamaSeikyuMeisai__c> updateListToUpdateOpportunity(List<OkyakusamaSeikyuMeisai__c> newList, Map<ID, OkyakusamaSeikyuMeisai__c> oldMap){
        Map<Id,OkyakusamaSeikyuMeisai__c> newMap = new Map<Id,OkyakusamaSeikyuMeisai__c>();
        for(OkyakusamaSeikyuMeisai__c okyakusamaSeikyumeisai:newList){
            OkyakusamaSeikyuMeisai__c oldOkyakusamaSeikyumeisai = oldMap.get(okyakusamaSeikyumeisai.Id);
            if(chkKessaibiForUpdate(okyakusamaSeikyumeisai,oldOkyakusamaSeikyumeisai)) newMap.put(okyakusamaSeikyumeisai.Id,okyakusamaSeikyumeisai);
        }
        return newMap;
    }
    private Boolean chkKessaibi(OkyakusamaSeikyuMeisai__c okyakusamameisai){
        return (okyakusamameisai.Kessaibi__c!=null);
    }
    private Boolean chkKessaibiForUpdate(OkyakusamaSeikyuMeisai__c okyakusamameisai,OkyakusamaSeikyuMeisai__c oldokyakusamaMeisai){
        return (okyakusamameisai.Kessaibi__c!=oldokyakusamaMeisai.Kessaibi__c);
    }
}