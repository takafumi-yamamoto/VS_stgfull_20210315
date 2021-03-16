@isTest
public class WrTkSdJizenAnkeitoT {
    @isTest
    public static void isContextMatch(){
        Test.startTest();
        new WrTkSdJizenAnkeito().isContextMatch( new WrTkCtxs.ContextData(), 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void existsHeiyoRiyoNg(){
        Test.startTest();
        new WrTkSdJizenAnkeito().existsHeiyoRiyoNg( new List<WrTkSds.WaribikiSeidoCodes>{ WrTkSds.WaribikiSeidoCodes.JizenAnkeito} );
        Test.stopTest();
    }

    @isTest
    public static void getWaribikiShohinBangos(){
        Test.startTest();
        new WrTkSdJizenAnkeito().getWaribikiShohinBangos( 'SBG-0005001' );
        Test.stopTest();
    }

    @isTest
    public static void getShohinBangoMap(){
        Test.startTest();
        new WrTkSdJizenAnkeito().getShohinBangoMap();
        Test.stopTest();
    }
}