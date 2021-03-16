@isTest
private class TerapSeikyushoPrintT {

    @isTest
    static void myUnitTest() {
        

        TerapSgSeik__c ts = new TerapSgSeik__c();
        insert ts;

        ts = [select id,name from TerapSgSeik__c limit 1];
        PageReference pageRef = Page.TerapSeikyushoPrint;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('no', ts.name);

        TerapSeikyushoPrint tp = new TerapSeikyushoPrint();
    }
}