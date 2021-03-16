public without sharing class GyomuRenrakuSaishuKoshinshaSet {

	public void insertGyomuRenraku(List<GyomuRenraku__c> newList) {
		
		String csLeader = [select Id from Profile where Name = 'CSリーダ'].Id; 
		for(GyomuRenraku__c gyomuRenraku : newList){
			gyomuRenraku.SaishuKoshinshaRef__c = UserInfo.getUserId();
			gyomuRenraku.SaishuKoshinbi__c = Datetime.now();

			if(UserInfo.getProfileId() == csLeader){
				gyomuRenraku.ShoninStatus__c = 'OK';
			}
		}
	}

	public void updateGyomuRenraku(List<GyomuRenraku__c> newList, Map<Id, GyomuRenraku__c> oldMap) {
		
		for(GyomuRenraku__c gyomuRenraku : newList){
			GyomuRenraku__c oldGyomuRenraku = oldMap.get(gyomuRenraku.Id);
			if(oldGyomuRenraku.KidokuUserID__c == gyomuRenraku.KidokuUserID__c){
				gyomuRenraku.SaishuKoshinshaRef__c = UserInfo.getUserId();
				gyomuRenraku.SaishuKoshinbi__c = Datetime.now();
			}
		}
	}
}