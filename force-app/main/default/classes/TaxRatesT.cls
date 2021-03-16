@isTest public class TaxRatesT {
	@isTest static void getRate_0TaxEra(){
        Decimal theExpected = 0;
        Decimal theActual = TaxRates.instance().getRate( Date.newInstance(1980,1,1) );
        System.assertEquals(theExpected, theActual);
    }
	@isTest static void getRate_10Per(){
        Decimal theExpected = 0.1;
        Decimal theActual = TaxRates.instance().getRate( Date.newInstance(2019,10,1) );
        System.assertEquals(theExpected, theActual);
    }
}