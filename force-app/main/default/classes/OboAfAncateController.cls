public class OboAfAncateController {
    @AuraEnabled
    public static String getOboAfAncateId(String pOppId){
    	if( String.isBlank(pOppId) ) return null;
    	List<OboAfAncate__c> theOboAfAncates = [
    		SELECT Id
    		FROM OboAfAncate__c
    		WHERE OppRef__c = :pOppId
    		LIMIT 1
    	];
    	return theOboAfAncates.size() == 0 ? null : theOboAfAncates.get(0).Id;
    }

}