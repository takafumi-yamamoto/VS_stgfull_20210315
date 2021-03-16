@isTest
private class HouyoPlansT{
	@isTest
	static void getHoyoPlans(){
		System.AssertEquals( true, HouyoPlans.getHoyoPlans().contains('四十九日法要') );
	}
	@isTest
	static void isHoyoPlan(){
		System.AssertEquals( true, HouyoPlans.isHoyoPlan('四十九日法要') );
	}
}