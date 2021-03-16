@isTest
public class TcmsNewEscalationMailT {
    @isTest public static void createMail(){
        Test.startTest();
        new TcmsNewEscalationMail().createMail( new TcmsNewEscalationMail.Req().set_TcmsEscalationId(null) );
        Test.stopTest();
    }
}