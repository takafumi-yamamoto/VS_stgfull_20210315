@isTest
public class WrTkSdOldYorisoKaiinT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdOldYorisoKaiin().isContextMatch(new WrTkCtxs.ContextData(), 'SBG-0005001');
        Test.stopTest();
    }
    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdOldYorisoKaiin().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.OldYorisoKaiin } );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdOldYorisoKaiin().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdOldYorisoKaiin().getShohinBangoMap();
        Test.stopTest();
    }
}