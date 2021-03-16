@isTest
public class WrTkSdShikigoAnkeitoT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdShikigoAnkeito().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdShikigoAnkeito().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.ShikigoAnkeito} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdShikigoAnkeito().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdShikigoAnkeito().getShohinBangoMap();
        Test.stopTest();
    }
}