public class SampleChildQms implements IHdlQms{
	public static String msgType = 'SampleChildQms';

	public class Data{
		public String someData;
		public String someData2;
	}

	public void handleQms(Qms__c pQms){
		try{
			this.runQms(pQms);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190724-1715', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}
	public void runQms(Qms__c pQms){
		//some logic here
		UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
	}
}