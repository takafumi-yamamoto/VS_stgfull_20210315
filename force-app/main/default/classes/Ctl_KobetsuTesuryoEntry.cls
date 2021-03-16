public with sharing class Ctl_KobetsuTesuryoEntry {
	public void checkIsEditableTesuryoTekiyo(list<KobetsuTesuryoEntry__c> newList){
		list<id> TesuryoTekiyoids=new list<id>();
        for(KobetsuTesuryoEntry__c KobetsuTesuryoEntry:newList){
            TesuryoTekiyoids.add(KobetsuTesuryoEntry.TesuryoTekiyoRef__c);
        }
        map<id,TesuryoTekiyo__c> TesuryoTekiyoMap= new map<id,TesuryoTekiyo__c>(Dao_TesuryoTekiyo.getListByIds(TesuryoTekiyoids));
        for(KobetsuTesuryoEntry__c KobetsuTesuryoEntry:newList){
            if (TesuryoTekiyoMap.get(KobetsuTesuryoEntry.TesuryoTekiyoRef__c).ShoninStatus__c=='承認済'){
                KobetsuTesuryoEntry.addError('承認済の手数料適用は変更できません。');
            }
        }
	}
}