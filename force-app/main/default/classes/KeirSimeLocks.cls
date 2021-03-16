public class KeirSimeLocks {
	
	public static void turnOnLockRule(){ KeirSimeLocksRuleEnables.turnOnLockRule(); }
	public static void turnOffLockRule(){ KeirSimeLocksRuleEnables.turnOffLockRule(); }

	private static KeirSimeLocksChgNotAllows mKeirSimeLocksChgNotAllows = new KeirSimeLocksChgNotAllows();
	private static String SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED = '売上日が経理締切済みのため、経理計上に影響する変更はできません;';
	private static String OPP_CLOSED_SO_CHANGES_ARE_DENIED = 'フェーズが商談クローズ中のため変更できません。フェーズを戻してから変更してください。;';

	public static void onOpportunityBeforeUpdate(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;

		for(Opportunity aNewOne : pNewOnes){
			Opportunity aOldOne = pOldOnes.get(aNewOne.Id);

			KeirSimekiris.Targets theSimekiriTarget = KeirSimekiris.resolveKeirSimekiriTargetByOppRecTypeId(aNewOne.RecordTypeId);
			if(theSimekiriTarget == KeirSimekiris.Targets.NONE) continue;

			//締切後訂正の禁止
			Boolean isErr_ChangeOnSimekiriOpp = false;
			if( isOppChgNotAllowedForSimekiri(aOldOne.RecordTypeId, aOldOne.Utiagebi__c, aOldOne.isWon) ){
				if(	aOldOne.isWon != aNewOne.isWon ) isErr_ChangeOnSimekiriOpp = true;
				if(	aOldOne.Utiagebi__c != aNewOne.Utiagebi__c ) isErr_ChangeOnSimekiriOpp = true;
			}
			if(isErr_ChangeOnSimekiriOpp){
				aNewOne.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
			}

			//割り込み計上の禁止
			if( aOldOne.isWon != aNewOne.isWon || aOldOne.Utiagebi__c != aNewOne.Utiagebi__c ){
				if( aNewOne.isWon && !KeirSimekiris.isAcceptableDate(theSimekiriTarget, aNewOne.Utiagebi__c) ){
					aNewOne.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
				}		
			}

			//Closed商談の売上訂正禁止
			Boolean isErr_ChangeOnClosedOpp = false;
			if( aOldOne.isWon && aNewOne.isWon ){
				if( aOldOne.Utiagebi__c != aNewOne.Utiagebi__c ) isErr_ChangeOnClosedOpp = true;
				if(theSimekiriTarget == KeirSimekiris.Targets.OBO_OPPS){
					if( new KeirSimeLocksObo().inClosedOpp_anyChgNotAcceptable(aOldOne, aNewOne) ) isErr_ChangeOnClosedOpp = true;
				}
				if(theSimekiriTarget == KeirSimekiris.Targets.REVI_OPPS){
					if( new KeirSimeLocksRevi().inClosedOpp_anyChgNotAcceptable(aOldOne, aNewOne) ) isErr_ChangeOnClosedOpp = true;
				}
				if(theSimekiriTarget == KeirSimekiris.Targets.SOGI_OPPS){
					if( new KeirSimeLocksSogi().inClosedOpp_anyChgNotAcceptable(aOldOne, aNewOne) ) isErr_ChangeOnClosedOpp = true;
				}
			}
			if(isErr_ChangeOnClosedOpp){
				aNewOne.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
			}
		}
	}

	public static void onOpportunityLineItemBeforeInsert(List<OpportunityLineItem> pNewOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOpportunityLineItem(pNewOnes);
	}	
	public static void onOpportunityLineItemBeforeUpdate(List<OpportunityLineItem> pNewOnes, Map<Id, OpportunityLineItem> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOpportunityLineItem(pNewOnes);
	}
	public static void onOpportunityLineItemBeforeDelete(List<OpportunityLineItem> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOpportunityLineItem( pOldOnes );
	}
	private static void onOpportunityLineItem(List<OpportunityLineItem> pEntries){
		Set<Id> theOppIds = new Set<Id>(); for(OpportunityLineItem aEntry : pEntries){ theOppIds.add( aEntry.OpportunityId ); }
		Map<Id,Opportunity> theOpps = selectOpps(theOppIds);

		for(OpportunityLineItem aEntry : pEntries){ 
			Opportunity theOpp = theOpps.get(aEntry.OpportunityId);
			if(theOpp == null) continue;
			if( isOppChgNotAllowedForSimekiri(theOpp.RecordTypeId, theOpp.Utiagebi__c, theOpp.isWon) ){
				aEntry.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
			}
			if( isOppChgNotAllowedForClosedOpp(theOpp.RecordTypeId, theOpp.isWon) ){
				aEntry.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
			}
		}
	}

	public static void onOkyakusamaSeikyuMeisaiBeforeInsert(List<OkyakusamaSeikyuMeisai__c> pNewOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOkyakusamaSeikyuMeisai(pNewOnes);
	}	
	public static void onOkyakusamaSeikyuMeisaiBeforeUpdate(List<OkyakusamaSeikyuMeisai__c> pNewOnes, Map<Id, OkyakusamaSeikyuMeisai__c> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOkyakusamaSeikyuMeisai(pNewOnes);
	}
	public static void onOkyakusamaSeikyuMeisaiBeforeDelete(List<OkyakusamaSeikyuMeisai__c> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onOkyakusamaSeikyuMeisai( pOldOnes );
	}
	private static void onOkyakusamaSeikyuMeisai(List<OkyakusamaSeikyuMeisai__c> pEntries){
		Set<Id> theOppIds = new Set<Id>(); for(OkyakusamaSeikyuMeisai__c aEntry : pEntries){ theOppIds.add( aEntry.OpportunityRef__c ); }
		Map<Id,Opportunity> theOpps = selectOpps(theOppIds);

		for(OkyakusamaSeikyuMeisai__c aEntry : pEntries){ 
			Opportunity theOpp = theOpps.get(aEntry.OpportunityRef__c);
			if(theOpp == null) continue;
			if( isOppChgNotAllowedForSimekiri(theOpp.RecordTypeId, theOpp.Utiagebi__c, theOpp.isWon) ){
				aEntry.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
			}
			if( isOppChgNotAllowedForClosedOpp(theOpp.RecordTypeId, theOpp.isWon) ){
				aEntry.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
			}
		}
	}

	public static void onPatnerUriageBeforeInsert(List<PatnerUriage__c> pNewOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onPatnerUriage(pNewOnes);
	}	
	public static void onPatnerUriageBeforeUpdate(List<PatnerUriage__c> pNewOnes, Map<Id, PatnerUriage__c> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onPatnerUriage(pNewOnes);
	}
	public static void onPatnerUriageBeforeDelete(List<PatnerUriage__c> pOldOnes){
		if( !KeirSimeLocksRuleEnables.isEnabled() ) return;
		onPatnerUriage( pOldOnes );
	}
	private static void onPatnerUriage(List<PatnerUriage__c> pEntries){
		Set<Id> theOppIds = new Set<Id>(); for(PatnerUriage__c aEntry : pEntries){ theOppIds.add( aEntry.Syodan__c ); }
		Map<Id,Opportunity> theOpps = selectOpps(theOppIds);

		for(PatnerUriage__c aEntry : pEntries){ 
			Opportunity theOpp = theOpps.get(aEntry.Syodan__c);
			if(theOpp == null) continue;
			if( isOppChgNotAllowedForSimekiri(theOpp.RecordTypeId, theOpp.Utiagebi__c, theOpp.isWon) ){
				aEntry.addError(SIMEKIRI_ZUMI_SO_CHANGES_ARE_DENIED); continue;
			}
			if( isOppChgNotAllowedForClosedOpp(theOpp.RecordTypeId, theOpp.isWon) ){
				aEntry.addError(OPP_CLOSED_SO_CHANGES_ARE_DENIED); continue;
			}
		}
	}

	private static Boolean isOppChgNotAllowedForSimekiri(Id pRecordTypeId, Date pUriageDate, Boolean isWon){
		return mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForSimekiri(pRecordTypeId, pUriageDate, isWon);
	}
	private static Boolean isOppChgNotAllowedForClosedOpp(Id pRecordTypeId, Boolean isWon){
		return mKeirSimeLocksChgNotAllows.isOppChgNotAllowedForClosedOpp(pRecordTypeId, isWon);
	}

	private static Map<Id, Opportunity> selectOpps(Set<Id> pOppIds){
		Map<Id, Opportunity> theOpps = new Map<Id, Opportunity>();
		for(Opportunity aOpp : [ SELECT Id, Utiagebi__c, RecordTypeId, isWon FROM Opportunity WHERE Id = :pOppIds ]){
			theOpps.put(aOpp.Id, aOpp);
		}
		return theOpps;
	}
}