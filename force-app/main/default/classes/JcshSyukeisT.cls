@isTest public class JcshSyukeisT {

    private class ISyukei_Logic_Of_Jucyu_Stub implements JcshSyukeis_Jucyu.ISyukei_Logic_Of_Jucyu{
        public JcshSyukeis_Jucyu.SyukeiResult get_syukei(Date pDate){
            return new JcshSyukeis_Jucyu.SyukeiResult();
        }
    }
    @isTest public static void Syukeier_getSyukei(){
        Test.startTest();
        new JcshSyukeis.Syukeier(
            new JcshSyukeis.Syukei_Logic_Of_Toiawase(),
            new JcshSyukeis.Syukei_Logic_Of_OnakunariTaio(),
            new ISyukei_Logic_Of_Jucyu_Stub(),
            new JcshSyukeis.Syukei_Logic_Of_Shiccyu()
        )
        .getSyukei(
            Date.newInstance(2020,1,1)
        );
        Test.stopTest();
    }

    @isTest public static void get_ISyukeier_instance(){
        Test.startTest();
        JcshSyukeis.get_ISyukeier_instance();
        Test.stopTest();
    }
}