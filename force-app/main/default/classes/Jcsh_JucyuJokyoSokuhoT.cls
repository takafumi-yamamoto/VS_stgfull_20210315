@isTest
public class Jcsh_JucyuJokyoSokuhoT {

    private class JcshSyukeis_ISyukeier_Stub implements JcshSyukeis.ISyukeier{
        public JcshSyukeis.SyukeiResult getSyukei(Datetime pSyukeiDateTime){
            return new JcshSyukeis.SyukeiResult();
        }
    }
    private class JcshMsgFmt_IMessageFormatter_Stub implements JcshMsgFmt.IMessageFormatter{
        public String get_message(JcshSyukeis.SyukeiResult pSyukeiResult){
            return '';
        }
    }
    public class SlackApiPostMsg_IClient_Stub implements SlackApiPostMsg.IClient{
        private Boolean m_isSuccess;
        public SlackApiPostMsg_IClient_Stub(Boolean p_isSuccess){
            this.m_isSuccess = p_isSuccess;
        }
        public SlackApiPostMsg.Result sendRequest(SlackApiPostMsg.Req pReq){
            SlackApiPostMsg.Result a_result = new SlackApiPostMsg.Result();
            a_result.isSuccess = this.m_isSuccess;
            return a_result;
        }
    }
    @isTest public static void JucyuJokyoSokuhoer_run(){

        Test.startTest();
        new Jcsh_JucyuJokyoSokuho.JucyuJokyoSokuhoer(
            new Todays.Today(),
            new JcshSyukeis_ISyukeier_Stub(),
            new JcshMsgFmt_IMessageFormatter_Stub(),
            new SlackApiPostMsg_IClient_Stub(true),
            'slack_user_name',
            '#slack_channel'
        ).run();
        Test.stopTest();
    }

    @isTest public static void JucyuJokyoSokuhoer_run_error(){

        Test.startTest();
        try{
            new Jcsh_JucyuJokyoSokuho.JucyuJokyoSokuhoer(
                new Todays.Today(),
                new JcshSyukeis_ISyukeier_Stub(),
                new JcshMsgFmt_IMessageFormatter_Stub(),
                new SlackApiPostMsg_IClient_Stub(false),
                'slack_user_name',
                '#slack_channel'
            ).run();
        }catch(Exception ex){ 
            //ignore 
        }
        Test.stopTest();
    }

    @isTest public static void get_IJucyuJokyoSokuhoer_instance(){
        Test.startTest();
        Jcsh_JucyuJokyoSokuho.get_IJucyuJokyoSokuhoer_instance();
        Test.stopTest();
    }
}