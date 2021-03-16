@isTest
public class WrTkSdKazoku2nichiT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKazoku2nichi().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005002' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKazoku2nichi().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Kazoku2nichi} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKazoku2nichi().getWaribikiShohinBangos( 'SBG-0005002' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKazoku2nichi().getShohinBangoMap();
        Test.stopTest();
    }
}