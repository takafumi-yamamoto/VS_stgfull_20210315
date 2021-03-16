public class TeikeiProc {

    public void onLeadAfterUpdated(List<Lead> pNewOnes, Map<Id, Lead> pOldOnes, Map<Id, Account> pAccounts){

        List<TeikeiProcess__c> theTeikeiProcesses = new List<TeikeiProcess__c>();
        Id theSoryoAccountRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount');
        Id theTeikeisaki_SoryoLeadRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Lead','Teikeisaki_Soryo');
        for(Lead aNewOne : pNewOnes){
            Lead aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.IsConverted == aOldOne.IsConverted ) continue;
            if(!aNewOne.IsConverted ) continue;
            if(aNewOne.ConvertedAccountId == null ) continue;
            if(
                !(
                    pAccounts.get(aNewOne.ConvertedAccountId).recordTypeId == theSoryoAccountRecordTypeId
                    ||
                    aNewOne.recordTypeId == theTeikeisaki_SoryoLeadRecordTypeId
                )
            ){ continue; }

            theTeikeiProcesses.add( new TeikeiProcess__c(AccountRef__c = pAccounts.get(aNewOne.ConvertedAccountId).Id) );
        }
        Insert theTeikeiProcesses;
    }
}