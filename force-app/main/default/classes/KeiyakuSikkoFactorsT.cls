@isTest
public class KeiyakuSikkoFactorsT {
    @isTest public static void ISikkoFactorReader_is_any_other_sikko_factor(){

        Test.startTest();
        new KeiyakuSikkoFactors.SikkoFactorReader().is_any_other_sikko_factor(
            new Keiyaku__c(
                KeiyakuJokyo__c = '失効中',
                KeiriSokyakuTeishiFlag__c = true,
                IsYosinOverStop__c = true,
                KeiyakuSikkouKasibi__c = Date.newInstance(2020,1,2),
                KeiyakuSikkouKaijoBi__c = Date.newInstance(2020,1,1),
                KeiyakuSikkoRiyu__c = '_'
            ),
            KeiyakuSikkoFactors.Factors.yosin_over
        );
        Test.stopTest();
    }

    @isTest public static void get_ISikkoFactorReader_instance(){
        Test.startTest();
        KeiyakuSikkoFactors.get_ISikkoFactorReader_instance();
        Test.stopTest();
    }
}