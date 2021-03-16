@isTest
public class WrTkSdJizenWari2YT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdJizenWari2Y().isContextMatch( new WrTkCtxs.ContextData(), '_' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdJizenWari2Y().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Atobarai} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdJizenWari2Y().getWaribikiShohinBangos( '_' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdJizenWari2Y().getShohinBangoMap();
		Test.stopTest();
	}
}