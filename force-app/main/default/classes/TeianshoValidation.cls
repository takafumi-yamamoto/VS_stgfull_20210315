public class TeianshoValidation {
    
    public static void validate(List<Teiansho__c> newList) {

        Set<Id> sogiShiryoSofuIdList = new Set<Id>();
        for(Teiansho__c teiansho : newList) sogiShiryoSofuIdList.add(teiansho.SogiShiryoSofuRef__c);

        Map<ID, SogiShiryoSofu__c> sogiShiryoSofuIdMap = new Map<Id, SogiShiryoSofu__c>([select Id, SofuJokyo__c from SogiShiryoSofu__c where Id = :sogiShiryoSofuIdList]);

		for(Teiansho__c teiansho : newList){
			if(sogiShiryoSofuIdMap.containsKey(teiansho.SogiShiryoSofuRef__c)){
				SogiShiryoSofu__c sogiShiryoSofu = sogiShiryoSofuIdMap.get(teiansho.SogiShiryoSofuRef__c);
				if(sogiShiryoSofu.SofuJokyo__c != '資料作成中' && sogiShiryoSofu.SofuJokyo__c != '情報確認中') {
					teiansho.addError('【送付状況】が\"資料作成中\"か\"情報確認中\"の場合に作成・編集が可能です');
					continue;
				}
			}
		}
	}
}