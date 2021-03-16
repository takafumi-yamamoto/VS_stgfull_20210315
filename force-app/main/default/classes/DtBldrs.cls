public class DtBldrs {

	public class Builder{
		private Datetime mDatetime;
		public Builder(Datetime pDatetime){
			this.mDatetime = pDatetime;
		}
		public Builder(Date pDate){
			this.mDatetime = Datetime.newInstance(
				pDate.year(), pDate.month(), pDate.day(), 0,0,0
			);
		}
		public Datetime getValue(){
			return this.mDatetime;
		}
		public Builder toStartOfMonth(Boolean truncateTime){
			Date theDate = this.mDatetime.date().toStartOfMonth();
			Datetime theNewDateTime;
			if(truncateTime){
				theNewDateTime = Datetime.newInstance(
					theDate.year(), theDate.month(), theDate.day(), 
					0, 0, 0 
				);				
			}else{
				theNewDateTime = Datetime.newInstance(
					theDate.year(), theDate.month(), theDate.day(), 
					this.mDatetime.hour(), this.mDatetime.minute(), this.mDatetime.second() 
				);
			}
			this.mDatetime = theNewDateTime; return this;
		}
	}
}