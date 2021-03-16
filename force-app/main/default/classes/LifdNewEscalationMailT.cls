@isTest
public class LifdNewEscalationMailT {
    @isTest public static void createMail(){
        Test.startTest();
        new LifdNewEscalationMail().createMail( new LifdNewEscalationMail.Req().set_LifdEscalationId(null) );
        Test.stopTest();
    }
}