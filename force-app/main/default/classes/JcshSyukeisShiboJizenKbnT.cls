@isTest public class JcshSyukeisShiboJizenKbnT {
    @isTest public static void Shibo_Or_JizenKbn_Mapper_get_shibo_or_jizen_kubun() {
        Test.startTest();
        new JcshSyukeisShiboJizenKbn.Shibo_Or_JizenKbn_Mapper()
        .get_shibo_or_jizen_kubun(
            new Opportunity( TaishoushaJokyo__c = '事前')
        );
        Test.stopTest();
    }
}