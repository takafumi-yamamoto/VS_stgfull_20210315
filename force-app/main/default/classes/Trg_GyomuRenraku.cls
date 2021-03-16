public without sharing class Trg_GyomuRenraku {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_GyomuRenraku(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<GyomuRenraku__c> newList){
		new GyomuRenrakuSaishuKoshinshaSet().insertGyomuRenraku(newList);
	}

	public void OnBeforeUpdate(List<GyomuRenraku__c> newList, Map<Id, GyomuRenraku__c> oldMap){
		new GyomuRenrakuSaishuKoshinshaSet().updateGyomuRenraku(newList, oldMap);
	}
}