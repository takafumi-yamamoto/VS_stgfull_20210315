public class SaijoInitialProcessing {
	
	public static void processingInsert(List<Saijo__c> newList) {
		for(Saijo__c saijo : newList){
			if(saijo.AccessHouhouDensha__c != null){
				saijo.MoyoriTohoFun__c = moyoriekiToho(saijo.AccessHouhouDensha__c);
			}
		}
	}

	public static void processingUpdate(List<Saijo__c> newList, Map<Id, Saijo__c> oldMap) {
		for(Saijo__c saijo : newList){
			if(saijo.AccessHouhouDensha__c != null && oldMap.get(saijo.Id).AccessHouhouDensha__c != saijo.AccessHouhouDensha__c){
				saijo.MoyoriTohoFun__c = moyoriekiToho(saijo.AccessHouhouDensha__c);
			}
		}
	}

	private static Integer moyoriekiToho(String accessHouhouDensha){
		String regex = '(徒歩[0-9]+分)';
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(accessHouhouDensha);
		Integer tohoFun = null;
		while(m.find()){
			Integer fun = Integer.valueOf(m.group().replace('徒歩', '').replace('分', ''));
			if(tohoFun == null){
				tohoFun = fun;
			}
			else if(tohoFun > fun){
				tohoFun = fun;
			}
		}

		return tohoFun;
	}
}