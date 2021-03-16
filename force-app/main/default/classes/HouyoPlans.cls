public class HouyoPlans {
	public static List<String> getHoyoPlans(){
		return new List<String>( OboPlanKeitais.getPlans(OboPlanKeitais.Keitais.HOYO) );
	}

	public static Boolean isHoyoPlan(String plan) {
		return OboPlanKeitais.isHoyo(plan);
	}
}