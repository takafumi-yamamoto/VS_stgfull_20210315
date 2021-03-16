@isTest
public class TodaysT {
	@isTest static void now(){ Todays.now(); }
	@isTest static void date(){ Todays.date(); }
	@isTest static void stub_setNow(){
		Todays.setInstance( new Todays.TodayStub().setNow( Datetime.now() ) );
		Todays.now();
		Todays.date();
	}
	@isTest static void stub_setDate(){
		Todays.setInstance( new Todays.TodayStub().setNow( Date.today() ) );
		Todays.date();
	}
}