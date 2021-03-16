@isTest
public class SzsdAssigneesCardT {
    @isTest public static void CardFinder_is_card_published_for_any_asignee(){
        Test.startTest();
        new SzsdAssigneesCard.CardFinder().is_card_published_for_any_asignee(null);
        Test.stopTest();
    }

    @isTest public static void get_ICardFinder_instance(){
        Test.startTest();
        SzsdAssigneesCard.get_ICardFinder_instance();
        Test.stopTest();
    }
}