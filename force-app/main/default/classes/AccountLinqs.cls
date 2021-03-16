public class AccountLinqs{
    public static Map<Id,Account> ListToMapById(List<Account> pAccounts){
        Map<Id,Account> theMap = new Map<Id,Account>();
        for(Account aAccount : pAccounts){
            theMap.put(aAccount.Id, aAccount);
        }
        return theMap;
    }
}