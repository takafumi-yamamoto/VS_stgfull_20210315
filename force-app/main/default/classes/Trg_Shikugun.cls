/**
* クラス名           :   Trg_Shikugun
* クラス概要       :   市区郡トリガーハンドラー
* @created  :   2018/01/05
* @modified :   
*/
public class Trg_Shikugun {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Shikugun(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    
	public void OnAfterInsert(List<Shikugun__c> newShikugunList){
		//緯度経度を設定
        Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Shikugun__c.getSObjectType().getDescribe().getName(),newShikugunList,null);  
	}
	public void OnAfterUpdate(List<Shikugun__c> newShikugunList, Map<ID, Shikugun__c> oldShikugunMap){
		//緯度経度を設定
        Com_LatitudeAndLongitude.setLatitudeAndLongitudeMain(Shikugun__c.getSObjectType().getDescribe().getName(),newShikugunList,oldShikugunMap); 
	}              
}