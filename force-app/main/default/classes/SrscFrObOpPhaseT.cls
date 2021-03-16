@isTest
public class SrscFrObOpPhaseT {
	@isTest
	public static void StageToSchedule_isInStageToSchedule() {
		Boolean isInStageToSchedule = 
			new SrscFrObOpPhase.StageToSchedule().isInStageToSchedule('除外');
		System.assertEquals(false,isInStageToSchedule);
	}
}