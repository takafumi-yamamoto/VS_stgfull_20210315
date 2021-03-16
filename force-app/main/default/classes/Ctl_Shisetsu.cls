/**
* クラス名  :   Ctl_Shisetsu 
* クラス概要:   施設コントローラー
* @created  :   2018/01/24
* @modified :   
*/
public class Ctl_Shisetsu {

	public static List<Id> collectShikugun(List<Shisetsu__c> pShisetsus){
		Set<Id> theIds = new Set<Id>();
		for(Shisetsu__c aShisetsu : pShisetsus){
			if(aShisetsu.Shikugun__c != null) theIds.add(aShisetsu.Shikugun__c);
		}
		return new List<Id>(theIds);
	}

	public class validator{
		public void validate(List<Shisetsu__c> pNewOnes, List<Shikugun__c> pShikuguns){
			for(Shisetsu__c aNewOne : pNewOnes){
				this.validate(aNewOne, pShikuguns);
			}
		}
		private void validate(Shisetsu__c pNewOne, List<Shikugun__c> pShikuguns){

			Map<Id, SObject> theShikuguns = SobjectsExtension.listToMap(pShikuguns);

			if(pNewOne.ShokaiKinshi__c) pNewOne.SimpleKeisai__c = false;

			Shikugun__c theShikugun = (Shikugun__c)theShikuguns.get(pNewOne.Shikugun__c);
			pNewOne.State__c = '';
			if( theShikugun != null )pNewOne.State__c = theShikugun.TodoufukenNameExp__c;
			pNewOne.City__c = '';
			if( theShikugun != null ) pNewOne.City__c = theShikugun.ShikugunMei__c;

			if(pNewOne.SimpleKeisai__c && String.isEmpty(pNewOne.ShisetsuShubetsu__c)) pNewOne.addError('施設種別未入力');
			if(pNewOne.SimpleKeisai__c && pNewOne.Shikugun__c == null) pNewOne.addError('市区郡未入力');
			if(pNewOne.SimpleKeisai__c && String.isEmpty(pNewOne.Street__c)) pNewOne.addError('町名・番地未入力');
		}
	}
}