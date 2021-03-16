public class Ctl_KanrenSyodan {

	static public List<Opportunity> targetOpportunities {get;set;}

    public Ctl_KanrenSyodan() { 
    }

    /** 永代供養 */
    @AuraEnabled
    static public List<Opportunity> getOpportunities(String serviceId){

        List<EitaiKuyo__c> targetEitaiKuyos = [SELECT Id,OpportunityRef__c,SodanshaRef__c FROM EitaiKuyo__c WHERE Id = :serviceId];

        Set<Id> accountIds = new Set<Id>();
        for(EitaiKuyo__c anEitaiKuyo : targetEitaiKuyos){
        	accountIds.add(anEitaiKuyo.SodanshaRef__c);
        }

 		return selectParentAndChildrenOpportunities(accountIds);
    }






    static public List<Opportunity> selectParentAndChildrenOpportunities(Set<Id> accountIds){

        List<Opportunity> targetOpportunities = [SELECT Id,
        												RecordType.Name,
        												Name,
        												TorihikiShodanRef__c,
        												StageName,
        												Account.Name,
        												CloseDate,
        												(
        													SELECT
        														Id,
		        												RecordType.Name,
		        												Name,
		        												TorihikiShodanRef__c,
		        												StageName,
		        												Account.Name,
		        												CloseDate
		        											FROM
		        												OpportunitysTorihikiShodan__r
        												)
        												FROM 
        													Opportunity
        												WHERE 
        													AccountId = :accountIds 
        												AND 
        													TorihikiShodanRef__c = null
//        												AND StageName = 'XXXXX'

        										];
        return targetOpportunities;
    }
}