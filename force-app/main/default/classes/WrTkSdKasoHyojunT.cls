@isTest
public class WrTkSdKasoHyojunT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKasoHyojun().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005005' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKasoHyojun().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.KasoHyojun} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKasoHyojun().getWaribikiShohinBangos( 'SBG-0005005' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKasoHyojun().getShohinBangoMap();
        Test.stopTest();
    }
}