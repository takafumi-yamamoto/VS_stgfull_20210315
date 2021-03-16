public class KeiriKeiyakuJokyoCheck {

	public static void OnBeforeUpdate(List<Keiyaku__c> newList) {
		
		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT 
												ErrAccountingCustomerStop__c,
												updateKeiyakuJokyoSTOP__c,
												RecordTypeName__c
											FROM KeiriSokyakuTeishiBat__mdt
											WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
											Limit 1];
		String sRecordTypeName = ACSP.RecordTypeName__c;
		List<String> lRecordTypeName = sRecordTypeName.split(',');
		List<Id> ObjRecordType = new List<Id>();
		for(String Str :lRecordTypeName){
			ObjRecordType.add(Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get(Str).getRecordTypeId());
		}

		for (Keiyaku__c newKeiyaku:newList){
			if(ObjRecordType.indexOf(newKeiyaku.RecordTypeId) > -1){
				if(newKeiyaku.KeiriSokyakuTeishiFlag__c) {
					if(newKeiyaku.KeiyakuJokyo__c  != ACSP.updateKeiyakuJokyoSTOP__c) {
						newKeiyaku.addError(ACSP.ErrAccountingCustomerStop__c);
						continue;
					}
				}
			}
		}
	}
}