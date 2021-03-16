public class Trg_Contact {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Contact(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<Contact> newList, Map<ID, Contact> oldMap){
		new Ctl_Contact().initialProcessing(newList, oldMap);
	}

	public void OnBeforeUpdate(List<Contact> newList, Map<ID, Contact> oldMap){
		new Ctl_Contact().initialProcessing(newList, oldMap);
	}
}