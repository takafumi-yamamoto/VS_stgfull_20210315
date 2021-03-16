@isTest
public class WrTkSdOldKazokuHanayakaT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldKazokuHanayaka().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005003' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldKazokuHanayaka().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldKazokuHanayaka} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldKazokuHanayaka().getWaribikiShohinBangos( 'SBG-0005003' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldKazokuHanayaka().getShohinBangoMap();
        Test.stopTest();
    }
}