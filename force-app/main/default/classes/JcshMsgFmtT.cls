@isTest public class JcshMsgFmtT {
    @isTest public static void MessageFormatter_get_message() {
        Test.startTest();
        JcshSyukeis.SyukeiResult a_result = new JcshSyukeis.SyukeiResult();
        a_result.syukei_date_time = Datetime.newInstance(2020, 1, 1, 12, 0, 0);
        new JcshMsgFmt.MessageFormatter()
        .get_message(
            a_result
        );
        Test.stopTest();
    }
}