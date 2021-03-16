public class SaijoValidation {

	public static void validate(List<Saijo__c> newList) {

		for(Saijo__c saijo : newList){
			if(!saijo.ShokaiKa__c) saijo.SimpleHPKeisaiAri__c = false;

			if(saijo.ShokaiKa__c && saijo.ShikugunRef__c == null) {
				saijo.addError('市区郡未入力');
				continue;
			}
			if(saijo.ShokaiKa__c && String.isEmpty(saijo.Street__c)) {
				saijo.addError('町名・番地未入力');
				continue;
			}
		}
	}
}