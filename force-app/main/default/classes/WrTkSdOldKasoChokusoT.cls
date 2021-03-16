@isTest
public class WrTkSdOldKasoChokusoT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldKasoChokuso().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldKasoChokuso().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldKasoChokuso} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldKasoChokuso().getWaribikiShohinBangos( 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldKasoChokuso().getShohinBangoMap();
        Test.stopTest();
    }
}