@isTest
public class WrTkSdOldKazoku1nichiT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldKazoku1nichi().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldKazoku1nichi().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldKazoku1nichi} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldKazoku1nichi().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldKazoku1nichi().getShohinBangoMap();
        Test.stopTest();
    }
}