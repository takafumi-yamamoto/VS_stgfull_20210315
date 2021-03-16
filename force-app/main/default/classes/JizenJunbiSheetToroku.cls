public without sharing class JizenJunbiSheetToroku {
    
    public void checkJizenJunbiSheetTorokuInsert(List<Account> newAccList){
        List<Account> targetAcc = new List<Account>();
        for(Account acc : newAccList){
            if(acc.AcvmJizenJunbiMinDate__c == null && acc.JizenJizenSheetTeishutsuzumi__c) targetAcc.add(acc);
        }

        processJizenJunbiSheetToroku(targetAcc);
    }

    public void checkJizenJunbiSheetTorokuUpdate(List<Account> newAccList, Map<ID, Account> oldAccountMap){
        List<Account> targetAcc = new List<Account>();
        for(Account acc : newAccList){
            Account oAcc = oldAccountMap.get(acc.Id);
            if(acc.AcvmJizenJunbiMinDate__c == null && !oAcc.JizenJizenSheetTeishutsuzumi__c && acc.JizenJizenSheetTeishutsuzumi__c) targetAcc.add(acc);
        }

        processJizenJunbiSheetToroku(targetAcc);
    }

    private void processJizenJunbiSheetToroku(List<Account> accList){
        List<Achievement__c> insAchiList = new List<Achievement__c>();
        for(Account acc : accList){
            insAchiList.add(
                new Achievement__c(
                    TorihikiSakiRef__c = acc.Id,
                    Syubetsu__c = 'JizenJunbiWeb',
                    YukoFlag__c = true, 
                    YukoKaishiBi__c = date.today()
                )
            );
        }

        if(insAchiList.size() > 0) insert insAchiList;
    }
}