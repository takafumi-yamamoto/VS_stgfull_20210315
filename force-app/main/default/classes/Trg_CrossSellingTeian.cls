/**
 * クロスセル提案トリガーハンドラー
 *
 */

public with sharing class Trg_CrossSellingTeian {
    public  static boolean isActive = true;

    public static final String PHASE_KIBOUARI = 'クロスセル希望あり';
    public static final String PHASE_KENTOCHU = 'クロスセル検討中';
    
    public Trg_CrossSellingTeian() {
    }

    public void OnBeforeInsert(List<CrossSellingTeian__c> newList){
        CrossSellingTeianOpportunityCreate cs = new CrossSellingTeianOpportunityCreate();
        cs.initialProcessing(newList, null);
    }

    public void OnBeforeUpdate(List<CrossSellingTeian__c> newList, Map<ID, CrossSellingTeian__c> oldMap){
        CrossSellingTeianOpportunityCreate cs = new CrossSellingTeianOpportunityCreate();
        cs.initialProcessing(newList, oldMap);
    }

    public void OnAfterInsert(List<CrossSellingTeian__c> newList){
        System.Debug('Trg_CrossSellingTeian OnAfterInsert');
        // サービス商談を作成する対象となるInsertのデータを特定する
        List<CrossSellingTeian__c> insertListTocreateOpportunity = insertListTocreateOpportunityCreate(newList);
        // 対象となるサービス商談を作成する
		CrossSellingTeianOpportunityCreate cs = new CrossSellingTeianOpportunityCreate();
		cs.CreateServiceOpportunityFromCrossSellingTeian(insertListTocreateOpportunity);

    }

	public void OnAfterUpdate(List<CrossSellingTeian__c> newList, Map<ID, CrossSellingTeian__c> oldMap){
        System.Debug('Trg_CrossSellingTeian OnAfterUpdate');
        // サービス商談を作成する対象となるUpdateのデータを特定する
        List<CrossSellingTeian__c> updateListTocreateOpportunity = updateListTocreateOpportunityCreate(newList,oldMap);
        // 対象となるサービス商談を作成する
		CrossSellingTeianOpportunityCreate cs = new CrossSellingTeianOpportunityCreate();
		cs.CreateServiceOpportunityFromCrossSellingTeian(updateListTocreateOpportunity);
	}

    private List<CrossSellingTeian__c> insertListTocreateOpportunityCreate(List<CrossSellingTeian__c> newList){
        List<CrossSellingTeian__c> newList2 = new List<CrossSellingTeian__c>();
        for(CrossSellingTeian__c csteian:newList){
            if(chkTeianPhase(csteian)) newList2.add(csteian);
        }
        return newList2;
    }

    private List<CrossSellingTeian__c> updateListTocreateOpportunityCreate(List<CrossSellingTeian__c> newList, Map<ID, CrossSellingTeian__c> oldMap){
        List<CrossSellingTeian__c> newList2 = new List<CrossSellingTeian__c>();
        for(CrossSellingTeian__c csteian:newList){
            if((chkTeianPhase(csteian) && !chkTeianPhase(oldMap.get(csteian.Id))) || 
                (chkTeianPhase(csteian) && csteian.OpportunityRef__c != null && oldMap.get(csteian.Id).OpportunityRef__c == null )) newList2.add(csteian);
        }
        return newList2;
    }
    private Boolean chkTeianPhase(CrossSellingTeian__c csteian){
        return (PHASE_KIBOUARI.equals(csteian.TeianKekka__c) || PHASE_KENTOCHU.equals(csteian.TeianKekka__c) );
    }
}