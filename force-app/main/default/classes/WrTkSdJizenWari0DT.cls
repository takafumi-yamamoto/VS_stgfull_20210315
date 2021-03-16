@isTest
public class WrTkSdJizenWari0DT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdJizenWari0D().isContextMatch( new WrTkCtxs.ContextData(), '_' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdJizenWari0D().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Atobarai} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdJizenWari0D().getWaribikiShohinBangos( '_' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdJizenWari0D().getShohinBangoMap();
		Test.stopTest();
	}
}