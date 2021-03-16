public class OkyakusamaSeikyuMeisaiCrudPolicy {
    private static Boolean isDeleting = false;
    private static Set<Id> noPolicyDeletingEntries = new Set<Id>();

    public static void DeleteInNoPolicy(List<OkyakusamaSeikyuMeisai__c> oldOnes){
        noPolicyDeletingEntries.addAll( SobjectsExtension.collectIds(oldOnes) );
        Delete oldOnes;
        noPolicyDeletingEntries.clear();
    }

    public void validateOnBeforeUpdate(List<OkyakusamaSeikyuMeisai__c> pNewOnes, Map<Id, OkyakusamaSeikyuMeisai__c> pOldOnes){
        for(OkyakusamaSeikyuMeisai__c aNewOne : pNewOnes){
            OkyakusamaSeikyuMeisai__c aOldOne = pOldOnes.get(aNewOne.Id);
            this.validateOnBeforeUpdate(aNewOne, aOldOne);
            aNewOne.isSkipCrudPlicy__c = false;
        }
    }
    public void validateOnBeforeDelete(List<OkyakusamaSeikyuMeisai__c> pOldOnes){
        for(OkyakusamaSeikyuMeisai__c aOldOne : pOldOnes){
            if( !OkyakusamaSeikyuMeisaiCrudPolicy.noPolicyDeletingEntries.contains( aOldOne.Id ) ){
                if(aOldOne.SeikyuHouhou__c == 'gmo_credit') aOldOne.addError('削除ポリシーエラー:このデータは削除できません;');
            }
        }
    }

    private void validateOnBeforeUpdate(OkyakusamaSeikyuMeisai__c pNewOne, OkyakusamaSeikyuMeisai__c pOldOne){
        if(pNewOne.isSkipCrudPlicy__c) return;

        if(pOldOne.SeikyuHouhou__c == 'gmo_credit'){
            if(pNewOne.SeikyuHouhou__c != pOldOne.SeikyuHouhou__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.IsBetsuNoSeikyuSaki__c != pOldOne.IsBetsuNoSeikyuSaki__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.UriageKakuteiBi__c != pOldOne.UriageKakuteiBi__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.Kessaibi__c != pOldOne.Kessaibi__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.SeikyuStatus__c != pOldOne.SeikyuStatus__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.seikyusakiMail__c != pOldOne.seikyusakiMail__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.seikyusaki__c != pOldOne.seikyusaki__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.SeikyuJiTorihikiSakiRef__c != pOldOne.SeikyuJiTorihikiSakiRef__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.SeikyuBango__c != pOldOne.SeikyuBango__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.SeikyuOya__c != pOldOne.SeikyuOya__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
            if(pNewOne.SeikyuKingaku__c != pOldOne.SeikyuKingaku__c){ pNewOne.addError('更新ポリシーエラー:この変更できません;'); return; }
        }
    }

}