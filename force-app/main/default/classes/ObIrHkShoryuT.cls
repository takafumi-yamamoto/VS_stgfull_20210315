@isTest
public class ObIrHkShoryuT {
    @isTest 
    public static void Provider_getKubun(){
        Test.startTest();
        new ObIrHkShoryu.Provider().getKubun('_');
        Test.stopTest();
    }
}