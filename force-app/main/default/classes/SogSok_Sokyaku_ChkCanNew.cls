public class SogSok_Sokyaku_ChkCanNew {

    public static void subscriveSogSokSokyakuBeforeInsert(List<SogSok_Sokyaku__c> pNewOnes, Map<Id, Opportunity> pOpps){

        for(SogSok_Sokyaku__c aNewOne : pNewOnes){
            Opportunity aOpp = pOpps.get(aNewOne.OpportunityRef__c);
            List<String> errorMsg = new List<String>();
            if(aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Id == null){
                errorMsg.add('決定葬儀社を入力してください');
            }
            if(aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.IsSoukyakujiFax__c && !TelNos.isTelNo(aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax) ){
                errorMsg.add('決定葬儀社のFax番号を入力してください');
            }
            if( !aOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.CanPtWebSokyakuExp__c ){
                errorMsg.add('この決定葬儀社はパートナーWebに対応していないため、パートナーWebによる送客はできません');
            }
            if( containsActiveSogSokSokyaku(aOpp.SogSok_Sokyakus__r) ){
                errorMsg.add('既に送客済みのレコードがあるため、新規に送客することはできません');
            }
            if( !containsSogiPlanShohin(aOpp.OpportunityLineItems) ){
                errorMsg.add('葬儀プラン商品を入力してください');
            }
            if( String.isBlank(aOpp.KiboShiharaiHouhou__c) ){
                errorMsg.add('希望支払方法を入力してください');
            }
            if( String.isBlank(aOpp.Account.FirstNameFurigana__pc) || String.isBlank(aOpp.Account.LastNameFurigana__pc) ){
                errorMsg.add('相談者の姓(カナ)・名(カナ)を入力してください');
            }
            if( String.isBlank(aOpp.Account.Phone) && String.isBlank(aOpp.Account.MobilePhone__c) ){
                errorMsg.add('相談者の電話番号もしくは携帯電話番号を入力してください');
            }
            if( String.isBlank(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.Id) ){
                errorMsg.add('対象者を入力してください');
            }
            if( String.isBlank(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc) || String.isBlank(aOpp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc) ){
                errorMsg.add('対象者の姓(カナ)・名(カナ)を入力してください');
            }
            if( String.isBlank(aOpp.SimpleYasugoRef__r.OmukaeSakiName__c) 
                || String.isBlank(aOpp.SimpleYasugoRef__r.OmukaeSakiStreet__c) 
                ){
                errorMsg.add('お迎え先情報（名称、住所）を入力してください');
            }
            if( String.isBlank(aOpp.SimpleYasugoRef__r.KiboGoanchisaki__c) ){
                errorMsg.add('希望安置先を入力してください');
            }
            if( (aOpp.SimpleYasugoRef__r.KiboGoanchisaki__c == '自宅' || aOpp.SimpleYasugoRef__r.KiboGoanchisaki__c == 'その他')
                && String.isBlank(aOpp.SimpleYasugoRef__r.GoanchisakiJusho__c) ){
                errorMsg.add('ご安置先住所を入力してください');
            }
            if(aOpp.KakuteibiSyodan__c == null){
                errorMsg.add('確定日を入力してください');
            }

            OpportunityLineItem chokusoPlan = containsChokusoPlan(aOpp.OpportunityLineItems);
            if(chokusoPlan != null){
                if(chokusoPlan.Product2.ShohinBango__c == 'SBG-0003001' && aOpp.KakuteibiSyodan__c >= datetime.newInstance(2020, 6, 11, 16, 00, 00)) errorMsg.add('確定日が2020/6/11 16時以降の場合は新直葬プランを設定してください');
                if(chokusoPlan.Product2.ShohinBango__c == 'SBG-0004001' && aOpp.KakuteibiSyodan__c < datetime.newInstance(2020, 6, 11, 16, 00, 00)) errorMsg.add('確定日が2020/6/11 16時以前の場合は旧直葬プランを設定してください');
            }

            for(OpportunityLineItem oppLineItem : aOpp.OpportunityLineItems){
                if(oppLineItem.Product2.HinmokuBunrui__c == '本体' && !oppLineItem.Product2.LatestFlg__c) errorMsg.add('旧プランはパートナーWebで送客できません');
            }

            if(errorMsg.size() > 0) aNewOne.addError(String.join(errorMsg, '；　'),false);
        }
    }

    private static Boolean containsActiveSogSokSokyaku(List<SogSok_Sokyaku__c> pSogSokSokyakus){
        for(SogSok_Sokyaku__c aEntry : pSogSokSokyakus){
            if(aEntry.SoukyakuStatus__c == 'wait_for_mitsumorisho') return true;
            if(aEntry.SoukyakuStatus__c == 'wait_for_seikyusho') return true;
            if(aEntry.SoukyakuStatus__c == 'seikyusho_received') return true;
        }
        return false;
    }
    private static Boolean containsSogiPlanShohin(List<OpportunityLineItem> pOppLineItems){
        for(OpportunityLineItem aEntry : pOppLineItems){
            if(aEntry.Product2.k_Service_Id_exp__c == '1' && aEntry.Product2.k_ShohinSyubetsu_Id_exp__c == '1') return true;
            if(aEntry.Product2.k_Service_Id_exp__c == '2' && aEntry.Product2.k_ShohinSyubetsu_Id_exp__c == '1') return true;
        }
        return false;
    }
    private static OpportunityLineItem containsChokusoPlan(List<OpportunityLineItem> pOppLineItems){
        for(OpportunityLineItem aEntry : pOppLineItems){
            if(aEntry.Product2.ShohinBango__c == 'SBG-0003001' ||  //【19.12】よりそうのお葬式 火葬式 直葬プラン(2020年6月9日まで)
                aEntry.Product2.ShohinBango__c == 'SBG-0004001') { //【20.06】よりそうのお葬式 火葬式 直葬プラン
                return aEntry;
            }
        }
        return null;
    }
}