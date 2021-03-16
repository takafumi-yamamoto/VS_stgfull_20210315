public class OboStSelProf {

    private static oboStSelProf__c f_CachedConfig = null;

    private oboStSelProf__c loadConfig(){
    	if(f_CachedConfig != null) return f_CachedConfig;

    	f_CachedConfig =
			(oboStSelProf__c)SobjectsExtension.firstOrNull(
				[
					SELECT Id,
					MaxDistance__c,
					LeftHoursToBeUrgent__c,
					HoursAllowedForReplyInUrgent__c,
					HoursAllowedForReply__c, LeftHoursToGiveUp__c,
					SenteiSize__c, DoziDashinSize__c,
					HourFindBeginInNoTimeSepc__c, HourFindEndInNoTimeSepc__c
					FROM oboStSelProf__c
					ORDER BY Id
				]
			);

        return f_CachedConfig;
    }

	public Integer getHoursAllowedForReply(Boolean isUrgent){
		this.loadConfig();
		Integer result;
		if(f_CachedConfig == null) result = 3;
		else if(isUrgent) {
			result = f_CachedConfig.HoursAllowedForReplyInUrgent__c != null ? (Integer)f_CachedConfig.HoursAllowedForReplyInUrgent__c : 1;
		}
		else{
			result = f_CachedConfig.HoursAllowedForReply__c != null ? (Integer)f_CachedConfig.HoursAllowedForReply__c : 3;
		}
		return result;
	}

	public Integer getDoziDashinSize(){
		this.loadConfig();
		return f_CachedConfig == null ? 3 : (Integer)f_CachedConfig.DoziDashinSize__c;
	}

	private Integer getLeftHoursToBeUrgent(){
		this.loadConfig();
		return f_CachedConfig == null ? 72 : (Integer)f_CachedConfig.LeftHoursToBeUrgent__c;
	}
	public Boolean isUrgent(Datetime pServiceTime, Datetime pNow){
		return pNow.addHours( this.getLeftHoursToBeUrgent() ) > pServiceTime;
	}

	private Integer getLeftHoursToGiveUp(){
		this.loadConfig();
		return f_CachedConfig == null ? 12 : (Integer)f_CachedConfig.LeftHoursToGiveUp__c;
	}
	public Datetime getTimeLimit(Datetime pServiceTime){
		Datetime theTimeLimit =  pServiceTime.addHours( -1 * this.getLeftHoursToGiveUp() );
		return theTimeLimit;
	}

	// 未使用ため、コメントアウトします
	// public Boolean hasEnoughTimeToReply(Datetime pDashinTime, Datetime pTimeLimit){
	// 	return pDashinTime.addHours( this.getHoursAllowedForReply() ) < pTimeLimit;
	// }

	public Integer getSenteiSize(){
		this.loadConfig();
		return f_CachedConfig == null ? 20 : (Integer)f_CachedConfig.SenteiSize__c;
	}

	public Integer getHourFindBeginInNoTimeSepc(){
		this.loadConfig();
		return f_CachedConfig == null ? 8 : (Integer)f_CachedConfig.HourFindBeginInNoTimeSepc__c;
	}
	public Integer getHourFindEndInNoTimeSepc(){
		this.loadConfig();
		return f_CachedConfig == null ? 20 : (Integer)f_CachedConfig.HourFindEndInNoTimeSepc__c;
	}
	public Integer getMaxDistance(){
		this.loadConfig();
		return f_CachedConfig == null ? 50 : (Integer)f_CachedConfig.MaxDistance__c;
	}
}