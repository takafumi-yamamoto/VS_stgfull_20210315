/**
手数料計算
*/
public class TesuryoPartnerKeisan {

	public void OnBeforeUpdateTesuryouKeisan(List<Opportunity> newList, Map<Id, Opportunity> oldMap){
		for(Opportunity aNewOne: newList ) {
            Opportunity aOldOne =  oldMap.get(aNewOne.Id);
            Boolean TesuryoChange = 
                aNewOne.TesuryoPartnerForPlan__c != aOldOne.TesuryoPartnerForPlan__c
                || aNewOne.TesuryoPartnerForSogiOption__c != aOldOne.TesuryoPartnerForSogiOption__c
                || aNewOne.TesuryoPartnerForYorisoOption__c != aOldOne.TesuryoPartnerForYorisoOption__c;

            if(TesuryoChange){
                if(aOldOne.isWon) aNewOne.addError('売上確定済みの商談の手数料は変更できません');
                aNewOne.TesuryoPartnerForSogiOption__c = aNewOne.TesuryoPartnerForSogiOption__c == null ? 0 : aNewOne.TesuryoPartnerForSogiOption__c;
                aNewOne.TesuryoPartnerForYorisoOption__c = aNewOne.TesuryoPartnerForYorisoOption__c == null ? 0 : aNewOne.TesuryoPartnerForYorisoOption__c;
                aNewOne.TesuryoPartnerForPlan__c = aNewOne.TesuryoPartnerForPlan__c == null ? 0 : aNewOne.TesuryoPartnerForPlan__c;
                aNewOne.TesuryoPartnerForOption__c = aNewOne.TesuryoPartnerForSogiOption__c + aNewOne.TesuryoPartnerForYorisoOption__c;
                aNewOne.TesuryoPartner__c = aNewOne.TesuryoPartnerForPlan__c + aNewOne.TesuryoPartnerForOption__c;
            }
        }
    }
}