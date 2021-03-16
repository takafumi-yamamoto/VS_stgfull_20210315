public  class KeirSimeLocksChgNotAllows {
	public Boolean isOppChgNotAllowedForSimekiri(Id pRecordTypeId, Date pUriageDate, Boolean isWon){
		KeirSimekiris.Targets theSimekiriTarget = KeirSimekiris.resolveKeirSimekiriTargetByOppRecTypeId(pRecordTypeId);
		if(theSimekiriTarget == KeirSimekiris.Targets.NONE) return false;
		return isWon && !KeirSimekiris.isAcceptableDate(theSimekiriTarget, pUriageDate);
	}
	public Boolean isOppChgNotAllowedForClosedOpp(Id pRecordTypeId, Boolean isWon){
		KeirSimekiris.Targets theSimekiriTarget = KeirSimekiris.resolveKeirSimekiriTargetByOppRecTypeId(pRecordTypeId);
		if(theSimekiriTarget == KeirSimekiris.Targets.NONE) return false;
		return isWon;
	}
}