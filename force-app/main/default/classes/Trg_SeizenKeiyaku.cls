/**
* クラス名           :   Trg_SeizenKeiyaku
* クラス概要       :   生前契約トリガーハンドラー
* @created  :   2018/01/16
* @modified :   
*/
public class Trg_SeizenKeiyaku {
    public void OnAfterInsertUpdate(List<SeizenKeiyaku__c> newSeizenKeiyakuList, Map<ID, SeizenKeiyaku__c> oldSeizenKeiyakuMap){
        new Ctl_Achievement().upsertSeizenKeiyakuAchievement(newSeizenKeiyakuList, oldSeizenKeiyakuMap);
        
    }

    public void OnAfterUpdate(List<SeizenKeiyaku__c> newOnes, Map<ID, SeizenKeiyaku__c> oldOnes){
        Ctl_Achievement_SeizenKeiyaku.getInstance().onSeizenKeiyakuAfterUpdate(newOnes,oldOnes);
    }
}