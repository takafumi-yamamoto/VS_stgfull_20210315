public class SaijoShokaiCheck {

    public static void OnBeforeUpdate(List<Saijo__c> newList) {

		KeiriSokyakuTeishiBat__mdt ACSP = [SELECT 
												ErrAccountingCustomerStop__c,
												updateShokaiKa__c,
												updateSimpleHPKeisaiAri__c
											FROM KeiriSokyakuTeishiBat__mdt
											WHERE DeveloperName = 'KeiriSokyakuTeishiBat'
											Limit 1];
		for(Saijo__c saijo : newList){

			if(saijo.KeiriSokyakuTeishiFlag__c) {

				if(saijo.ShokaiKa__c != ACSP.updateShokaiKa__c) {
					saijo.addError(ACSP.ErrAccountingCustomerStop__c);
					continue;
				}
				

				if(saijo.SimpleHPKeisaiAri__c != ACSP.updateSimpleHPKeisaiAri__c) {
					saijo.addError(ACSP.ErrAccountingCustomerStop__c);
					continue;
				}

			}
		}
	}
}