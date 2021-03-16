@isTest
public class WrTkSdKazoku1nichiTokubetsuKakakuT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdKazoku1nichiTokubetsuKakaku().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdKazoku1nichiTokubetsuKakaku().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.Kazoku1nichiTokubetsuKakaku} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdKazoku1nichiTokubetsuKakaku().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdKazoku1nichiTokubetsuKakaku().getShohinBangoMap();
        Test.stopTest();
    }
}