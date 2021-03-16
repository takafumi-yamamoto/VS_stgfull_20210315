@isTest
public class WrTkSdKakakuComT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdKakakuCom().isContextMatch( new WrTkCtxs.ContextData(), '_' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdKakakuCom().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Atobarai} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdKakakuCom().getWaribikiShohinBangos( '_' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdKakakuCom().getShohinBangoMap();
		Test.stopTest();
	}
}