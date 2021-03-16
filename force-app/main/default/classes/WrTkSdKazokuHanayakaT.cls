@isTest
public class WrTkSdKazokuHanayakaT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKazokuHanayaka().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005003' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKazokuHanayaka().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.KazokuHanayaka} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKazokuHanayaka().getWaribikiShohinBangos( 'SBG-0005003' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKazokuHanayaka().getShohinBangoMap();
        Test.stopTest();
    }
}