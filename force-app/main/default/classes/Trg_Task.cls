public with sharing class Trg_Task {
  /**
   * BeforeInsert処理
   *
   * @Auther yamamoto
   * @param List<Task> ToDoリスト
   */

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_Task(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(List<Task> newTaskList, Map<ID, Task> oldTaskMap){
        new Ctl_JudenLogHang().phoneNumerBinding(newTaskList);

        // 後程ちゃんと書く start
        for(Task t : newTaskList){
            if(!String.isBlank(t.YokenSyubetsu__c)) t.Subject = t.YokenSyubetsu__c;
            if(t.Kijitsu__c != null) t.ActivityDate = t.Kijitsu__c.dateGMT();
        }
    }

    public void OnAfterInsert(List<Task> newTaskList, Map<ID, Task> oldTaskMap){
    }

    public void OnAfterUpdate(List<Task> newTaskList, Map<ID, Task> oldTaskMap){
    }
}