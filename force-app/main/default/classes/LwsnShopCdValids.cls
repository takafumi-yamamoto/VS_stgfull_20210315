public class LwsnShopCdValids {

	private LwsnIsLwsnKeiyakus.IIsLawsonKeiyakuSvc mIIsLawsonKeiyakuSvc;
	public LwsnShopCdValids( LwsnIsLwsnKeiyakus.IIsLawsonKeiyakuSvc pIIsLawsonKeiyakuSvc){
		this.mIIsLawsonKeiyakuSvc = pIIsLawsonKeiyakuSvc;
	}

	public void onOppBeforeUpdate(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
		for(Opportunity aNewOne : pNewOnes){ Opportunity aOldOne = pOldOnes.get(aNewOne.Id);
			this.validate_oppShoudHaveShopCode(aNewOne, aOldOne);
		}
	}
	public void validate_oppShoudHaveShopCode(Opportunity pNewOne, Opportunity pOldOne){
		String theRecordTypeId_SimpleYasugo = 
			Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
			.get('SimpleYasugo').getRecordTypeId();

		Boolean isChangeToValidate = 
			pNewOne.AllianceRef__c != pOldOne.AllianceRef__c ||
			pNewOne.LawsonShopCode__c != pOldOne.LawsonShopCode__c;
		
		Boolean isMatchToValidate = 
			pNewOne.RecordTypeId == theRecordTypeId_SimpleYasugo &&
			this.mIIsLawsonKeiyakuSvc.IsLawsonKeiyakuById(pNewOne.AllianceRef__c);

		if(!isChangeToValidate) return;
		if(!isMatchToValidate) return;

		if( String.isBlank(pNewOne.LawsonShopCode__c) )pNewOne.LawsonShopCode__c.addError('店舗コード未入力');
	}
}