@isTest
public class WrTkSdOldKazoku2nichiT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldKazoku2nichi().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005002' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldKazoku2nichi().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldKazoku2nichi} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldKazoku2nichi().getWaribikiShohinBangos( 'SBG-0005002' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldKazoku2nichi().getShohinBangoMap();
        Test.stopTest();
    }
}