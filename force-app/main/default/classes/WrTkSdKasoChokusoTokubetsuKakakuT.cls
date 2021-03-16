@isTest
public class WrTkSdKasoChokusoTokubetsuKakakuT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKasoChokusoTokubetsuKakaku().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKasoChokusoTokubetsuKakaku().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.KasoChokusoTokubetsuKakaku} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKasoChokusoTokubetsuKakaku().getWaribikiShohinBangos( 'SBG-0005004' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKasoChokusoTokubetsuKakaku().getShohinBangoMap();
        Test.stopTest();
    }
}