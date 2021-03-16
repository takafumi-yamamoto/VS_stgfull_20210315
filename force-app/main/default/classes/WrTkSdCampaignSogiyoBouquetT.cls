@isTest
public class WrTkSdCampaignSogiyoBouquetT {
	@isTest
	public static void isContextMatch(){
		Test.startTest();
		new WrTkSdCampaignSogiyoBouquet().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void existsHeiyoRiyoNg(){
		Test.startTest();
		new WrTkSdCampaignSogiyoBouquet().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.CampaignSogiyoBouquet} );
		Test.stopTest();
	}

	@isTest
	public static void getWaribikiShohinBangos(){
		Test.startTest();
		new WrTkSdCampaignSogiyoBouquet().getWaribikiShohinBangos( 'SBG-0005001' );
		Test.stopTest();
	}

	@isTest
	public static void getShohinBangoMap(){
		Test.startTest();
		new WrTkSdCampaignSogiyoBouquet().getShohinBangoMap();
		Test.stopTest();
	}
}