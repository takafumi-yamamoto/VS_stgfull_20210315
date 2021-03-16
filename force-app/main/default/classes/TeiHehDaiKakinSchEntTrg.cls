public class TeiHehDaiKakinSchEntTrg {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public TeiHehDaiKakinSchEntTrg(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}
	
	public void onBeforeInsert(List<TeiHehDaiKakinSchEnt__c > pNewOnes){
		TeiHehDaiKakinsExeLogs.ILogger theLogger = TeiHehDaiKakinsExeLogs.getInstance();

		for(TeiHehDaiKakinSchEnt__c aNewOne : pNewOnes){
            aNewOne.BeginDate__c = aNewOne.BeginDate__c.toStartOfMonth();
            aNewOne.EndDate__c = aNewOne.BeginDate__c.toStartOfMonth().addMonths(1).addDays(-1);
		}

		for(TeiHehDaiKakinSchEnt__c aNewOne : pNewOnes){
            if( aNewOne.KakinScheme__c == '従量課金' && aNewOne.Kingaku__c != 0 ) aNewOne.addError( '従量課金の場合は、定額課金額を0にしてください。' );
		}
		
		TeiHehDaiKakinsLocks.getInstance().onTeiHehDaiKakinSchEnt_Before_Upsert(pNewOnes);
    }
    
	public void OnBeforeUpdate(List<TeiHehDaiKakinSchEnt__c> pNewOnes, Map<Id, TeiHehDaiKakinSchEnt__c> pOldOnes){
		TeiHehDaiKakinsExeLogs.ILogger theLogger = TeiHehDaiKakinsExeLogs.getInstance();

		for(TeiHehDaiKakinSchEnt__c aNewOne : pNewOnes){ TeiHehDaiKakinSchEnt__c aOldOne = pOldOnes.get( aNewOne.Id );
			if( aNewOne.BeginDate__c != aOldOne.BeginDate__c ){
				aNewOne.BeginDate__c = aNewOne.BeginDate__c.toStartOfMonth();
				aNewOne.EndDate__c = aNewOne.BeginDate__c.addMonths(1).addDays(-1);
			}
		}

		for(TeiHehDaiKakinSchEnt__c aNewOne : pNewOnes){ TeiHehDaiKakinSchEnt__c aOldOne = pOldOnes.get( aNewOne.Id );
			if( aNewOne.KakinScheme__c != aOldOne.KakinScheme__c || aNewOne.Kingaku__c != aOldOne.Kingaku__c){
				if( aNewOne.KakinScheme__c == '従量課金' && aNewOne.Kingaku__c != 0 ) aNewOne.addError( '従量課金の場合は、定額課金額を0にしてください。' );
			}
		}

		TeiHehDaiKakinsLocks.getInstance().onTeiHehDaiKakinSchEnt_Before_Upsert(pNewOnes);
	}

}