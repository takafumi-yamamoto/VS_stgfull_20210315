public class AccDml {
    
    public static void updates(List<Account> pAccounts, Boolean pDuplicateRuleHeader_allowSave){

        Database.DMLOptions theDmlOption = new Database.DMLOptions(); 
        theDmlOption.DuplicateRuleHeader.AllowSave = pDuplicateRuleHeader_allowSave;

        List<Database.SaveResult> theSaveResults = Database.UPDATE(pAccounts, theDmlOption);

        Boolean isError = false;
        for(Database.SaveResult aSaveResult : theSaveResults){
            if( !aSaveResult.isSuccess() ) isError = true;
        }

        if(isError){
            throw new AccDmlException(
                JSON.serializePretty(theSaveResults)
            );
        }
    }

    public class AccDmlException extends Exception{}
}