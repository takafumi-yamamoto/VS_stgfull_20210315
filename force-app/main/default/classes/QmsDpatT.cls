@isTest
public class QmsDpatT {
    public class HdlQmsStub implements IHdlQms{
        public void handleQms(Qms__c pQms){ return; }
    }

    public class HdlQmsStub_Err implements IHdlQms{
        public void handleQms(Qms__c pQms){ 
            throw new Exceptions.AnException('a exception');
        }
    }
    @isTest public static void startDispatch(){
        Test.startTest();
        QmsDpat.startDispatch(
            new Qms__c(),
            new HdlQmsStub()
        );
        Test.stopTest();
    }

    @isTest public static void startDispatch_Exception(){
        Test.startTest();
        QmsDpat.startDispatch(
            new Qms__c(),
            new HdlQmsStub_Err()
        );
        Test.stopTest();
    }
}