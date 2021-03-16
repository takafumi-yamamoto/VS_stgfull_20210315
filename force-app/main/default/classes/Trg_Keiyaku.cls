public class Trg_Keiyaku 
{   
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_Keiyaku(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Keiyaku__c> newList){ 
        KeiyakuSimplValidation.onKeiyakuSimplUpsert(newList);
    }

    public void OnBeforeUpdate(List<Keiyaku__c> newList, Map<ID, Keiyaku__c> oldMap){ 
        KeiyakuSimplValidation.onKeiyakuSimplUpsert(newList);
        KeiriKeiyakuJokyoCheck.OnBeforeUpdate(newList);
        this.get_KrYsLockKeiyaku_IKeiyakuLocker_instance().on_keiyaku_before_update(newList, oldMap);
    }
    public void OnBeforeDelete(List<Keiyaku__c> pOldOnes){
        new OboStSynVer().OnPartnerKeiyakuBeforeDelete(pOldOnes);
    }

    public void OnAfterInsert(List<Keiyaku__c> pNewOnes){     
        new OboStSynVer().OnPartnerKeiyakuAfterInsert(pNewOnes);
    }

    public void OnAfterUpdate(List<Keiyaku__c> newList, Map<ID, Keiyaku__c> oldMap){     
        new OboStSynVer().OnPartnerKeiyakuAfterUpdate(newList, oldMap);
    }

    @TestVisible private static KrYsLockKeiyaku.IKeiyakuLocker m_KrYsLockKeiyaku_IKeiyakuLocker_instance;
    private KrYsLockKeiyaku.IKeiyakuLocker get_KrYsLockKeiyaku_IKeiyakuLocker_instance(){
        if( m_KrYsLockKeiyaku_IKeiyakuLocker_instance == null ){ 
            m_KrYsLockKeiyaku_IKeiyakuLocker_instance = KrYsLockKeiyaku.get_IKeiyakuLocker_instance();
        }
        return m_KrYsLockKeiyaku_IKeiyakuLocker_instance;
    }
}