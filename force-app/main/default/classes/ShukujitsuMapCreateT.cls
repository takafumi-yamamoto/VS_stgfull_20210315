/**
 * 祝日マップを返すShukujitsuMapCreateのテストクラス
 *
 */
@isTest
private class ShukujitsuMapCreateT {
    /**
     * クロスセル提案のInsert(永代供養)
     */
    static testMethod void testgetShukujitsuMap(){
        Map<Date, String> shukujitsuMap = ShukujitsuMapCreate.getShukujitsuMap();
    }
}