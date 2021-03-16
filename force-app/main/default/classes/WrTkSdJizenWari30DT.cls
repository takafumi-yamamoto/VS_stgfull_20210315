@isTest
public class WrTkSdJizenWari30DT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdJizenWari30D().isContextMatch( new WrTkCtxs.ContextData(), '_' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdJizenWari30D().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Atobarai} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdJizenWari30D().getWaribikiShohinBangos( '_' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdJizenWari30D().getShohinBangoMap();
		Test.stopTest();
	}
}