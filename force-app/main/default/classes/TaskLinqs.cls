public class TaskLinqs{
    public static List<Id> CollectAtesakiRef(List<Task> pTasks){
        Set<Id> theAtesakiRefs = new Set<Id>();
        for(Task aTask: pTasks){
            if(aTask.AtesakiRef__c != null){
                theAtesakiRefs.add(aTask.AtesakiRef__c);
            }
        }
        return new List<Id>(theAtesakiRefs);
    }
}