@isTest public class JcshSchedT {

    private class IJucyuJokyoSokuhoer_Stub implements Jcsh_JucyuJokyoSokuho.IJucyuJokyoSokuhoer{
        public void run(){return;}
        public void run(Datetime p_syukei_datetime, String p_slack_user_name, String p_slack_channel){return;}
    }
    @isTest public static void Schedulable_execute(){
        JcshSched.m_IJucyuJokyoSokuhoer_instance = new IJucyuJokyoSokuhoer_Stub();
        Test.startTest();
        new JcshSched().execute(null);
        Test.stopTest();
    }

    @isTest public static void JucyuJokyoHokokuJob_startAsync(){
        Test.startTest();
        new JcshSched.JucyuJokyoHokokuJob(
            new IJucyuJokyoSokuhoer_Stub()
        )
        .startAsync();
        Test.stopTest();
    }

    @isTest public static void JucyuJokyoHokokuJob_execute_error(){
        JcshSched.to_raise_error_for_test_coverage = true;

        Test.startTest();
        try{
            new JcshSched.JucyuJokyoHokokuJob(
                new IJucyuJokyoSokuhoer_Stub()
            )
            .execute(null);          
        }catch(Exception ex){
            //ignore
        }

        Test.stopTest();
    }
}