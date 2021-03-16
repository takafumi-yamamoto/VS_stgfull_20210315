public class Jcsh_JucyuJokyoSokuho {
    public static IJucyuJokyoSokuhoer get_IJucyuJokyoSokuhoer_instance(){
        JcshConf.Config a_config = JcshConf.get_IProvider_instance().getConfig();
        return new JucyuJokyoSokuhoer(
            new Todays.Today(),
            JcshSyukeis.get_ISyukeier_instance(),
            JcshMsgFmt.get_IMessageFormatter_instance(),
            SlackApiPostMsg.get_IClient_instance(),
            a_config.slack_user_name,
            a_config.slack_channel
        );
    }

    public interface IJucyuJokyoSokuhoer {
        void run();
        void run(Datetime p_syukei_datetime, String p_slack_user_name, String p_slack_channel);
    }
    public class JucyuJokyoSokuhoer implements IJucyuJokyoSokuhoer{
        private Todays.IToday m_IToday;
        private JcshSyukeis.ISyukeier m_ISyukeier;
        private JcshMsgFmt.IMessageFormatter m_IMessageFormatter;
        private SlackApiPostMsg.IClient m_SlackApiPostMsgIClient;
        private String m_slack_user_name;
        private String m_slack_channel;
        public JucyuJokyoSokuhoer(
            Todays.IToday p_IToday,
            JcshSyukeis.ISyukeier p_ISyukeier,
            JcshMsgFmt.IMessageFormatter p_IMessageFormatter,
            SlackApiPostMsg.IClient p_SlackApiPostMsgIClient,
            String p_slack_user_name,
            String p_slack_channel
        ){
            this.m_IToday = p_IToday;
            this.m_ISyukeier = p_ISyukeier;
            this.m_IMessageFormatter = p_IMessageFormatter;
            this.m_SlackApiPostMsgIClient = p_SlackApiPostMsgIClient;
            this.m_slack_user_name = p_slack_user_name;
            this.m_slack_channel = p_slack_channel;
        }

        public void run(){
            this.run(
                this.m_IToday.now(),
                this.m_slack_user_name,
                this.m_slack_channel
            );
        }

        public void run(Datetime p_syukei_datetime, String p_slack_user_name, String p_slack_channel){

            JcshSyukeis.SyukeiResult the_syukei_result = this.m_ISyukeier.getSyukei(p_syukei_datetime);

            String the_message = this.m_IMessageFormatter.get_message(the_syukei_result);

            SlackApiPostMsg.Result a_Result = 
                this.m_SlackApiPostMsgIClient.sendRequest(
                    new SlackApiPostMsg.Req()
                        .set_username(p_slack_user_name)
                        .set_channel(p_slack_channel)
                        .set_text(the_message)
                );
            
            if( !a_Result.isSuccess ){
                Loggings.LogEntry a_LogEntry = 
                    Loggings.createLogEntry(Loggings.Level.Error, '202012061150', 'Jcsh_JucyuJokyoSokuho.JucyuJokyoSokuhoer.run')
                    .putAttr('JSON.serialize(a_Result)',a_Result == null ? '' : JSON.serialize(a_Result));
                
                Loggings.writeLog( a_LogEntry );

                throw new Exceptions.AnException(
                    JSON.serialize(
                        new Map<String, String>{
                            'message' => 'slack api error.',
                            'a_LogEntry' => JSON.serialize(a_LogEntry)
                        }
                    )
                );
            }
        }
    }
}