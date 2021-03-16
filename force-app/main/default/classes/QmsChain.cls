public class QmsChain {

	public static void onQmsBeforeInsert(List<Qms__c> pNewOnes){
		for(Qms__c aQms : pNewOnes){
			validateOnQmsBeforeInsert(aQms);
		}
	}
	public static void validateOnQmsBeforeInsert(Qms__c pNewOne){
		Boolean isInvalid = false;
		if( pNewOne.ChainNodeType__c != 'Root' && pNewOne.ChainNodeType__c != 'Child' ) isInvalid = true;
		if( String.isBlank(pNewOne.ChainNodeId__c) ) isInvalid = true;
		if( String.isBlank(pNewOne.ChainRootId__c) ) isInvalid = true;
		if(pNewOne.ChainDepth__c == null) isInvalid = true;

		if(pNewOne.ChainNodeType__c == 'Root'){
			if(pNewOne.ChainDepth__c != 0) isInvalid = true;
			if( !String.isBlank(pNewOne.ChainParentId__c) ) isInvalid = true;
		}
		if(pNewOne.ChainNodeType__c == 'Child'){
			if(pNewOne.ChainDepth__c <= 0) isInvalid = true;
			if( String.isBlank(pNewOne.ChainParentId__c) ) isInvalid = true;
		}
		if(isInvalid) pNewOne.addError('QmsChain.validateOnQmsBeforeInsert');

		if(pNewOne.ChainDepth__c > 100) pNewOne.addError('QmsChain.validateOnQmsBeforeInsert.tooDeepChain');
		
	}
}