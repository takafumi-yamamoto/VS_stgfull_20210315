public class KrshTesRyoMeiTrg {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public KrshTesRyoMeiTrg(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void onBeforeInsert(List<KrshTesRyoMei__c> pNewOnes){
		onBeforeUpsert(pNewOnes);
	}
	public void onBeforeUpdate(List<KrshTesRyoMei__c> pNewOnes, Map<Id, KrshTesRyoMei__c> pOldOnes){
		onBeforeUpsert(pNewOnes);
	}
	private static void onBeforeUpsert(List<KrshTesRyoMei__c> pNewOnes){
		for(KrshTesRyoMei__c aNewOne : pNewOnes){
			if( aNewOne.isDeleted__c ){
				aNewOne.DeletedKrshSzkSdnStsRecRef__c = aNewOne.KrshSzkSdnStsRecRef__c;
				aNewOne.KrshSzkSdnStsRecRef__c = null;
				aNewOne.DeletedDt__c = Datetime.now();
			}	
		}
	}


	public void onAfterInsert(List<KrshTesRyoMei__c> pNewOnes){
		onAfterUpsert(pNewOnes);
	}
	public void onAfterUpdate(List<KrshTesRyoMei__c> pNewOnes, Map<Id, KrshTesRyoMei__c> pOldOnes){

		for(KrshTesRyoMei__c aNewOne : pNewOnes){
			if( aNewOne.isDeleted__c ) continue;

			KrshTesRyoMei__c aOldOne = pOldOnes.get( aNewOne.Id );
			if( aNewOne.KrshSzkSdnStsRecRef__c != aOldOne.KrshSzkSdnStsRecRef__c){
				aNewOne.addError( createErrMsg( aNewOne, '倉敷事務所管理番号不正 変更不可; ' ) );
			}
		}
		onAfterUpsert(pNewOnes);
	}
	private static void onAfterUpsert(List<KrshTesRyoMei__c> pNewOnes){

		Map<String, KrshSzkSdnStsRec__c> theKrshSzkSdnStsRecMap = new Map<String, KrshSzkSdnStsRec__c>();
		{
			Set<String> theKrshSzkSdnStsRecIds = new Set<String>();
			for(KrshTesRyoMei__c aNewOne : pNewOnes){
				if( !String.isBlank(aNewOne.KrshSzkSdnStsRecRef__c) ) theKrshSzkSdnStsRecIds.add(aNewOne.KrshSzkSdnStsRecRef__c);
			}
			
			for(KrshSzkSdnStsRec__c aStsRec : [
				SELECT 
				Id, KanryoDate__c
				FROM KrshSzkSdnStsRec__c 
				WHERE Id IN :theKrshSzkSdnStsRecIds
			]){
				theKrshSzkSdnStsRecMap.put( aStsRec.Id, aStsRec );
			}
		}

		for(KrshTesRyoMei__c aNewOne : pNewOnes){
			if( aNewOne.isDeleted__c ) continue;

			KrshSzkSdnStsRec__c aStsRec = theKrshSzkSdnStsRecMap.get( aNewOne.KrshSzkSdnStsRecRef__c );

			if( aNewOne.KrshSzkSdnStsRecRef__c == null ){
				aNewOne.addError( createErrMsg( aNewOne, '倉敷事務所管理番号不正 未入力; ' ) );
			}

			if( aStsRec == null ){
				aNewOne.addError( createErrMsg( aNewOne, '倉敷事務所管理番号不正 該当なし; ' ) );
			}
		}

	}
	private static String createErrMsg(KrshTesRyoMei__c pKrshTesRyoMei, String pErrDescr){
		String theMsgTemplate = '倉敷事務所管理番号={0}; よりそう管理番号={1}; エラー内容={2}; ';
		List<String> theMsgContens = new List<String>{
			pKrshTesRyoMei != null && !String.isBlank(pKrshTesRyoMei.Krsh_KanriBangoExp__c) ? pKrshTesRyoMei.Krsh_KanriBangoExp__c : '',
			String.isBlank(pErrDescr) ? '' : pErrDescr
		};
		return String.Format(theMsgTemplate, theMsgContens);
	}
}