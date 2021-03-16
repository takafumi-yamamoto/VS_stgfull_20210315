@isTest
public class Tes_Utility_Common {

	static testMethod void testCase(){

		// 平成
		Utility_Common.conversionJpCalendar(date.newInstance(1989,1,1));
		// 昭和
		Utility_Common.conversionJpCalendar(date.newInstance(1868,1,1));
		// 大正
		Utility_Common.conversionJpCalendar(date.newInstance(1912,1,1));
		// 明治
		Utility_Common.conversionJpCalendar(date.newInstance(1926,1,1));

		Utility_Common.ZenkakuReplace('ﾃｽﾄ');
		Utility_Common.HankakuReplace('テスト');
		Utility_Common.DateTimeToDateConversion(Datetime.now());
		Utility_Common.paddingLeftZero('　1234',4);
		Utility_Common.sleep(1000);
		Boolean bl = Utility_Common.isValidEmailAddress('test@minrevi.jp');



	}

}