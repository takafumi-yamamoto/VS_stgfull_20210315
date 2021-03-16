public class WrTkSbgMaps {
	
	public interface IShohinBangoMap {
		Map<String, Set<String>> getShohinBangoMap();
	}

	public class MapEntry{
		public Product target;
		public List<Product> waribikis = new List<Product>();
	}
	public class Product{
		public String shohinBango;
		public String name;
		public Product Load(Product2 pProduct2){
			this.shohinBango = pProduct2.ShohinBango__c;
			this.name = pProduct2.Name;
			return this;
		}
	}
	public List<MapEntry> getMapping(IShohinBangoMap pWaribikiSeido){
		Map<String, Set<String>> theShohinBangoMap = pWaribikiSeido.getShohinBangoMap();
		Set<String> theShohinBangos = new Set<String>();
		for( String aShohinBango : theShohinBangoMap.keySet() ){ theShohinBangos.add(aShohinBango); }
		for( Set<String> aWaribikiShohinBangos : theShohinBangoMap.values() ){ 
			for(String aWaribikiShohinBango : aWaribikiShohinBangos) theShohinBangos.add(aWaribikiShohinBango); 
		}

		Map<String, Product2> theShohinBangoToProduct = new Map<String, Product2>();
		for( Product2 aProduct2 : [ SELECT Id, ShohinBango__c, Name FROM Product2 WHERE ShohinBango__c IN :theShohinBangos ] ){
			theShohinBangoToProduct.put( aProduct2.ShohinBango__c, aProduct2 );
		}

		List<MapEntry> theEntries = new List<MapEntry>();
		for( String aTargetShohinBango : theShohinBangoMap.keySet() ){ 
			MapEntry theMapEntry = new MapEntry();
			theMapEntry.target = new Product().load( theShohinBangoToProduct.get( aTargetShohinBango ) ) ;
			for(String aWaribikiShohinBango : theShohinBangoMap.get(aTargetShohinBango)){
				theMapEntry.waribikis.add( 
					new Product().load( theShohinBangoToProduct.get( aWaribikiShohinBango ) ) 
				);
			}
			theEntries.add(theMapEntry);
		}
		return theEntries;
	}
}