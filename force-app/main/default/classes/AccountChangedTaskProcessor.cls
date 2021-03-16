/*
取引先が変更される場合、取引商談とケースに同期する
*/
public class AccountChangedTaskProcessor implements Queueable {

	public static Boolean isProcessing = false;
	private List<AccountChangedTask__c> taskList;
    private List<AccountChangedTask__c> accountChangedTaskList;
	private Account defaultAccount;
	private Map<ID, Account> accountIdMap;

	public AccountChangedTaskProcessor(List<AccountChangeTaskProcessReq__e> eventList){
		this.taskList = new List<AccountChangedTask__c>();
		for(AccountChangeTaskProcessReq__e event : eventList){
			this.taskList.add(new AccountChangedTask__c(Id=event.TaskId__c));
		}
	}

	public AccountChangedTaskProcessor(AccountChangedTask__c aTask){
		this.taskList = new List<AccountChangedTask__c>();
		this.taskList.add(aTask);
	}

    public void execute(QueueableContext context) {
    	this.run();
    }

    public void run(){
    	isProcessing = true;
		init(this.taskList);
    	syncStart();
    	isProcessing = false;
    }

    private void init(List<AccountChangedTask__c> taskList){
    	this.accountChangedTaskList = [
    		SELECT 
			        Opportunity__c ,    // 商談
			        Opportunity__r.TorihikiShodanRef__c,
			        Opportunity__r.CaseRef__c,
			        OldAccount__c ,    // 旧お客様・提携先
			        NewAccount__c ,    // お客様・提携先
			        NewAccount__r.Name
			 FROM AccountChangedTask__c
			 WHERE ShoriStatus__c = '未処理'
			 And Id = :taskList
			 ];
		if(this.defaultAccount == null){
			this.defaultAccount = AccountDaos.GetInstance().GetDefualtAccount();
		}
    }

	private void syncStart(){
		if(this.accountChangedTaskList.size() == 0) return;

		Savepoint sp = Database.setSavepoint();
		try {
			//取引商談の取引先を同期
			List<Opportunity> torihikiShodanList = getTorihikiShodanList();
			List<Case> caseList = getCaseList();
			List<Case> childCaseList = getChildCaseList(caseList);
			update torihikiShodanList;
			update caseList;
			update childCaseList;
			updateOppAccountChangeHistory('完了');
		}
		catch (Exception ex) {
			Database.rollback(sp);
			updateOppAccountChangeHistory('エラー');
		}
	}

    private List<Opportunity> getTorihikiShodanList(){
		//取引商談の取引先を同期
		set<opportunity> updateTorihikiShodanSet=new set<opportunity>();
		for (AccountChangedTask__c oppAccountChangeHistory : this.accountChangedTaskList){
			if(String.isBlank(oppAccountChangeHistory.Opportunity__r.TorihikiShodanRef__c)) continue;
			opportunity torihikiShodan = new opportunity();
			torihikiShodan.id = oppAccountChangeHistory.Opportunity__r.TorihikiShodanRef__c;
			torihikiShodan.Accountid = oppAccountChangeHistory.NewAccount__c;
			if(String.isBlank(oppAccountChangeHistory.NewAccount__c)){
				torihikiShodan.Accountid = this.defaultAccount.Id;
				torihikiShodan.Name = this.defaultAccount.Name + '_' + '取引商談';
			} else {
				torihikiShodan.Name = oppAccountChangeHistory.NewAccount__r.Name + '_' + '取引商談';
			}
			updateTorihikiShodanSet.add(torihikiShodan);
		}
		system.debug('***updateTorihikiShodanSet='+updateTorihikiShodanSet);
		return new List<Opportunity>(updateTorihikiShodanSet);
    }


    private List<Case> getCaseList(){

		//ケースの取引先を同期
		Set<Case> updateCaseSet=new Set<Case>();
		for (AccountChangedTask__c oppAccountChangeHistory : this.accountChangedTaskList){
			if(String.isBlank(oppAccountChangeHistory.Opportunity__r.CaseRef__c)) continue;
			case c = new case();
			c.id = oppAccountChangeHistory.Opportunity__r.CaseRef__c;
			c.Accountid = oppAccountChangeHistory.NewAccount__c;
			updateCaseSet.add(c);
		}
		return new List<Case>(updateCaseSet);
    }

    private List<Case> getChildCaseList(List<Case> parentCases){
		Map<ID, ID> caseAccountMap = new Map<Id,Id>();
		for (Case pCase: parentCases){
			caseAccountMap.put(pCase.Id, pCase.AccountId);
		}

		List<Case> childrenCases = [Select Id, ParentId FROM Case where ParentId in :parentCases];
		List<Case> updateCaseList = new List<Case>();
		for (Case cCase : childrenCases){
			case c =new case();
			c.id = cCase.Id;
			c.Accountid = caseAccountMap.get(cCase.ParentId);
			updateCaseList.add(c);
		}
		return updateCaseList;
    }

    private void updateOppAccountChangeHistory(String shoriStatus){
    	List<AccountChangedTask__c> oppAccountChangeHistoryUpdateList = new List<AccountChangedTask__c>();
		for (AccountChangedTask__c obj : this.accountChangedTaskList){
			obj.ShoriStatus__c = shoriStatus;
		}
		update this.accountChangedTaskList;
    }


}