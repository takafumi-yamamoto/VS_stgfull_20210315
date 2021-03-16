public class ObosanbinOppUriagebiSet {

    public void onOppBeforeUpdate(List<Opportunity> newOppList, Map<ID, Opportunity> oldOppMap, Map<ID, Obosanbin__c> pObosanbins){

        for(Opportunity newOpp : newOppList){
            Opportunity oldOpp = oldOppMap.get(newOpp.Id);

            if(newOpp.RecordTypeId != RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin')) continue;
            if(newOpp.StageName == oldOpp.StageName) continue;

            if( newOpp.StageName == '除外' ||
                newOpp.StageName == '失注' ||
                newOpp.StageName == 'キャンセル' ){
                newOpp.Utiagebi__c = null;
            }
            
            if(newOpp.StageName == '施行完了' || newOpp.StageName == '施行待ち') {
                if(pObosanbins.containskey(newOpp.ObosanbinRef__c)){
                    Obosanbin__c pObousanbin = pObosanbins.get(newOpp.ObosanbinRef__c);

                    if(String.isBlank(pObousanbin.MemorialServicePlan__c )){
                        newOpp.addError('「お坊さん便-プラン」を入力してください。');
                        continue;
                    }

                    Date thePartnerIraiDate = pObousanbin.IraiTehaiDate__c; // 依頼書・手配報告書送付日
                    Date theKasoDate = pObousanbin.KasoDateTime_Inp__c == null ? null : pObousanbin.KasoDateTime_Inp__c.date(); // 火葬日
                    Date theHouyouDate = pObousanbin.KokubetsuDateTime_Inp__c == null ? null : pObousanbin.KokubetsuDateTime_Inp__c.date(); // 法要日
                    Date theKokubetsuDate = pObousanbin.KokubetsushikiNichiji__c == null ? null : pObousanbin.KokubetsushikiNichiji__c.date(); // 告別式日時
                    Date theTsuyaDate = pObousanbin.TsuyaDateTime_Inp__c == null ? null : pObousanbin.TsuyaDateTime_Inp__c.date(); // 通夜日時
                    Date theShukkanDate = pObousanbin.ShukkanDateTimei_Inp__c == null ? null : pObousanbin.ShukkanDateTimei_Inp__c.date(); // 出棺日時

                    if(HouyoPlans.isHoyoPlan(pObousanbin.MemorialServicePlan__c)){
                        if(theHouyouDate != null) newOpp.Utiagebi__c = theHouyouDate;
                        else newOpp.addError('「法要日」を入力してください。');
                        continue;
                    }
                    if(pObousanbin.MemorialServicePlan__c == '火葬式') {
                        if(theKasoDate != null) newOpp.Utiagebi__c = theKasoDate;
                        else if(theShukkanDate != null) newOpp.Utiagebi__c = theShukkanDate;
                        else newOpp.addError('「火葬日」または「出棺日時」のいずれかを入力してください。');
                        continue;
                    }
                    if(pObousanbin.MemorialServicePlan__c == '一日葬') {
                        if(theKasoDate != null) newOpp.Utiagebi__c = theKasoDate;
                        else if(theKokubetsuDate != null) newOpp.Utiagebi__c = theKokubetsuDate;
                        else newOpp.addError('「火葬日」または「告別式日時」のいずれかを入力してください。');
                        continue;
                    }
                    if(pObousanbin.MemorialServicePlan__c == '一般葬') {
                        if(theKasoDate != null) newOpp.Utiagebi__c = theKasoDate;
                        else if(theKokubetsuDate != null) newOpp.Utiagebi__c = theKokubetsuDate;
                        else if(theTsuyaDate != null) newOpp.Utiagebi__c = theTsuyaDate;
                        else newOpp.addError('「火葬日」、「告別式日時」または「通夜日時」のいずれかを入力してください。');
                        continue;
                    }
                    if(pObousanbin.MemorialServicePlan__c == '戒名・法名のみ') {
                        if(thePartnerIraiDate != null) newOpp.Utiagebi__c = thePartnerIraiDate.addDays(8);
                        else newOpp.addError('「依頼書・手配報告書送付日」を入力してください。');
                        continue;
                    }
                }
            } 
        }
    }
}