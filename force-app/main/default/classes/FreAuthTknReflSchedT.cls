@isTest
public class FreAuthTknReflSchedT {

    public class FreAuthTknRefl_ITokenReflesher_Stub implements FreAuthTknRefl.ITokenReflesher{
        public void refleshToken(){ return; }
    }
    public class FreAuthTknRefl_ITokenReflesher_Stub_Error implements FreAuthTknRefl.ITokenReflesher{
        public void refleshToken(){ throw new Exceptions.AnException(); }
    }
    @isTest public static void Schedulable_execute(){
        FreAuthTknReflSched.m_ITokenReflesher_instance = new FreAuthTknRefl_ITokenReflesher_Stub();

        Test.startTest();
        new FreAuthTknReflSched().execute(null);
        Test.stopTest();
    }

    @isTest public static void Schedulable_execute_error(){
        FreAuthTknReflSched.i_will_raise_error_in_run_for_errHandleTest = true;
    
        Test.startTest();
        new FreAuthTknReflSched().execute(null);
        Test.stopTest();
    }

    @isTest public static void Schedulable_execute_reflesh_error(){
        FreAuthTknReflSched.m_ITokenReflesher_instance = new FreAuthTknRefl_ITokenReflesher_Stub_Error();

        Test.startTest();
        new FreAuthTknReflSched().execute(null);
        Test.stopTest();
    }
}