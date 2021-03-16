public class SogiShiharaitsuchisyoWaribikiKeisan {
    public class ResultSogiwaribiki {
        public Decimal kishafutan = 0;
        public Decimal yorisofutan = 0;
    }
    public ResultSogiwaribiki waribikiTotalization(String shodanId) {
        return this.mainWarbikiCalcProcess(shodanId,'shiharai');
    }

    public ResultSogiwaribiki waribikiTotalizationSeikyu(String shodanId) {
        return this.mainWarbikiCalcProcess(shodanId,'seikyu');
    }

    public ResultSogiwaribiki mainWarbikiCalcProcess(String shodanId , String mode){
        ResultSogiwaribiki ret = new ResultSogiwaribiki ();
        integer bouquetPrice = 0;
        if(mode == 'shiharai'){
            bouquetPrice = -2200;
        }else{
            bouquetPrice = 0;
        }
        // 商談IDより商談を取得
        Opportunity aOpportunity = [
             select Id,
             ShodanBango__c,
             SimpleYasugoRef__c,
             SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
             (
                 select 
                 Id,
                 HinmokuBunrui__c,
                 Product2.NameForCustomerExp__c,
                 Product2.ShohinBango__c,
                 TotalPrice,
                 Product2.k_ShohinCategory_Id_exp__c, 
                 Product2.DataKubun__c,
                 Product2.k_Coupon_Id_exp__c
                 from OpportunityLineItems
            ),(
                select 
                Name,
                ShohinKamoku__c,
                Kingaku__c
                from PatnerUriagesSyodan__r
            )
            from Opportunity
            where Id = :shodanId 
        ];
        // 登録されている商品より葬儀社・よりそう負担の切り分けを行う
        for(OpportunityLineItem aOpportunityLineItem : aOpportunity.OpportunityLineItems){
            String waribikiType = '';
			if(aOpportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'waribiki'){
                waribikiType = this.waribikihantei(aOpportunityLineItem.Product2.ShohinBango__c);
            }else if(aOpportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option-campaign'
            && aOpportunityLineItem.Product2.ShohinBango__c == 'SBG-0005420'){
                waribikiType = 'yoriso-option-bouquet';
            }
            if(waribikiType == 'yoriso'){
                ret.yorisofutan = ret.yorisofutan + aOpportunityLineItem.TotalPrice;
            }else if(waribikiType == 'yoriso-option-bouquet'){
                ret.yorisofutan = ret.yorisofutan + bouquetPrice;
            }else if(waribikiType == 'partner' && aOpportunity.PatnerUriagesSyodan__r.size() > 0){
                // その他お客様向け割引（パートナー起因） で手数料調整が入っていた場合は貴社負担として合算
                ret.kishafutan += ret.kishafutan + aOpportunityLineItem.TotalPrice;
            }else if(waribikiType == 'partner' && aOpportunity.PatnerUriagesSyodan__r.size() == 0){
                // その他お客様向け割引（パートナー起因） で手数料調整が入っていない場合はよりそう負担として合算
                ret.yorisofutan = ret.yorisofutan + aOpportunityLineItem.TotalPrice;
            }
        }
        // パートナー手数料調整も葬儀社・よりそう負担の切り分けを行う
        for(PatnerUriage__c patnerUriage : aOpportunity.PatnerUriagesSyodan__r){
            // patnerUriage.Kingaku__c
            if(patnerUriage.Kingaku__c > 0){
                // + 入力の場合
                ret.kishafutan = ret.kishafutan + patnerUriage.Kingaku__c;
            }else{
                // -入力の場合
                ret.yorisofutan = ret.yorisofutan + patnerUriage.Kingaku__c;
            }
        }

        return ret;
    }

    public String waribikihantei (String shohinbango){
        String retType = '';
        switch on shohinbango {
            when 'SBG-0003537','SBG-0003620','SBG-0003531'
            ,'SBG-0003532','SBG-0003533','SBG-0000214'
            ,'SBG-0003621','SBG-0003622' {
                retType = 'yoriso';
            }
            when 'SBG-0000246'{
                // その他お客様向け割引（パートナー起因）
                retType = 'partner';
            }
            when else{

            }
        }
        return retType;
    }

}