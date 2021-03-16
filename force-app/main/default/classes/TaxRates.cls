public class TaxRates {

	private TaxRates(){}
	private static TaxRates m_instance = null;
	public static TaxRates instance(){
		if(m_instance == null) m_instance = new TaxRates();
		return m_instance;
	}

	public Decimal getRate(Date pDate){ 
		if(pDate >= Date.newInstance(2019,10,1) ) return 0.10;
		if(pDate >= Date.newInstance(2014,4,1) ) return 0.08;
		if(pDate >= Date.newInstance(1997,4,1) ) return 0.05;
		if(pDate >= Date.newInstance(1989,4,1) ) return 0.03;
		return 0.0;
	}
}