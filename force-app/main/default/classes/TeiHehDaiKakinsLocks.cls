public class TeiHehDaiKakinsLocks {

	private static ITeiHehDaiKakinsLock mInstance = null;
	public static ITeiHehDaiKakinsLock getInstance(){ 
		if( mInstance == null ){
			mInstance = new TeiHehDaiKakinsLock( TeiHehDaiKakinsExeLogs.getInstance() );
		}
		return mInstance; 
	}

	public interface ITeiHehDaiKakinsLock{
		void onTeiHehDaiKakinSchEnt_Before_Upsert(List<TeiHehDaiKakinSchEnt__c> pNewOnes);
		void turnOnValidaton();
		void turnOffValidaton();
	}

	public class TeiHehDaiKakinsLock implements ITeiHehDaiKakinsLock{
		private Boolean isValidationEnabled = true;
		public void turnOnValidaton(){ this.isValidationEnabled = true; }
		public void turnOffValidaton(){ this.isValidationEnabled = false; }

		private TeiHehDaiKakinsExeLogs.ILogger mTeiHehDaiKakinsExeLogger;
		public TeiHehDaiKakinsLock(TeiHehDaiKakinsExeLogs.ILogger pTeiHehDaiKakinsExeLogger) {
			this.mTeiHehDaiKakinsExeLogger = pTeiHehDaiKakinsExeLogger;
		}

		public void onTeiHehDaiKakinSchEnt_Before_Upsert(List<TeiHehDaiKakinSchEnt__c> pNewOnes){
			for(TeiHehDaiKakinSchEnt__c aNewOne : pNewOnes){ this.validate(aNewOne); }
		}

		private void validate(TeiHehDaiKakinSchEnt__c pNewOne){
			TeiHehDaiKakinsExeLogs.ShoriStatus theShoriStatus =
				this.mTeiHehDaiKakinsExeLogger.getShoriStatus( pNewOne.BeginDate__c );
			if( theShoriStatus == TeiHehDaiKakinsExeLogs.ShoriStatus.Started ){
				pNewOne.addError('課金明細の月次更新処理中です。しばらくたってから、登録してください;');
			}
			else if( theShoriStatus == TeiHehDaiKakinsExeLogs.ShoriStatus.Finished ){
				Boolean isNextMonthExists = [
					SELECT Id FROM TeiHehDaiKakinSchEnt__c
					WHERE KeiyakuRef__c = :pNewOne.KeiyakuRef__c
					AND BeginDate__c = :pNewOne.BeginDate__c.addMonths(1)
				].size() > 0;
				if( !isNextMonthExists ){
					pNewOne.addError('課金明細の月次更新処理日を過ぎています。翌月の課金明細を先に追加してください。;');
				}
			}
		}
	}

}