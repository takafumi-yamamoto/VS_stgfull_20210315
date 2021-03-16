public class Ctl_Affiliate {
	public void onCaseAfterInsert(List<Case> caseList){
        List<Case> childrenCases = this.getChildrenCases(caseList);
        if(childrenCases != null && childrenCases.size() > 0){
        	update childrenCases;
        } 
	}

	private List<Case> getChildrenCases(List<Case> caseList){
		Map<String, Id> parentMap = this.getParentCasesMap(caseList);
		Set<String> parent_mailshori_list = parentMap.keySet();

		List<Case> childrenCases = [
			Select Id,parent_mailshori_id__c From Case 
			Where ParentId = null
			and parent_mailshori_id__c in :parent_mailshori_list
		];

		for(Case aCase : childrenCases){
			aCase.ParentId = parentMap.get(aCase.parent_mailshori_id__c);
		}

		return childrenCases;
	}
    
	private Map<String, Id> getParentCasesMap(List<Case> caseList){
		Map<String, Id> parentMap = new Map<String, Id>();
		for(Case aCase : caseList){
			if(String.isNotBlank(aCase.uniq_id__c)){
				parentMap.put(aCase.uniq_id__c, aCase.Id);
			}
		}
		return parentMap;
	}
}