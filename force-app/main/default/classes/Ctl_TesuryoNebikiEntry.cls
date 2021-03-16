public with sharing class Ctl_TesuryoNebikiEntry {
	public void checkIsEditableTesuryoTekiyo(list<TesuryoNebikiEntry__c> newList){
		list<id> TesuryoTekiyoids=new list<id>();
        for(TesuryoNebikiEntry__c TesuryoNebikiEntry:newList){
            TesuryoTekiyoids.add(TesuryoNebikiEntry.TesuryoTekiyoRef__c);
        }
        map<id,TesuryoTekiyo__c> TesuryoTekiyoMap= new map<id,TesuryoTekiyo__c>(Dao_TesuryoTekiyo.getListByIds(TesuryoTekiyoids));
        for(TesuryoNebikiEntry__c TesuryoNebikiEntry:newList){
            if (TesuryoTekiyoMap.get(TesuryoNebikiEntry.TesuryoTekiyoRef__c).ShoninStatus__c=='承認済'){
                TesuryoNebikiEntry.addError('承認済の手数料適用は変更できません。');
            }
        }
	}
}