public class KrshSzkSdnStsRecTrg {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public KrshSzkSdnStsRecTrg(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void onBeforeInsert(List<KrshSzkSdnStsRec__c> pNewOnes){
		
		KrshSzkSdnStsRecKeys.assignIfNotAssigned(pNewOnes);
		onBeforeUpsert(pNewOnes);

	}
	public void onBeforeUpdate(List<KrshSzkSdnStsRec__c> pNewOnes, Map<Id, KrshSzkSdnStsRec__c> pOldOnes){
		
		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){
			KrshSzkSdnStsRec__c aOldOne = pOldOnes.get(aNewOne.Id);

			if( aOldOne.Key__c != aNewOne.Key__c ){
				aNewOne.addError( createErrMsg( aNewOne, 'レコードNoの変更はできません; ' ) );
			}
		}

		onBeforeUpsert(pNewOnes);
	}

	public static void onBeforeUpsert(List<KrshSzkSdnStsRec__c> pNewOnes){

		Set<String> theCardRefIds = new Set<String>();
		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){
			if( !String.isBlank( aNewOne.KrshSzkSdnShkCardRef__c ) ) theCardRefIds.add( aNewOne.KrshSzkSdnShkCardRef__c );
		}
		Map<String, KrshSzkSdnShkCard__c> theCards = new Map<String, KrshSzkSdnShkCard__c>();
		for(KrshSzkSdnShkCard__c aCard : [
			SELECT 
			Id, YorisoKanriBango__c, 
			ShokaiDate__c, SekouDate__c, ShokaiTantoName__c, KaikanMei__c,
			KojinName__c, KojinAgeAtDeath__c, KojinDeathDate__c, KojinAddr__c,
			SodanshaName__c, SodanshaMobile__c, SodanshaPhone__c, SodanshaAddr__c, SodanshaZokugara__c,
			Biko__c,
			OppRef__c, AccountRef__c 
			FROM KrshSzkSdnShkCard__c 
			WHERE Id IN :theCardRefIds
		]){
			theCards.put( aCard.Id, aCard );
		}

		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){

			KrshSzkSdnShkCard__c aCard = 
				!String.isBlank( aNewOne.KrshSzkSdnShkCardRef__c )
				? theCards.get( aNewOne.KrshSzkSdnShkCardRef__c )
				: null;

			aNewOne.YorisoKanriBango__c = aCard == null ? null : aCard.YorisoKanriBango__c;
			aNewOne.OppRef__c = aCard == null ? null : aCard.OppRef__c;
			aNewOne.AccountRef__c = aCard == null ? null : aCard.AccountRef__c;


			if( aCard != null ){ //紹介カード情報でのDefaulting
				if( aNewOne.ShokaiDate__c == null ) aNewOne.ShokaiDate__c = aCard.ShokaiDate__c;
				if( aNewOne.SekouDate__c == null ) aNewOne.SekouDate__c = aCard.SekouDate__c;
				if( String.isBlank(aNewOne.ShokaiTantoName__c) ) aNewOne.ShokaiTantoName__c = aCard.ShokaiTantoName__c;
				if( String.isBlank(aNewOne.KaikanMei__c) ) aNewOne.KaikanMei__c = aCard.KaikanMei__c;
				if( String.isBlank(aNewOne.KojinName__c) ) aNewOne.KojinName__c = aCard.KojinName__c;
				if( aNewOne.KojinAgeAtDeath__c == Null ) aNewOne.KojinAgeAtDeath__c = aCard.KojinAgeAtDeath__c;
				if( aNewOne.KojinDeathDate__c == Null ) aNewOne.KojinDeathDate__c = aCard.KojinDeathDate__c;
				if( String.isBlank(aNewOne.KojinAddr__c) ) aNewOne.KojinAddr__c = aCard.KojinAddr__c;
				if( String.isBlank(aNewOne.SodanshaName__c) ) aNewOne.SodanshaName__c = aCard.SodanshaName__c;
				if( String.isBlank(aNewOne.SodanshaMobile__c) ) aNewOne.SodanshaMobile__c = aCard.SodanshaMobile__c;
				if( String.isBlank(aNewOne.SodanshaPhone__c) ) aNewOne.SodanshaPhone__c = aCard.SodanshaPhone__c;
				if( String.isBlank(aNewOne.SodanshaAddr__c) ) aNewOne.SodanshaAddr__c = aCard.SodanshaAddr__c;
				if( String.isBlank(aNewOne.SodanshaZokugara__c) ) aNewOne.SodanshaZokugara__c = aCard.SodanshaZokugara__c;
				if( String.isBlank(aNewOne.Biko__c) ) aNewOne.Biko__c = aCard.Biko__c;
			}
			if( aNewOne.ShokaiDate__c == null ) aNewOne.ShokaiDate__c = Date.today();

		}

		for(KrshSzkSdnStsRec__c aNewOne : pNewOnes){
			if( String.isBlank(aNewOne.Key__c) ) aNewOne.addError( createErrMsg( aNewOne, 'レコードNo未入力; ' ) );
		}
	}
	
	private static String createErrMsg(KrshSzkSdnStsRec__c pKrshSzkSdnStsRec, String pErrDescr){
		String theMsgTemplate = 'レコードNo={0}; 倉敷事務所管理番号={1}; よりそう管理番号={2}; エラー内容={2}; ';
		List<String> theMsgContens = new List<String>{
			pKrshSzkSdnStsRec != null && !String.isBlank(pKrshSzkSdnStsRec.Key__c) ? pKrshSzkSdnStsRec.Key__c : '',
			pKrshSzkSdnStsRec != null && !String.isBlank(pKrshSzkSdnStsRec.Krsh_KanriBango__c) ? pKrshSzkSdnStsRec.Krsh_KanriBango__c : '',
			pKrshSzkSdnStsRec != null && !String.isBlank(pKrshSzkSdnStsRec.YorisoKanriBango__c) ? pKrshSzkSdnStsRec.YorisoKanriBango__c : '',
			String.isBlank(pErrDescr) ? '' : pErrDescr
		};
		return String.Format(theMsgTemplate, theMsgContens);
	}
}