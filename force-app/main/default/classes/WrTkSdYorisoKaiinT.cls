@isTest
public class WrTkSdYorisoKaiinT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdYorisoKaiin().isContextMatch(new WrTkCtxs.ContextData(), 'SBG-0005001');
        Test.stopTest();
    }
    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdYorisoKaiin().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.YorisoKaiin } );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdYorisoKaiin().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdYorisoKaiin().getShohinBangoMap();
        Test.stopTest();
    }
}