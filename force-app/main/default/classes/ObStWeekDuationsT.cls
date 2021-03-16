@isTest
public class ObStWeekDuationsT {

	@isTest static void doTest_getWeekDaysDurations(){

		List<ObStWeekDuations.Duration> theDurations 
			= ObStWeekDuations.getWeekDaysDurations( Date.newInstance(2019, 4, 21), Date.newInstance(2019, 5, 1) );

		System.assertEquals(2, theDurations.size() );

		System.assertEquals( 
			DateTime.newInstance(2019, 4, 22, 0, 0, 0), 
			theDurations.get(0).fromDateTime
		);
		System.assertEquals( 
			DateTime.newInstance(2019, 4, 26, 23, 59, 59), 
			theDurations.get(0).toDateTime
		);

		System.assertEquals( 
			DateTime.newInstance(2019, 4, 29, 0, 0, 0), 
			theDurations.get(1).fromDateTime
		);
		System.assertEquals( 
			DateTime.newInstance(2019, 5, 1, 23, 59, 59), 
			theDurations.get(1).toDateTime
		);

	}

	@isTest static void doTest_getWeekEndDaysDurations(){

		List<ObStWeekDuations.Duration> theDurations 
			= ObStWeekDuations.getWeekEndDaysDurations( Date.newInstance(2019, 4, 21), Date.newInstance(2019, 5, 1) );

		System.assertEquals(2, theDurations.size() );
		
		System.assertEquals( 
			DateTime.newInstance(2019, 4, 21, 0, 0, 0), 
			theDurations.get(0).fromDateTime
		);
		System.assertEquals( 
			DateTime.newInstance(2019, 4, 21, 23, 59, 59), 
			theDurations.get(0).toDateTime
		);

		System.assertEquals( 
			DateTime.newInstance(2019, 4, 27, 0, 0, 0), 
			theDurations.get(1).fromDateTime
		);
		System.assertEquals( 
			DateTime.newInstance(2019, 4, 28, 23, 59, 59), 
			theDurations.get(1).toDateTime
		);

	}
}