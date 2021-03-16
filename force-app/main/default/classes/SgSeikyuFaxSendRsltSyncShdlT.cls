@isTest
public class SgSeikyuFaxSendRsltSyncShdlT {
    @isTest public static void scheduleNew(){
        Test.startTest();
        new SgSeikyuFaxSendRsltSyncShdl().scheduleNew();
        Test.stopTest();
    }
    
    @isTest public static void scheduleNew_error(){
    
        SgSeikyuFaxSendRsltSyncShdl.to_raise_error_for_test_coverage = true;
        
        Test.startTest();
        new SgSeikyuFaxSendRsltSyncShdl().scheduleNew();
        Test.stopTest();
    }
    
}