@isTest
public class OboPlanKeitaisT {

	@isTest
	static void getSogiPlans(){
		System.AssertEquals( 
			true, 
			OboPlanKeitais.getPlans(OboPlanKeitais.Keitais.SOGI).contains('火葬式') 
		);
	}
	@isTest
	static void getHoyoPlans(){
		System.AssertEquals( 
			true, 
			OboPlanKeitais.getPlans(OboPlanKeitais.Keitais.HOYO).contains('四十九日法要') 
		);
	}
	@isTest
	static void getKaimyoPlans(){
		System.AssertEquals( 
			true, 
			OboPlanKeitais.getPlans(OboPlanKeitais.Keitais.KAIMYO).contains('戒名・法名のみ') 
		);
	}

	@isTest
	static void isSogi(){
		System.AssertEquals( true, OboPlanKeitais.isSogi('火葬式') );
	}
	@isTest
	static void isHoyo(){
		System.AssertEquals( true, OboPlanKeitais.isHoyo('四十九日法要') );
	}
	@isTest
	static void isKaimyo(){
		System.AssertEquals( true, OboPlanKeitais.isKaimyo('戒名・法名のみ') );
	}

}