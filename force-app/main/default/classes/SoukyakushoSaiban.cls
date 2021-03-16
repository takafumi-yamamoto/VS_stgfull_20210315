public class SoukyakushoSaiban {
	private static SoukyakushoSaiban saiban;
	
	private SoukyakushoSaiban(){

	}

	public static SoukyakushoSaiban getInstance(){
		if(saiban == null) saiban = new SoukyakushoSaiban();
		return saiban;
	}

	public String newSoukyakushoBango(){
		SoukyakushoSaiban__c obj = new SoukyakushoSaiban__c();
		insert obj;
		SoukyakushoSaiban__c obj1 = [Select Name From SoukyakushoSaiban__c Where Id = :obj.id limit 1];
		return obj1.Name;
	}
}