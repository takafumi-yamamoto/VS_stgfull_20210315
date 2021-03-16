@isTest
public class WrTkSdBenefitT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdBenefit().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdBenefit().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Benifit} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdBenefit().getWaribikiShohinBangos( 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdBenefit().getShohinBangoMap();
		Test.stopTest();
	}
}