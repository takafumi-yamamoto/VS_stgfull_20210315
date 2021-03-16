public with sharing class Dao_k_Service {
	private static Dao_k_Service instance;
	public static Dao_k_Service getInstance(){
		if(instance == null) instance = new Dao_k_Service();
		return instance;
	}
    static public List<k_Service__c> getAllRecords(){
        list<k_Service__c> ServiceLst=[select id,
                                              Name,
                                              ID__c
                                         from k_Service__c];
		return ServiceLst;
    }
}