@isTest
public class ShisetsuCoreSyncTaskRunReqTriggerTest {

    @istest
    public static void doTest(){

        Map<String, ShisetsuCoreSyncTask__c> theTasks = new Map<String,ShisetsuCoreSyncTask__c>{
            '1' => new ShisetsuCoreSyncTask__c(
                EndPoint__c = '<test endpoint>',
                MessageBody__c = '<msg body>'
            ),
            '2' => new ShisetsuCoreSyncTask__c(
                EndPoint__c = '<test endpoint>',
                MessageBody__c = '<msg body>'
            )
        };
        Insert theTasks.values();

        Map<String, ShisetsuCoreSyncTaskRunReq__e> theEvents = new Map<String, ShisetsuCoreSyncTaskRunReq__e>{
            '1' => new ShisetsuCoreSyncTaskRunReq__e( TaskId__c = theTasks.get('1').Id ),
            '2' => new ShisetsuCoreSyncTaskRunReq__e( TaskId__c = theTasks.get('2').Id )
        };

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200) );
        
        Test.startTest();
        List<Database.SaveResult> theSaveResults = EventBus.publish( theEvents.values() );
        Test.stopTest();

        for (Database.SaveResult aResult : theSaveResults) {
            System.assertEquals(true, aResult.isSuccess());
            if(!aResult.isSuccess()){
                for(Database.Error aError : aResult.getErrors()) {
                    System.debug('Error returned: ' + aError.getStatusCode() + ' - ' + aError.getMessage());
                }
            }
        }
    }
}