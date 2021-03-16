/**
* クラス名           :   Trg_Shisetsu
* クラス概要       :   施設トリガーハンドラー
* @created  :   2018/01/05
* @modified :   
*/
public class Trg_Shisetsu {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Shisetsu(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    
	public void OnBeforeInsert(List<Shisetsu__c> newOnes){
		List<Shikugun__c> theShikuguns = this.selectShikuguns(newOnes);
		new ShisetsuAutoNumberings().assingAutoNumberOnShisetsuBeforeInsert(newOnes);
		new Ctl_Shisetsu.validator().validate(newOnes,theShikuguns);
	}
	public void OnBeforeUpdate(List<Shisetsu__c> newOnes, Map<ID, Shisetsu__c> oldOnes){
		List<Shikugun__c> theShikuguns = this.selectShikuguns(newOnes);
		new Ctl_Shisetsu.validator().validate(newOnes,theShikuguns);
	}	
	public void OnAfterInsert(List<Shisetsu__c> newOnes, Map<Id, Shisetsu__c> oldOnes){
        //緯度経度を設定        
        Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Shisetsu__c.getSObjectType().getDescribe().getName(),newOnes,null);
		//new ShisetsuTransferSaijo().processing(newOnes, oldOnes);
	}
	public void OnAfterUpdate(List<Shisetsu__c> newOnes, Map<ID, Shisetsu__c> oldOnes){
        //緯度経度を設定        
        Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Shisetsu__c.getSObjectType().getDescribe().getName(),newOnes,oldOnes);
		new ShisetsuCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterUpdate(newOnes, oldOnes);
		new KasojoSogiReviSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterUpdate(newOnes);
	}  
	
	public void OnAfterDelete(Map<ID, Shisetsu__c> oldOnes){
		new ShisetsuCoreSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterDelete(oldOnes.values());
		new KasojoSogiReviSyncTasks.TaskScheduler().scheduleTasksOnShisetsuAfterDelete(oldOnes.values());
	}

	private List<Shikugun__c> selectShikuguns(List<Shisetsu__c> newOnes){
		List<Shikugun__c> theShikuguns = new List<Shikugun__c>(
			[
				select 
				Id, Name, TodoufukenNameExp__c, ShikugunMei__c
				from Shikugun__c
				where Id = :Ctl_Shisetsu.collectShikugun(newOnes)
			]
		);
		return theShikuguns;
	}

}