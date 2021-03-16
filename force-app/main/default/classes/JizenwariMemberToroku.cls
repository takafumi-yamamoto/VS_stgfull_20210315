public without sharing class JizenwariMemberToroku {

    public void checkJizenwariMemberTorokuInsert(List<Account> newAccList){
        List<Account> targetAcc = new List<Account>();
        for(Account acc : newAccList){
            // issues4156 --Start--
            // if(acc.AcvmJizenWariMinDate__c ==null && acc.MemberTourokuZumi__c) targetAcc.add(acc);
            if(acc.AcvmOsoushikiYoyakuMinDate__c ==null && acc.AcvmJizenWariMinDate__c ==null && acc.AcvmYorisokaiinYoyakuMinDate__c ==null && acc.MemberTourokuZumi__c) targetAcc.add(acc);
            // issues4156 --end--
        }

        processJizenJunbiSheetToroku(targetAcc);
    }

    public void checkJizenwariMemberTorokuUpdate(List<Account> newAccList, Map<ID, Account> oldAccountMap){
        List<Account> targetAcc = new List<Account>();
        for(Account acc : newAccList){
            Account oAcc = oldAccountMap.get(acc.Id);
            // issues4156 --Start--
            // if(acc.AcvmJizenWariMinDate__c ==null && !oAcc.MemberTourokuZumi__c && acc.MemberTourokuZumi__c) targetAcc.add(acc);
            if(acc.AcvmOsoushikiYoyakuMinDate__c ==null && acc.AcvmJizenWariMinDate__c ==null && acc.AcvmYorisokaiinYoyakuMinDate__c ==null && !oAcc.MemberTourokuZumi__c && acc.MemberTourokuZumi__c) targetAcc.add(acc);
            // issues4156 --end--
        }

        processJizenJunbiSheetToroku(targetAcc);
    }

    private void processJizenJunbiSheetToroku(List<Account> accList){
        List<Achievement__c> insAchiList = new List<Achievement__c>();

        Date kisanbi = date.today();
        // 2019/12/27以降は不要になる処理 start
        if(kisanbi < date.newInstance(2019, 12, 27)){
            kisanbi = date.newInstance(2019, 12, 27);
        }
        // 2019/12/27以降は不要になる処理 end
        
        for(Account acc : accList){
            insAchiList.add(
                new Achievement__c(
                    TorihikiSakiRef__c = acc.Id,
                    Syubetsu__c = 'YorisoJizenWari',
                    YukoFlag__c = true, 
                    JizenwariMemberKisanbi__c = kisanbi
                )
            );
        }

        insert insAchiList;
    }
}