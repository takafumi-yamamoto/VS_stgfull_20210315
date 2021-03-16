@isTest
public class WrTkSdKazoku1nichiT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKazoku1nichi().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKazoku1nichi().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Kazoku1nichi} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKazoku1nichi().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKazoku1nichi().getShohinBangoMap();
        Test.stopTest();
    }
}