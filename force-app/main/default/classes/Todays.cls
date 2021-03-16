public class Todays {
	
	private static IToday instance = new Today();
	public static void setInstance(IToday pInstance){ instance = pInstance; }

	public static Datetime now(){ return instance.now(); }
	public static Date Date(){ return instance.Date(); }

	public interface IToday{ 
		Date Date();
		Datetime now();
	}

	public class Today implements IToday{
		public Date Date(){ return Date.today(); }
		public Datetime now(){ return DateTime.now(); }
	}

	public class TodayStub implements IToday{
		private Datetime now = Datetime.now();
		public TodayStub setNow(Datetime pValue){ this.now = pValue; return this; }
		public TodayStub setNow(Date pValue){ 
			this.now = Datetime.newInstance(
					pValue.year(), pValue.month(), pValue.day(),
					0,0,0
				);
			return this;
		}
		public Date Date(){ 
			return Date.newInstance(this.now.year(), this.now.month(), this.now.day() );
		}
		public Datetime now(){ return this.now; }
	}

}