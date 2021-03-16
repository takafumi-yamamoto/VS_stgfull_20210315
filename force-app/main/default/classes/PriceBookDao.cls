public class PriceBookDao {

	private static PriceBookDao m_instance;
	private static Map<String, PriceBookEnt> m_PBookIdShohinBango_to_PriceBookEnt = new Map<String, PriceBookEnt>();
	private static Set<String> m_loadedPriceBookIds = new Set<String>();

	private PriceBookDao(){}

	public static PriceBookDao instance(){
		if(m_instance == null) m_instance = new PriceBookDao();
		return m_instance;
	}

	public class PriceBookEnt{
		public String product2Id;
		public String shohinBango;
		public Decimal unitPrice = 0;
	}
	public PriceBookEnt getEntry(String pPriceBookId, String pShohinBango){
		if( !m_loadedPriceBookIds.contains(pPriceBookId) ) this.loadPriceBook( pPriceBookId );
		String thePBookIdShohinBango = this.createPBookIdShohinBango( pPriceBookId, pShohinBango );
		return m_PBookIdShohinBango_to_PriceBookEnt.get( thePBookIdShohinBango );
	}

	private void loadPriceBook(String pPriceBookId){
		for(PriceBookEntry aPriceBookEntry : [
			SELECT Id, Product2Id, Product2.ShohinBango__c, unitPrice
			FROM PriceBookEntry
			WHERE PriceBook2Id = :pPriceBookId
		]){
			PriceBookEnt thePriceBookEnt = new PriceBookEnt();
			{
				thePriceBookEnt.product2Id = aPriceBookEntry.Product2Id;
				thePriceBookEnt.shohinBango = aPriceBookEntry.Product2.ShohinBango__c;
				thePriceBookEnt.unitPrice = aPriceBookEntry.unitPrice;
			}
			String thePBookIdShohinBango = this.createPBookIdShohinBango( pPriceBookId, thePriceBookEnt.shohinBango ) ;
			m_PBookIdShohinBango_to_PriceBookEnt.put( thePBookIdShohinBango, thePriceBookEnt);
		}
		m_loadedPriceBookIds.add(pPriceBookId);
	}

	private String createPBookIdShohinBango(String pPriceBookId, String pShohinBango){
		return String.format( '{0}-{1}', new List<String>{ pPriceBookId, pShohinBango } );
	}
}