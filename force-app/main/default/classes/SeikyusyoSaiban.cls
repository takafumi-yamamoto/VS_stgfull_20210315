public class SeikyusyoSaiban {
	private static SeikyusyoSaiban saiban;
	
	private SeikyusyoSaiban(){

	}

	public static SeikyusyoSaiban getInstance(){
		if(saiban == null) saiban = new SeikyusyoSaiban();
		return saiban;
	}

	public String newSeikyusyoBango(){
		SeikyusyoSaiban__c obj = new SeikyusyoSaiban__c();
		insert obj;
		SeikyusyoSaiban__c obj1 = [Select Name From SeikyusyoSaiban__c Where Id = :obj.id limit 1];
		return obj1.Name;
	}
}