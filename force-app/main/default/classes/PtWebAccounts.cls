public class PtWebAccounts {

    public static void subscriveOnAccountAfterDeleted(List<Account> pOldOnes){
        for(Account aAccount : pOldOnes  ){
            if(aAccount.PtWebAccountRef__c != null) aAccount.addError('PartnerWebアカウントのある取引先は削除できません。;');
        }
    }
}