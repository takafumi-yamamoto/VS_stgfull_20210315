@isTest
public class KeirSimeLocksRuleEnablesT {
	@isTest public static void turnOnLockRule(){
		Test.startTest();
		KeirSimeLocksRuleEnables.turnOnLockRule();
		Test.stopTest();
		System.assertEquals(true, KeirSimeLocksRuleEnables.isEnabled() );
	}
	@isTest public static void turnOffLockRule(){
		Test.startTest();
		KeirSimeLocksRuleEnables.turnOffLockRule();
		Test.stopTest();
		System.assertEquals(false, KeirSimeLocksRuleEnables.isEnabled() );
	}
}