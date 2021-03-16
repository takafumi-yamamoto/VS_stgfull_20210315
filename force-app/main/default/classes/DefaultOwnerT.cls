@isTest
public class DefaultOwnerT {

    @isTest
    public static void doTest(){
    	String theOwnerId;
    	Test.startTest();
    		theOwnerId = DefaultOwner.getOwnerId();
    	Test.stopTest();
    	System.assertEquals(false, String.isBlank(theOwnerId) );
    }
}