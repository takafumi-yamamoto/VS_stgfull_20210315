public class SampleQms implements IHdlQms{
	public static String msgType = 'SampleQms';

	public class Data{
		public String someData;
	}

	public void handleQms(Qms__c pQms){
		try{
			this.runQms(pQms);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190724-1645', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}
	public void runQms(Qms__c pQms){
		//some logic here.
		this.do_example_enqueue_new_child_qms(pQms);

		UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
	}

	private void do_example_enqueue_new_child_qms(Qms__c pQms){
		//chain child-qms example.
		Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
		SampleChildQms.Data theSampleChildData = new SampleChildQms.Data();
		theSampleChildData.someData = theData.someData;
		theSampleChildData.someData2 = 'this is sameData2';

		//insert new Qms as a child.
        INSERT QmsBld.newChild(pQms).setMsgType( SampleChildQms.msgType ).setData( JSON.serialize( theSampleChildData ) ).build();
	}

	public static void do_example_enqueue_new_root_qms(){

		SampleQms.Data theSampleQmsData = new SampleQms.Data();
		theSampleQmsData.someData = 'this is someData';
		INSERT QmsBld.newRoot().setMsgType( SampleQms.msgType ).setData( JSON.serialize( theSampleQmsData ) ).build();
	}
}