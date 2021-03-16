/**
* クラス名           :   Trg_Jizenwari
* クラス概要       :   事前割トリガーハンドラー
* @created  :   2018/01/16
* @modified :   
*/
public class Trg_Jizenwari {
    // public void OnAfterInsertUpdate(List<Jizenwari__c> newJizenwariList, Map<ID, Jizenwari__c> oldJizenwariMap){
    //     new Ctl_Achievement().upsertJizenwariAchievement(newJizenwariList, oldJizenwariMap);
        
    // }
    public void onAfterUpdate(List<Jizenwari__c> newOnes, Map<ID, Jizenwari__c> oldOnes){
        Ctl_Achievement_Jizenwari.getInstance().onJizenwariAfterUpdate(newOnes,oldOnes);
    }
}