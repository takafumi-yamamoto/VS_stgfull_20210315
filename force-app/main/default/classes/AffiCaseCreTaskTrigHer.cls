public class AffiCaseCreTaskTrigHer {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public AffiCaseCreTaskTrigHer(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }    

    public void OnAfterInsert(List<AffiCaseCreTask__c> pNewOnes){
        AffiCaseCre.subscriveOnAffiCaseCreTaskAfterInserted(pNewOnes);
    }

    public void OnAfterUpdate(List<AffiCaseCreTask__c> pNewOnes, Map<ID, AffiCaseCreTask__c> pOldOnes){
        AffiCaseCre.subscriveOnAffiCaseCreTaskAfterUpdated(pNewOnes, pOldOnes);
    }  
}