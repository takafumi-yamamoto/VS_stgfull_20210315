public class SimpleOppValidation {
    
    private static String simpleRtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

    public class KetteiValidation {
        
        public void onOppBeforeUpdate(List<Opportunity> pNewOnes, Map<Id,Opportunity> pOldOnes){

            Set<Id> oppIdSet = new Set<Id>();
            for(Opportunity aNewOne : pNewOnes){ 
                if(aNewOne.RecordTypeId != simpleRtId) continue;
                if(aNewOne.StageName == '決定' && pOldOnes.get(aNewOne.Id).StageName != '決定'){ oppIdSet.add(aNewOne.Id); }
            }
            
            if(oppIdSet.size() > 0){

                Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>();
                for(Opportunity opp : [ select Id, 
                                            KiboShiharaiHouhou__c, 
                                            SurveyDiscountAgreeStatus__c, 
                                            Account.MemberTourokuZumi__c, 
                                            SimpleYasugoRef__r.TaishoshaRef__r.MemberTourokuZumi__c, 
                                            (
                                                select Id, 
                                                        Product2.ShohinBango__c 
                                                from OpportunityLineItems
                                            )
                                        from Opportunity 
                                        where Id = :oppIdSet ]){
                    oppIdMap.put(opp.Id, opp);
                }

                for(Opportunity aNewOne : pNewOnes){
                    Opportunity tempOpp = oppIdMap.get(aNewOne.id);
                    Boolean isKaiin = tempOpp.Account.MemberTourokuZumi__c || tempOpp.SimpleYasugoRef__r.TaishoshaRef__r.MemberTourokuZumi__c;
                    
                    if(String.isBlank(aNewOne.KiboShiharaiHouhou__c)){
                        aNewOne.addError('【希望支払方法】を設定してください');
                    }
                    if(isKaiin && aNewOne.SurveyDiscountAgreeStatus__c != '同意済' && aNewOne.SurveyDiscountAgreeStatus__c != '拒否'){
                        aNewOne.addError('会員の場合は【アンケート割同意状況】結果を設定してください');
                    }
                    if(!isKaiin){
                        for(OpportunityLineItem tempOppLineItem : tempOpp.OpportunityLineItems){
                            if(tempOppLineItem.Product2.ShohinBango__c == 'SBG-0005107'){ //【20.11】よりそうお葬式 式後アンケート割
                                aNewOne.addError('非会員の場合は式後アンケート割引を設定できません');
                            }
                        }
                    }
                }
            }
        }
    }
}