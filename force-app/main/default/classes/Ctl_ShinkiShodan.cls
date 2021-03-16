public class Ctl_ShinkiShodan {

    @AuraEnabled
    public static String auraCreateOpportunity(String objectId, String recordTypeDevName, String recordTypeName, String stageName) {

    	RecordType recordType = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Opportunity', recordTypeDevName);
        Opportunity selectOpportunity = new OpportunityDao().SelectById(objectId);

    	Opportunity insertOpportunity = new Opportunity();
    	insertOpportunity.Name = selectOpportunity.Account.LastName + ' ' + selectOpportunity.Account.FirstName + '_' + recordTypeName;
    	insertOpportunity.RecordTypeId = recordType.Id;
    	insertOpportunity.StageName = stageName;
    	insertOpportunity.CloseDate = selectOpportunity.CloseDate;
    	insertOpportunity.TorihikiShodanRef__c = selectOpportunity.TorihikiShodanRef__c;
    	insertOpportunity.AccountId = selectOpportunity.AccountId;
        insertOpportunity.KanrenMotoShodanRef__c = objectId;

    	try{
    		insert insertOpportunity;
    	}
    	catch(Exception e){
    		String err = 'エラーメッセージ:' + e.getMessage() + '\n' + e.getStackTraceString();
            System.debug('err:' + err);
            return err;
    	}

    	return insertOpportunity.Id;
    }
    
}