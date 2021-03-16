@isTest
public class Tes_Com_Utility {
	static testMethod void testCase(){
		// 平成
		Com_Utility.conversionJpCalendar(date.newInstance(1989,1,1));
		// 昭和
		Com_Utility.conversionJpCalendar(date.newInstance(1868,1,1));
		// 大正
		Com_Utility.conversionJpCalendar(date.newInstance(1912,1,1));
		// 明治
		Com_Utility.conversionJpCalendar(date.newInstance(1926,1,1));

		Com_Utility.ZenkakuReplace('ﾃｽﾄ');
		Com_Utility.HankakuReplace('テスト');
		Com_Utility.DateTimeToDateConversion(Datetime.now());
		Com_Utility.paddingLeftZero('　1234',4);
		Com_Utility.toDate('2000/01/01');
	}

}