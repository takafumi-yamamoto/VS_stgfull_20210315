@isTest
public class WrTkSdOldKasoHyojunT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldKasoHyojun().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005005' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldKasoHyojun().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldKasoHyojun} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldKasoHyojun().getWaribikiShohinBangos( 'SBG-0005005' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldKasoHyojun().getShohinBangoMap();
        Test.stopTest();
    }
}