public class TESTKenallcAddressKensakuPage {

	public class Addres{
		public String name {get; set;}
		public String post_code {get; set;}
		public String todofuken {get; set;}
		public String shikugun {get; set;}
		public String tyoumei {get; set;}
	}

	@RemoteAction
	public static List<Addres> searchAddress(String SearchString){

		List<List<SObject>>SearchList = new List<List<SObject>>();
		List<Ken_all__c> Ken_allList = new List<Ken_all__c>();
		List<Addres> returnAddres = new List<Addres>();
		if(String.isNotBlank(SearchString)){
			String SearchQuery = 'FIND\'*';
			SearchQuery += SearchString;
			SearchQuery += '*\'IN ALL FIELDS RETURNING Ken_all__c(';
			SearchQuery += 'post_code__c, todofuken__c, shikugun__c, tyoumei__c';
			SearchQuery += ' order by name ASC,post_code__c ASC, todofuken__c ASC , shikugun__c ASC , tyoumei__c ASC ';
			SearchQuery += ' NULLS LAST limit 10 ';
			SearchQuery += ')';
			SearchList = search.query(SearchQuery);
			Ken_allList = SearchList[0];
		}

		for(Ken_all__c aKen :Ken_allList){
			Addres aAddres = new Addres();
			if(aKen.post_code__c.length() > 6){
				aAddres.post_code = aKen.post_code__c;
			}else{
				aAddres.post_code = '0' + aKen.post_code__c;
			}
			aAddres.todofuken = aKen.todofuken__c;
			aAddres.shikugun = aKen.shikugun__c;
			aAddres.tyoumei = aKen.tyoumei__c;
			aAddres.name = aAddres.post_code + ' ' + aAddres.todofuken + ' ' + aAddres.shikugun + ' ' + aAddres.tyoumei;
			returnAddres.add(aAddres);
		}
		return returnAddres;
	}
}