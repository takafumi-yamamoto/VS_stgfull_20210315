@isTest
public class DtBldrsT {

	@isTest public static void Builder_ctor_by_datetime(){
		Test.startTest();
		Date theDate = Date.newInstance(2020, 1, 15);

		String theValue =
			new DtBldrs.Builder(theDate)
			.getValue()
			.format('yyyy-MM-dd HH:mm:ss');
		Test.stopTest();
		System.assertEquals('2020-01-15 00:00:00', theValue);
	}

	@isTest public static void Builder_by_date(){
		Test.startTest();
		Datetime theDatetime = 
			Datetime.newInstance(
				2020, 1, 15, 12, 11, 10
			);

		String theValue =
			new DtBldrs.Builder(theDatetime)
			.getValue()
			.format('yyyy-MM-dd HH:mm:ss');
		Test.stopTest();
		System.assertEquals('2020-01-15 12:11:10', theValue);
	}

	@isTest public static void Builder_toStartOfMonth(){
		Test.startTest();
		Datetime theDatetime = 
			Datetime.newInstance(
				2020, 1, 15, 12, 11, 10
			);

		String theValue =
			new DtBldrs.Builder(theDatetime)
			.toStartOfMonth(false)
			.getValue()
			.format('yyyy-MM-dd HH:mm:ss');
		Test.stopTest();
		System.assertEquals('2020-01-01 12:11:10', theValue);
	}

	@isTest public static void Builder_toStartOfMonth_timeTruncated(){
		Test.startTest();
		Datetime theDatetime = 
			Datetime.newInstance(
				2020, 1, 15, 12, 11, 10
			);

		String theValue =
			new DtBldrs.Builder(theDatetime)
			.toStartOfMonth(true)
			.getValue()
			.format('yyyy-MM-dd HH:mm:ss');
		Test.stopTest();
		System.assertEquals('2020-01-01 00:00:00', theValue);
	}
}