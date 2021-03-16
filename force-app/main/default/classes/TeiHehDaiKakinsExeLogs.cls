public class TeiHehDaiKakinsExeLogs {

	private static ILogger mInstance = null;
	public static ILogger getInstance(){ 
		if( mInstance == null ){
			mInstance = new TeiHehDaiKakinsExeLogs.Logger( new TeiHehDaiKakinsExeLogs.TargetYmKeys() ); 
		}
		return mInstance; 
	}

	public class TargetYmKeys{
		public String genTargetYmKey(Date pRenewTargetYm){
			return new DtBldrs.Builder(pRenewTargetYm)
				.toStartOfMonth(true)
				.getValue()
				.format('yyyy-MM');
		}
	}

	public Enum ShoriStatus{ None, NotYet, Started, Finished }
	public interface ILogger {
		void logStart( Date pRenewTargetYm, Datetime pStartedDateTime );
		void logFinish( Date pRenewTargetYm, Datetime pFinishedDatetime );
		ShoriStatus getShoriStatus(Date pRenewTargetYm);
	}

	public class Logger implements ILogger{
		private TargetYmKeys mTargetYmKeys;
		public Logger(TargetYmKeys pTargetYmKeys){
			this.mTargetYmKeys = pTargetYmKeys;
		}
		public void logStart( Date pRenewTargetYm, Datetime pStartedDateTime ){
			String theRenewTargetYmKey = this.mTargetYmKeys.genTargetYmKey(pRenewTargetYm);
			UPSERT New TeiHehDaiKakinsExeLog__c(
				RenewTargetYmKey__c = theRenewTargetYmKey,
				StartedTime__c = pStartedDateTime
			) RenewTargetYmKey__c;
		}
		public void logFinish( Date pRenewTargetYm, Datetime pFinishedDatetime ){
			String theRenewTargetYmKey = this.mTargetYmKeys.genTargetYmKey(pRenewTargetYm);
			UPSERT New TeiHehDaiKakinsExeLog__c(
				RenewTargetYmKey__c = theRenewTargetYmKey,
				FinishedTime__c = pFinishedDatetime
			) RenewTargetYmKey__c;
		}
		public ShoriStatus getShoriStatus(Date pRenewTargetYm){
			String theRenewTargetYmKey = this.mTargetYmKeys.genTargetYmKey(pRenewTargetYm);
			TeiHehDaiKakinsExeLog__c theExeLog = 
				(TeiHehDaiKakinsExeLog__c)SobjectsExtension.firstOrNull(
					[
						SELECT Id, StartedTime__c, FinishedTime__c
						FROM TeiHehDaiKakinsExeLog__c
						WHERE RenewTargetYmKey__c = :theRenewTargetYmKey
					]
				);
			If( theExeLog == null ) return ShoriStatus.NotYet;
			If( theExeLog.FinishedTime__c != null ) return ShoriStatus.Finished;
			If( theExeLog.StartedTime__c != null ) return ShoriStatus.Started;
			return ShoriStatus.NotYet;
		}
	}



}