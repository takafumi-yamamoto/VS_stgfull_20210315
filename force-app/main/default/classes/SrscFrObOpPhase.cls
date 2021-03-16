public class SrscFrObOpPhase {
	public class StageToSchedule{
		public Boolean isInStageToSchedule(String pStageName){
			if(pStageName == '決定') return true;
			if(pStageName == '施行待ち') return true;
			if(pStageName == '施行完了') return true;
			if(pStageName == '商談クローズ') return true;
			return false;
		}
	}
}