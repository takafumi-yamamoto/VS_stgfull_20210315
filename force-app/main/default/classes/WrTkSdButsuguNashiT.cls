@isTest
public class WrTkSdButsuguNashiT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdButsuguNashi().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdButsuguNashi().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.ButsugiNashi} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdButsuguNashi().getWaribikiShohinBangos( 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdButsuguNashi().getShohinBangoMap();
		Test.stopTest();
	}
}