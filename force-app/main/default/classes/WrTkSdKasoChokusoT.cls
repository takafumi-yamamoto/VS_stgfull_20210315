@isTest
public class WrTkSdKasoChokusoT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKasoChokuso().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKasoChokuso().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.KasoChokuso} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKasoChokuso().getWaribikiShohinBangos( 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKasoChokuso().getShohinBangoMap();
        Test.stopTest();
    }
}