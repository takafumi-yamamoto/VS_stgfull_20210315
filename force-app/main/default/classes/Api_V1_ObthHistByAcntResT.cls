@isTest
public class Api_V1_ObthHistByAcntResT {
	
	@isTest
	public static void OboTehaiValidator_isValid(){

		Api_V1_ObthHistByAcntRes.OboTehai theOboTehai = new Api_V1_ObthHistByAcntRes.OboTehai();
		theOboTehai.shodan_bango = 'not_blank';
		theOboTehai.oboplan_keitai = 'not_blank';
		theOboTehai.oboplan_event = new Api_V1_ObthHistByAcntRes.OboPlanEvent();
		theOboTehai.kibo_shuha = new Api_V1_ObthHistByAcntRes.KiboShuha();
		theOboTehai.service_date = '2020-01-01';
		theOboTehai.taishosha = new Api_V1_ObthHistByAcntRes.Taishosha();
		theOboTehai.tehaisaki = new Api_V1_ObthHistByAcntRes.Tehaisaki();
		theOboTehai.tehaisaki.sekosha = new Api_V1_ObthHistByAcntRes.Sekosha();
		theOboTehai.tehaisaki.sekosha.name = 'not_blank';
		theOboTehai.tehaisaki.jiin = new Api_V1_ObthHistByAcntRes.Jiin();
		theOboTehai.tehaisaki.jiin.name = 'not_blank';
		theOboTehai.tehaisaki.jiin.shushi = 'not_blank';

		Test.startTest();
		new Api_V1_ObthHistByAcntRes.OboTehaiValidator().isValid(theOboTehai);
		Test.stopTest();
	}
}