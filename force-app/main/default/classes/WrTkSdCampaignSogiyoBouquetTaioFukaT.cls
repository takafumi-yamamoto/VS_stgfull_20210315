@isTest
public class WrTkSdCampaignSogiyoBouquetTaioFukaT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdCampaignSogiyoBouquetTaioFuka().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdCampaignSogiyoBouquetTaioFuka().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.CampaignSogiyoBouquetTaioFuka} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdCampaignSogiyoBouquetTaioFuka().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdCampaignSogiyoBouquetTaioFuka().getShohinBangoMap();
        Test.stopTest();
    }
}