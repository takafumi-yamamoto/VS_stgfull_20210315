@isTest
public class WrTkSdOsoshikiYoyakuT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdOsoshikiYoyaku().isContextMatch( new WrTkCtxs.ContextData(), '_' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdOsoshikiYoyaku().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Atobarai} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdOsoshikiYoyaku().getWaribikiShohinBangos( '_' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdOsoshikiYoyaku().getShohinBangoMap();
		Test.stopTest();
	}
}