public class  SogiSmsFollowEffectMeasurement {

    public void OnAccountAfterUpdate(List<Account> pNewOnes, Map<ID, Account> pOldOnes){
        List<Id> theTargetAccountIds = new List<Id>();
        for(Account aNewOne : pNewOnes){
            Account aOldOne = pOldOnes.get(aNewOne.Id);
            if(this.isSogiSmsChangedOnAccount(aNewOne,aOldOne)){
                theTargetAccountIds.add(aNewOne.Id);
            }
        }
        if(theTargetAccountIds.size() == 0){
            return;
        } 
        // SMS配信メンバーに存在するか確認
        List<TelSogiFollowSMSDeliveryMember__c> deliveryhistory =[
            SELECT Id, Name,AccountID__c ,Tel_SendSogiSmsPhase__c,Tel_SendSogiSmsYorisoMemberDay__c,Tel_SendSogiSmsDatetime__c
            FROM TelSogiFollowSMSDeliveryMember__c 
            WHERE AccountID__c  in :theTargetAccountIds
            AND Tel_SendSogiSmsStatus__c = '送信OK'
            ORDER BY AccountID__c ,Tel_SendSogiSmsDatetime__c DESC
        ];
        // 存在したら更新対象取得
        Map<String, TelSogiFollowSMSDeliveryMember__c> latestRecord = new Map<String, TelSogiFollowSMSDeliveryMember__c>();
        for(TelSogiFollowSMSDeliveryMember__c row :deliveryhistory){
            if(latestRecord.get(row.AccountID__c) != null){
                // SMS配信日が最新日付かチェック
                TelSogiFollowSMSDeliveryMember__c checkData = latestRecord.get(row.AccountID__c);
                Date latestDate = checkData.Tel_SendSogiSmsDatetime__c.date();
                Date checkDate = row.Tel_SendSogiSmsDatetime__c.date();
                Integer daysdue = latestDate.daysBetween(checkDate);
                if(daysdue > 0){
                    latestRecord.put(row.AccountID__c , row);
                }
            }else{
                latestRecord.put(row.AccountID__c , row);
            }
        }
        List<TelSogiFollowSMSDeliveryMember__c> updateSMSDeliveryData = new List<TelSogiFollowSMSDeliveryMember__c>();
        for(String latestKey :latestRecord.keySet() ){
            TelSogiFollowSMSDeliveryMember__c latestSMSDeliveryData = latestRecord.get(latestKey);
            latestSMSDeliveryData.Tel_SendSogiSmsYorisoMemberDay__c = Date.today();
            updateSMSDeliveryData.add(latestSMSDeliveryData);
        }
        if(updateSMSDeliveryData.size() > 0){
            update updateSMSDeliveryData;
        }
    }

    private Boolean isSogiSmsChangedOnAccount(Account pNewOne, Account pOldOne){
		if(pNewOne.MemberTourokuZumi__c != pOldOne.MemberTourokuZumi__c ){
            return true;
        }
        //JizenJizenSheetTeishutsuzumi__c
        if(pNewOne.JizenJizenSheetTeishutsuzumi__c!= pOldOne.JizenJizenSheetTeishutsuzumi__c){
            return true;
        }
		return false;
	}
}